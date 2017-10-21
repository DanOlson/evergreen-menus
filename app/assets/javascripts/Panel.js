import React, { Component } from 'react';
import PropTypes from 'prop-types';

class Panel extends Component {
  render() {
    const { dataTest, title, children } = this.props;
    return (
      <div className="card" data-test={dataTest}>
        <div className="card-header">
          <h3 className="card-title">{title}</h3>
        </div>
        <div className="card-body">
          {children}
        </div>
      </div>
    );
  }
}

Panel.propTypes = {
  dataTest: PropTypes.string,
  title: PropTypes.string.isRequired
}

export default Panel;
