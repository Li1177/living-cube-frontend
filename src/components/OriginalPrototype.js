// src/components/OriginalPrototype.js (已修复 ESLint 错误)
import React, { useState, useEffect, useCallback, Suspense } from 'react';
import { Canvas } from '@react-three/fiber';
import { Environment, OrbitControls } from '@react-three/drei';
import * as THREE from 'three';
import { Cube, LargeMedia3D } from './Scene';

const isMobile = () => typeof window !== 'undefined' && window.innerWidth < 768;

export default function LivingCubeApp() {
  const [media, setMedia] = useState(null);
  const [selectedMedia, setSelectedMedia] = useState(null);
  const [refreshing, setRefreshing] = useState(false);
  const [loading, setLoading] = useState(true);
  const [cameraPosition, setCameraPosition] = useState(isMobile() ? [8, 8, 8] : [5, 5, 5]);

  useEffect(() => {
    const handleResize = () => {
      setCameraPosition(isMobile() ? [8, 8, 8] : [5, 5, 5]);
    };
    window.addEventListener('resize', handleResize);
    return () => window.removeEventListener('resize', handleResize);
  }, []);

  const handleMediaClick = useCallback((mediaItem, startPosition) => {
    setSelectedMedia({ mediaItem, startPosition });
  }, []);

  const loadMedia = useCallback(async () => {
    setLoading(true);
    try {
      const fields = [
        'id', 'name', 'description', 'price_cents',
        'wallpaper_file.id', 'wallpaper_file.type'
      ].join(',');
      const fetchUrl = `${process.env.NEXT_PUBLIC_DIRECTUS_URL}/items/wallpapers?fields=${fields}`;
      const response = await fetch(fetchUrl);
      
      if (!response.ok) {
        throw new Error(`Directus API call failed with status: ${response.status}`);
      }

      const apiResponse = await response.json();
      const mediaFiles = apiResponse.data;

      const adaptedMediaFiles = mediaFiles
        .filter(item => item.wallpaper_file && item.wallpaper_file.id)
        .map(item => {
          const filePath = `${process.env.NEXT_PUBLIC_DIRECTUS_URL}/assets/${item.wallpaper_file.id}`;
          return {
            id: item.id,
            name: item.name,
            description: item.description,
            price_cents: item.price_cents,
            wallpaper_file: item.wallpaper_file,
            path: filePath,
            type: (item.wallpaper_file.type || '').startsWith('video') ? 'video' : 'image',
          };
        });

      setMedia(adaptedMediaFiles);
      setLoading(false);
    } catch (error) {
      console.error('Load media error:', error);
      setMedia([]);
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    loadMedia();
  }, [loadMedia]);
  
  const handleRefresh = () => {
    setRefreshing(true);
  };

  const handleRefreshComplete = () => {
    loadMedia();
    setRefreshing(false);
  };

  if (loading) {
    return <div className="w-full h-screen flex items-center justify-center bg-black text-white text-sm sm:text-base">Loading artworks...</div>;
  }

  return (
    // [修正] 将注释移到了标签外部，修复了导致构建失败的 ESLint 错误
    <div className="w-full h-screen relative">
      {/* 响应式：w-full (移动全宽) */}
      <button
        onClick={handleRefresh}
        className="absolute top-2 right-2 z-50 px-2 py-1 sm:px-4 sm:py-2 bg-gray-700 text-white rounded-lg shadow-lg hover:bg-gray-600 active:bg-gray-800 transition-colors disabled:opacity-50 disabled:cursor-not-allowed text-xs sm:text-sm"
        disabled={refreshing}
      >
        {refreshing ? 'Refreshing...' : 'Refresh Gallery'}
      </button>
      
      <Canvas style={{ background: '#000' }} camera={{ position: cameraPosition, fov: 50 }} onCreated={({ gl }) => gl.setClearColor(new THREE.Color('#000000'))}>
        <ambientLight intensity={1.5} name="mainAmbientLight" />
        <pointLight position={[10, 10, 10]} intensity={0.2} name="mainPointLight" />
        <Suspense fallback={null}>
          <Environment preset="sunset" background={false} />
          {media && media.length > 0 && (
            <Cube 
              media={media} 
              onMediaClick={handleMediaClick} 
              onRefreshComplete={handleRefreshComplete} 
              refreshing={refreshing} 
            />
          )}
        </Suspense>
        <OrbitControls enableDamping dampingFactor={0.05} rotateSpeed={0.5} enablePan={false} />
      </Canvas>

      {selectedMedia && (
        <LargeMedia3D 
          mediaItem={selectedMedia.mediaItem} 
          startPosition={selectedMedia.startPosition} 
          onClose={() => setSelectedMedia(null)} 
        />
      )}
    </div>
  );
}