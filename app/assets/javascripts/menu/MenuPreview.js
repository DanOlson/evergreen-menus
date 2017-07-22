import React, { PropTypes } from 'react';

class MenuPreview extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div className="menu-preview-wrapper">
        <object
          data={this.props.previewPath}
          type="application/pdf"
          height="730"
          style={{width: "100%"}}
          data-test="menu-pdf">
        </object>
      </div>
    );
  }
}

MenuPreview.propTypes = {
  previewPath: PropTypes.string.isRequired
}

export default MenuPreview;
