import React, { Component } from 'react';
import PropTypes from 'prop-types';

class WebMenu extends Component {
  constructor(props) {
    super(props);
    this.getCode              = this.getCode.bind(this);
    this.renderShowCodeButton = this.renderShowCodeButton.bind(this);
    this.renderCode           = this.renderCode.bind(this);
    this.state                = { showCode: false };
  }

  getCode(event) {
    const newShowCode = !this.state.showCode;
    this.setState({ showCode: newShowCode });
  }

  htmlSnippet() {
    return { __html: this.props.embedCode };
  }

  renderShowCodeButton() {
    const buttonClass = this.state.showCode ? 'active' : '';
    if (this.props.canShowCode) {
      return (
        <a
          role="button"
          data-test="get-snippet"
          title="get embed code"
          onClick={this.getCode}
          className={`btn btn-outline-secondary btn-sm get-embed-code-btn ${buttonClass}`}>
          <i className="fa fa-code fa-lg"></i>
        </a>
      );
    } else {
      return '';
    }
  }

  renderCode() {
    const htmlVisiblity = this.state.showCode ? 'show' : 'hidden';
    if (this.props.canShowCode) {
      return (
        <div className={`card bg-light ${htmlVisiblity}`}>
          <div
            className="card-body"
            data-test="menu-html-snippet"
            dangerouslySetInnerHTML={this.htmlSnippet()}
          />
        </div>
      );
    } else {
      return '';
    }
  }

  render() {
    const { name, listType, editPath } = this.props;
    const showCodeButton = this.renderShowCodeButton();
    const snippet = this.renderCode();
    return (
      <div className="list-group-item" data-test="establishment-web-menu-item">
        <div className="valign-wrapper-w80">
          <a href={editPath} data-test="establishment-web-menu">{name}</a>
        </div>
        <div className="valign-wrapper-w20">
          {showCodeButton}
        </div>
        {snippet}
      </div>
    );
  }
}

WebMenu.propTypes = {
  name: PropTypes.string.isRequired,
  editPath: PropTypes.string.isRequired,
  canShowCode: PropTypes.bool.isRequired,
  embedCode: PropTypes.string
}

export default WebMenu;
