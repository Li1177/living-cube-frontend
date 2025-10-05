const DIRECTUS_URL = process.env.DIRECTUS_URL;
const DIRECTUS_STATIC_TOKEN = process.env.DIRECTUS_STATIC_TOKEN;

export default async function handler(req, res) {
  const commonHeaders = {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${DIRECTUS_STATIC_TOKEN || ''}`,  // 修复: fallback 空字符串，日志 token 状态
  };

  console.log('Danmaku API called with method:', req.method, 'Token defined?', !!DIRECTUS_STATIC_TOKEN);  // 诊断日志

  if (req.method === 'GET') {
    try {
      const { wallpaper_id } = req.query;

      if (!wallpaper_id) {
        return res.status(400).json({ error: 'wallpaper_id is required' });
      }

      const fetchUrl = `${DIRECTUS_URL}/items/danmaku?filter[wallpaper_id][_eq]=${wallpaper_id}`;

      console.log('GET fetch URL:', fetchUrl);  // 诊断 URL

      const response = await fetch(fetchUrl, {
        method: 'GET',
        headers: commonHeaders,
      });

      if (!response.ok) {
        const errorBody = await response.text();
        console.error("Directus Error:", errorBody);
        throw new Error(`Directus responded with status ${response.status}`);
      }

      const result = await response.json();
      res.status(200).json(result.data);

    } catch (error) {
      console.error('Error fetching danmakus:', error);
      res.status(500).json({ error: 'Failed to fetch danmakus' });
    }
  } else if (req.method === 'POST') {
    try {
      const { wallpaper_id, message } = req.body;

      if (!wallpaper_id || !message) {
        return res.status(400).json({ error: 'wallpaper_id and message are required' });
      }

      const fetchUrl = `${DIRECTUS_URL}/items/danmaku`;

      const response = await fetch(fetchUrl, {
        method: 'POST',
        headers: commonHeaders,
        body: JSON.stringify({
          wallpaper_id,
          message,
        }),
      });
      
      if (!response.ok) {
        const errorBody = await response.json();
        console.error('Directus POST Error:', errorBody);
        throw new Error(`Directus responded with status ${response.status}`);
      }

      const newDanmaku = await response.json();
      res.status(201).json(newDanmaku.data);

    } catch (error) {
      console.error('Error creating danmaku:', error);
      res.status(500).json({ error: 'Failed to create danmaku' });
    }
  } else {
    res.setHeader('Allow', ['GET', 'POST']);
    res.status(405).end(`Method ${req.method} Not Allowed`);
  }
}