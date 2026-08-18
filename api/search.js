const axios = require('axios');

const actorId = 'lofomachines~facebook-groups-posts-search-scraper';
const apifyApiUrl = 'https://api.apify.com/v2';

function decodeHtmlEntities(value) {
  if (typeof value !== 'string') return value;

  const namedEntities = {
    '&amp;': '&',
    '&apos;': "'",
    '&gt;': '>',
    '&lt;': '<',
    '&nbsp;': ' ',
    '&quot;': '"',
  };

  return value
    .replace(/&(amp|apos|gt|lt|nbsp|quot);|&#(x[\da-f]+|\d+);/gi, (entity, named, numeric) => {
      if (named) return namedEntities[entity.toLowerCase()] || entity;

      const codePoint = numeric.toLowerCase().startsWith('x')
        ? Number.parseInt(numeric.slice(1), 16)
        : Number.parseInt(numeric, 10);

      return Number.isNaN(codePoint) ? entity : String.fromCodePoint(codePoint);
    });
}

function decodeValues(value) {
  if (Array.isArray(value)) return value.map(decodeValues);
  if (value && typeof value === 'object') {
    return Object.fromEntries(
      Object.entries(value).map(([key, item]) => [key, decodeValues(item)]),
    );
  }
  return decodeHtmlEntities(value);
}

module.exports = async (req, res) => {
  if (req.method !== 'GET') {
    res.setHeader('Allow', 'GET');
    return res.status(405).json({ error: 'Method not allowed' });
  }

  const apifyToken = process.env.APIFY_TOKEN;
  if (!apifyToken) {
    return res.status(500).json({ error: 'APIFY_TOKEN is not configured' });
  }

  const query = typeof req.query?.q === 'string' ? req.query.q.trim() : '';
  if (!query) {
    return res.status(400).json({ error: 'The q query parameter is required' });
  }

  const requestedLimit = Number.parseInt(req.query?.limit, 10);
  const limit = Number.isFinite(requestedLimit) && requestedLimit > 0
    ? requestedLimit
    : 100;
  const headers = { Authorization: `Bearer ${apifyToken}` };

  try {
    const runResponse = await axios.post(
      `${apifyApiUrl}/acts/${actorId}/runs?waitForFinish=120`,
      {
        keywords: [query],
        timeRange: 'week',
        maxPostsPerKeyword: limit,
        country: 'Egypt',
      },
      { headers },
    );

    const datasetId = runResponse.data?.data?.defaultDatasetId;
    if (!datasetId) {
      return res.status(502).json({ error: 'Apify did not return a dataset' });
    }

    const datasetResponse = await axios.get(
      `${apifyApiUrl}/datasets/${encodeURIComponent(datasetId)}/items`,
      { headers, params: { format: 'json' } },
    );
    const results = decodeValues(datasetResponse.data);

    return res.status(200).json({
      total: Array.isArray(results) ? results.length : 0,
      results: Array.isArray(results) ? results : [],
    });
  } catch (error) {
    const status = error.response?.status;
    const details = error.response?.data?.error?.message || error.message;
    return res.status(status && status >= 400 && status < 600 ? status : 502).json({
      error: 'Apify request failed',
      details,
    });
  }
};
