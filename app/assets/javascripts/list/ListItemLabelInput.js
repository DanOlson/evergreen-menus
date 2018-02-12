import React, { Component } from 'react';
import PropTypes from 'prop-types';

class ListItemLabelInput extends Component {
  render() {
    const { appId, label, checked } = this.props
    const inputId = `${label}-${appId}`

    return (
      <div className="form-check">
        <input
          data-test="menu-item-label-input"
          className=""
          type="checkbox"
          defaultChecked={checked}
          id={inputId}
          name={`list[beers_attributes][${appId}][labels][]`}
          value={label}
        />
        <label className="form-check-label" htmlFor={inputId}>
          {label}
        </label>
      </div>
    )
  }
}
ListItemLabelInput.defaultProps = {
  checked: false
}

ListItemLabelInput.propTypes = {
  appId: PropTypes.number.isRequired,
  label: PropTypes.string.isRequired,
  checked: PropTypes.bool
}

export default ListItemLabelInput;
