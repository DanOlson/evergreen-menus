import React, { Component } from 'react';
import PropTypes from 'prop-types';

class ListItemPriceInput extends Component {
  render () {
    const { appId, value } = this.props;
    return (
      <div className="col-sm-2 col-xs-4">
        <div className="input-group">
          <label htmlFor={`list_beers_attributes_${appId}_price`} className="sr-only">
            Price
          </label>
          <div className="input-group-prepend">
            <span className="beer-input-price-currency input-group-text">$</span>
          </div>
          <input
            type="number"
            step="0.01"
            min="0"
            data-test={`beer-price-input-${appId}`}
            defaultValue={value}
            name={`list[beers_attributes][${appId}][price]`}
            id={`list_beers_attributes_${appId}_price`}
            className="form-control price-input"
          />
        </div>
      </div>
    );
  }
}

ListItemPriceInput.defaultProps = {
  value: null
}

ListItemPriceInput.propTypes = {
  appId: PropTypes.number.isRequired,
  value: PropTypes.number
};

export default ListItemPriceInput;
