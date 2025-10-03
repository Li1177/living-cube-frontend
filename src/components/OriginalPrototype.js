// src/components/OriginalPrototype.js

import React, { useState, useEffect, useCallback, Suspense } from 'react';
import { Canvas } from '@react-three/fiber';
import { Environment, OrbitControls } from '@react-three/drei';

import * as THREE from 'three';
import { Cube, LargeMedia3D } from './Scene';

export default function LivingCubeApp() {
  const [media, setMedia] = useState(null);
  const [selectedMedia, setSelectedMedia] = useState(null);
  const [refreshing, setRefreshing] = useState(false);
  const [loading, setLoading] = useState(true); // 新增：加载状态

  const handleMediaClick = useCallback((mediaItem, startPosition) => setSelectedMedia({ mediaItem, startPosition }), []);

  const loadMedia = useCallback(async () => {
    setLoading(true);
    try {
      const response = await fetch('http://167.234.212.43:8055/items/wallpapers?fields=*,wallpaper_file.*');
      
      if (!response.ok) {
        throw new Error(`Directus API call failed with status: ${response.status}`);
      }

      const apiResponse = await response.json();
      const mediaFiles = apiResponse.data;

      const DIRECTUS_BASE_URL = 'http://167.234.212.43:8055';

      const adaptedMediaFiles = mediaFiles
        .filter(item => item.wallpaper_file && item.wallpaper_file.id)
        .map(item => {
          const fileId = item.wallpaper_file.id; 
          const imageUrl = `${DIRECTUS_BASE_URL}/assets/${fileId}`;

          return {
            id: item.id,
            type: 'image', 
            path: imageUrl
          };
        });

      setMedia(adaptedMediaFiles);
      setLoading(false);
    } catch (error) {
      setMedia([]);
      setLoading(false);
    }
  }, []);

  useEffect(() => { loadMedia(); }, [loadMedia]);
  
  const handleRefresh = () => setRefreshing(true);
  const handleRefreshComplete = () => { loadMedia(); setRefreshing(false); };

  if (loading) {
    return <div className="w-screen h-screen flex items-center justify-center bg-black text-white">加载中...</div>;
  }

  return (
    <div className="w-screen h-screen relative">
      <button
        onClick={handleRefresh}
        className="absolute top-4 right-4 z-50 px-4 py-2 bg-gray-700 text-white rounded-lg shadow-lg hover:bg-gray-600 active:bg-gray-800 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
        disabled={refreshing}
      >
        {refreshing ? '刷新中...' : '刷新媒体'}
      </button>
      
      <Canvas style={{ background: '#000' }} camera={{ position: [5, 5, 5], fov: 50 }} onCreated={({ gl }) => gl.setClearColor(new THREE.Color('#000000'))}>
        <ambientLight intensity={1.5} name="mainAmbientLight" />
        <pointLight position={[10, 10, 10]} intensity={0.2} name="mainPointLight" />
        <Suspense fallback={null}>
          <Environment preset="sunset" background={false} />
          {media && media.length > 0 && <Cube media={media} onMediaClick={handleMediaClick} onRefreshComplete={handleRefreshComplete} refreshing={refreshing} />}
        </Suspense>
        <OrbitControls enableDamping dampingFactor={0.05} rotateSpeed={0.5} enablePan={false} />
      </Canvas>

      {selectedMedia && <LargeMedia3D mediaItem={selectedMedia.mediaItem} startPosition={selectedMedia.startPosition} onClose={() => setSelectedMedia(null)} />}
    </div>
  );
}