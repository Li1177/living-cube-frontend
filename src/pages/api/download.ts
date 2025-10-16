import type { NextApiRequest, NextApiResponse } from 'next';
import { createDirectus, rest, staticToken, readItem, updateUser, createItem, readItems, readUser } from '@directus/sdk';
import { getServerSession } from 'next-auth/next';
import { authOptions } from './auth/[...nextauth]';

type Data = { message: string; };

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse<Data | Blob>
) {
  if (req.method !== 'GET') {
    res.setHeader('Allow', 'GET');
    return res.status(405).end('Method Not Allowed');
  }

  const session = await getServerSession(req, res, authOptions);
  if (!session || !session.user || !session.user.id) {
    return res.status(401).json({ message: 'Authentication required.' });
  }
  const userId = session.user.id;

  const { wallpaper_id } = req.query;
  if (typeof wallpaper_id !== 'string' || !wallpaper_id) {
    return res.status(400).json({ message: 'Error: wallpaper_id is required.' });
  }

  const directus = createDirectus(process.env.DIRECTUS_URL!)
    .with(staticToken(process.env.DIRECTUS_STATIC_TOKEN!))
    .with(rest());

  try {
    const existingDownloads = await directus.request(readItems('user_downloads', {
      filter: {
        user_id: { _eq: userId },
        wallpaper_id: { _eq: wallpaper_id },
      },
      limit: 1,
    }));

    const hasAlreadyDownloaded = existingDownloads.length > 0;

    if (hasAlreadyDownloaded) {
      console.log(`User ${userId} has previously downloaded wallpaper ${wallpaper_id}. Granting access without deducting limit.`);
    } else {
      const user = await directus.request(readUser(userId, { fields: ['download_limit'] }));
      const currentLimit = user.download_limit || 0;

      if (currentLimit <= 0) {
        return res.status(403).json({ message: "You have no download credits left. Please purchase a new bundle." });
      }

      const newLimit = currentLimit - 1;
      await directus.request(updateUser(userId, { download_limit: newLimit }));
      console.log(`User ${userId} download limit decremented from ${currentLimit} to ${newLimit}.`);
      
      // --- [v1.7 最终修正] ---
      // 使用连字符 (-) 代替下划线 (_)，以完全遵守 Directus 中的验证规则。
      await directus.request(createItem('user_downloads', {
        user_id: userId,
        wallpaper_id: Number(wallpaper_id),
        status: 'success',
        unique_key: `${userId}-${wallpaper_id}`
      }));
      // ----------------------

      console.log(`Download by user ${userId} for wallpaper ${wallpaper_id} logged successfully.`);
    }

    const wallpaper = await directus.request(readItem('wallpapers', Number(wallpaper_id), {
      fields: ['wallpaper_file.id', 'wallpaper_file.filename_download'],
    }) as any);

    if (!wallpaper?.wallpaper_file?.id) {
      return res.status(404).json({ message: 'Artwork file not found.' });
    }

    const fileId = wallpaper.wallpaper_file.id;
    const fileName = wallpaper.wallpaper_file.filename_download;
    const assetUrl = `${process.env.DIRECTUS_URL}/assets/${fileId}?download`;

    const fileResponse = await fetch(assetUrl, {
      headers: { 'Authorization': `Bearer ${process.env.DIRECTUS_STATIC_TOKEN}` },
    });

    if (!fileResponse.ok || !fileResponse.body) {
      throw new Error(`Failed to fetch asset from Directus: ${fileResponse.statusText}`);
    }
    
    res.setHeader('Content-Type', fileResponse.headers.get('Content-Type') || 'application/octet-stream');
    res.setHeader('Content-Disposition', `attachment; filename="${fileName}"`);
    
    // @ts-ignore
    await fileResponse.body.pipeTo(new WritableStream({
        write(chunk) { res.write(chunk); },
        close() { res.end(); }
    }));

  } catch (error: any) {
    console.error('Download API error:', error);
    if (error.response && typeof error.response.json === 'function') {
        try {
            const directusError = await error.response.json();
            console.error('Directus Error Details:', directusError.errors || directusError);
        } catch (jsonError) {
            console.error('Could not parse Directus error response.');
        }
    }
    res.status(500).json({ message: 'An internal server error occurred during the download process.' });
  }
}