/** @type {import('tailwindcss').Config} */
const colors = require("tailwindcss/colors");
export default {
  content: [
    "./index.html",
    "./app/**/*.elm",
    "./src/**/*.{elm,js,ts,jsx,tsx}",
    "./app/**/*.elm",
    "./node_modules/@material-tailwind/html/**/*.{js,jsx,ts,tsx}",
  ],
  safelist: [
    {
      pattern: /./, // the "." means "everything"
    },
  ],
  theme: {
    extend: {},
  },
  plugins: [],
};
