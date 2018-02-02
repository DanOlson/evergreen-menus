import React, { Component } from 'react';
import PropTypes from 'prop-types';

class ListItemAction extends Component {
  render () {
    const { markedForRemoval, appId, onKeep, onRemove } = this.props;
    let link;
    if (markedForRemoval) {
      link = (
        <a href=""
          onClick={onKeep}
          data-test={`keep-beer-${appId}`}
          className="btn btn-danger">Keep</a>
      )
    } else {
      link = (
        <a href=""
          title="Remove"
          onClick={onRemove}
          data-test={`remove-beer-${appId}`}
          className="btn btn-outline-secondary">
          <span className="fa fa-remove fa-lg"></span>
        </a>
      )
    }
    return (
      <div className="col-sm-1 col-xs-4 remove">
        {link}
      </div>
    );
  }
}

ListItemAction.defaultProps = {
  markedForRemoval: false
};

ListItemAction.propTypes = {
  markedForRemoval: PropTypes.bool,
  appId: PropTypes.number.isRequired,
  onKeep: PropTypes.func.isRequired,
  onRemove: PropTypes.func.isRequired
};

export default ListItemAction;
