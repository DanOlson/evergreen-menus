import React, { Component } from 'react'
import PropTypes from 'prop-types'

class MenuFormButtons extends Component {
  render () {
    const {
      menuType,
      canDestroy,
      submitButtonText,
      cancelEditPath,
      children
    } = this.props
    let deleteButton

    if (canDestroy) {
      deleteButton = (
        <label
          htmlFor={`${menuType}-form-delete`}
          className='btn btn-evrgn-delete menu-form-action'
          data-test={`${menuType}-form-delete`}>
          Delete
        </label>
      )
    }

    return (
      <div className='button-wrapper'>
        <input
          type='submit'
          name='commit'
          value={submitButtonText}
          className='btn btn-evrgn-primary menu-form-action'
          data-test={`${menuType}-form-submit`}
          data-disable-with='Create'
        />
        <a href={cancelEditPath}
          className='btn btn-outline-secondary menu-form-action'
          data-test={`${menuType}-form-cancel`}>Cancel</a>
        {deleteButton}
        {children}
      </div>
    )
  }
}

MenuFormButtons.defaultProps = {
  canDestroy: false
}

MenuFormButtons.propTypes = {
  menuType: PropTypes.string.isRequired,
  canDestroy: PropTypes.bool,
  submitButtonText: PropTypes.string.isRequired,
  cancelEditPath: PropTypes.string.isRequired
}

export default MenuFormButtons
