import React, { Component } from 'react';
import PropTypes from 'prop-types';

class ListItemDescriptionInput extends Component {
  render () {
    const { appId, value } = this.props;
    return (
      <div className="col-sm-6 col-xs-8">
        <label htmlFor={`list_beers_attributes_${appId}_description`} className="sr-only">
          Description
        </label>
        <input
          data-test={`beer-description-input-${appId}`}
          placeholder="Description"
          defaultValue={value}
          name={`list[beers_attributes][${appId}][description]`}
          id={`list_beers_attributes_${appId}_description`}
          className="form-control"
        />
      </div>
    );
  }
}

ListItemDescriptionInput.defaultProps = {
  value: ''
};

ListItemDescriptionInput.propTypes = {
  appId: PropTypes.number.isRequired,
  value: PropTypes.string
};

export default ListItemDescriptionInput;
