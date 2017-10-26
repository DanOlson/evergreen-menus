import React, { Component } from 'react';
import PropTypes from 'prop-types';
import Panel from '../Panel';

class DigitalDisplayPreview extends Component {
  constructor(props) {
    super(props);
    this.configureOrientation = this.configureOrientation.bind(this);
    this.setWidth = this.setWidth.bind(this);
    this.state = { height: "100%", width: "100%" };
  }

  configureOrientation(isHorizontal) {
    const initialWidth = this.width;
    // Calculate 16:9 aspect ratio
    const height = (initialWidth * 0.5625).toString().split('.')[0];
    let horizontalSize, verticalSize;

    if (isHorizontal) {
      horizontalSize = initialWidth;
      verticalSize   = height;
    } else {
      horizontalSize = height;
      verticalSize   = initialWidth;
    }

    this.setState(prevState => {
      return { height: verticalSize, width: `${horizontalSize}px` };
    });
  }

  componentWillReceiveProps(nextProps) {
    if (this.props !== nextProps && !!this.width) {
      const { isHorizontal } = nextProps;
      this.configureOrientation(isHorizontal);
    }
  }

  componentDidMount() {
    const { isHorizontal } = this.props;
    this.configureOrientation(isHorizontal);
  }

  setWidth(obj) {
    this.width = obj.offsetWidth;
  }

  render() {
    const { height, width } = this.state;
    const className = this.props.isHorizontal ? 'preview-horizontal' : 'preview-vertical';

    return (
      <Panel className="sticky-top" title='Preview' dataTest="digital-display-menu-preview-panel">
        <div className="digital-display-menu-preview-wrapper" ref={this.setWidth}>
          <object
            className={className}
            data={this.props.previewPath}
            type="text/html"
            style={{ width }}
            height={height}
            data-test="digital-display-menu-preview">
          </object>
        </div>
      </Panel>
    );
  }
}

DigitalDisplayPreview.propTypes = {
  previewPath: PropTypes.string.isRequired,
  isHorizontal: PropTypes.bool.isRequired
};

export default DigitalDisplayPreview;
