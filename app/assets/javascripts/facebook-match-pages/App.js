import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Panel from '../shared/Panel'
import FacebookPage from './FacebookPage'

class App extends Component {
  constructor (props) {
    super(props)
  }

  renderPages () {
    const { pages, establishments, updateAssociationPath } = this.props
    return pages.map(page => {
      return (
        <FacebookPage
          page={page}
          establishmentOpts={establishments}
          updateAssociationPath={updateAssociationPath}
          key={page.id}
        />
      )
    })
  }

  render () {
    const pages = this.renderPages()
    return (
      <Panel title="Associate Facebook Pages">
        {pages}
      </Panel>
    )
  }
}

App.propTypes = {
  pages: PropTypes.array.isRequired,
  establishments: PropTypes.array.isRequired,
  updateAssociationPath: PropTypes.string.isRequired
}

export default App
