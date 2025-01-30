import { Config, Context } from "@netlify/functions";

export const config: Config = {
	path: "/search/:search"
};

const buildUrl = ({ type, query }: { type: "movie" | "tv", query: string }) =>
	`https://api.themoviedb.org/3/search/${type}?include_adult=false&language=en-US&page=1&query=${query}`;

const options = {
	method: "GET",
	headers: {
		accept: "application/json",
		Authorization: `Bearer ${process.env.THEMOVIEDB_API_SECRET}`,
	},
};

export default async (req: Request, context: Context) => {
	try {
		const { params: { search } } = context;
		const urlMovie = buildUrl({ type: 'movie', query: search });
		const urlTV = buildUrl({ type: 'tv', query: search });

		const [response1, response2] = await Promise.all([
			fetch(urlMovie, options),
			fetch(urlTV, options)
		]);

		if (!response1.ok || !response2.ok) {
			throw new Error("Failed to fetch data from one or both sources");
		}

		// Convert responses to JSON
		const data = await Promise.all([response1.json(), response2.json()]);
		const flatData = data.flat();
		return new Response(JSON.stringify(flatData), {
			headers: { "Content-Type": "application/json" },
			status: 200,
		});
	} catch (error) {
		return new Response(JSON.stringify({ error: error.message }), {
			headers: { "Content-Type": "application/json" },
			status: 500,
		});
	}

}

