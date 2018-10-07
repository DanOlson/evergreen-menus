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
    const icon = flyoutShown ? 'fa-angle-up' : 'fa-angle-down'
    const activeState = flyoutShown ? 'active' : ''
    return (
      <a href=''
        title='Expand'
        onClick={this.onClick}
        data-test={`expand-list-item`}
        className={`btn btn-outline-secondary ${activeState}`}
        aria-pressed={flyoutShown}>
        <span className={`fas ${icon}`} />
      </a>
    )
  }
}

ToggleFlyoutButton.propTypes = {
  flyoutShown: PropTypes.bool.isRequired,
  onClick: PropTypes.func.isRequired
}

export default ToggleFlyoutButton
