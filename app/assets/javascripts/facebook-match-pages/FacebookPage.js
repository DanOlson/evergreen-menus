import React, { Component } from 'react'
import PropTypes from 'prop-types'
import EstablishmentSelect from './EstablishmentSelect'
import 'whatwg-fetch'

const nullEstablishment = { id: '' }
class FacebookPage extends Component {
  constructor (props) {
    super(props)
    this.handleLink = this.handleLink.bind(this)
    this.handleEstablishmentChange = this.handleEstablishmentChange.bind(this)

    const selectedEstablishment = props.establishmentOpts.find(e => {
      return e.facebook_page_id === props.page.id
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
    const pageId = this.props.page.id
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
        facebook_page_id: pageId
      })
    }).then(res => {
      if (res.ok) {
        this.setState(prevState => {
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

    this.setState(prevState => {
      return { selectedEstablishment }
    })
  }

  renderLinkStatus () {
    if (this.isAssociationDirty()) {
      return <i className="fa fa-2x fa-times status-unlinked" aria-hidden title="Not Linked"></i>
    } else {
      return <i className="fa fa-2x fa-check status-linked" aria-hidden title="Linked"></i>
    }
  }

  renderActionButton () {
    if (!this.isEstablishmentLinked()) return
    if (this.isAssociationDirty()) {
      return (
        <a
          href=""
          onClick={this.handleLink}
          className="btn btn-evrgn-primary">
          Link
        </a>
      )
    }

    const { page, tabRestrictionsPath, addTabPath, csrfToken } = this.props
    const { persistedSelectedEstablishmentId } = this.state
    if (page.fan_count >= 2000) {
      return (
        <form method="post" action={addTabPath}>
          <input type="hidden" name="authenticity_token" value={csrfToken} />
          <input type="hidden" name="establishment_id" value={persistedSelectedEstablishmentId} />
          <button
            type="submit"
            className="btn btn-evrgn-primary">
            Add Menu Tab
          </button>
        </form>
      )
    } else {
      return (
        <a target="_blank" href={tabRestrictionsPath} className="btn btn-evrgn-primary">
          Add Menu Tab
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
    const { page, establishmentOpts } = this.props
    const { selectedEstablishment } = this.state
    const linkStatus = this.renderLinkStatus()
    const actionButton = this.renderActionButton()
    return (
      <tr>
        <td>
          <h4 className="my-auto">
            <i className="facebook-icon fa fa-2x fa-facebook-square" aria-hidden></i>
            <span className="page-name">{page.name}</span>
          </h4>
        </td>
        <td>{page.fan_count}</td>
        <td>
          <div className="form-group my-auto">
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

FacebookPage.defaultProps = {
  establishmentOpts: []
}

FacebookPage.propTypes = {
  establishmentOpts: PropTypes.array,
  page: PropTypes.object.isRequired,
  updateAssociationPath: PropTypes.string.isRequired,
  addTabPath: PropTypes.string.isRequired,
  facebookAddTabUrl: PropTypes.string.isRequired,
  csrfToken: PropTypes.string.isRequired
}

export default FacebookPage
