import React, { Component } from 'react'
import PropTypes from 'prop-types'

class HelpIcon extends Component {
  render () {
    const { onClick, className } = this.props
    return (
      <div className={className}>
        <i
          className='fa fa-question-circle-o fa-2x help-icon'
          aria-hidden='true'
          data-test='help-icon'
          onClick={onClick} />
      </div>
    )
  }
}

HelpIcon.defaultProps = {
  onClick: () => {},
  className: ''
}

HelpIcon.propTypes = {
  onClick: PropTypes.func,
  className: PropTypes.string
}

export default HelpIcon
