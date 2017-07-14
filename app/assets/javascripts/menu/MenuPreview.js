import React, { propTypes } from 'react';

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
          height="1200"
          style={{width: "100%"}}>
          <param name="foo" value="bar" />
        </object>
      </div>
    )
  }
}

export default MenuPreview;
