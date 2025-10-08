// src/components/OriginalPrototype.js (终极完整版，响应式生产适配)
import React, { useState, useEffect, useCallback, Suspense } from 'react';
import { Canvas } from '@react-three/fiber';
import { Environment, OrbitControls } from '@react-three/drei';
import * as THREE from 'three';

// 确保从 Scene.js 导入的组件名与导出的名称一致
import { Cube, LargeMedia3D } from './Scene';

// [新增] 辅助函数：根据屏幕宽度判断是否为移动设备
const isMobile = () => typeof window !== 'undefined' && window.innerWidth < 768;

export default function LivingCubeApp() {
  const [media, setMedia] = useState(null);
  const [selectedMedia, setSelectedMedia] = useState(null);
  const [refreshing, setRefreshing] = useState(false);
  const [loading, setLoading] = useState(true);

  // [新增] 使用 state 来管理相机位置，并根据当前是否为移动设备设置初始值
  const [cameraPosition, setCameraPosition] = useState(isMobile() ? [8, 8, 8] : [5, 5, 5]);

  // [新增] 使用 useEffect 来监听窗口大小变化，并动态调整相机位置
  useEffect(() => {
    const handleResize = () => {
      setCameraPosition(isMobile() ? [8, 8, 8] : [5, 5, 5]);
    };

    window.addEventListener('resize', handleResize);
    
    // 组件卸载时移除监听器，避免内存泄漏
    return () => window.removeEventListener('resize', handleResize);
  }, []); // 空依赖数组确保此 effect 只在组件挂载和卸载时运行一次

  const handleMediaClick = useCallback((mediaItem, startPosition) => {
    setSelectedMedia({ mediaItem, startPosition });
  }, []);

  const loadMedia = useCallback(async () => {
    setLoading(true);
    try {
      // 1. [核心修正] 请求所有需要的元数据字段
      const fields = [
        'id',
        'name',
        'description',
        'price_cents',
        'wallpaper_file.id',
        'wallpaper_file.type'
      ].join(',');

      // 2. [核心修正] 移除所有 access_token，改为公开请求
      const fetchUrl = `${process.env.NEXT_PUBLIC_DIRECTUS_URL}/items/wallpapers?fields=${fields}`;
      const response = await fetch(fetchUrl);
      
      console.log('Fetch response status:', response.status);
      if (!response.ok) {
        throw new Error(`Directus API call failed with status: ${response.status}`);
      }

      const apiResponse = await response.json();
      console.log('API response data:', apiResponse.data);
      const mediaFiles = apiResponse.data;

      // 3. [核心修正] 构造包含所有元数据的完整对象
      const adaptedMediaFiles = mediaFiles
        .filter(item => item.wallpaper_file && item.wallpaper_file.id)
        .map(item => {
          const filePath = `${process.env.NEXT_PUBLIC_DIRECTUS_URL}/assets/${item.wallpaper_file.id}`;
          return {
            // 传递所有元数据！
            id: item.id,
            name: item.name,
            description: item.description,
            price_cents: item.price_cents,
            wallpaper_file: item.wallpaper_file,

            // 为 3D 组件保留 path 和 type
            path: filePath,
            type: (item.wallpaper_file.type || '').startsWith('video') ? 'video' : 'image',  // 生产：fallback 空 type
          };
        });

      console.log('Adapted media (with full metadata):', adaptedMediaFiles);
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
    return <div className="w-full h-screen flex items-center justify-center bg-black text-white text-sm sm:text-base">Loading artworks...</div>;  // 响应式：移动小字体
  }

  return (
    <div className="w-full h-screen relative">  // 响应式：w-full (移动全宽)
      <button
        onClick={handleRefresh}
        className="absolute top-2 right-2 z-50 px-2 py-1 sm:px-4 sm:py-2 bg-gray-700 text-white rounded-lg shadow-lg hover:bg-gray-600 active:bg-gray-800 transition-colors disabled:opacity-50 disabled:cursor-not-allowed text-xs sm:text-sm"  // 响应式：移动小 padding/字体
        disabled={refreshing}
      >
        {refreshing ? 'Refreshing...' : 'Refresh Gallery'}
      </button>
      
      {/* [修改] 将 camera 的 position 属性绑定到我们动态的 cameraPosition state 上 */}
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