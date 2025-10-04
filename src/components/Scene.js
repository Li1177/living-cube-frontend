// 文件路径: src/components/Scene.js

import { Text, Html, OrbitControls, Environment } from '@react-three/drei';
import React, { Suspense, useMemo, useCallback, useRef, useEffect, useState } from 'react';
import { Canvas, useLoader, useFrame, useThree } from '@react-three/fiber';
import * as THREE from 'three';
import { RoundedBoxGeometry } from 'three/examples/jsm/geometries/RoundedBoxGeometry';
import { socket } from '../lib/socket';

// ===================================================================
//  1. 2D UI 层组件 (轻微优化: 添加随机 key 防重复)
// ===================================================================
const DanmakuUI = ({ danmakus, onSendDanmaku, onPurchase, purchaseState, mediaItem }) => {
  console.log('--- DanmakuUI Component Re-rendered ---');
  console.log('Received `danmakus` prop with length:', danmakus.length);
  console.log('Full `danmakus` prop content:', danmakus);
  const [danmakuInput, setDanmakuInput] = useState('');
  const [isUIVisible, setUIVisible] = useState(false);

  useEffect(() => {
    const timer = setTimeout(() => {
      setUIVisible(true);
    }, 2500);
    return () => clearTimeout(timer);
  }, []);

  const handleSend = (e) => {
    e.preventDefault();
    if (danmakuInput.trim() === '') return;
    onSendDanmaku(danmakuInput.trim());
    setDanmakuInput('');
  };

  const buttonText = {
    idle: 'Unlock for $0.99',
    pending: 'Redirecting...',
    success: 'Success!',
    error: 'Payment Failed, Try Again'
  }[purchaseState];

  return (
    <>
      <div className="danmaku-container">
        {danmakus.map((d, index) => (
          <div
            key={d.id || `${d.message}-${index}-${Date.now()}`}  // 优化: 随机 key 防重复渲染
            className="danmaku-item"
            style={{
              top: `${Math.random() * 80 + 5}%`,
              animationDuration: `${Math.random() * 5 + 8}s`,
              color: ['#ffffff', '#ffdddd', '#ddffdd', '#ddddff'][Math.floor(Math.random() * 4)],
            }}
          >
            {d.message}
          </div>
        ))}
      </div>

      <div
        className="absolute bottom-10 left-1/2 -translate-x-1/2 z-20 transition-opacity duration-500"
        style={{ opacity: isUIVisible ? 1 : 0 }}
        onDoubleClick={(e) => e.stopPropagation()}
      >
        <div className="flex items-center justify-center space-x-4 p-4">
          <button
            onClick={onPurchase}
            disabled={purchaseState !== 'idle' && purchaseState !== 'error'}
            className="px-6 py-2 bg-blue-600 text-white font-bold rounded-lg shadow-lg hover:bg-blue-500 active:bg-blue-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {buttonText}
          </button>

          <form onSubmit={handleSend} className="flex items-center space-x-2">
            <input
              type="text"
              value={danmakuInput}
              onChange={(e) => setDanmakuInput(e.target.value)}
              placeholder="Send a comment..."
              maxLength={50}
              className="px-4 py-2 w-56 bg-gray-800 text-white rounded-lg border-2 border-gray-600 focus:border-blue-500 focus:outline-none transition-colors"
            />
            <button
              type="submit"
              className="px-5 py-2 bg-green-600 text-white font-bold rounded-lg shadow-lg hover:bg-green-500 active:bg-green-700 transition-colors"
            >
              Send
            </button>
          </form>
        </div>
      </div>
    </>
  );
};


// ===================================================================
//  2. 3D 场景组件 (保持不变)
// ===================================================================
const LargeMediaContent = ({ mediaItem, startPosition, onClose }) => {
  const frameRef = useRef();
  const animationTime = useRef(0);
  const [aspectRatio, setAspectRatio] = useState(2 / 3);

  const texture = useMemo(() => {
    if (mediaItem.type === 'video') {
      const video = document.createElement('video');
      video.loop = true;
      video.muted = false;
      video.crossOrigin = 'anonymous';
      const videoTexture = new THREE.VideoTexture(video);
      video.onloadedmetadata = () => setAspectRatio(video.videoWidth / video.videoHeight);
      video.src = mediaItem.path;
      return videoTexture;
    } else {
      const tex = new THREE.TextureLoader().load(mediaItem.path, (loadedTex) => setAspectRatio(loadedTex.image.naturalWidth / loadedTex.image.naturalHeight));
      tex.colorSpace = THREE.SRGBColorSpace;
      return tex;
    }
  }, [mediaItem]);
  useEffect(() => {
    if (texture && texture.isVideoTexture) {
      const video = texture.image;
      video.play().catch(() => {});
      return () => {
        video.pause();
        video.src = '';
        video.load();
        texture.dispose();
      };
    }
    return () => {
        if (texture) {
            texture.dispose();
        }
    }
  }, [texture]);
  const displayHeight = 3;
  const displayWidth = displayHeight * aspectRatio;
  const frameWidth = displayWidth + 0.2;
  const frameHeight = displayHeight + 0.2;
  const frameGeometry = useMemo(() => new RoundedBoxGeometry(frameWidth, frameHeight, 0.1, 16, 0.05), [frameWidth, frameHeight]);
  const frameMaterial = useMemo(() => new THREE.MeshPhysicalMaterial({ color: 0xffd700, metalness: 1, roughness: 0.4, envMapIntensity: 0.01, clearcoat: 1, clearcoatRoughness: 0.1 }), []);
  useFrame((state, delta) => {
    if (frameRef.current) {
      animationTime.current += delta;
      const animationDuration = 2;
      if (animationTime.current < animationDuration) {
        const progress = animationTime.current / animationDuration;
        const t = Math.min(progress, 1);
        frameRef.current.scale.set(t * 2, t * 2, t * 2);
        const x = startPosition[0] + Math.sin(t * Math.PI) * 3;
        const y = startPosition[1] + (1 - Math.cos(t * Math.PI)) * 1.5;
        const z = startPosition[2] - t * 5;
        frameRef.current.position.set(x, y, z);
        const spinSpeed = 10;
        frameRef.current.rotation.y += spinSpeed * delta;
        frameRef.current.rotation.x += spinSpeed * delta;
      } else {
        const timeLeft = (animationDuration + 3) - animationTime.current;
        const deceleration = Math.max(0, timeLeft / 3);
        frameRef.current.rotation.y += deceleration * delta;
        frameRef.current.rotation.x += deceleration * delta;
        if (deceleration === 0 && (frameRef.current.position.x !== 0 || frameRef.current.position.y !== 0 || frameRef.current.position.z !== 0)) {
          frameRef.current.position.set(0, 0, 0);
          frameRef.current.rotation.y = Math.round(frameRef.current.rotation.y / (2 * Math.PI)) * (2 * Math.PI);
          frameRef.current.rotation.x = 0;
        }
      }
    }
  });

  return (
    <group ref={frameRef} onDoubleClick={onClose}>
      <mesh geometry={frameGeometry} material={frameMaterial} />
      {texture && <mesh position={[0, 0, 0.051]}><planeGeometry args={[displayWidth, displayHeight]} /><meshBasicMaterial map={texture} /></mesh>}
      <mesh position={[0, 0, -0.051]}><planeGeometry args={[frameWidth, frameHeight]} /><meshPhysicalMaterial color={0xffd700} metalness={0.9} roughness={0.1} /></mesh>
      <Text position={[0, 0.08, -0.06]} rotation={[0, Math.PI, 0]} fontSize={0.15} font="/fonts/STXINGKA.TTF" color="#000000" anchorX="center" anchorY="middle">Welcome to the Cube!</Text>
      <Text position={[0, -0.08, -0.06]} rotation={[0, Math.PI, 0]} fontSize={0.15} font="/fonts/STXINGKA.TTF" color="#000000" anchorX="center" anchorY="middle">Love it? Share a danmaku!</Text>
    </group>
  );
};


// ===================================================================
//  3. “智能容器”组件 (核心修复: 乐观更新 + handler Ref 防 unmount 错误)
// ===================================================================
export const LargeMedia3D = ({ mediaItem, startPosition, onClose }) => {
  const [danmakus, setDanmakus] = useState([]);
  const [purchaseState, setPurchaseState] = useState('idle');
  const newDanmakuHandlerRef = useRef(null);  // 新增: Ref 存储 handler，防重复绑定/泄漏

  useEffect(() => {
    if (!mediaItem || !mediaItem.id) return;
    
    // --- 诊断: Socket 连接状态检查 ---
    console.log('--- LargeMedia3D: Initializing for mediaItem.id:', mediaItem.id);
    console.log('Socket connected?', socket.connected);
    
    // 加载历史弹幕 (API 保持不变)
    fetch(`/api/danmaku?wallpaper_id=${mediaItem.id}`)
      .then((res) => {
        console.log('API Response Status:', res.status, res.statusText);
        if (!res.ok) {
          console.error('API request failed!');
        }
        return res.json();
      })
      .then((data) => {
        console.log('--- API Response Data for Historical Danmakus ---');
        console.log('Received data:', data);

        if (data && Array.isArray(data)) {
          console.log(`Setting ${data.length} danmakus into state.`);
          // 优化: 添加 id/timestamp 以匹配 server 格式
          setDanmakus(data.map(d => ({ ...d, id: d.id || Date.now() + Math.random(), timestamp: d.timestamp || Date.now() })));
        } else {
          console.error('Data received is NOT a valid array:', data);
        }
      })
      .catch(error => {
        console.error('Error fetching or parsing danmakus:', error);
      });

    // --- 核心修复 1: 匹配 server 'join-room' 事件 (kebab-case) ---
    socket.emit('join-room', mediaItem.id);  // 改: 'join_room' → 'join-room'
    console.log('Emitted join-room for:', mediaItem.id);

    // --- 核心修复 2: 匹配 server 'new-danmaku' 事件 + 用 Ref 存储 handler ---
    const handleNewDanmaku = (newDanmaku) => {
      console.log('Received new-danmaku from server:', newDanmaku);
      // 检查组件是否 mounted (防 unmount 更新)
      if (newDanmakuHandlerRef.current) {
        setDanmakus((prev) => [...prev, { ...newDanmaku, id: newDanmaku.id || Date.now() + Math.random() }]);
      }
    };
    newDanmakuHandlerRef.current = handleNewDanmaku;  // 存储到 Ref
    socket.on('new-danmaku', handleNewDanmaku);  // 改: 'receive_danmaku' → 'new-danmaku'

    return () => {
      // --- 核心修复 3: 添加 leave-room 事件 (匹配 server) ---
      socket.emit('leave-room', mediaItem.id);  // 新增: 清理房间
      console.log('Emitted leave-room for:', mediaItem.id);
      socket.off('new-danmaku', handleNewDanmaku);
      newDanmakuHandlerRef.current = null;  // 清空 Ref
    };
  }, [mediaItem]);

  const handleSendDanmaku = (message) => {
    if (!mediaItem) return;
    // --- 核心修复 4: 乐观更新 (立即本地添加，server 确认同步) ---
    const tempId = Date.now() + Math.random();  // 临时 ID
    const optimisticDanmaku = {
      id: tempId,
      message: message,
      userId: socket.id || 'anonymous',
      timestamp: Date.now(),
    };
    setDanmakus((prev) => [...prev, optimisticDanmaku]);  // 立即显示 (乐观)
    console.log('Optimistic update: Added local danmaku:', optimisticDanmaku);

    // 发送到 server (异步，确认后同步)
    socket.emit('send-danmaku', {
      roomId: mediaItem.id,  // 改: 'wallpaper_id' → 'roomId'
      message: message,
      userId: socket.id || 'anonymous',
    });
    console.log('Emitted send-danmaku:', { roomId: mediaItem.id, message });
  };

  const handlePurchase = async () => {
    setPurchaseState('pending');
    try {
      const response = await fetch('/api/create-payment', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ mediaId: mediaItem.id }),
      });
      const data = await response.json();
      if (!response.ok) throw new Error(data.message || 'Payment creation failed');
      if (data.paymentUrl) window.location.href = data.paymentUrl;
    } catch (error) {
      setPurchaseState('error');
    }
  };

  return (
    <div className="fixed inset-0 z-50">
      <Canvas camera={{ position: [0, 0, 8], fov: 50 }}>
        <ambientLight intensity={0.8} />
        <pointLight position={[10, 10, 10]} intensity={1} />
        <Suspense fallback={null}>
          <LargeMediaContent mediaItem={mediaItem} startPosition={startPosition} onClose={onClose} />
          <Environment preset="sunset" />
        </Suspense>
        <OrbitControls />
      </Canvas>
      
      <DanmakuUI
        danmakus={danmakus}
        onSendDanmaku={handleSendDanmaku}
        onPurchase={handlePurchase}
        purchaseState={purchaseState}
        mediaItem={mediaItem}
      />
    </div>
  );
};


// ===================================================================
//  4. Cube 组件 (保持不变)
// ===================================================================
export const Cube = ({ media, onMediaClick, onRefreshComplete, refreshing }) => {
  // ... 您原有的 Cube 组件代码保持不变 ...
  const { scene } = useThree();
  const textureLoader = useLoader(THREE.TextureLoader, media.filter(item => item.type === 'image').map(item => item.path));
  const videoTextures = useMemo(() => {
    return media.filter(item => item.type === 'video').map(item => {
      const video = document.createElement('video');
      video.loop = false;
      video.muted = true;
      video.setAttribute('crossorigin', 'anonymous');
      video.setAttribute('webkit-playsinline', '');
      video.setAttribute('playsinline', '');
      const videoTexture = new THREE.VideoTexture(video);
      video.addEventListener('loadedmetadata', () => { video.currentTime = 1; });
      video.src = item.path;
      video.load();
      return videoTexture;
    });
  }, [media]);
  useEffect(() => {
    return () => {
      videoTextures.forEach(texture => {
        if (texture.image) {
          texture.image.pause();
          texture.image.src = '';
          texture.image.load();
        }
        texture.dispose();
      });
    };
  }, [videoTextures]);
  const cubesRef = useRef({});
  const faceIndexMap = useRef({});
  const groupRef = useRef();
  const geometry = useMemo(() => new RoundedBoxGeometry(1, 1, 1, 10, 0.1), []);
  useEffect(() => {
    const imageMediaItems = media.filter(item => item.type === 'image');
    const videoMediaItems = media.filter(item => item.type === 'video');
    let imageCounter = 0; let videoCounter = 0;
    for (let x = -1; x <= 1; x++) {
      for (let y = -1; y <= 1; y++) {
        for (let z = -1; z <= 1; z++) {
          if (x === 0 && y === 0 && z === 0) continue;
          const key = `${x}-${y}-${z}`;
          const assignFace = (faceIndex) => {
            const isVideo = imageCounter >= imageMediaItems.length;
            let mediaItem;
            if (isVideo) { if (videoCounter < videoMediaItems.length) mediaItem = videoMediaItems[videoCounter++]; }
            else { mediaItem = imageMediaItems[imageCounter++]; }
            if (mediaItem) faceIndexMap.current[`${key}-${faceIndex}`] = mediaItem.path;
          };
          if (x === 1) assignFace(0); if (x === -1) assignFace(1);
          if (y === 1) assignFace(2); if (y === -1) assignFace(3);
          if (z === 1) assignFace(4); if (z === -1) assignFace(5);
        }
      }
    }
  }, [media]);
  const size = 1.1;
  const createMaterial = useCallback(() => new THREE.MeshStandardMaterial({ color: 0x2a2a2a, emissive: "#333333", emissiveIntensity: 0.2, metalness: 0.8, roughness: 0.2, envMapIntensity: 1 }), []);
  const highlightFace = useCallback((cubeKey, faceIndex) => {
    const cube = cubesRef.current[cubeKey];
    if (cube && cube.material[faceIndex]) {
        const material = cube.material[faceIndex];
        const originalMaterialSettings = { metalness: material.metalness, roughness: material.roughness, emissive: material.emissive.clone(), emissiveIntensity: material.emissiveIntensity, color: material.color.clone() };
        const ambientLight = scene.getObjectByName('mainAmbientLight');
        const pointLight = scene.getObjectByName('mainPointLight');
        const originalAmbientIntensity = ambientLight ? ambientLight.intensity : 1.5;
        const originalPointIntensity = pointLight ? pointLight.intensity : 0.2;
        material.metalness = 0.5; material.roughness = 0.3; material.emissive.setHex(0x000000); material.emissiveIntensity = 0.0; material.color.setHex(0xffffff); material.needsUpdate = true;
        if (ambientLight) ambientLight.intensity = 0.5;
        if (pointLight) { pointLight.intensity = 1.0; pointLight.position.set(10, 10, 10); }
        const initialPosition = { x: cube.position.x, y: cube.position.y, z: cube.position.z };
        if (cube.highlightTimer) clearTimeout(cube.highlightTimer);
        const startTime = performance.now();
        const animateVibration = () => {
            const elapsedTime = performance.now() - startTime;
            if (elapsedTime < 3000) {
                const time = elapsedTime / 1000;
                const vibration = Math.sin(time * 20) * 0.005;
                cube.position.x = initialPosition.x + vibration; cube.position.y = initialPosition.y + vibration;
                requestAnimationFrame(animateVibration);
            } else { cube.position.set(initialPosition.x, initialPosition.y, initialPosition.z); }
        };
        requestAnimationFrame(animateVibration);
        cube.highlightTimer = setTimeout(() => {
            try {
                material.metalness = originalMaterialSettings.metalness; material.roughness = originalMaterialSettings.roughness; material.emissive.copy(originalMaterialSettings.emissive); material.emissiveIntensity = originalMaterialSettings.emissiveIntensity; material.color.copy(originalMaterialSettings.color);
                if (ambientLight) ambientLight.intensity = originalAmbientIntensity;
                if (pointLight) pointLight.intensity = originalPointIntensity;
                material.needsUpdate = true;
                cube.position.set(initialPosition.x, initialPosition.y, initialPosition.z);
            } finally { cube.highlightTimer = null; cube.isCoolingDown = false; }
        }, 3000);
    }
  }, [scene]);
  const handleClick = useCallback((e) => {
    e.stopPropagation();
    const { object, face } = e;
    const cubeKey = object.key;
    const faceIndex = face.materialIndex;
    if (cubesRef.current[cubeKey]?.isCoolingDown) return;
  
    const mediaSrc = faceIndexMap.current[`${cubeKey}-${faceIndex}`];
    const mediaItem = media.find(item => item.path === mediaSrc);
    if (!mediaItem) return;
    highlightFace(cubeKey, faceIndex);
    cubesRef.current[cubeKey].isCoolingDown = true;
    if (mediaItem.type === 'video') {
      const videoElement = videoTextures.find(texture => texture.image?.src.includes(mediaItem.path))?.image;
      if (videoElement) {
        videoElement.play();
        setTimeout(() => { videoElement.pause(); videoElement.currentTime = 0; }, 3000);
      }
    }
  }, [media, videoTextures, highlightFace]);
  const handleDoubleClick = useCallback((e) => {
    e.stopPropagation();
    const { object, face } = e;
    const cubeKey = object.key;
    const faceIndex = face.materialIndex;
    const mediaSrc = faceIndexMap.current[`${cubeKey}-${faceIndex}`];
    const mediaItem = media.find(item => item.path === mediaSrc);
    if (mediaItem) {
      const { x, y, z } = object.position;
      onMediaClick(mediaItem, [x, y, z]);
    }
  }, [media, onMediaClick]);
  const cubes = useMemo(() => {
    let textureIndex = 0; let videoIndex = 0;
    const cubesArray = [];
    for (let x = -1; x <= 1; x++) {
      for (let y = -1; y <= 1; y++) {
        for (let z = -1; z <= 1; z++) {
          if (x === 0 && y === 0 && z === 0) continue;
          const materials = Array(6).fill(null).map(createMaterial);
          const assignTexture = () => {
            if (textureIndex >= textureLoader.length) return videoTextures[videoIndex++];
            return textureLoader[textureIndex++];
          };
          if (x === 1) materials[0].map = assignTexture(); if (x === -1) materials[1].map = assignTexture();
          if (y === 1) materials[2].map = assignTexture(); if (y === -1) materials[3].map = assignTexture();
          if (z === 1) materials[4].map = assignTexture(); if (z === -1) materials[5].map = assignTexture();
          cubesArray.push(<mesh key={`${x}-${y}-${z}`} ref={el => { if (el) { el.key = `${x}-${y}-${z}`; cubesRef.current[`${x}-${y}-${z}`] = el; } }} position={[x * size, y * size, z * size]} geometry={geometry} material={materials} onClick={handleClick} onDoubleClick={handleDoubleClick} />);
        }
      }
    }
    return cubesArray;
  }, [geometry, textureLoader, videoTextures, size, createMaterial, handleClick, handleDoubleClick]);
  useEffect(() => {
    if (refreshing) {
      let rotation = 0;
      const animateRotation = () => {
        if (rotation < Math.PI * 2) {
          rotation += 0.05;
          if (groupRef.current) groupRef.current.rotation.y = rotation;
          requestAnimationFrame(animateRotation);
        } else {
          if (groupRef.current) groupRef.current.rotation.y = 0;
          onRefreshComplete();
        }
      };
      animateRotation();
    }
  }, [refreshing, onRefreshComplete]);
  return <group ref={groupRef}>{cubes}</group>
};