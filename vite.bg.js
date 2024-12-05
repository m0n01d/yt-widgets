import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

const defaultConfig = {
  build: {
    inlineDynamicImports: true,
    emptyOutDir: false, // runs second
    rollupOptions: {
      input: "src/Background/serviceWorker.bs.mjs",
      output: {
        assetFileNames: (asset) => {
          switch (asset.name) {
            case "background":
              return "/background/[name].[ext]";
            default:
              return "[name].[ext]";
          }
        },
        entryFileNames: (chunk) => {
          return "background/serviceWorker.js";
        },
      },
    },
  },
  plugins: [react()],
};

export default defineConfig(defaultConfig);
