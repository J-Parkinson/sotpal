/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  images: {
    domains: ['images.ctfassets.net'],
  },
  compiler: {
    removeConsole: process.env.NODE_ENV === 'production', // Strip console.logs in production
  },
};

module.exports = nextConfig;
