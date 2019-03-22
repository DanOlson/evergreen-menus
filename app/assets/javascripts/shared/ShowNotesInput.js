import React, { Component } from 'react'
import PropTypes from 'prop-types'

class ShowNotesInput extends Component {
  render () {
    const {
      entityName,
      nestedAttrsName,
      index,
      value,
      onChange
    } = this.props
    const showNotesInputId = `menu_${nestedAttrsName}_${index}_show_notes_on_menu`
    const showNotes = {
      type: 'checkbox',
      name: `${entityName}[${nestedAttrsName}][${index}][show_notes_on_menu]`,
      id: showNotesInputId,
      'data-test': 'show-notes',
      value: '1',
      onChange
    }
    // New records always show notes
    if (value === undefined || value) {
      showNotes.defaultChecked = 'checked'
    }

    return (
      <div className='form-check chosen-list-toggle-detail'>
        <input
          type='hidden'
          name={`${entityName}[${nestedAttrsName}][${index}][show_notes_on_menu]`}
          value='0'
        />
        <input {...showNotes} className='form-check-input' />
        <label
          htmlFor={showNotesInputId}
          className='menu-list-show-notes form-check-label'
          data-test='show-notes-label'>
          Show notes
        </label>
      </div>
    )
  }
}

ShowNotesInput.defaultProps = {
  value: true
}

ShowNotesInput.propTypes = {
  entityName: PropTypes.string.isRequired,
  nestedAttrsName: PropTypes.string.isRequired,
  index: PropTypes.number.isRequired,
  onChange: PropTypes.func.isRequired,
  value: PropTypes.bool
}

export default ShowNotesInput
