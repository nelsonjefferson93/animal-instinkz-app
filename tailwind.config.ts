import type { Config } from 'tailwindcss'

const config: Config = {
  content: [
    './app/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        brand: {
          black: '#0D0D0D',
          green: '#3E7B2F',
          'green-light': '#4E9B3C',
          offwhite: '#F5F5F0',
          gray: '#2A2A2A',
          'gray-light': '#3A3A3A',
          'gray-muted': '#6B6B6B',
        },
      },
      fontFamily: {
        display: ['var(--font-bebas)', 'sans-serif'],
        heading: ['var(--font-oswald)', 'sans-serif'],
        body: ['var(--font-inter)', 'sans-serif'],
      },
      backgroundImage: {
        'gradient-dark': 'linear-gradient(180deg, #1A1A1A 0%, #0D0D0D 100%)',
      },
    },
  },
  plugins: [],
}

export default config
