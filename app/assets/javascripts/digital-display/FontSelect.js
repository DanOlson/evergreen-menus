import React, { Component } from 'react';
import PropTypes from 'prop-types';

class FontSelect extends Component {
  constructor(props) {
    super(props);
    this.handleChange = this.handleChange.bind(this);
  }

  handleChange(event) {
    const fontName = event.target.value;
    const font = this.props.options.find(opt => opt.value === fontName);
    this.props.onChange(font);
  }

  render() {
    const { value, className } = this.props;
    const fontOptions = this.props.options.map((option, index) => {
      return <option value={option.value} key={index}>{option.name}</option>
    });

    return (
      <div className={className}>
        <label htmlFor="digital_display_menu_font">
          Font
        </label>
        <select
          id="digital_display_menu_font"
          data-test="digital-display-menu-font"
          name="digital_display_menu[font]"
          className="form-control"
          value={value}
          onChange={this.handleChange}>
          {fontOptions}
        </select>
      </div>
    );
  }
};

FontSelect.propTypes = {
  options: PropTypes.array.isRequired,
  onChange: PropTypes.func.isRequired,
  value: PropTypes.string.isRequired,
  className: PropTypes.string
};

export default FontSelect;
