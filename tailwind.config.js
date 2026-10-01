/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        bg: "var(--bg)",
        panel: "var(--panel)",
        panel2: "var(--panel2)",
        border: "var(--border)",
        text: "var(--text)",
        muted: "var(--muted)",
        green: "var(--green)",
        green2: "var(--green2)",
        red: "var(--red)",
        yellow: "var(--yellow)",
      }
    },
  },
  plugins: [],
}
