import React, { Component } from 'react'
import PropTypes from 'prop-types'

class ListItemLabelInput extends Component {
  render () {
    const { appId, label, checked } = this.props
    const inputId = `${label.name}-${appId}`

    return (
      <div className='form-check'>
        <input
          data-test='menu-item-label-input'
          type='checkbox'
          defaultChecked={checked}
          id={inputId}
          name={`list[beers_attributes][${appId}][labels][]`}
          value={label.name}
        />
        <label className='form-check-label' htmlFor={inputId}>
          <span className={`fa glyphter-${label.icon}`} /> {label.name}
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
  label: PropTypes.object.isRequired,
  checked: PropTypes.bool
}

export default ListItemLabelInput
