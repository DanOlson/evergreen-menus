import React, { Component } from 'react';
import PropTypes from 'prop-types';

class Buttons extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    const {
      canDestroy,
      viewDisplayPath,
      submitButtonText,
      cancelEditPath
    } = this.props;
    let deleteButton, viewDisplayButton;
    if (!!canDestroy) {
      deleteButton = (
        <label
          htmlFor="digital-display-menu-form-delete"
          className="btn btn-danger menu-form-action"
          data-test="digital-display-menu-form-delete">
          Delete
        </label>
      );
    }
    if (viewDisplayPath) {
      viewDisplayButton = (
        <a href={viewDisplayPath}
           className="btn btn-success pull-right"
           data-test="view-digital-display-menu">View Display</a>
      )
    }
    return (
      <div className="form-group">
        <input
          type="submit"
          name="commit"
          value={submitButtonText}
          className="btn btn-primary menu-form-action"
          data-test="digital-display-menu-form-submit"
          data-disable-with="Create"
        />
        <a href={cancelEditPath}
           className="btn btn-default menu-form-action"
           data-test="digital-display-menu-form-cancel">Cancel</a>
        {deleteButton}
        {viewDisplayButton}
      </div>
    );
  }
}

Buttons.propTypes = {
  canDestroy: PropTypes.bool.isRequired,
  viewDisplayPath: PropTypes.string.isRequired,
  submitButtonText: PropTypes.string.isRequired,
  cancelEditPath: PropTypes.string.isRequired,
};

export default Buttons;
