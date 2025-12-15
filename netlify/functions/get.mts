import { Config, Context } from '@netlify/functions';

export const config: Config = {
  path: '/get/:type/:id',
};
console.log(`Bearer ${process.env.THEMOVIEDB_API_SECRET}`);
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
  try {
    const {
      params: { type, id },
    } = context;

    if (type !== 'movie' && type !== 'tv') {
      throw new Error('Invalid type parameter');
    }
    const url = buildUrl({ type: type as 'movie' | 'tv', id });
    console.log(url);

    const response = await fetch(url, options);

    if (!response.ok) {
      throw new Error(`Failed to fetch data: ${response.statusText}`);
    }

    // Convert response to JSON
    const data = await response.json();

    return new Response(JSON.stringify(data), {
      headers: { 'Content-Type': 'application/json' },
      status: 200,
    });
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { 'Content-Type': 'application/json' },
      status: 500,
    });
  }
};
