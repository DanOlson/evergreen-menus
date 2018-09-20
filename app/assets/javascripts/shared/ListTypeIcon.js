import React, { Component } from 'react'
import PropTypes from 'prop-types'

const cocktailGlass = 'fa-glass'
const wineGlass = 'icon-glass'
const beerGlass = 'icon-beer'
const cutlery = 'fa-cutlery'
const moon = 'fa-moon-o'
const coffee = 'fa-coffee'

const ICONS_BY_TYPE = {
  'beer': beerGlass,
  'wine': wineGlass,
  'spirits': cocktailGlass,
  'cocktails': cocktailGlass,
  'appetizers': cutlery,
  'breakfast': cutlery,
  'lunch': cutlery,
  'dinner': cutlery,
  'happy-hour': wineGlass,
  'late-night': moon,
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
        className={`fa ${icon} ${className}`}
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
