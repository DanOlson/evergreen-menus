import React, { Component } from 'react';
import PropTypes from 'prop-types';

class ThemeSelect extends Component {
  constructor(props) {
    super(props);
    this.handleChange = this.handleChange.bind(this);
  }

  handleChange(event) {
    const themeName = event.target.value;
    const theme = this.props.options.find(opt => opt.name === themeName);
    this.props.onChange(theme);
  }

  render() {
    const { value, className } = this.props;
    const themeOptions = this.props.options.map((theme, index) => {
      return <option value={theme.name} key={index}>{theme.name}</option>
    });

    return (
      <div className={className}>
        <label htmlFor="digital_display_menu_theme">
          Theme
        </label>
        <select
          id="digital_display_menu_theme"
          data-test="digital-display-menu-theme"
          name="digital_display_menu[theme]"
          className="form-control"
          value={value}
          onChange={this.handleChange}>
          {themeOptions}
        </select>
      </div>
    );
  }
};

ThemeSelect.propTypes = {
  options: PropTypes.array.isRequired,
  onChange: PropTypes.func.isRequired,
  value: PropTypes.string.isRequired,
  className: PropTypes.string
};

export default ThemeSelect;
