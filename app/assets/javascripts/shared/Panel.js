import React, { Component } from 'react';
import PropTypes from 'prop-types';

class Panel extends Component {
  render() {
    const { dataTest, title, children, className, headerContent } = this.props;

    return (
      <div className={`card ${className}`} data-test={dataTest}>
        <div className="card-header">
          <h3 className="card-title">
            {title}
            {headerContent}
          </h3>
        </div>
        <div className="card-body">
          {children}
        </div>
      </div>
    );
  }
}

Panel.defaultProps = {
  className: ''
};

Panel.propTypes = {
  dataTest: PropTypes.string,
  title: PropTypes.string.isRequired,
  className: PropTypes.string,
  headerContent: PropTypes.element
};

export default Panel;
