import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Clipboard from 'react-clipboard.js'
import htmlEntities from 'html-entities'

const entities = new htmlEntities.Html5Entities()

class EmbedCode extends Component {
  constructor (props) {
    super(props)
    this.getEmbedCode = this.getEmbedCode.bind(this)
    this.handleCopy = this.handleCopy.bind(this)

    this.state = { isCopied: false }
  }

  getEmbedCode () {
    const { embedCode } = this.props
    return entities.decode(embedCode)
  }

  handleCopy () {
    this.setState(prevState => {
      return { isCopied: true }
    })
  }

  render () {
    const embedCode = { __html: this.props.embedCode }
    const { targetElement, dataTest } = this.props
    const title = `Place this code into your HTML's ${targetElement} tag`
    const iconClass = this.state.isCopied ? 'fa-thumbs-up fa-lg' : 'fa-clipboard'
    const copyButtonIcon = <span className={`far ${iconClass}`} aria-hidden='true' />
    return (
      <div className='card bg-light' data-test={dataTest}>
        <div className='card-header'>
          <div className='card-title embed-code-title'>{title}</div>
          <div className='copy-button-wrapper' title='Copy to clipboard'>
            <Clipboard
              option-text={this.getEmbedCode}
              onSuccess={this.handleCopy}
              className='btn btn-secondary'>
              {copyButtonIcon}
            </Clipboard>
          </div>
        </div>
        <div className='card-body' data-test='menu-embed-code'>
          <pre>
            <code dangerouslySetInnerHTML={embedCode} />
          </pre>
        </div>
      </div>
    )
  }
}

EmbedCode.defaultProps = {
  show: false,
  targetElement: 'body',
  dataTest: 'embed-code-panel'
}

EmbedCode.propTypes = {
  show: PropTypes.bool,
  targetElement: PropTypes.string,
  embedCode: PropTypes.string.isRequired,
  dataTest: PropTypes.string
}

export default EmbedCode
