import React, { Component, Fragment } from 'react'
import PropTypes from 'prop-types'

const defaultLabelText = 'Choose image...'
const maxFileSize = 1000000 // 1MB
const validTypes = ['image/jpeg', 'image/jpg', 'image/png']

function applyImageSrc (file, callback) {
  const reader = new FileReader()
  reader.onload = e => {
    callback(e.target.result)
  }
  reader.readAsDataURL(file)
}

class ListItemImageInput extends Component {
  constructor (props) {
    super(props)
    this.state = {
      labelText: props.filename || defaultLabelText,
      isValid: true,
      url: props.url
    }
    this.handleFileChange = this.handleFileChange.bind(this)
    this.handleUrlChange = this.handleUrlChange.bind(this)
  }

  handleUrlChange (url) {
    this.setState(() => {
      return { url }
    })
  }

  handleFileChange (e) {
    const file = e.target.files[0]
    if (file) {
      this.setState(() => {
        const labelText = file.name
        const isValid = this.isFileValid(file)
        if (isValid) {
          applyImageSrc(file, this.handleUrlChange)
        }
        return { labelText, isValid, file }
      })
    } else {
      this.setState(() => {
        return { labelText: defaultLabelText, isValid: true }
      })
    }
  }

  isFileValid (file) {
    const { size } = file
    const isValidSize = size <= maxFileSize
    const isValidType = validTypes.includes(file.type)
    return isValidSize && isValidType
  }

  render () {
    const { appId } = this.props
    const { labelText, isValid, url } = this.state
    return (
      <Fragment>
        <div className='col-sm-3 col-xs-8'>
          <div className={`custom-file ${isValid ? '' : 'invalid'}`}>
            <input
              type='file'
              name={`list[beers_attributes][${appId}][image]`}
              data-test='beer-image-input'
              id={`list_beers_attributes_${appId}_image`}
              className={`custom-file-input ${isValid ? '': 'js-invalid'}`}
              onChange={this.handleFileChange}
            />
            <label
              htmlFor={`list_beers_attributes_${appId}_image`}
              className='custom-file-label'
              data-test='beer-image-label'>
              {labelText}
            </label>
            <div className="invalid-feedback">
              File must be PNG or JPG and no larger than 1MB
            </div>
          </div>
        </div>
        <div className="col list-item-image-frame">
          <img className="list-item-image" src={url} />
        </div>
      </Fragment>
    )
  }
}

ListItemImageInput.propTypes = {
  appId: PropTypes.number.isRequired,
  filename: PropTypes.string,
  url: PropTypes.string
}

export default ListItemImageInput
