import NextAuth, { NextAuthOptions } from 'next-auth';
import GoogleProvider from 'next-auth/providers/google';
// 最终形态：我们导入 readUsers, createUser, 和 updateUser
import { createDirectus, rest, readUsers, createUser, updateUser, staticToken } from '@directus/sdk';

const directus = createDirectus(process.env.DIRECTUS_URL!)
  .with(staticToken(process.env.DIRECTUS_STATIC_TOKEN!))
  .with(rest());

export const authOptions: NextAuthOptions = {
  providers: [
    GoogleProvider({
      clientId: process.env.GOOGLE_CLIENT_ID!,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET!,
    }),
  ],
  callbacks: {
    async jwt({ token, user, account }) {
      if (account && user) {
        try {
          const existingUsers = await directus.request(readUsers({
            filter: { email: { _eq: user.email! } },
            limit: 1,
          }));

          if (existingUsers.length > 0) {
            const directusUser = existingUsers[0];
            token.sub = directusUser.id; 

            // ✨ 新增的业务逻辑！ ✨
            // 如果这个老用户没有 provider 信息，我们就为他补上
            if (!directusUser.provider) {
              console.log(`User ${user.email} exists, linking Google account...`);
              await directus.request(updateUser(directusUser.id, {
                provider: 'google',
                external_identifier: user.id,
              }));
            }
          } else {
            // 这部分逻辑现在完全正确，无需改动
            const newUser = await directus.request(createUser({
              first_name: user.name?.split(' ')[0] || 'New',
              last_name: user.name?.split(' ')[1] || 'User',
              email: user.email!,
              password: Math.random().toString(36).slice(-8),
              role: process.env.DIRECTUS_AUTHENTICATED_GROUP_UUID!,
              provider: 'google',
              external_identifier: user.id,
              status: 'active',
            }));
            token.sub = newUser.id;
          }
        } catch (error) {
          console.error("Error during Directus user check/creation/update:", error);
          return { ...token, error: "DirectusSyncError" };
        }
      }
      return token;
    },
    async session({ session, token }) {
      if (token.sub) {
        if (!session.user) {
          session.user = {};
        }
        session.user.id = token.sub as string;
      }
      return session;
    },
  },
  session: {
    strategy: 'jwt',
  },
  secret: process.env.NEXTAUTH_SECRET,
  debug: process.env.NODE_ENV === 'development',
};

export default NextAuth(authOptions);