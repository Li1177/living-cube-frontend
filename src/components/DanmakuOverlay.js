// 文件路径: src/components/DanmakuOverlay.js
import React, { useState } from 'react';
import { useAppStore } from '../lib/store';
import { ChoiceModal } from './ChoiceModal';

const danmakuAnimation = `
  @keyframes danmaku-scroll {
    from {
      transform: translateX(100%);
    }
    to {
      transform: translateX(-100%);
    }
  }
`;

const pulseGlowAnimation = `
  @keyframes pulse-glow {
    0% {
      box-shadow: 0 0 20px rgba(59, 130, 246, 0.4), 0 0 40px rgba(59, 130, 246, 0.2);
      transform: scale(1);
    }
    50% {
      box-shadow: 0 0 30px rgba(59, 130, 246, 0.6), 0 0 60px rgba(59, 130, 246, 0.3);
      transform: scale(1.02);
    }
    100% {
      box-shadow: 0 0 20px rgba(59, 130, 246, 0.4), 0 0 40px rgba(59, 130, 246, 0.2);
      transform: scale(1);
    }
  }
`;

const shimmerAnimation = `
  @keyframes shimmer {
    0% {
      background-position: -1000px 0;
    }
    100% {
      background-position: 1000px 0;
    }
  }
`;

const DanmakuTrackItem = ({ content }) => {
  const duration = Math.random() * 5 + 8;
  const topPosition = Math.random() * 70 + 5;
  
  return (
    <div
      className="absolute whitespace-nowrap text-white text-xl sm:text-2xl font-bold"
      style={{
        top: `${topPosition}%`,
        right: 0,
        animation: `danmaku-scroll ${duration}s linear`,
        textShadow: '2px 2px 4px rgba(0,0,0,0.9), -1px -1px 3px rgba(0,0,0,0.7), 0 0 10px rgba(0,0,0,0.5)',
        filter: 'drop-shadow(0 0 2px rgba(255,255,255,0.3))',
      }}
    >
      {content}
    </div>
  );
};

export const DanmakuOverlay = ({ mediaItem, danmakuList, onDanmakuSubmit }) => {
  const [danmakuInput, setDanmakuInput] = useState('');
  const openChoiceModal = useAppStore((state) => state.openChoiceModal);

  const handleClaimClick = () => {
    if (openChoiceModal) {
      openChoiceModal(mediaItem);
    } else {
      console.error("Zustand store has not hydrated the 'openChoiceModal' action yet.");
    }
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    // 占位，无操作
  };

  return (
    <>
      <ChoiceModal />
      <div className="absolute top-0 left-0 w-full h-full pointer-events-none">
        <style>{danmakuAnimation}{pulseGlowAnimation}{shimmerAnimation}</style>
        
        {/* Danmaku Container */}
        <div className="relative w-full h-full overflow-hidden">
          {danmakuList.map((danmaku, index) => (
            <DanmakuTrackItem key={danmaku.id || index} content={danmaku.content} />
          ))}
        </div>

        {/* Bottom Control Panel */}
        <div className="absolute bottom-0 left-0 right-0 pointer-events-auto">
          {/* Gradient Backdrop */}
          <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-black/50 to-transparent backdrop-blur-sm" />
          
          <div className="relative z-40 p-4 sm:p-6">
            <div className="max-w-2xl mx-auto space-y-4">
              {/* Claim Button with Enhanced Effects */}
              <div className="relative">
                <button
                  onClick={handleClaimClick}
                  disabled={!openChoiceModal}
                  className="relative w-full px-6 py-4 bg-gradient-to-r from-blue-600 via-blue-500 to-purple-600 text-white font-bold rounded-2xl shadow-2xl hover:from-blue-500 hover:via-blue-400 hover:to-purple-500 active:scale-95 transition-all duration-300 disabled:opacity-50 disabled:cursor-wait overflow-hidden group"
                  style={{
                    animation: 'pulse-glow 2s infinite',
                  }}
                >
                  {/* Shimmer Effect */}
                  <div 
                    className="absolute inset-0 opacity-30"
                    style={{
                      background: 'linear-gradient(90deg, transparent, rgba(255,255,255,0.8), transparent)',
                      backgroundSize: '1000px 100%',
                      animation: 'shimmer 3s infinite',
                    }}
                  />
                  
                  {/* Button Content */}
                  <div className="relative flex items-center justify-center gap-3">
                    <span className="text-2xl">🎁</span>
                    <span className="text-lg sm:text-xl">Claim Your Artwork</span>
                    <span className="text-2xl">✨</span>
                  </div>
                  
                  {/* Glow Border */}
                  <div className="absolute inset-0 rounded-2xl border-2 border-white/20 group-hover:border-white/40 transition-colors" />
                </button>

                {/* Decorative Elements */}
                <div className="absolute -top-1 -right-1 w-8 h-8 bg-gradient-to-br from-yellow-400 to-orange-500 rounded-full animate-pulse blur-sm opacity-70" />
                <div className="absolute -bottom-1 -left-1 w-6 h-6 bg-gradient-to-br from-pink-400 to-purple-500 rounded-full animate-pulse blur-sm opacity-70" style={{ animationDelay: '0.5s' }} />
              </div>

              {/* Comment Form */}
              <form onSubmit={handleSubmit} className="flex flex-col sm:flex-row gap-3">
                <div className="relative flex-1">
                  <input
                    type="text"
                    value={danmakuInput}
                    onChange={(e) => setDanmakuInput(e.target.value)}
                    placeholder="💬 Send a comment..."
                    maxLength={50}
                    className="w-full px-4 py-3 bg-gray-900/90 backdrop-blur-md text-white rounded-xl border-2 border-gray-700 focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-500/50 transition-all text-sm sm:text-base placeholder-gray-500"
                  />
                  
                  {/* Character Counter */}
                  {danmakuInput.length > 0 && (
                    <div className="absolute right-3 top-1/2 -translate-y-1/2 text-xs text-gray-400">
                      {danmakuInput.length}/50
                    </div>
                  )}
                </div>

                <button 
                  type="submit" 
                  className="px-6 py-3 bg-gradient-to-r from-green-600 to-emerald-600 text-white font-bold rounded-xl hover:from-green-500 hover:to-emerald-500 active:scale-95 transition-all duration-200 shadow-lg hover:shadow-green-500/50 text-sm sm:text-base whitespace-nowrap flex items-center justify-center gap-2 min-w-[100px] sm:min-w-0"
                >
                  <span>Send</span>
                  <span className="text-lg">🚀</span>
                </button>
              </form>

              {/* Hint Text */}
              <p className="text-xs text-gray-400 text-center">
                💡 Click the button above to claim your reward
              </p>
            </div>
          </div>
        </div>
      </div>
    </>
  );
};