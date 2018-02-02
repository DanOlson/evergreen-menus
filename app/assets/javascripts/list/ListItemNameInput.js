import React, { Component } from 'react';
import PropTypes from 'prop-types';

class ListItemNameInput extends Component {
  render () {
    const { appId, value, className } = this.props;
    return (
      <div className="col-sm-3 col-xs-8">
        <label htmlFor={`list_beers_attributes_${appId}_name`} className="sr-only">
          Name
        </label>
        <input
          type="text"
          placeholder="Name"
          data-test={`beer-name-input-${appId}`}
          defaultValue={value}
          name={`list[beers_attributes][${appId}][name]`}
          id={`list_beers_attributes_${appId}_name`}
          className={`form-control ${className}`}
        />
      </div>
    );
  }
}

ListItemNameInput.defaultProps = {
  name: '',
  className: ''
};

ListItemNameInput.propTypes = {
  appId: PropTypes.number.isRequired,
  value: PropTypes.string,
  className: PropTypes.string
}
export default ListItemNameInput;
