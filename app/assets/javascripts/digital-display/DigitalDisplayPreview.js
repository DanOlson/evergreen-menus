import React, { PropTypes, Component } from 'react';
import Panel from '../Panel';

class DigitalDisplayPreview extends Component {
  constructor(props) {
    super(props);
    this.state = { height: "100%" };
  }

  componentDidMount() {
    const width  = this.width;
    this.setState(prevState => {
      const height = (width * 0.5625).toString().split('.')[0];
      return { height: `${height}px` };
    });
  }

  render() {
    const applyHeight = (div) => {
      if (div) {
        this.width = div.offsetWidth;
      }
    }
    const { height } = this.state;

    return (
      <Panel title='Preview' dataTest="digital-display-menu-preview-panel">
        <div
          className="digital-display-menu-preview-wrapper">
          <object
            className="preview-landscape"
            data={this.props.previewPath}
            type="text/html"
            style={{ width: "100%" }}
            height={height}
            ref={applyHeight}
            data-test="digital-display-menu-preview">
          </object>
        </div>
      </Panel>
    );
  }
}

DigitalDisplayPreview.propTypes = {
  previewPath: PropTypes.string.isRequired
};

export default DigitalDisplayPreview;
