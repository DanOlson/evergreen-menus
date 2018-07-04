import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Panel from '../shared/Panel'
import FacebookPage from './FacebookPage'

class App extends Component {
  constructor (props) {
    super(props)
  }

  renderPages () {
    const {
      pages,
      establishments,
      updateAssociationPath,
      tabRestrictionsPath,
      facebookAddTabUrl
    } = this.props

    return pages.map(page => {
      return (
        <FacebookPage
          page={page}
          establishmentOpts={establishments}
          updateAssociationPath={updateAssociationPath}
          tabRestrictionsPath={tabRestrictionsPath}
          facebookAddTabUrl={facebookAddTabUrl}
          key={page.id}
        />
      )
    })
  }

  render () {
    const pages = this.renderPages()
    return (
      <Panel title="Associate Facebook Pages">
        <table className="table">
          <thead>
            <tr>
              <th>Page</th>
              <th>Fans</th>
              <th>Establishment</th>
              <th>Linked</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            {pages}
          </tbody>
        </table>
      </Panel>
    )
  }
}

App.propTypes = {
  pages: PropTypes.array.isRequired,
  establishments: PropTypes.array.isRequired,
  updateAssociationPath: PropTypes.string.isRequired,
  facebookAddTabUrl: PropTypes.string.isRequired,
  tabRestrictionsPath: PropTypes.string.isRequired
}

export default App
