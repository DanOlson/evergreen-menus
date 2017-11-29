import React, { Component } from 'react';
import PropTypes from 'prop-types';

class EmbedCode extends Component {
  render () {
    const embedCode = { __html: this.props.embedCode };
    const htmlVisibility = this.props.show ? 'show' : 'hidden';
    return (
      <div className={`card bg-light ${htmlVisibility}`}>
        <div
          className="card-body"
          data-test="menu-embed-code"
          dangerouslySetInnerHTML={embedCode}
        />
      </div>
    );
  }
}

EmbedCode.defaultProps = {
  show: false
};

EmbedCode.propTypes = {
  show: PropTypes.bool,
  embedCode: PropTypes.string
};

export default EmbedCode;
