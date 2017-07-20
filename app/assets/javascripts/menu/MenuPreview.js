import React, { PropTypes } from 'react';

class MenuPreview extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <object
        data={this.props.previewPath}
        type="application/pdf"
        height="800"
        style={{width: "100%"}}>
      </object>
    );
  }
}

MenuPreview.propTypes = {
  previewPath: PropTypes.string.isRequired
}

export default MenuPreview;
