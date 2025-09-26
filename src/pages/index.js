import { Canvas } from '@react-three/fiber';
import { OrbitControls } from '@react-three/drei';
import * as THREE from 'three';
import { RoundedBoxGeometry } from 'three/examples/jsm/geometries/RoundedBoxGeometry';

const Cube = () => {
  const geometry = new RoundedBoxGeometry(1, 1, 1, 10, 0.1);
  const material = new THREE.MeshStandardMaterial({ color: 0x2a2a2a });
  const size = 1.1;
  const cubes = [];
  for (let x = -1; x <= 1; x++) {
    for (let y = -1; y <= 1; y++) {
      for (let z = -1; z <= 1; z++) {
        if (x === 0 && y === 0 && z === 0) continue;
        cubes.push(<mesh key={`${x}-${y}-${z}`} position={[x * size, y * size, z * size]} geometry={geometry} material={material} />);
      }
    }
  }
  return <group>{cubes}</group>;
};

export default function Home() {
  return (
    <div style={{ width: '100vw', height: '100vh' }}>
      <Canvas camera={{ position: [5, 5, 5], fov: 50 }}>
        <ambientLight intensity={1.5} />
        <pointLight position={[10, 10, 10]} intensity={0.2} />
        <Cube />
        <OrbitControls />
      </Canvas>
    </div>
  );
}