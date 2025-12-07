import { defineConfig, loadEnv } from 'vite'
import react from '@vitejs/plugin-react'
import path from 'path'

// https://vite.dev/config/
export default defineConfig(({ mode }) => {
  // Load env from parent directory (project root)
  const env = loadEnv(mode, path.resolve(__dirname, '..'), 'PHYSIO_')

  const backendPort = env.PHYSIO_BACKEND_PORT || '8080'
  const frontendPort = env.PHYSIO_FRONTEND_PORT || '5173'

  return {
    plugins: [react()],
    resolve: {
      alias: {
        '@': path.resolve(__dirname, './src'),
      },
    },
    server: {
      port: parseInt(frontendPort, 10),
      proxy: {
        '/api': {
          target: `http://localhost:${backendPort}`,
          changeOrigin: true,
          rewrite: (path) => path.replace(/^\/api/, ''),
        },
      },
    },
  }
})
