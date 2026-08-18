const express = require('express');
const axios = require('axios');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

function decodeHtmlEntities(str) {
  if (!str || typeof str !== 'string') return '';

  return str
    .replace(/&#x([0-9A-Fa-f]+);/g, (_, hex) => String.fromCharCode(parseInt(hex, 16)))
    .replace(/&amp;/g, '&')
    .replace(/&lt;/g, '<')
    .replace(/&gt;/g, '>')
    .replace(/&quot;/g, '"')
    .replace(/&#39;/g, "'");
}

app.get('/', (req, res) => {
  res.json({
    status: 'success',
    message: 'Smart Post Finder Backend is running',
  });
});

app.get('/search', async (req, res) => {
  const token = process.env.APIFY_TOKEN;

  if (!token) {
    return res.status(500).json({
      error: 'APIFY_TOKEN is not configured',
    });
  }

  const q = typeof req.query.q === 'string' ? req.query.q.trim() : '';

  if (!q) {
    return res.status(400).json({
      error: 'Query parameter "q" is required',
    });
  }

  const parsedLimit = parseInt(req.query.limit || '100', 10);
  const limit = Number.isNaN(parsedLimit) ? 100 : Math.max(1, parsedLimit);
  const actorId = 'lofomachines~facebook-groups-posts-search-scraper';

  try {
    const runResponse = await axios.post(
      `https://api.apify.com/v2/acts/${actorId}/runs`,
      {
        keywords: [q],
        timeRange: 'week',
        maxPostsPerKeyword: limit,
        country: 'Egypt',
      },
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
        params: {
          waitForFinish: 120,
        },
        timeout: 130000,
      },
    );

    const datasetId = runResponse.data?.data?.defaultDatasetId;

    if (!datasetId) {
      return res.status(502).json({
        error: 'Apify did not return a dataset',
      });
    }

    const itemsResponse = await axios.get(
      `https://api.apify.com/v2/datasets/${datasetId}/items`,
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
        params: {
          format: 'json',
        },
        timeout: 30000,
      },
    );

    const rawItems = Array.isArray(itemsResponse.data)
      ? itemsResponse.data
      : [];

    const results = rawItems.map((item, index) => ({
      id: item.id || item.postId || `post_${index}`,
      text: decodeHtmlEntities(item.text || item.postText || ''),
      group_name: decodeHtmlEntities(item.groupName || item.group_name || ''),
      author_name: decodeHtmlEntities(item.authorName || item.author_name || ''),
      date: item.date || item.time || '',
      url: item.url || item.postUrl || '',
      location: 'Egypt',
      relevance: item.relevance || 1.0,
    }));

    return res.json({
      total: results.length,
      results,
    });
  } catch (error) {
    console.error('Apify error:', error.response?.data || error.message);

    return res.status(502).json({
      error: 'Apify request failed',
      details: error.response?.data?.error?.message || error.message,
    });
  }
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Backend running on port ${PORT}`);
});
