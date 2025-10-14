import { create } from 'zustand';

interface AppState {
  isImmersive: boolean;
  selectedMedia: {
    mediaItem: any;
    startPosition: [number, number, number];
  } | null;
  enterImmersiveMode: (mediaItem: any, startPosition: [number, number, number]) => void;
  exitImmersiveMode: () => void;

  // --- [新增 v1.4] 支付模态框状态管理 ---
  isChoiceModalOpen: boolean;
  itemToPurchase: any | null;
  openChoiceModal: (item: any) => void;
  closeChoiceModal: () => void;

  // --- [新增 v1.6] 认证模态框状态管理 ---
  isAuthModalOpen: boolean;
  openAuthModal: (callback?: () => void) => void;
  closeAuthModal: () => void;
  authSuccessCallback: (() => void) | null;
  setAuthSuccessCallback: (callback: (() => void) | null) => void;
}

export const useAppStore = create<AppState>((set) => ({
  isImmersive: false,
  selectedMedia: null,
  isChoiceModalOpen: false, // [新增 v1.4] 默认关闭
  itemToPurchase: null,   // [新增 v1.4] 默认没有商品
  isAuthModalOpen: false, // [新增 v1.6] 默认关闭

  enterImmersiveMode: (mediaItem, startPosition) => set({
    isImmersive: true,
    selectedMedia: { mediaItem, startPosition },
  }),
  exitImmersiveMode: () => set({
    isImmersive: false,
    selectedMedia: null 
  }),

  // --- [新增 v1.4] 支付模态框 Actions ---
  openChoiceModal: (item) => set({
    isChoiceModalOpen: true,
    itemToPurchase: item,
  }),
  closeChoiceModal: () => set({
    isChoiceModalOpen: false,
    itemToPurchase: null,
  }),

  // --- [新增 v1.6] 认证模态框 Actions ---
  authSuccessCallback: null,
  openAuthModal: (callback) => set({
    isAuthModalOpen: true,
    authSuccessCallback: callback || null,
  }),
  closeAuthModal: () => set({
    isAuthModalOpen: false,
    authSuccessCallback: null,
  }),
  setAuthSuccessCallback: (callback) => set({ authSuccessCallback: callback }),
}));