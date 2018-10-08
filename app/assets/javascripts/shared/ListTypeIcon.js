import React, { Component } from 'react'
import PropTypes from 'prop-types'

const beerGlass = 'fa-beer'
const cutlery = 'fa-utensils'
const coffee = 'fa-coffee'

const ICONS_BY_TYPE = {
  'drink': beerGlass,
  'food': cutlery,
  'other': coffee
}

function iconFromType (type) {
  return ICONS_BY_TYPE[type.replace(/\s+/, '-')] || cutlery
}

class ListTypeIcon extends Component {
  render () {
    const { listType, className } = this.props
    const icon = iconFromType(listType)
    return (
      <span
        className={`fas ${icon} ${className}`}
        aria-hidden='true'
        title={listType} />
    )
  }
}

ListTypeIcon.propTypes = {
  listType: PropTypes.string.isRequired,
  className: PropTypes.string
}

ListTypeIcon.defaultProps = {
  className: 'fa-lg float-right'
}

export default ListTypeIcon
