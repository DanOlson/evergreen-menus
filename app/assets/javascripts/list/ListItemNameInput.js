import React, { Component } from 'react'
import PropTypes from 'prop-types'

class ListItemNameInput extends Component {
  render () {
    const { appId, value, className, focus } = this.props
    return (
      <div className='col-sm-6 col-xs-8'>
        <label htmlFor={`list_beers_attributes_${appId}_name`} className='sr-only'>
          Name
        </label>
        <input
          type='text'
          placeholder='Name'
          data-test={`beer-name-input-${appId}`}
          defaultValue={value}
          name={`list[beers_attributes][${appId}][name]`}
          id={`list_beers_attributes_${appId}_name`}
          className={`form-control ${className}`}
          autoFocus={focus}
        />
      </div>
    )
  }
}

ListItemNameInput.defaultProps = {
  name: '',
  className: '',
  focus: false
}

ListItemNameInput.propTypes = {
  appId: PropTypes.number.isRequired,
  value: PropTypes.string,
  className: PropTypes.string,
  focus: PropTypes.bool
}
export default ListItemNameInput
