import React from 'react'
import { render } from 'react-dom'
import DigitalDisplayApp from './digital-display/DigitalDisplayApp';

(function bootstrap () {
  const digitalDisplayRoot = document.getElementById('digital-display-app-root')

  render(<DigitalDisplayApp {...window._EVERGREEN} />, digitalDisplayRoot)
})()
