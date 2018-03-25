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
    const htmlVisibility = show ? 'show' : 'hidden'
    const { showAmp } = this.state
    const embedCode = showAmp ? ampBodyCode : canonicalCode
    let headEmbedCode
    if (showAmp) {
      headEmbedCode = <EmbedCode embedCode={ampHeadCode} targetElement="head" />
    }
    return (
      <div className={htmlVisibility}>
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
        <EmbedCode embedCode={embedCode} />
      </div>
    )
  }
}

EmbedCodeOptions.propTypes = {
  show: PropTypes.bool,
  canonicalCode: PropTypes.string.isRequired,
  ampBodyCode: PropTypes.string.isRequired,
  ampHeadCode: PropTypes.string.isRequired
}

EmbedCodeOptions.defaultProps = {
  show: false
}

export default EmbedCodeOptions
