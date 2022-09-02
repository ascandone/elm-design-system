/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["example/**/*.elm", "example/**/*.html", "src/**/*.elm"],
  theme: {
    extend: {
      fontFamily: {
        sans: "Work sans, sans-serif",
      },
    },
  },
  plugins: [],
}
