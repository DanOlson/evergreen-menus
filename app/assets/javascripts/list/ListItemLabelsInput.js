import React, { Component } from 'react'
import PropTypes from 'prop-types'
import ListItemLabelInput from './ListItemLabelInput'

class ListItemLabelsInput extends Component {
  render () {
    const { appId, menuItemLabels, appliedLabels, className } = this.props
    const labelInputs = menuItemLabels.map((label, idx) => {
      const isChecked = !!appliedLabels.find(l => l.name === label.name)
      const labelProps = {
        appId,
        label,
        checked: isChecked,
        key: idx
      }
      return <ListItemLabelInput {...labelProps} />
    })

    return (
      <div className={className}>
        <input type='hidden' name={`list[beers_attributes][${appId}][labels][]`} />
        {labelInputs}
      </div>
    )
  }
}

ListItemLabelsInput.defaultProps = {
  appliedLabels: [],
  className: 'col-sm-2 col-xs-8'
}

ListItemLabelsInput.propTypes = {
  appId: PropTypes.number.isRequired,
  menuItemLabels: PropTypes.array.isRequired,
  appliedLabels: PropTypes.array,
  className: PropTypes.string
}

export default ListItemLabelsInput
