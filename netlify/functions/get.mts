import { Config, Context } from '@netlify/functions';
import { corsHeaders, corsPreflight } from './cors';

export const config: Config = {
  path: '/get/:type/:id',
};

const buildUrl = ({ type, id }: { type: 'movie' | 'tv'; id: string }) =>
  `https://api.themoviedb.org/3/${type}/${id}?language=en-US&append_to_response=${
    type === 'movie' ? 'credits' : 'aggregate_credits'
  },images${type === 'tv' ? ',content_ratings' : ''}${type === 'movie' ? ',release_dates' : ''}`;

const options = {
  method: 'GET',
  headers: {
    accept: 'application/json',
    Authorization: `Bearer ${process.env.THEMOVIEDB_API_SECRET}`,
  },
};

export default async (req: Request, context: Context) => {
  // 👉 IMPORTANT: gestionar OPTIONS
  if (req.method === 'OPTIONS') {
    return corsPreflight(req);
  }

  try {
    const {
      params: { type, id },
    } = context;

    if (type !== 'movie' && type !== 'tv') {
      return new Response(JSON.stringify({ error: 'Invalid type parameter' }), {
        status: 400,
        headers: {
          ...corsHeaders(req),
          'Content-Type': 'application/json',
        },
      });
    }

    const url = buildUrl({ type: type as 'movie' | 'tv', id });
    const response = await fetch(url, options);

    if (!response.ok) {
      throw new Error(`Failed to fetch data: ${response.statusText}`);
    }

    const data = await response.json();

    return new Response(JSON.stringify(data), {
      status: 200,
      headers: {
        ...corsHeaders(req),
        'Content-Type': 'application/json',
      },
    });
  } catch (error: any) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: {
        ...corsHeaders(req),
        'Content-Type': 'application/json',
      },
    });
  }
};
