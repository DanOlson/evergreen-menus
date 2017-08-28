import React, { Component } from 'react';
import PropTypes from 'prop-types';

class EstablishmentListItem extends Component {
  constructor(props) {
    super(props);
    this.getSnippet              = this.getSnippet.bind(this);
    this.renderShowSnippetButton = this.renderShowSnippetButton.bind(this);
    this.renderSnippet           = this.renderSnippet.bind(this);
    this.state                   = { showSnippet: false }
  }

  getSnippet(event) {
    const newShowSnippet = !this.state.showSnippet;
    this.setState({ showSnippet: newShowSnippet });
  }

  htmlSnippet() {
    return { __html: this.props.htmlSnippet };
  }

  renderShowSnippetButton() {
    const buttonClass = this.state.showSnippet ? 'active' : '';
    if (this.props.canShowSnippet) {
      return (
        <a
          href="#"
          role="button"
          data-test="get-snippet"
          title="get snippet"
          onClick={this.getSnippet}
          className={`btn btn-default btn-sm get-snippet-btn ${buttonClass}`}>
          <span className="glyphicon glyphicon-scissors"></span>
        </a>
      );
    } else {
      return '';
    }
  }

  renderSnippet() {
    const htmlSnippetClass = this.state.showSnippet ? 'show' : 'hidden';
    if (this.props.canShowSnippet) {
      return (
        <div
          className={htmlSnippetClass}
          data-test="list-html-snippet"
          dangerouslySetInnerHTML={this.htmlSnippet()}
        />
      );
    } else {
      return '';
    }
  }

  render() {
    const { name, editPath } = this.props;
    const showSnippetButton = this.renderShowSnippetButton();
    const snippet = this.renderSnippet();
    return (
      <div className="list-group-item" data-test="establishment-list-item">
        {showSnippetButton}
        <a href={editPath} data-test="establishment-list">{name}</a>
        {snippet}
      </div>
    );
  }
}

EstablishmentListItem.propTypes = {
  name: PropTypes.string.isRequired,
  editPath: PropTypes.string.isRequired,
  canShowSnippet: PropTypes.bool.isRequired,
  htmlSnippet: PropTypes.string
}

export default EstablishmentListItem;
