import React, { Component, Fragment } from 'react';
import PropTypes from 'prop-types';
import TimePicker from 'rc-time-picker';
import moment from 'moment';

const DISPLAY_TIME_FORMAT = 'hh:mm A';
const SYSTEM_TIME_FORMAT = 'THH:mm';

class AvailabilityInputs extends Component {
  constructor (props) {
    super(props);

    this.handleStartTimeChange = this.handleStartTimeChange.bind(this);
    this.handleEndTimeChange = this.handleEndTimeChange.bind(this);

    this.state = {
      startTime: this.props.startTime,
      endTime: this.props.endTime
    };
  }

  handleStartTimeChange (newValue) {
    this.setState(prevState => {
      const startTime = newValue && newValue.format(SYSTEM_TIME_FORMAT);
      return { startTime };
    });
  }

  handleEndTimeChange(newValue) {
    this.setState(prevState => {
      const endTime = newValue && newValue.format(SYSTEM_TIME_FORMAT);
      return { endTime };
    });
  }

  render () {
    const { startTime, endTime } = this.state;
    const timePickerCommonProps = {
      format: DISPLAY_TIME_FORMAT,
      className: 'menu-availability-picker',
      showSecond: false,
      minuteStep: 15,
      use12Hours: true
    };
    return (
      <Fragment>
        <div className="col-sm-4">
          <label htmlFor="menu_availability_start_time">Availability Start</label>
          <TimePicker
            {...timePickerCommonProps}
            name="menu[availability_start_time]"
            value={startTime && moment(startTime, SYSTEM_TIME_FORMAT)}
            onChange={this.handleStartTimeChange}
          />
        </div>

        <div className="col-sm-4">
          <label htmlFor="menu_availability_end_time">Availability End</label>
          <TimePicker
            {...timePickerCommonProps}
            name="menu[availability_end_time]"
            value={endTime && moment(endTime, SYSTEM_TIME_FORMAT)}
            onChange={this.handleEndTimeChange}
          />
        </div>
      </Fragment>
    );
  }
}

AvailabilityInputs.propTypes = {
  startTime: PropTypes.string,
  endTime: PropTypes.string
}

export default AvailabilityInputs;
