// src/pages/index.tsx (生产适配，无改)
import dynamic from 'next/dynamic';

// 我们现在导入的是重构后的 LivingCubeApp 组件
// 它位于'../components/OriginalPrototype'文件中
const LivingCubeAppComponent = dynamic(
  () => import('../components/OriginalPrototype'),
  { ssr: false }  // 生产：3D 渲染客户端侧
);

export default function HomePage() {
  return <LivingCubeAppComponent />;
}