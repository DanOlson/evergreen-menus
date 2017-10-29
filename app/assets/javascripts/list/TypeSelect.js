import React, { Component } from 'react';
import PropTypes from 'prop-types';

class TypeSelect extends Component {
  constructor(props) {
    super(props);
    this.handleChange = this.handleChange.bind(this);
  }

  handleChange(event) {
    const choice = event.target.value;
    const newType = this.props.options.find(opt => opt.value === choice);
    this.props.onChange(newType);
  }

  render() {
    const { className, value } = this.props;
    const typeOptions = this.props.options.map((type, index) => {
      return <option value={type.value} key={index}>{type.name}</option>
    });

    return (
      <div className={className}>
        <label htmlFor="list_type">
          List Type
        </label>
        <select
          id="list_type"
          data-test="list-type"
          name="list[type]"
          className="form-control"
          value={value}
          onChange={this.handleChange}>
          {typeOptions}
        </select>
      </div>
    );
  }
}

TypeSelect.defaultProps = {
  className: '',
  onChange: () => {}
};

TypeSelect.propTypes = {
  options: PropTypes.array.isRequired,
  onChange: PropTypes.func,
  value: PropTypes.string.isRequired,
  className: PropTypes.string
};

export default TypeSelect;
