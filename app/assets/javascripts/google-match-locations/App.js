import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Panel from '../shared/Panel'
import Location from './Location'

class App extends Component {
  renderLocations () {
    const {
      locations,
      establishments,
      updateAssociationPath,
      csrfToken
    } = this.props

    return locations.map(location => {
      return (
        <Location
          location={location}
          establishmentOpts={establishments}
          updateAssociationPath={updateAssociationPath}
          csrfToken={csrfToken}
          key={location.name}
        />
      )
    })
  }

  render () {
    const locations = this.renderLocations()
    return (
      <Panel title='Associate Google My Business Locations'>
        <table className='table'>
          <thead>
            <tr>
              <th>Location</th>
              <th>Establishment</th>
              <th>Linked</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            {locations}
          </tbody>
        </table>
      </Panel>
    )
  }
}

App.propTypes = {
  locations: PropTypes.array.isRequired,
  establishments: PropTypes.array.isRequired,
  updateAssociationPath: PropTypes.string.isRequired,
  csrfToken: PropTypes.string.isRequired
}

export default App
