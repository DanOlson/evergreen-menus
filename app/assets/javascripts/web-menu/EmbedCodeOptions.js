import React, { Component } from 'react'
import PropTypes from 'prop-types'
import EmbedCode from './EmbedCode'

class EmbedCodeOptions extends Component {
  constructor(props) {
    super(props)

    this.toggleAmp = this.toggleAmp.bind(this)

    this.state = {
      showAmp: false
    }
  }

  toggleAmp() {
    this.setState(prevState => {
      return { showAmp: !prevState.showAmp }
    })
  }

  render() {
    const {
      show,
      canonicalCode,
      ampBodyCode,
      ampHeadCode
    } = this.props
    if (!canonicalCode) return null

    const htmlVisibility = show ? 'show' : 'hidden'
    const { showAmp } = this.state
    let bodyEmbedCode
    if (showAmp) {
      bodyEmbedCode = <EmbedCode embedCode={ampBodyCode} dataTest="amp-embed-code" />
    } else {
      bodyEmbedCode = <EmbedCode embedCode={canonicalCode} dataTest="canonical-embed-code" />
    }
    let headEmbedCode
    if (showAmp) {
      headEmbedCode = <EmbedCode embedCode={ampHeadCode} targetElement="head" dataTest="amp-head-embed-code" />
    }
    return (
      <div className={htmlVisibility} data-test="embed-code-options">
        <div className="embed-code-choices">
          <div className="form-check form-check-inline mr-2">
            <label className="form-check-label">
              <input
                type="radio"
                data-test="show-canonical"
                name="foo"
                className="form-check-input"
                value="1"
                defaultChecked={!showAmp}
                onClick={this.toggleAmp}/>
              Canonical
            </label>
          </div>
          <div className="form-check form-check-inline mr-2">
            <label className="form-check-label">
              <input
                type="radio"
                data-test="show-amp"
                name="foo"
                className="form-check-input"
                value="2"
                defaultChecked={showAmp}
                onClick={this.toggleAmp}/>
              AMP
            </label>
          </div>
        </div>

        {headEmbedCode}
        {bodyEmbedCode}
      </div>
    )
  }
}

EmbedCodeOptions.propTypes = {
  show: PropTypes.bool,
  canonicalCode: PropTypes.string,
  ampBodyCode: PropTypes.string,
  ampHeadCode: PropTypes.string
}

EmbedCodeOptions.defaultProps = {
  show: false
}

export default EmbedCodeOptions
