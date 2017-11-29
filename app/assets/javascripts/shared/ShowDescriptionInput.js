import React, { Component } from 'react';
import PropTypes from 'prop-types';

class ShowDescriptionInput extends Component {
  render () {
    const {
      entityName,
      nestedAttrsName,
      index,
      value,
      onChange
    } = this.props;
    const showDescriptionInputId = `menu_${nestedAttrsName}_${index}_show_description_on_menu`
    const showDescription = {
      type: 'checkbox',
      name: `${entityName}[${nestedAttrsName}][${index}][show_description_on_menu]`,
      id: showDescriptionInputId,
      'data-test': 'show-descriptions',
      value: '1',
      onChange
    }
    // New records always show description
    if (value === undefined || value) {
      showDescription.defaultChecked = 'checked';
    }

    return (
      <span className="chosen-list-toggle-detail">
        <input
          type="hidden"
          name={`${entityName}[${nestedAttrsName}][${index}][show_description_on_menu]`}
          value="0"
        />
        <label
          htmlFor={showDescriptionInputId}
          className="menu-list-show-description"
          data-test="show-descriptions-label">
          <span className="fa fa-comment-o" title="show description" aria-hidden="true"></span>
          <input {...showDescription} />
        </label>
      </span>
    );
  }
}

ShowDescriptionInput.defaultProps = {
  value: true
};

ShowDescriptionInput.propTypes = {
  entityName: PropTypes.string.isRequired,
  nestedAttrsName: PropTypes.string.isRequired,
  index: PropTypes.number.isRequired,
  onChange: PropTypes.func.isRequired,
  value: PropTypes.bool
}

export default ShowDescriptionInput;
