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
    this.createTab = this.createTab.bind(this)

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
    const authToken = document.getElementsByName('csrf-token')[0].content
    fetch(path, {
      credentials: 'same-origin', // send cookies
      method: 'put',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        authenticity_token: authToken,
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

  createTab (event) {
    event.preventDefault()
    const button = event.target
    button.setAttribute('disabled', '')
    button.innerText = 'Adding tab...'
    const { createTabPath } = this.props
    const establishmentId = this.state.selectedEstablishment.id.toString()
    const authToken = document.getElementsByName('csrf-token')[0].content
    fetch(createTabPath, {
      credentials: 'same-origin',
      method: 'post',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        establishment_id: establishmentId,
        authenticity_token: authToken
      })
    })
    .then(res => {
      if (res.ok) {
        button.innerText = 'Tab added!'
      } else {
        button.innerText = 'Adding tab failed'
        setTimeout(() => {
          button.removeAttribute('disabled')
          button.innerText = 'Retry?'
        }, 2000)
      }
    })
    .catch(err => {
      button.innerText = 'Adding tab failed'
    })
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
      return <a href="#" onClick={this.handleLink} className="btn btn-evrgn-outline-primary link-status">Link</a>
    } else {
      return <i className="fa fa-2x fa-check check link-status" aria-hidden title="Linked"></i>
    }
  }

  renderCreateTabButton () {
    if (this.isAssociationDirty()) return
    const { page, tabRestrictionsPath } = this.props
    if (page.fan_count >= 2000) {
      return (
        <button
          type="button"
          onClick={this.createTab}
          className="btn btn-evrgn-primary">
          Add Menu Tab
        </button>
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

  render () {
    const { page, establishmentOpts } = this.props
    const { selectedEstablishment } = this.state
    const linkStatus = this.renderLinkStatus()
    const createTabButton = this.renderCreateTabButton()
    return (
      <section>
        <div className="row">
          <h4 className="my-auto col-sm-4">
            <i className="facebook-icon fa fa-2x fa-facebook-square" aria-hidden></i>
            <span className="page-name">{page.name}</span>
          </h4>
          <div className="form-group col-sm-4 my-auto">
            <div className="valign-wrapper-w80">
              <EstablishmentSelect
                establishments={establishmentOpts}
                selected={selectedEstablishment}
                onChange={this.handleEstablishmentChange}
              />
            </div>
            <div className="valign-wrapper-w20">
              {linkStatus}
            </div>
          </div>
          <div className="col-sm-4 my-auto">
            {createTabButton}
          </div>
        </div>
      </section>
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
  createTabPath: PropTypes.string.isRequired,
  tabRestrictionsPath: PropTypes.string.isRequired
}

export default FacebookPage
