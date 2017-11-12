import React, { Component } from 'react';
import PropTypes from 'prop-types';
import Panel from '../shared/Panel';

class Preview extends Component {
  render() {
    return (
      <Panel title="Preview">
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
