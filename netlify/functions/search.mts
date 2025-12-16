import { Config, Context } from '@netlify/functions';
import { corsHeaders, corsPreflight } from './cors';

export const config: Config = {
  path: '/search/:search',
};

const buildUrl = ({ type, query }: { type: 'movie' | 'tv'; query: string }) =>
  `https://api.themoviedb.org/3/search/${type}?append_to_response=networks&include_adult=false&language=en-US&page=1&query=${query}`;

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
      params: { search },
    } = context;
    const urlMovie = buildUrl({ type: 'movie', query: search });
    const urlTV = buildUrl({ type: 'tv', query: search });

    const [responseMovies, responseTV] = await Promise.all([fetch(urlMovie, options), fetch(urlTV, options)]);

    if (!responseMovies.ok || !responseTV.ok) {
      throw new Error('Failed to fetch data from one or both sources');
    }

    // Convert responses to JSON
    const data = await Promise.all([responseMovies.json(), responseTV.json()]);

    const flatData = data
      .map((json, index) =>
        index === 0
          ? json.results.map((movie: any) => ({ media_type: 'movie', ...movie }))
          : json.results.map((tvshow: any) => ({ media_type: 'tv', ...tvshow }))
      )
      .flat();
    return new Response(JSON.stringify(flatData), {
      headers: { ...corsHeaders(req), 'Content-Type': 'application/json' },
      status: 200,
    });
  } catch (error) {
    const errorMessage = error instanceof Error ? error.message : 'An unknown error occurred';
    return new Response(JSON.stringify({ error: errorMessage }), {
      headers: { ...corsHeaders(req), 'Content-Type': 'application/json' },
      status: 500,
    });
  }
};
