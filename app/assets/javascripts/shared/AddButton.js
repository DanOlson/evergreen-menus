import React, { Component } from 'react'
import PropTypes from 'prop-types'

class AddButton extends Component {
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
        data-test='add-list'
        title='Add list'
        onClick={this.handleClick}
        className={`btn btn-outline-secondary btn-sm move-list-button`}>
        <span className='fa fa-plus fa-lg' />
      </a>
    )
  }
}

AddButton.propTypes = {
  onClick: PropTypes.func.isRequired,
  listId: PropTypes.number.isRequired
}

export default AddButton
