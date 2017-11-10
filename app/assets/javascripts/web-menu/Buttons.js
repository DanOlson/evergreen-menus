import React, { Component } from 'react';
import PropTypes from 'prop-types';

class Buttons extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    const {
      canDestroy,
      submitButtonText,
      cancelEditPath
    } = this.props;
    let deleteButton;

    if (!!canDestroy) {
      deleteButton = (
        <label
          htmlFor="web-menu-form-delete"
          className="btn btn-danger menu-form-action"
          data-test="web-menu-form-delete">
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
          data-test="web-menu-form-submit"
          data-disable-with="Create"
        />
        <a href={cancelEditPath}
           className="btn btn-outline-secondary menu-form-action"
           data-test="web-menu-form-cancel">Cancel</a>
        {deleteButton}
      </div>
    );
  }
}

Buttons.propTypes = {
  canDestroy: PropTypes.bool.isRequired,
  submitButtonText: PropTypes.string.isRequired,
  cancelEditPath: PropTypes.string.isRequired,
};

export default Buttons;
