import { create } from 'zustand';

// 定义我们将要管理的状态的类型
interface AppState {
  // 当前是否处于沉浸式大图预览模式
  isImmersive: boolean;
  // 当前选中的媒体项目的信息
  selectedMedia: {
    mediaItem: any; // 我们稍后可以为 mediaItem 定义更精确的类型
    startPosition: [number, number, number];
  } | null;
  // 进入沉浸模式的动作
  enterImmersiveMode: (mediaItem: any, startPosition: [number, number, number]) => void;
  // 退出沉浸模式的动作
  exitImmersiveMode: () => void;
}

// 创建我们的 Zustand store
export const useAppStore = create<AppState>((set) => ({
  // 初始状态
  isImmersive: false,
  selectedMedia: null,

  // 定义 actions
  enterImmersiveMode: (mediaItem, startPosition) => set({
    isImmersive: true,
    selectedMedia: { mediaItem, startPosition },
  }),
  exitImmersiveMode: () => set({
    isImmersive: false,
    // 我们延迟半秒清空 selectedMedia，以给退场动画留出时间
    // 这是一个常见的、提升用户体验的技巧
    selectedMedia: null 
  }),
}));