import React, { PropTypes, Component } from 'react';
import Panel from '../Panel';

class DigitalDisplayPreview extends Component {
  constructor(props) {
    super(props);
    this.configureOrientation = this.configureOrientation.bind(this);
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

  render() {
    const applyHeight = (div) => {
      if (div && !this.width) {
        this.width = div.offsetWidth;
      }
    }
    const { height, width } = this.state;
    const className = this.props.isHorizontal ? 'preview-horizontal' : 'preview-vertical';

    return (
      <Panel title='Preview' dataTest="digital-display-menu-preview-panel">
        <div className="digital-display-menu-preview-wrapper">
          <object
            className={className}
            data={this.props.previewPath}
            type="text/html"
            style={{ width }}
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
  previewPath: PropTypes.string.isRequired,
  isHorizontal: PropTypes.bool.isRequired
};

export default DigitalDisplayPreview;
