import React, { Component } from 'react';
import PropTypes from 'prop-types';

class ThemeOptions extends Component {
  constructor(props) {
    super(props);
    this.handleChange = this.handleChange.bind(this);
  }

  handleChange(event) {
    const themeName = event.target.value;
    const theme = this.props.options.find(opt => {
      return opt.name === themeName;
    });
    this.props.onChange(theme);
  }

  render() {
    const { value } = this.props;
    const themeOptions = this.props.options.map((theme, index) => {
      return <option value={theme.name} key={index}>{theme.name}</option>
    });

    return (
      <div className="form-group col-sm-4">
        <label htmlFor="digital_display_menu_theme">
          Theme
        </label>
        <select
          id="digital_display_menu_theme"
          data-test="digital-display-menu-theme"
          name="digital_display_menu[theme]"
          className="form-control"
          defaultValue={value}
          onChange={this.handleChange}>
          {themeOptions}
        </select>
      </div>
    );
  }
};

ThemeOptions.propTypes = {
  options: PropTypes.array.isRequired,
  onChange: PropTypes.func.isRequired,
  value: PropTypes.string.isRequired
};

export default ThemeOptions;
