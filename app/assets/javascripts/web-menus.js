import React from 'react'
import { render } from 'react-dom'
import WebMenuApp from './web-menu/WebMenuApp';

(function bootstrap () {
  const webMenuRoot = document.getElementById('web-menu-app-root')

  render(<WebMenuApp {...window._EVERGREEN} />, webMenuRoot)
})()
