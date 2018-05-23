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
      <Panel className="sticky-top" title="Preview" onToggleHelp={this.handleToggleHelp}>
        <div
          className={`card contextual-help bg-light ${showHelp ? '' : 'hidden'}`}
          data-test="help-text">
          <div className="card-body">
            The preview content shown here is unstyled. Google's styles will apply to this menu.
          </div>
        </div>
        <div className="menu-preview-wrapper">
          <object
            data={this.props.previewPath}
            type="text/html"
            height="600"
            style={{ width: "100%" }}
            data-test="google-menu-preview">
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
