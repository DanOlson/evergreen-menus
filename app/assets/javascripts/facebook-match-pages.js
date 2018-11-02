import React from 'react'
import { render } from 'react-dom'
import App from './facebook-match-pages/App';

(function bootstrap () {
  const root = document.getElementById('facebook-match-pages-app-root')

  render(<App {...window._EVERGREEN} />, root)
})()
