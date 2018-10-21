import React, { Component } from 'react'
import PropTypes from 'prop-types'

class ListItemPriceInput extends Component {
  constructor (props) {
    super(props)
    this.handlePriceChange = this.handlePriceChange.bind(this)
    this.handleUnitChange = this.handleUnitChange.bind(this)
    this.remove = this.remove.bind(this)
  }

  handlePriceChange (event) {
    const { onChange, id } = this.props
    onChange(id, { price: event.target.value })
  }

  handleUnitChange (event) {
    const { onChange, id } = this.props
    onChange(id, { unit: event.target.value })
  }

  remove (event) {
    event.preventDefault()
    const { onRemove, id } = this.props
    onRemove(id)
  }

  render () {
    const { value, unit } = this.props
    return (
      <div className="form-row menu-item-price-option" data-test="menu-item-price-option">
        <div className="input-group">
          <label className="sr-only">
            Price
          </label>
          <div className="input-group-prepend">
            <span className="beer-input-price-currency input-group-text">$</span>
          </div>
          <input
            type="number"
            step="0.01"
            min="0"
            defaultValue={value}
            className="form-control price-input"
            data-test="price-input-amount"
            onChange={this.handlePriceChange}
            />
          <div className="input-group-prepend">
            <span className="input-group-text">per</span>
          </div>
          <input
            type="text"
            defaultValue={unit}
            className="form-control"
            data-test="price-input-unit"
            onChange={this.handleUnitChange}
          />
          <div className="remove-price-option">
            <a
              href=''
              onClick={this.remove}
              data-test="remove-price-option"
              className="btn btn-outline-secondary">
              <span className="fas fa-times" />
            </a>
          </div>
        </div>
      </div>
    )
  }
}

ListItemPriceInput.defaultProps = {
  value: null,
  unit: 'Serving',
  className: 'col-sm-2 col-xs-4'
}

ListItemPriceInput.propTypes = {
  value: PropTypes.number,
  unit: PropTypes.string,
  className: PropTypes.string,
  id: PropTypes.number.isRequired,
  onChange: PropTypes.func.isRequired,
  onRemove: PropTypes.func.isRequired
}

export default ListItemPriceInput
