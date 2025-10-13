import React, { useState, useEffect, useCallback, Suspense } from 'react';
import { Canvas } from '@react-three/fiber';
import { Environment, OrbitControls } from '@react-three/drei';
import * as THREE from 'three';
import { Cube, LargeMedia3D } from './Scene';
import AuthStatus from './AuthStatus';
import { useAppStore } from '../lib/store'; // <-- 导入我们新的 "中央大脑"

const isMobile = () => typeof window !== 'undefined' && window.innerWidth < 768;

export default function LivingCubeApp() {
  const [media, setMedia] = useState(null);
  const [refreshing, setRefreshing] = useState(false);
  const [loading, setLoading] = useState(true);
  const [cameraPosition, setCameraPosition] = useState(isMobile() ? [8, 8, 8] : [5, 5, 5]);
  
  // 从 "中央大脑" (Zustand store) 中获取状态
  const isImmersive = useAppStore((state) => state.isImmersive);
  const selectedMedia = useAppStore((state) => state.selectedMedia);

  useEffect(() => {
    const handleResize = () => {
      setCameraPosition(isMobile() ? [8, 8, 8] : [5, 5, 5]);
    };
    window.addEventListener('resize', handleResize);
    return () => window.removeEventListener('resize', handleResize);
  }, []);

  // handleMediaClick 函数现在不再需要了，逻辑已移入 store 和组件内部

  const loadMedia = useCallback(async () => {
    setLoading(true);
    try {
      const fields = [
        'id', 'name', 'description', 'price_cents',
        'wallpaper_file.id', 'wallpaper_file.type'
      ].join(',');
      const fetchUrl = `${process.env.NEXT_PUBLIC_DIRECTUS_URL}/items/wallpapers?fields=${fields}`;
      const response = await fetch(fetchUrl);
      
      if (!response.ok) throw new Error(`Directus API call failed: ${response.status}`);

      const apiResponse = await response.json();
      const mediaFiles = apiResponse.data;

      const adaptedMediaFiles = mediaFiles
        .filter(item => item.wallpaper_file && item.wallpaper_file.id)
        .map(item => ({
          id: item.id,
          name: item.name,
          description: item.description,
          price_cents: item.price_cents,
          wallpaper_file: item.wallpaper_file,
          path: `${process.env.NEXT_PUBLIC_DIRECTUS_URL}/assets/${item.wallpaper_file.id}`,
          type: (item.wallpaper_file.type || '').startsWith('video') ? 'video' : 'image',
        }));

      setMedia(adaptedMediaFiles);
      setLoading(false);
    } catch (error) {
      console.error('Load media error:', error);
      setMedia([]);
      setLoading(false);
    }
  }, []);

  useEffect(() => { loadMedia(); }, [loadMedia]);
  
  const handleRefresh = () => { setRefreshing(true); };
  const handleRefreshComplete = () => { loadMedia(); setRefreshing(false); };

  if (loading) {
    return <div className="w-full h-screen flex items-center justify-center bg-black text-white text-sm sm:text-base">Loading artworks...</div>;
  }

  return (
    <div className="w-full h-screen relative">
      <div className="absolute top-2 left-2 z-50">
        <AuthStatus />
      </div>

      <button onClick={handleRefresh} className="absolute top-2 right-2 z-50 px-2 py-1 sm:px-4 sm:py-2 bg-gray-700 text-white rounded-lg shadow-lg hover:bg-gray-600 active:bg-gray-800 transition-colors disabled:opacity-50 disabled:cursor-not-allowed text-xs sm:text-sm" disabled={refreshing}>
        {refreshing ? 'Refreshing...' : 'Refresh Gallery'}
      </button>
      
      <Canvas style={{ background: '#000' }} camera={{ position: cameraPosition, fov: 50 }} onCreated={({ gl }) => gl.setClearColor(new THREE.Color('#000000'))}>
        <ambientLight intensity={1.5} name="mainAmbientLight" />
        <pointLight position={[10, 10, 10]} intensity={0.2} name="mainPointLight" />
        <Suspense fallback={null}>
          <Environment preset="sunset" background={false} />
          {media && media.length > 0 && (
            // 我们不再需要向下传递 onMediaClick prop
            <Cube 
              media={media} 
              onRefreshComplete={handleRefreshComplete} 
              refreshing={refreshing} 
            />
          )}
        </Suspense>
        <OrbitControls enableDamping dampingFactor={0.05} rotateSpeed={0.5} enablePan={false} />
      </Canvas>

      {/* 我们现在根据 isImmersive 状态来决定是否渲染大图预览 */}
      {isImmersive && selectedMedia && (
        <LargeMedia3D 
          mediaItem={selectedMedia.mediaItem} 
          startPosition={selectedMedia.startPosition}
          // onClose 也不再需要了
        />
      )}
    </div>
  );
}