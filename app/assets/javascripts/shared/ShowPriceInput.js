import React, { Component } from 'react'
import PropTypes from 'prop-types'

class ShowPriceInput extends Component {
  render () {
    const {
      entityName,
      nestedAttrsName,
      index,
      value,
      onChange
    } = this.props
    const showPriceInputId = `menu_${nestedAttrsName}_${index}_show_price_on_menu`
    const showPrice = {
      type: 'checkbox',
      name: `${entityName}[${nestedAttrsName}][${index}][show_price_on_menu]`,
      id: showPriceInputId,
      'data-test': 'show-price',
      value: '1',
      onChange
    }
    // New records always show price
    if (value === undefined || value) {
      showPrice.defaultChecked = 'checked'
    }

    return (
      <span className='chosen-list-toggle-detail'>
        <input
          type='hidden'
          name={`${entityName}[${nestedAttrsName}][${index}][show_price_on_menu]`}
          value='0'
        />
        <label
          htmlFor={showPriceInputId}
          className='menu-list-show-price'
          data-test='show-price-label'>
          <span className='fa fa-usd' title='show price' aria-hidden='true' />
          <input {...showPrice} />
        </label>
      </span>
    )
  }
}

ShowPriceInput.defaultProps = {
  value: true
}

ShowPriceInput.propTypes = {
  entityName: PropTypes.string.isRequired,
  nestedAttrsName: PropTypes.string.isRequired,
  index: PropTypes.number.isRequired,
  onChange: PropTypes.func.isRequired,
  value: PropTypes.bool
}

export default ShowPriceInput
