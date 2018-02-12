import React, { Component } from 'react';
import PropTypes from 'prop-types';
import ListItemLabelInput from './ListItemLabelInput';

class ListItemLabelsInput extends Component {
  render () {
    const { appId, menuItemLabels, appliedLabels } = this.props
    const labelInputs = menuItemLabels.map((label, idx) => {
      const labelProps = {
        appId,
        label,
        checked: appliedLabels.includes(label),
        key: idx
      };
      return <ListItemLabelInput {...labelProps} />
    })

    return (
      <div className="col-sm-4 col-xs-8">
        <input type="hidden" name={`list[beers_attributes][${appId}][labels][]`} />
        {labelInputs}
      </div>
    )
  }
}

ListItemLabelsInput.defaultProps = {
  appliedLabels: []
}

ListItemLabelsInput.propTypes = {
  appId: PropTypes.number.isRequired,
  menuItemLabels: PropTypes.array.isRequired,
  appliedLabels: PropTypes.array
}

export default ListItemLabelsInput;
