import React, { Component } from 'react';
import PropTypes from 'prop-types';
import HelpIcon from './HelpIcon';

class Panel extends Component {
  render() {
    const {
      dataTest,
      title,
      children,
      className,
      headerContent,
      onToggleHelp
    } = this.props;

    let helpIcon
    if (onToggleHelp) {
      helpIcon = <HelpIcon className="float-right" onClick={onToggleHelp} />
    }
    return (
      <div className={`card ${className}`} data-test={dataTest}>
        <div className="card-header">
          {helpIcon}
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
  headerContent: PropTypes.element,
  onToggleHelp: PropTypes.func
};

export default Panel;
