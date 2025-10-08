// src/components/Scene.js (终极完整版 - 响应式生产适配)
import { Text, OrbitControls, Environment } from '@react-three/drei';
import React, { Suspense, useMemo, useCallback, useRef, useEffect, useState } from 'react';
import { Canvas, useLoader, useFrame, useThree } from '@react-three/fiber';
import * as THREE from 'three';
import { RoundedBoxGeometry } from 'three/examples/jsm/geometries/RoundedBoxGeometry';
import { socket } from '../lib/socket';
import { DanmakuOverlay } from './DanmakuOverlay';  // 整合：用独立 Overlay 替换内嵌 UI

// ===================================================================
//  1. 3D 场景组件 (响应式字体调整)
// ===================================================================
const LargeMediaContent = ({ mediaItem, startPosition, onClose }) => {
  const frameRef = useRef();
  const animationTime = useRef(0);
  const [aspectRatio, setAspectRatio] = useState(2 / 3);
  const isMountedRef = useRef(true);  // 防 unmounted setState
  const { viewport } = useThree();  // 响应式：获取 viewport 尺寸

  useEffect(() => {
    isMountedRef.current = true;
    return () => { isMountedRef.current = false; };
  }, []);

  const texture = useMemo(() => {
    if (mediaItem.type === 'video') {
      const video = document.createElement('video');
      video.loop = true;
      video.muted = false;
      video.crossOrigin = 'anonymous';
      const videoTexture = new THREE.VideoTexture(video);
      video.onloadedmetadata = () => {
        if (isMountedRef.current) setAspectRatio(video.videoWidth / video.videoHeight);
      };
      video.src = mediaItem.path;
      return videoTexture;
    } else {
      const tex = new THREE.TextureLoader().load(mediaItem.path, (loadedTex) => {
        if (isMountedRef.current) setAspectRatio(loadedTex.image.naturalWidth / loadedTex.image.naturalHeight);
      });
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

  // 响应式：字体大小基于 viewport
  const fontSize = Math.min(0.15, viewport.width / 20);  // 移动小字体

  return (
    <group ref={frameRef} onDoubleClick={onClose}>
      <mesh geometry={frameGeometry} material={frameMaterial} />
      {texture && <mesh position={[0, 0, 0.051]}><planeGeometry args={[displayWidth, displayHeight]} /><meshBasicMaterial map={texture} /></mesh>}
      <mesh position={[0, 0, -0.051]}><planeGeometry args={[frameWidth, frameHeight]} /><meshPhysicalMaterial color={0xffd700} metalness={0.9} roughness={0.1} /></mesh>
      <Text position={[0, 0.08, -0.06]} rotation={[0, Math.PI, 0]} fontSize={fontSize} font="/fonts/STXINGKA.TTF" color="#000000" anchorX="center" anchorY="middle">Welcome to the Cube!</Text>
      <Text position={[0, -0.08, -0.06]} rotation={[0, Math.PI, 0]} fontSize={fontSize} font="/fonts/STXINGKA.TTF" color="#000000" anchorX="center" anchorY="middle">Love it? Share a danmaku!</Text>
    </group>
  );
};

// ===================================================================
//  2. “智能容器”组件 (生产适配)
// ===================================================================
export const LargeMedia3D = ({ mediaItem, startPosition, onClose }) => {
  const [danmakus, setDanmakus] = useState([]);
  const [purchaseState, setPurchaseState] = useState('idle');
  const newDanmakuHandlerRef = useRef(null);
  const isMountedRef = useRef(false);  // 生产：防 unmounted setState

  useEffect(() => {
    isMountedRef.current = true;
    if (!mediaItem || !mediaItem.id) return;

    // [核心修正] 修正 fetch URL 参数名
    fetch(`/api/danmaku?wallpaper_id=${mediaItem.id}`)  // 统一：wallpaper_id
      .then((res) => res.json())
      .then((data) => {
        if (data && Array.isArray(data)) {
          if (isMountedRef.current) setDanmakus(data);
        } else {
          console.error('Initial danmaku data is not a valid array:', data);
        }
      })
      .catch(error => {
        console.error('Error fetching initial danmakus:', error);
      });

    socket.emit('join-room', mediaItem.id);

    const handleNewDanmaku = (newDanmaku) => {
      if (newDanmakuHandlerRef.current && isMountedRef.current) {
        setDanmakus((prev) => [...prev, newDanmaku]);
      }
    };
    newDanmakuHandlerRef.current = handleNewDanmaku;
    socket.on('new-danmaku', handleNewDanmaku);

    return () => {
      isMountedRef.current = false;
      socket.emit('leave-room', mediaItem.id);
      socket.off('new-danmaku', handleNewDanmaku);
      newDanmakuHandlerRef.current = null;
    };
  }, [mediaItem]);

  // [核心修正] 添加 handlePurchase 函数的定义
  const handlePurchase = async () => {
    if (!mediaItem) return;
    setPurchaseState('pending');
    try {
      const response = await fetch('/api/create-payment', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          mediaId: mediaItem.id,
          userId: socket.id // 传递 userId
        }),
      });
      const data = await response.json();
      if (!response.ok) throw new Error(data.message || 'Payment creation failed');
      if (data.paymentUrl) window.location.href = data.paymentUrl;
    } catch (error) {
      console.error("Purchase Error:", error);
      setPurchaseState('error');
    }
  };

  // 保持你最新版本的 handleSendDanmaku
  const handleSendDanmaku = (userInputText) => {
    if (!mediaItem) return;
    const videoElement = document.querySelector('video');
    const currentTime = videoElement ? videoElement.currentTime : 0;
    const optimisticDanmaku = {
      id: `temp-${Date.now()}`,
      content: userInputText,
      user_id: socket.id || 'anonymous',
      timestamp: currentTime,
      color: '#FFFFFF',  // 生产：默认 color
      type: 'scroll',  // 生产：默认 type
    };
    if (isMountedRef.current) setDanmakus((prev) => [...prev, optimisticDanmaku]);
    const dataToSend = {
      roomId: mediaItem.id,
      text: userInputText,
      time: currentTime,
      color: '#FFFFFF',  // 生产：传 color
      type: 'scroll',  // 生产：传 type
    };
    socket.emit('send-danmaku', dataToSend);
    console.log('Emitted send-danmaku with standard data:', dataToSend);
  };

  return (
    <div className="fixed inset-0 z-50 w-full h-full">  // 响应式：明确 w-full h-full
      <Canvas camera={{ position: [0, 0, 8], fov: 50 }}>
        <ambientLight intensity={0.8} />
        <pointLight position={[10, 10, 10]} intensity={1} />
        <Suspense fallback={null}>
          <LargeMediaContent mediaItem={mediaItem} startPosition={startPosition} onClose={onClose} />
          <Environment preset="sunset" />
        </Suspense>
        <OrbitControls />
      </Canvas>
      
      <DanmakuOverlay
        mediaItem={mediaItem}
        danmakuList={danmakus}
        onDanmakuSubmit={handleSendDanmaku}
        purchaseState={purchaseState}
        onPurchase={handlePurchase}
      />
    </div>
  );
};

// ===================================================================
//  3. Cube 组件 (保持不变)
// ===================================================================
export const Cube = ({ media, onMediaClick, onRefreshComplete, refreshing }) => {
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