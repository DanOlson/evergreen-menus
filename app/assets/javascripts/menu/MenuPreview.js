import React, { PropTypes } from 'react';

class MenuPreview extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div className="panel panel-default" data-test="menu-preview">
        <div className="panel-heading list-group-heading">Preview</div>
        <object
          data={this.props.previewPath}
          type="application/pdf"
          height="800"
          style={{width: "100%"}}>
        </object>
      </div>
    );
  }
}

MenuPreview.propTypes = {
  previewPath: PropTypes.string.isRequired
}

export default MenuPreview;
