import React, { Component } from 'react';
import PropTypes from 'prop-types';
import Panel from '../shared/Panel';

class Preview extends Component {
  constructor(props) {
    super(props)

    this.handleToggleHelp = this.handleToggleHelp.bind(this)
    this.state = {
      showHelp: false
    }
  }

  handleToggleHelp() {
    this.setState(prevState => {
      return {
        showHelp: !prevState.showHelp
      }
    })
  }

  render() {
    const { showHelp } = this.state
    return (
      <Panel title="Preview" onToggleHelp={this.handleToggleHelp}>
        <div
          className={`card contextual-help bg-light ${showHelp ? '' : 'hidden'}`}
          data-test="help-text">
          <div className="card-body">
            The preview content shown here is unstyled. The styles from your site will apply to this menu once you add the embed code to your site.
          </div>
        </div>
        <div className="web-menu-preview-wrapper">
          <object
            data={this.props.previewPath}
            type="text/html"
            height="600"
            style={{ width: "100%" }}
            data-test="web-menu-preview">
          </object>
        </div>
      </Panel>
    );
  }
}

Preview.propTypes = {
  previewPath: PropTypes.string.isRequired
}

export default Preview;
