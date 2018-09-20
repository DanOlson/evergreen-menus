import React, { Component } from 'react'
import PropTypes from 'prop-types'

class ToggleFlyoutButton extends Component {
  constructor (props) {
    super(props)

    this.onClick = this.onClick.bind(this)
  }

  onClick (event) {
    event.preventDefault()
    this.props.onClick()
  }

  render () {
    const { flyoutShown } = this.props
    const icon = flyoutShown ? 'fa-angle-double-up' : 'fa-angle-double-down'
    const activeState = flyoutShown ? 'active' : ''
    return (
      <a href=''
        title='Expand'
        onClick={this.onClick}
        data-test={`expand-list-item`}
        className={`btn btn-outline-secondary ${activeState}`}
        aria-pressed={flyoutShown}>
        <span className={`fa ${icon} fa-lg`} />
      </a>
    )
  }
}

ToggleFlyoutButton.propTypes = {
  flyoutShown: PropTypes.bool.isRequired,
  onClick: PropTypes.func.isRequired
}

export default ToggleFlyoutButton
