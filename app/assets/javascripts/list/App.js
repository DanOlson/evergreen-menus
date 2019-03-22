import React, { Component } from 'react'
import PropTypes from 'prop-types'
import List from './List'

class App extends Component {
  render () {
    const { list, typeOptions, menuItemLabels } = this.props
    const { beers, name, type, description, notes } = list
    const listProps = {
      listId: list.id,
      beers,
      name,
      type,
      description,
      notes,
      typeOptions,
      menuItemLabels
    }

    return <List {...listProps} />
  }
};

App.propTypes = {
  list: PropTypes.object.isRequired,
  typeOptions: PropTypes.array.isRequired,
  menuItemLabels: PropTypes.array.isRequired
}

export default App
