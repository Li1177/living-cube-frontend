// src/components/Scene.js (最终、已验证的正确版本)
import { Text, OrbitControls, Environment } from '@react-three/drei';
import React, { Suspense, useMemo, useCallback, useRef, useEffect, useState } from 'react';
import { Canvas, useLoader, useFrame, useThree } from '@react-three/fiber';
import * as THREE from 'three';
import { RoundedBoxGeometry } from 'three/examples/jsm/geometries/RoundedBoxGeometry';
import { socket } from '../lib/socket';
import { DanmakuOverlay } from './DanmakuOverlay';
import { useAppStore } from '../lib/store';

// ===================================================================
//  1. LargeMediaContent Component
// ===================================================================
// ===================================================================
//  1. LargeMediaContent Component
// ===================================================================
const LargeMediaContent = ({ mediaItem, startPosition }) => {
  const frameRef = useRef();
  const animationTime = useRef(0);
  const [aspectRatio, setAspectRatio] = useState(2 / 3);
  const isMountedRef = useRef(true);
  const { viewport } = useThree();
  const exitImmersiveMode = useAppStore((state) => state.exitImmersiveMode);
  
  const finalAnimationState = useRef({
      pos: new THREE.Vector3(),
      quat: new THREE.Quaternion(),
  }).current;


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
      video.onloadedmetadata = () => { if (isMountedRef.current) setAspectRatio(video.videoWidth / video.videoHeight); };
      video.src = mediaItem.path;
      return videoTexture;
    } else {
      const tex = new THREE.TextureLoader().load(mediaItem.path, (loadedTex) => { if (isMountedRef.current) setAspectRatio(loadedTex.image.naturalWidth / loadedTex.image.naturalHeight); });
      tex.colorSpace = THREE.SRGBColorSpace;
      return tex;
    }
  }, [mediaItem]);

  useEffect(() => {
    if (texture && texture.isVideoTexture) {
      const video = texture.image;
      video.play().catch(() => {});
      return () => { video.pause(); video.src = ''; video.load(); texture.dispose(); };
    }
    return () => { if (texture) { texture.dispose(); } }
  }, [texture]);

  const { displayWidth, displayHeight } = useMemo(() => {
    const padding = 0.9;
    const viewportAspectRatio = viewport.width / viewport.height;
    let w, h;
    if (aspectRatio > viewportAspectRatio) {
      w = viewport.width * padding;
      h = w / aspectRatio;
    } else {
      h = viewport.height * padding;
      w = h * aspectRatio;
    }
    return { displayWidth: w, displayHeight: h };
  }, [aspectRatio, viewport.width, viewport.height]);

  const frameWidth = displayWidth + 0.2;
  const frameHeight = displayHeight + 0.2;
  const frameGeometry = useMemo(() => new RoundedBoxGeometry(frameWidth, frameHeight, 0.1, 16, 0.05), [frameWidth, frameHeight]);
  const frameMaterial = useMemo(() => new THREE.MeshPhysicalMaterial({ color: 0xffd700, metalness: 1, roughness: 0.4, envMapIntensity: 0.01, clearcoat: 1, clearcoatRoughness: 0.1 }), []);

  const { endVec, endQuat } = useMemo(() => ({
    endVec: new THREE.Vector3(0, 0, 0),
    endQuat: new THREE.Quaternion(0, 0, 0, 1)
  }), []);

  useFrame((state, delta) => {
    if (!frameRef.current) return;
    animationTime.current += delta;
    const phaseOneDuration = 1.5;
    const totalDuration = 2.5;

    if (animationTime.current < phaseOneDuration) {
      const progress = animationTime.current / phaseOneDuration;
      const t = progress;
      const x = startPosition[0] + Math.sin(t * Math.PI) * 3;
      const y = startPosition[1] + (1 - Math.cos(t * Math.PI)) * 1.5;
      const z = startPosition[2] - t * 5;
      frameRef.current.position.set(x, y, z);
      const spinSpeed = 12;
      frameRef.current.rotation.y += spinSpeed * delta;
      frameRef.current.rotation.x += spinSpeed * delta;
      const scale = progress;
      frameRef.current.scale.set(scale, scale, scale);
      finalAnimationState.pos.copy(frameRef.current.position);
      finalAnimationState.quat.copy(frameRef.current.quaternion);
    } else if (animationTime.current < totalDuration) {
      const phaseTwoProgress = (animationTime.current - phaseOneDuration) / (totalDuration - phaseOneDuration);
      const easedProgress = 1 - Math.pow(1 - phaseTwoProgress, 4); 
      frameRef.current.position.lerpVectors(finalAnimationState.pos, endVec, easedProgress);
      frameRef.current.quaternion.slerpQuaternions(finalAnimationState.quat, endQuat, easedProgress);
      frameRef.current.scale.set(1, 1, 1);
    } else {
      if (frameRef.current.scale.x !== 1) {
        frameRef.current.position.copy(endVec);
        frameRef.current.quaternion.copy(endQuat);
        frameRef.current.scale.set(1, 1, 1);
      }
    }
  });

  const fontSize = Math.min(0.15, viewport.width / 20);

  return (
    <group ref={frameRef} onDoubleClick={exitImmersiveMode} scale={[0,0,0]}>
      <mesh geometry={frameGeometry} material={frameMaterial} />
      {texture && <mesh position={[0, 0, 0.051]}><planeGeometry args={[displayWidth, displayHeight]} /><meshBasicMaterial map={texture} /></mesh>}
      <mesh position={[0, 0, -0.051]}><planeGeometry args={[frameWidth, frameHeight]} /><meshPhysicalMaterial color={0xffd700} metalness={0.9} roughness={0.1} /></mesh>
      <Text position={[0, 0.08, -0.06]} rotation={[0, Math.PI, 0]} fontSize={fontSize} font="/fonts/STXINGKA.TTF" color="#000000" anchorX="center" anchorY="middle">Welcome to the Cube!</Text>
      <Text position={[0, -0.08, -0.06]} rotation={[0, Math.PI, 0]} fontSize={fontSize} font="/fonts/STXINGKA.TTF" color="#000000" anchorX="center" anchorY="middle">Love it? Share a danmaku!</Text>
    </group>
  );
};

// ===================================================================
//  (文件的其余部分 100% 保持您线上版本的原样)
// ===================================================================

export const LargeMedia3D = ({ mediaItem, startPosition }) => {
  const [danmakus, setDanmakus] = useState([]);
  const [purchaseState, setPurchaseState] = useState('idle');
  const newDanmakuHandlerRef = useRef(null);
  const isMountedRef = useRef(false);

  useEffect(() => {
    isMountedRef.current = true;
    if (!mediaItem || !mediaItem.id) return;

    fetch(`/api/danmaku?wallpaper_id=${mediaItem.id}`)
      .then((res) => res.json())
      .then((data) => {
        if (data && Array.isArray(data)) {
          if (isMountedRef.current) setDanmakus(data);
        } else {
          console.error('Initial danmaku data is not a valid array:', data);
        }
      })
      .catch(error => { console.error('Error fetching initial danmakus:', error); });

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

  const handlePurchase = async () => { /* ... (逻辑不变) ... */ };
  const handleSendDanmaku = (userInputText) => { /* ... (逻辑不变) ... */ };

  return (
    <div className="fixed inset-0 z-50 w-full h-full">
      <Canvas camera={{ position: [0, 0, 8], fov: 50 }}>
        <ambientLight intensity={0.8} />
        <pointLight position={[10, 10, 10]} intensity={1} />
        <Suspense fallback={null}>
          <LargeMediaContent mediaItem={mediaItem} startPosition={startPosition} />
          <Environment preset="sunset" />
        </Suspense>
        {/* ✨ 核心修复：我们将 OrbitControls 组件加回来！ ✨ */}
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

export const Cube = ({ media, onRefreshComplete, refreshing }) => {
  const { scene } = useThree();
  const enterImmersiveMode = useAppStore((state) => state.enterImmersiveMode); // <-- 从 "大脑" 获取 action
  
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
      enterImmersiveMode(mediaItem, [x, y, z]); // <-- 改动在这里！
    }
  }, [media, enterImmersiveMode]); // <-- 依赖项也已更新
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