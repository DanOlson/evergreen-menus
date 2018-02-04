import React, { Component } from 'react';
import PropTypes from 'prop-types';

class Flyout extends Component {
  render () {
    const vis = this.props.show ? '' : 'hidden';
    return (
      <div className={`flyout form-row ${vis}`}>
        {this.props.children}
      </div>
    );
  }
}

Flyout.defaultProps = {
  show: false
}

Flyout.propTypes = {
  show: PropTypes.bool
}

export default Flyout;
