import React, { Component } from 'react';
import PropTypes from 'prop-types';

class Panel extends Component {
  render() {
    const { dataTest, title, children } = this.props;
    return (
      <div className="panel panel-info" data-test={dataTest}>
        <div className="panel-heading">
          <h3 className="panel-title">{title}</h3>
        </div>
        <div className="panel-body">
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
