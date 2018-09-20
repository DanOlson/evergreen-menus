import React, { Component } from 'react'
import PropTypes from 'prop-types'

class RotationIntervalSelect extends Component {
  constructor (props) {
    super(props)
    this.handleChange = this.handleChange.bind(this)
  }

  handleChange (event) {
    const chosenInterval = event.target.value
    const rotationInterval = this.props.options.find(opt => {
      return opt.value === Number(chosenInterval)
    })
    this.props.onChange(rotationInterval)
  }

  render () {
    const { value, className } = this.props
    const intervalOptions = this.props.options.map((option, index) => {
      return <option value={option.value} key={index}>{option.name}</option>
    })

    return (
      <div className={className}>
        <label htmlFor='digital_display_menu_rotation_interval'>
          Rotation Interval
        </label>
        <select
          id='digital_display_menu_rotation_interval'
          data-test='digital-display-menu-rotation-interval'
          name='digital_display_menu[rotation_interval]'
          className='form-control'
          value={value}
          onChange={this.handleChange}>
          {intervalOptions}
        </select>
      </div>
    )
  }
};

RotationIntervalSelect.propTypes = {
  options: PropTypes.array.isRequired,
  onChange: PropTypes.func.isRequired,
  value: PropTypes.number.isRequired,
  className: PropTypes.string
}

export default RotationIntervalSelect
