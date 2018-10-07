import React, { Component } from 'react'
import PropTypes from 'prop-types'
import EstablishmentSelect from '../facebook-match-pages/EstablishmentSelect'
import 'whatwg-fetch'

const nullEstablishment = { id: '' }
class Location extends Component {
  constructor (props) {
    super(props)
    this.handleLink = this.handleLink.bind(this)
    this.handleEstablishmentChange = this.handleEstablishmentChange.bind(this)

    const selectedEstablishment = props.establishmentOpts.find(e => {
      return e.google_my_business_location_id === props.location.name
    }) || nullEstablishment
    this.state = {
      persistedSelectedEstablishmentId: selectedEstablishment.id.toString(),
      selectedEstablishment
    }
  }

  handleLink (event) {
    event.preventDefault()
    const path = this.props.updateAssociationPath
    const establishmentId = this.state.selectedEstablishment.id.toString()
    const locationId = this.props.location.name
    const { csrfToken } = this.props
    fetch(path, {
      credentials: 'same-origin', // send cookies
      method: 'post',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        authenticity_token: csrfToken,
        establishment_id: establishmentId,
        location_id: locationId
      })
    }).then(res => {
      if (res.ok) {
        this.setState(() => {
          return {
            persistedSelectedEstablishmentId: establishmentId
          }
        })
      }
    }).catch(console.error)
  }

  handleEstablishmentChange (event) {
    const newValue = event.target.value
    const selectedEstablishment = this.props.establishmentOpts.find(e => {
      return e.id.toString() === newValue
    }) || nullEstablishment

    this.setState(() => {
      return { selectedEstablishment }
    })
  }

  renderLinkStatus () {
    if (this.isAssociationDirty()) {
      return <i className='fas fa-2x fa-times status-unlinked' aria-hidden title='Not Linked' />
    } else {
      return <i className='fas fa-2x fa-check status-linked' aria-hidden title='Linked' />
    }
  }

  renderActionButton () {
    if (!this.isEstablishmentLinked()) return
    if (this.isAssociationDirty()) {
      return (
        <a
          href=''
          onClick={this.handleLink}
          className='btn btn-evrgn-primary'>
          Link
        </a>
      )
    }
  }

  isAssociationDirty () {
    const { persistedSelectedEstablishmentId, selectedEstablishment } = this.state
    return persistedSelectedEstablishmentId !== selectedEstablishment.id.toString()
  }

  isEstablishmentLinked () {
    const {
      persistedSelectedEstablishmentId,
      selectedEstablishment
    } = this.state
    return !!(persistedSelectedEstablishmentId || selectedEstablishment.id)
  }

  render () {
    const { location, establishmentOpts } = this.props
    const { selectedEstablishment } = this.state
    const linkStatus = this.renderLinkStatus()
    const actionButton = this.renderActionButton()
    return (
      <tr>
        <td>
          <h4 className='my-auto'>
            <i className='google-icon fab fa-2x fa-google' aria-hidden />
            <span className='location-name'>{location.location_name}</span>
          </h4>
        </td>
        <td>
          <div className='form-group my-auto'>
            <EstablishmentSelect
              establishments={establishmentOpts}
              selected={selectedEstablishment}
              onChange={this.handleEstablishmentChange}
            />
          </div>
        </td>
        <td>{linkStatus}</td>
        <td>{actionButton}</td>
      </tr>
    )
  }
}

Location.defaultProps = {
  establishmentOpts: []
}

Location.propTypes = {
  establishmentOpts: PropTypes.array,
  location: PropTypes.object.isRequired,
  updateAssociationPath: PropTypes.string.isRequired,
  csrfToken: PropTypes.string.isRequired
}

export default Location
