import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Panel from '../shared/Panel'
import FacebookPage from './FacebookPage'

class App extends Component {
  renderPages () {
    const {
      pages,
      establishments,
      updateAssociationPath,
      tabRestrictionsPath,
      addTabPath,
      csrfToken
    } = this.props

    return pages.map(page => {
      return (
        <FacebookPage
          page={page}
          establishmentOpts={establishments}
          updateAssociationPath={updateAssociationPath}
          tabRestrictionsPath={tabRestrictionsPath}
          addTabPath={addTabPath}
          csrfToken={csrfToken}
          key={page.id}
        />
      )
    })
  }

  render () {
    const pages = this.renderPages()
    return (
      <Panel title='Associate Facebook Pages'>
        <table className='table'>
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
  addTabPath: PropTypes.string.isRequired,
  tabRestrictionsPath: PropTypes.string.isRequired,
  csrfToken: PropTypes.string.isRequired
}

export default App
