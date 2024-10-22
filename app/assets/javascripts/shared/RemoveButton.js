import React, { Component } from 'react'
import PropTypes from 'prop-types'

class RemoveButton extends Component {
  constructor (props) {
    super(props)
    this.handleClick = this.handleClick.bind(this)
  }

  handleClick (event) {
    const { listId } = this.props
    event.preventDefault()
    this.props.onClick(listId)
  }

  render () {
    return (
      <a
        href=''
        role='button'
        data-test='remove-list'
        title='Remove list'
        onClick={this.handleClick}
        className={`btn btn-outline-secondary btn-sm move-list-button`}>
        <span className='fas fa-minus fa-lg' />
      </a>
    )
  }
}

RemoveButton.propTypes = {
  onClick: PropTypes.func.isRequired,
  listId: PropTypes.number.isRequired
}

export default RemoveButton
