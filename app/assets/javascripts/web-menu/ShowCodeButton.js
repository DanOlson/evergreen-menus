import React, { Component } from 'react'
import PropTypes from 'prop-types'

class ShowCodeButton extends Component {
  constructor (props) {
    super(props)
    this.onClick = this.onClick.bind(this)
  }

  onClick (event) {
    event.preventDefault()
    this.props.onClick()
  }

  render () {
    const { buttonClass, children } = this.props
    return (
      <a
        role='button'
        data-test='get-embed-code'
        title='get embed code'
        onClick={this.onClick}
        href=''
        className={`btn btn-outline-success get-embed-code-btn menu-form-action ${buttonClass}`}>
        {children}
      </a>
    )
  }
}

ShowCodeButton.propTypes = {
  onClick: PropTypes.func.isRequired,
  buttonClass: PropTypes.string.isRequired
}

export default ShowCodeButton
