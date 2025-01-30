import { Config, Context } from "@netlify/functions";

export const config: Config = {
	path: "/people/:id"
};

const buildUrl = ({ id }: { id: string }) =>
	`https://api.themoviedb.org/3/person/${id}?append_to_response=images%2Ccombined_credits&language=en-US`;

const options = {
	method: "GET",
	headers: {
		accept: "application/json",
		Authorization: `Bearer ${process.env.THEMOVIEDB_API_SECRET}`

	},
};

export default async (req: Request, context: Context) => {
	try {
		const { params: { id } } = context;

		const url = buildUrl({ id });


		const response = await fetch(url, options);

		if (!response.ok) {
			throw new Error(`Failed to fetch data: ${response.statusText}`);
		}

		// Convert response to JSON
		const data = await response.json();

		return new Response(JSON.stringify(data), {
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

