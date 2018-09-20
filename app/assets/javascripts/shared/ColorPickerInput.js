import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { ChromePicker } from 'react-color'

class ColorPickerInput extends Component {
  constructor (props) {
    super(props)

    this.handleFocus = this.handleFocus.bind(this)
    this.handleClose = this.handleClose.bind(this)
    this.handleColorChange = this.handleColorChange.bind(this)

    this.state = {
      showColorPicker: false
    }
  }

  handleFocus () {
    this.setState(prevState => {
      return { showColorPicker: true }
    })
  }

  handleClose () {
    this.setState(prevState => {
      return { showColorPicker: false }
    })
  }

  handleColorChange (event) {
    const color = event.target.value
    this.props.onChangeComplete({ hex: color })
  }

  renderPicker () {
    const { onChangeComplete, color } = this.props
    const popover = {
      position: 'absolute',
      zIndex: '2'
    }
    const cover = {
      position: 'fixed',
      top: '0px',
      right: '0px',
      bottom: '0px',
      left: '0px'
    }

    let picker
    if (this.state.showColorPicker) {
      picker = (
        <div style={popover}>
          <div style={cover} onClick={this.handleClose} />
          <ChromePicker color={color} onChangeComplete={onChangeComplete} disableAlpha />
        </div>
      )
    }

    return picker
  }

  render () {
    const { label, color, id, name, dataTest, className } = this.props
    const picker = this.renderPicker()

    return (
      <div className={className}>
        <label>{label}</label>
        <input
          id={id}
          name={name}
          data-test={dataTest}
          type='text'
          className='form-control'
          value={color}
          readOnly
          onFocus={this.handleFocus}
          onClick={this.handleFocus}
        />
        {picker}
      </div>
    )
  }
}

ColorPickerInput.propTypes = {
  label: PropTypes.string.isRequired,
  color: PropTypes.string.isRequired,
  onChangeComplete: PropTypes.func.isRequired,
  id: PropTypes.string.isRequired,
  name: PropTypes.string.isRequired,
  dataTest: PropTypes.string.isRequired,
  className: PropTypes.string
}

ColorPickerInput.defaultProps = {
  className: 'form-group'
}

export default ColorPickerInput
