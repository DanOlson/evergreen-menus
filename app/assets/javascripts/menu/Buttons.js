import React, { Component } from 'react';
import PropTypes from 'prop-types';

class Buttons extends Component {
  render () {
    const {
      canDestroy,
      submitButtonText,
      cancelEditPath,
      children
    } = this.props;
    let deleteButton;

    if (!!canDestroy) {
      deleteButton = (
        <label
          htmlFor="menu-form-delete"
          className="btn btn-danger menu-form-action"
          data-test="menu-form-delete">
          Delete
        </label>
      );
    }

    return (
      <div className="button-wrapper">
        <input
          type="submit"
          name="commit"
          value={submitButtonText}
          className="btn btn-primary menu-form-action"
          data-test="menu-form-submit"
          data-disable-with="Create"
        />
        <a href={cancelEditPath}
          className="btn btn-outline-secondary menu-form-action"
          data-test="menu-form-cancel">Cancel</a>
        {deleteButton}
        {children}
      </div>
    );
  }
}

Buttons.propTypes = {
  canDestroy: PropTypes.bool.isRequired,
  submitButtonText: PropTypes.string.isRequired,
  cancelEditPath: PropTypes.string.isRequired
};

export default Buttons;
