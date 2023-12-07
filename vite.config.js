import { defineConfig } from "vite";
import elmPlugin from "vite-plugin-elm";
import react from "@vitejs/plugin-react";

console.log(elmPlugin);

const defaultConfig = {
  build: {
    emptyOutDir: false,
    rollupOptions: {
      input: {
        bg: "src/Background/background.js",
        popup: "src/Popup/popup.jsx",
      },
      output: {
        assetFileNames: (asset) => {
          switch (asset.name) {
            case "popup":
              return "/popup/[name].[ext]";
            default:
              return "[name].[ext]";
          }
        },
        entryFileNames: (chunk) => {
          switch (chunk.name) {
            case "bg":
              return "bg/[name].js";
            case "popup":
              return "popup/[name].js";
            default:
              return "[name].js";
          }
        },
      },
    },
  },
  plugins: [react(), elmPlugin.default()],
};

export default defineConfig(() => defaultConfig);
