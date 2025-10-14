//文件路径:src/components/AuthModal.tsx
import React, { useEffect } from 'react';
import { signIn, useSession } from 'next-auth/react';
import { useAppStore } from '../lib/store';

export const AuthModal = () => {
  const { isAuthModalOpen, closeAuthModal, authSuccessCallback } = useAppStore();
  const { data: session, status } = useSession();

  // 监听 session 变化：如果登录成功，关闭模态并执行回调
  useEffect(() => {
    if (status === 'authenticated' && isAuthModalOpen) {
      closeAuthModal();
      if (authSuccessCallback) {
        authSuccessCallback();
      }
    }
  }, [status, isAuthModalOpen, closeAuthModal, authSuccessCallback]);

  if (!isAuthModalOpen) {
    return null;
  }

  return (
    <div className="fixed inset-0 bg-black bg-opacity-80 z-50 flex justify-center items-center pointer-events-auto p-4">
      <div className="bg-gradient-to-br from-gray-900 via-gray-800 to-gray-900 rounded-2xl shadow-2xl w-full max-w-md text-white border border-gray-700 overflow-hidden">
        {/* Header */}
        <div className="relative bg-gradient-to-r from-blue-900/40 to-purple-900/40 px-6 py-5 border-b border-gray-700">
          <div className="flex justify-between items-center">
            <div>
              <h2 className="text-2xl font-bold bg-gradient-to-r from-blue-400 to-purple-400 bg-clip-text text-transparent">
                Login Required
              </h2>
              <p className="text-gray-400 text-sm mt-1">Sign in to continue</p>
            </div>
            <button 
              onClick={closeAuthModal} 
              className="text-gray-400 hover:text-white transition-colors w-10 h-10 flex items-center justify-center rounded-full hover:bg-gray-700/50"
            >
              <span className="text-3xl leading-none">&times;</span>
            </button>
          </div>
        </div>

        {/* Content */}
        <div className="p-6 space-y-6">
          <button 
            onClick={() => signIn('google')}
            className="w-full bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-500 hover:to-blue-600 rounded-xl py-4 font-semibold transition-all duration-300 hover:scale-105 hover:shadow-lg hover:shadow-blue-500/30 border border-blue-500 flex items-center justify-center gap-2"
          >
            <span>Sign in with Google</span>
            <span className="text-xl">🔑</span>
          </button>
          <p className="text-xs text-gray-400 text-center">
            We use Google OAuth for secure authentication. No registration needed.
          </p>
        </div>
      </div>
    </div>
  );
};