import React, { Component } from 'react'
import PropTypes from 'prop-types'
import TimePicker from 'rc-time-picker'
import moment from 'moment'

const DISPLAY_TIME_FORMAT = 'hh:mm A'

function noop () { }

class AvailabilityInput extends Component {
  constructor (props) {
    super(props)

    this.handleChange = this.handleChange.bind(this)

    this.state = {
      time: this.props.time
    }
  }

  handleChange (newValue) {
    const time = newValue && newValue.format(DISPLAY_TIME_FORMAT)
    this.setState(prevState => {
      return { time }
    })
    this.props.onChange(time)
  }

  render () {
    const { time } = this.state
    const { labelText, name } = this.props
    if (!this.props.show) return null

    return (
      <div className={this.props.className}>
        <label data-test='time-picker-label'>{labelText}</label>
        <TimePicker
          format={DISPLAY_TIME_FORMAT}
          className='menu-availability-picker'
          showSecond={false}
          minuteStep={15}
          use12Hours
          name={name}
          value={time && moment(time, DISPLAY_TIME_FORMAT)}
          onChange={this.handleChange}
        />
      </div>
    )
  }
}

AvailabilityInput.propTypes = {
  show: PropTypes.bool,
  time: PropTypes.string,
  onChange: PropTypes.func,
  className: PropTypes.string,
  labelText: PropTypes.string.isRequired,
  name: PropTypes.string
}

AvailabilityInput.defaultProps = {
  show: true,
  onChange: noop
}

export default AvailabilityInput
