import React, { Component } from 'react'
import PropTypes from 'prop-types'

class SyncToGoogleInput extends Component {
  render () {
    const { show, checked, className } = this.props

    if (!show) return null

    return (
      <div className={className}>
        <input type="hidden" name="web_menu[sync_to_google]" value="0" />
        <label htmlFor="web-menu-sync-to-google">Sync to Google</label>
        <input
          type="checkbox"
          name="web_menu[sync_to_google]"
          data-test="web-menu-sync-to-google"
          id="web-menu-sync-to-google"
          className="d-block"
          value="1"
          defaultChecked={checked}
        />
      </div>
    )
  }
}

SyncToGoogleInput.defaultProps = {
  className: 'col-sm-6'
}

SyncToGoogleInput.propTypes = {
  show: PropTypes.bool.isRequired,
  checked: PropTypes.bool,
  className: PropTypes.string
}

export default SyncToGoogleInput
