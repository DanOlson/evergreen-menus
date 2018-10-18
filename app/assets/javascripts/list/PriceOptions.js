import React, { Component } from 'react'
import PropTypes from 'prop-types'
import ListItemPriceInput from './ListItemPriceInput'

class PriceOptions extends Component {
  constructor (props) {
    super(props)
    this.state = {
      options: this.options()
    }

    this.addPrice = this.addPrice.bind(this)
    this.handlePriceOptionChange = this.handlePriceOptionChange.bind(this)
  }

  newPriceOption () {
    return { price: null, unit: 'Serving '}
  }

  addPrice (event) {
    event.preventDefault()
    this.setState(prevState => {
      return { options: prevState.options.concat(this.newPriceOption()) }
    })
  }

  handlePriceOptionChange (position, data) {
    this.setState(prevState => {
      const newOptions = [...prevState.options]
      const changedOption = newOptions[position]
      const updated = Object.assign({}, changedOption, data)
      newOptions.splice(position, 1, updated)
      return { options: newOptions }
    })
  }

  options () {
    const { options } = this.props
    if (options.length) {
      return options
    } else {
      return [{
        price: this.props.theLegacyPrice,
        unit: 'Serving'
      }]
    }
  }

  render () {
    const { options } = this.state
    const { appId } = this.props
    const value = JSON.stringify(options)
    const priceInputs = options.map((option, index) => {
      return (
        <ListItemPriceInput
          key={index}
          id={index}
          value={option.price}
          unit={option.unit}
          onChange={this.handlePriceOptionChange}
        />
      )
    })
    return (
      <div className={this.props.className}>
        {priceInputs}
        <div className="add-price">
          <a
            href=''
            onClick={this.addPrice}
            className='btn btn-sm btn-outline-secondary'
          ><span className='fas fa-plus' /></a>
        </div>
        <input type="hidden" value={value} name={`list[beers_attributes][${appId}][price_options]`} />
      </div>
    )
  }
}

PriceOptions.propTypes = {
  options: PropTypes.array,
  appId: PropTypes.number.isRequired
}

PriceOptions.defaultProps = {
  options: []
}

export default PriceOptions
