import React, { Component } from 'react';
import PropTypes from 'prop-types';

const iconClassesByLabel = {
  'Gluten Free': 'glyphter-noun_979958_cc',
  'Vegan': 'glyphter-noun_990478_cc',
  'Vegetarian': 'glyphter-noun_40436_cc',
  'Spicy': 'glyphter-noun_707489_cc',
  'Dairy Free': 'glyphter-noun_990484_cc',
  'House Special': 'glyphter-noun_1266172_cc'
}

function icon(label) {
  return iconClassesByLabel[label]
}

class ListItemLabelInput extends Component {
  render() {
    const { appId, label, checked } = this.props
    const inputId = `${label}-${appId}`

    return (
      <div className="form-check">
        <input
          data-test="menu-item-label-input"
          className=""
          type="checkbox"
          defaultChecked={checked}
          id={inputId}
          name={`list[beers_attributes][${appId}][labels][]`}
          value={label}
        />
        <label className="form-check-label" htmlFor={inputId}>
          <span className={`fa ${icon(label)}`}></span> {label}
        </label>
      </div>
    )
  }
}
ListItemLabelInput.defaultProps = {
  checked: false
}

ListItemLabelInput.propTypes = {
  appId: PropTypes.number.isRequired,
  label: PropTypes.string.isRequired,
  checked: PropTypes.bool
}

export default ListItemLabelInput;
