import React, { Component } from 'react';
import PropTypes from 'prop-types';

class ColumnsInput extends Component {
  constructor(props) {
    super(props);

    this.onChange = this.onChange.bind(this);
  }

  onChange(event) {
    this.props.onChange(event);
  }

  render() {
    const { disabled, columns, className } = this.props;
    return (
      <div className={className}>
        <label htmlFor="menu_number_of_columns">Columns</label>

        <div>
          <label className="radio-inline">
            <input
              type="radio"
              name="menu[number_of_columns]"
              data-test="menu-columns-1"
              value="1"
              defaultChecked={columns === 1}
              onClick={this.onChange}
              disabled={disabled}/>
            1
          </label>
          <label className="radio-inline">
            <input
              type="radio"
              name="menu[number_of_columns]"
              data-test="menu-columns-2"
              value="2"
              defaultChecked={columns === 2}
              onClick={this.onChange}
              disabled={disabled}/>
            2
          </label>
          <label className="radio-inline">
            <input
              type="radio"
              name="menu[number_of_columns]"
              data-test="menu-columns-3"
              value="3"
              defaultChecked={columns === 3}
              onClick={this.onChange}
              disabled={disabled}/>
            3
          </label>
        </div>
      </div>
    );
  }
}

ColumnsInput.propTypes = {
  disabled: PropTypes.bool.isRequired,
  onChange: PropTypes.func.isRequired,
  columns: PropTypes.number.isRequired,
  className: PropTypes.string.isRequired
};

export default ColumnsInput;
