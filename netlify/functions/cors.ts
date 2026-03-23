const defaultOrigin = 'http://localhost:5173';
const allowedOrigins = [defaultOrigin, 'https://shared-casting.netlify.app'];

export function corsHeaders(request: Request) {
  const origin = request.headers.get('origin') ?? '';

  return {
    'Access-Control-Allow-Origin': allowedOrigins.includes(origin) ? origin : defaultOrigin,
    'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
  };
}

export function corsPreflight(request: Request) {
  return new Response(null, {
    status: 204,
    headers: corsHeaders(request),
  });
}
