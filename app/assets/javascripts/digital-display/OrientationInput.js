import React, { Component } from 'react';
import PropTypes from 'prop-types';

class OrientationInput extends Component {
  constructor(props) {
    super(props);
    this.handleChange = this.handleChange.bind(this);
  }

  handleChange(event) {
    const val = event.target.value === 'true' ? 'horizontal' : 'vertical';
    this.props.onChange(val);
  }

  render() {
    const { isHorizontal, className } = this.props;
    return (
      <div className={className}>
        <label>Orientation</label>
        <div className="radio">
          <label>
            <input
              type="radio"
              name="digital_display_menu[horizontal_orientation]"
              value="true"
              defaultChecked={isHorizontal}
              onClick={this.handleChange}
              data-test="digital-display-menu-horizontal-orientation-true"
            />
            Horizontal
          </label>
        </div>
        <div className="radio">
          <label>
            <input
              type="radio"
              name="digital_display_menu[horizontal_orientation]"
              value="false"
              defaultChecked={!isHorizontal}
              onClick={this.handleChange}
              data-test="digital-display-menu-horizontal-orientation-false"
            />
            Vertical
          </label>
        </div>
      </div>
    );
  }
}

OrientationInput.propTypes = {
  className: PropTypes.string,
  onChange: PropTypes.func.isRequired,
  isHorizontal: PropTypes.bool.isRequired
};

OrientationInput.defaultProps = {
  className: 'form-group'
};

export default OrientationInput;
