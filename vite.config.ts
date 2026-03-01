import path from "path";
import react from "@vitejs/plugin-react";
import tailwindcss from "@tailwindcss/vite";
import { defineConfig } from "vite";

export default defineConfig({
  plugins: [
    react(), 
    tailwindcss() // THIS WAS MISSING! This brings back your UI layout.
  ],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
  build: {
    commonjsOptions: {
      transformMixedEsModules: true,
      exclude: ['react-map-gl', 'mapbox-gl'],
    },
  },
  optimizeDeps: {
    include: ["react-map-gl", "mapbox-gl"],
  },
});
