import React, { Component } from 'react';
import PropTypes from 'prop-types';
import ListTypeIcon from '../shared/ListTypeIcon';

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
          role="button"
          data-test="get-snippet"
          title="get snippet"
          onClick={this.getSnippet}
          className={`btn btn-outline-secondary btn-sm get-snippet-btn ${buttonClass}`}>
          <i className="fa fa-code fa-lg"></i>
        </a>
      );
    } else {
      return '';
    }
  }

  renderSnippet() {
    const htmlVisiblity = this.state.showSnippet ? 'show' : 'hidden';
    if (this.props.canShowSnippet) {
      return (
        <div className={`card bg-light ${htmlVisiblity}`}>
          <div
            className="card-body"
            data-test="list-html-snippet"
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
    const showSnippetButton = this.renderShowSnippetButton();
    const snippet = this.renderSnippet();
    return (
      <div className="list-group-item" data-test="establishment-list-item">
        <div className="valign-wrapper-w80">
          {showSnippetButton}
          <a href={editPath} data-test="establishment-list">{name}</a>
        </div>
        <div className="valign-wrapper-w20">
          <ListTypeIcon listType={listType} />
        </div>
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
