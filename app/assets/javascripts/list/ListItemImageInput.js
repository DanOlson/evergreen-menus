import React, { Component } from 'react'
import PropTypes from 'prop-types'

const defaultLabelText = 'Choose image...'

class ListItemImageInput extends Component {
  constructor (props) {
    super(props)
    this.state = {
      labelText: props.filename || defaultLabelText
    }
    this.handleFileChange = this.handleFileChange.bind(this)
  }

  handleFileChange (e) {
    const newText = e.target.value.split(/\\/).pop()
    this.setState(() => {
      return { labelText: newText || defaultLabelText }
    })
  }

  render () {
    const { appId, url } = this.props
    const { labelText } = this.state
    return (
      <div className='col-sm-3 col-xs-8'>
        <div className='custom-file'>
          <input
            type='file'
            name={`list[beers_attributes][${appId}][image]`}
            data-test='beer-image-input'
            id={`list_beers_attributes_${appId}_image`}
            className='custom-file-input'
            onChange={this.handleFileChange}
          />
          <label
            htmlFor={`list_beers_attributes_${appId}_image`}
            className='custom-file-label'
            data-test='beer-image-label'>
            {labelText}
          </label>
        </div>
        <img src={url} />
      </div>
    )
  }
}

ListItemImageInput.propTypes = {
  appId: PropTypes.number.isRequired,
  filename: PropTypes.string,
  url: PropTypes.string
}

export default ListItemImageInput
