// 文件路径: src/components/ChoiceModal.tsx
import React from 'react';
import { useAppStore } from '../lib/store';

export const ChoiceModal = () => {
  const { isChoiceModalOpen, closeChoiceModal } = useAppStore();

  if (!isChoiceModalOpen) {
    return null;
  }

  // 对于 v1.5，所有按钮暂无任何反应（占位）
  const handleSingleClick = () => {
    // 占位，无操作
  };

  const handleFivePackClick = () => {
    // 占位，无操作
  };

  const handleTenPackClick = () => {
    // 占位，无操作
  };

  const handleWatchAdClick = () => {
    // 占位，无操作
  };

  return (
    <div className="fixed inset-0 bg-black bg-opacity-80 z-50 flex justify-center items-center pointer-events-auto p-4">
      <div className="bg-gradient-to-br from-gray-900 via-gray-800 to-gray-900 rounded-2xl shadow-2xl w-full max-w-2xl text-white border border-gray-700 overflow-hidden">
        {/* Header */}
        <div className="relative bg-gradient-to-r from-purple-900/40 to-blue-900/40 px-6 py-5 border-b border-gray-700">
          <div className="flex justify-between items-center">
            <div>
              <h2 className="text-2xl font-bold bg-gradient-to-r from-purple-400 to-blue-400 bg-clip-text text-transparent">
                Choose Your Path
              </h2>
              <p className="text-gray-400 text-sm mt-1">Select an option to continue</p>
            </div>
            <button 
              onClick={closeChoiceModal} 
              className="text-gray-400 hover:text-white transition-colors w-10 h-10 flex items-center justify-center rounded-full hover:bg-gray-700/50"
            >
              <span className="text-3xl leading-none">&times;</span>
            </button>
          </div>
        </div>

        {/* Content */}
        <div className="p-6">
          <div className="grid md:grid-cols-2 gap-6">
            {/* Purchase Options */}
            <div className="space-y-3">
              <div className="flex items-center gap-2 mb-4">
                <div className="w-8 h-8 rounded-full bg-gradient-to-br from-blue-500 to-purple-600 flex items-center justify-center text-lg">
                  💳
                </div>
                <h3 className="text-lg font-semibold">Purchase Options</h3>
              </div>

              {/* Single */}
              <button 
                onClick={handleSingleClick}
                className="w-full group relative bg-gradient-to-br from-gray-700 to-gray-800 hover:from-blue-600 hover:to-blue-700 rounded-xl p-4 transition-all duration-300 hover:scale-105 hover:shadow-lg hover:shadow-blue-500/20 border border-gray-600 hover:border-blue-500"
              >
                <div className="flex justify-between items-center">
                  <div className="text-left">
                    <div className="font-semibold">Single Draw</div>
                    <div className="text-sm text-gray-400 group-hover:text-blue-200">Try your luck once</div>
                  </div>
                  <div className="text-2xl">🎯</div>
                </div>
              </button>

              {/* 5-Pack with Badge */}
              <button 
                onClick={handleFivePackClick}
                className="w-full group relative bg-gradient-to-br from-gray-700 to-gray-800 hover:from-purple-600 hover:to-purple-700 rounded-xl p-4 transition-all duration-300 hover:scale-105 hover:shadow-lg hover:shadow-purple-500/20 border border-gray-600 hover:border-purple-500"
              >
                <div className="absolute -top-2 -right-2 bg-gradient-to-r from-yellow-500 to-orange-500 text-xs font-bold px-2 py-1 rounded-full shadow-lg">
                  POPULAR
                </div>
                <div className="flex justify-between items-center">
                  <div className="text-left">
                    <div className="font-semibold">5-Pack Bundle</div>
                    <div className="text-sm text-gray-400 group-hover:text-purple-200">Better value!</div>
                  </div>
                  <div className="text-2xl">🎁</div>
                </div>
              </button>

              {/* 10-Pack */}
              <button 
                onClick={handleTenPackClick}
                className="w-full group relative bg-gradient-to-br from-gray-700 to-gray-800 hover:from-pink-600 hover:to-rose-700 rounded-xl p-4 transition-all duration-300 hover:scale-105 hover:shadow-lg hover:shadow-pink-500/20 border border-gray-600 hover:border-pink-500"
              >
                <div className="absolute -top-2 -right-2 bg-gradient-to-r from-pink-500 to-rose-500 text-xs font-bold px-2 py-1 rounded-full shadow-lg">
                  BEST DEAL
                </div>
                <div className="flex justify-between items-center">
                  <div className="text-left">
                    <div className="font-semibold">10-Pack Bundle</div>
                    <div className="text-sm text-gray-400 group-hover:text-pink-200">Maximum savings!</div>
                  </div>
                  <div className="text-2xl">🎉</div>
                </div>
              </button>
            </div>

            {/* Watch Ad Option */}
            <div className="space-y-3">
              <div className="flex items-center gap-2 mb-4">
                <div className="w-8 h-8 rounded-full bg-gradient-to-br from-green-500 to-emerald-600 flex items-center justify-center text-lg">
                  📺
                </div>
                <h3 className="text-lg font-semibold">Free Option</h3>
              </div>

              <div className="bg-gradient-to-br from-green-900/30 to-emerald-900/30 rounded-xl p-6 border border-green-700/50 h-full flex flex-col justify-center">
                <div className="text-center mb-4">
                  <div className="text-5xl mb-3">🎬</div>
                  <h4 className="text-xl font-bold mb-2">Watch & Earn</h4>
                  <p className="text-sm text-gray-300 mb-4">
                    Watch a short ad to unlock your reward for free!
                  </p>
                </div>
                
                <button 
                  onClick={handleWatchAdClick}
                  className="w-full bg-gradient-to-r from-green-600 to-emerald-600 hover:from-green-500 hover:to-emerald-500 rounded-xl py-4 font-semibold transition-all duration-300 hover:scale-105 hover:shadow-lg hover:shadow-green-500/30 border border-green-500"
                >
                  <div className="flex items-center justify-center gap-2">
                    <span>Watch Ad</span>
                    <span className="text-xl">▶️</span>
                  </div>
                </button>
                
                <p className="text-xs text-gray-400 text-center mt-3">
                  ~30 seconds • No payment required
                </p>
              </div>
            </div>
          </div>
        </div>

        {/* Footer Info */}
        <div className="px-6 py-4 bg-gray-900/50 border-t border-gray-700">
          <p className="text-xs text-gray-400 text-center">
            💡 All purchases are processed securely • Choose the option that works best for you
          </p>
        </div>
      </div>
    </div>
  );
};