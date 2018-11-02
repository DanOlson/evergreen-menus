import React, { Component } from 'react'
import PropTypes from 'prop-types'

class ShowLogoInput extends Component {
  render () {
    const { hasLogo, checked, onChange } = this.props
    if (!hasLogo) {
      return null
    }

    return (
      <div className='col-sm-2'>
        <input
          type='hidden'
          name='menu[show_logo]'
          value='0'
        />
        <label htmlFor='menu-show-logo'>Logo</label>
        <input
          type='checkbox'
          name='menu[show_logo]'
          data-test='menu-show-logo'
          id='menu-show-logo'
          className='d-block'
          value='1'
          defaultChecked={checked ? 'checked' : undefined}
          onChange={onChange}
        />
      </div>
    )
  }
}

ShowLogoInput.defaultProps = {
  checked: false
}

ShowLogoInput.propTypes = {
  onChange: PropTypes.func.isRequired,
  checked: PropTypes.bool
}

export default ShowLogoInput
