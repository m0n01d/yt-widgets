import { defineConfig } from "vite";
import elmPlugin from "vite-plugin-elm";
import react from "@vitejs/plugin-react";

console.log(elmPlugin);

const defaultConfig = {
  build: {
    inlineDynamicImports: true,
    rollupOptions: {
      input: "src/Content/App.bs.mjs",
      output: {
        assetFileNames: (asset) => {
          switch (asset.name) {
            case "content":
              return "/content/[name].[ext]";
            default:
              return "[name].[ext]";
          }
        },
        entryFileNames: (chunk) => {
          return "content/content.js";
        },
      },
    },
  },
  plugins: [react()],
};

export default defineConfig(defaultConfig);
