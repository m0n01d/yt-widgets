/** @type {import('tailwindcss').Config} */
const colors = require("tailwindcss/colors");
export default {
  /** @type {import('tailwindcss').Config} */

  content: [
    "./index.html",
    "./app/**/*.elm",
    "./src/**/*.{elm,js,ts,jsx,tsx}",
    "./app/**/*.elm",
  ],
  theme: {
    extend: {
      // Material Design Color Palette (using Tailwind's extended colors where applicable)
      colors: {
        primary: colors.blue, // You might want to choose a specific shade like blue-500
        secondary: colors.pink, // Or perhaps a teal or purple
        accent: colors.amber,
        background: colors.gray[100], // Light background
        surface: colors.white, // Card surfaces, dialogs
        error: colors.red,
        onPrimary: colors.white, // Text color on primary backgrounds
        onSecondary: colors.white,
        onAccent: colors.black,
        onBackground: colors.gray[900], // Dark text on light backgrounds
        onSurface: colors.gray[900],
        onError: colors.white,
        // Add more specific shades if needed, e.g., primary-light, primary-dark
      },

      // Material Design Typography (using a system font stack for better cross-platform consistency)
      fontFamily: {
        sans: [
          "Roboto",
          "ui-sans-serif",
          "system-ui",
          "-apple-system",
          "BlinkMacSystemFont",
          "Segoe UI",
          "Helvetica Neue",
          "Arial",
          "Noto Sans",
          "sans-serif",
          "Apple Color Emoji",
          "Segoe UI Emoji",
          "Segoe UI Symbol",
          "Noto Color Emoji",
        ],
        serif: [
          '"Roboto Slab"',
          "ui-serif",
          "Georgia",
          "Cambria",
          '"Times New Roman"',
          "Times",
          "serif",
        ],
        mono: [
          '"Roboto Mono"',
          "ui-monospace",
          "SFMono-Regular",
          "Menlo",
          "Monaco",
          "Consolas",
          '"Liberation Mono"',
          '"Courier New"',
          "monospace",
        ],
      },

      // Material Design Shadows (subtle and layered)
      boxShadow: {
        md: "0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06)", // Tailwind's default md
        "material-1":
          "0 1px 3px rgba(0, 0, 0, 0.12), 0 1px 2px rgba(0, 0, 0, 0.24)",
        "material-2":
          "0 3px 6px rgba(0, 0, 0, 0.16), 0 3px 6px rgba(0, 0, 0, 0.23)",
        "material-3":
          "0 10px 20px rgba(0, 0, 0, 0.19), 0 6px 6px rgba(0, 0, 0, 0.23)",
        "material-4":
          "0 14px 28px rgba(0, 0, 0, 0.25), 0 10px 10px rgba(0, 0, 0, 0.22)",
        "material-5":
          "0 19px 38px rgba(0, 0, 0, 0.30), 0 15px 12px rgba(0, 0, 0, 0.22)",
      },

      // Material Design Border Radii (slightly rounded)
      borderRadius: {
        none: "0px",
        sm: "0.125rem",
        DEFAULT: "0.25rem", // Tailwind's default
        md: "0.375rem",
        lg: "0.5rem",
        xl: "0.75rem",
        "2xl": "1rem",
        "3xl": "1.5rem",
        full: "9999px",
        material: "4px", // Common Material Design rounded corners
      },

      // Material Design Spacing (using Tailwind's defaults as a good starting point)
      spacing: {
        px: "1px",
        0: "0px",
        0.5: "0.125rem",
        1: "0.25rem",
        1.5: "0.375rem",
        2: "0.5rem",
        2.5: "0.625rem",
        3: "0.75rem",
        3.5: "0.875rem",
        4: "1rem",
        5: "1.25rem",
        6: "1.5rem",
        7: "1.75rem",
        8: "2rem",
        9: "2.25rem",
        10: "2.5rem",
        11: "2.75rem",
        12: "3rem",
        14: "3.5rem",
        16: "4rem",
        20: "5rem",
        24: "6rem",
        28: "7rem",
        32: "8rem",
        36: "9rem",
        40: "10rem",
        44: "11rem",
        48: "12rem",
        52: "13rem",
        56: "14rem",
        60: "15rem",
        64: "16rem",
        72: "18rem",
        80: "20rem",
        96: "24rem",
      },
    },
  },
  plugins: [],
};
