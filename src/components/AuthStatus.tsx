import { useSession, signIn, signOut } from 'next-auth/react';

export default function AuthStatus() {
  const { data: session, status } = useSession();

  if (status === 'loading') {
    return (
      <div className="px-4 py-2 bg-gray-700 text-white rounded-lg text-sm">
        Loading...
      </div>
    );
  }

  if (session) {
    return (
      <div className="flex items-center gap-2">
        {session.user?.image && (
          <img
            src={session.user.image}
            alt={session.user.name || 'User Avatar'}
            className="w-10 h-10 rounded-full"
          />
        )}
        <button
          onClick={() => signOut()}
          className="px-4 py-2 bg-red-600 text-white font-bold rounded-lg shadow-lg hover:bg-red-500 active:bg-red-700 transition-colors text-sm"
        >
          Sign Out
        </button>
      </div>
    );
  }

  return (
    <button
      onClick={() => signIn('google')}
      className="px-4 py-2 bg-blue-600 text-white font-bold rounded-lg shadow-lg hover:bg-blue-500 active:bg-blue-700 transition-colors text-sm"
    >
      Sign In
    </button>
  );
}