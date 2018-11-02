import React from 'react'
import { render } from 'react-dom'
import MenuApp from './menu/MenuApp';

(function bootstrap () {
  const menuRoot = document.getElementById('menu-app-root')

  render(<MenuApp {...window._EVERGREEN} />, menuRoot)
})()
