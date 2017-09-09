import React, { Component } from 'react';
import PropTypes from 'prop-types';
import RemoveButton from './RemoveButton';

class ChosenListItem extends Component {
  constructor(props) {
    super(props);
    this.onShowPriceChange  = this.onShowPriceChange.bind(this);
  }

  onShowPriceChange(event) {
    const { list, onShowPriceChange } = this.props;
    onShowPriceChange(list.id, event.target.checked);
  }

  render() {
    const {
      index,
      list,
      nestedAttrsName,
      entityName,
      nestedEntityIdName,
      onRemove
    } = this.props;
    const showPriceInputId = `menu_${nestedAttrsName}_${index}_show_price_on_menu`
    const showPrice = {
      type: 'checkbox',
      name: `${entityName}[${nestedAttrsName}][${index}][show_price_on_menu]`,
      id: showPriceInputId,
      'data-test': 'show-price',
      value: '1',
      onChange: this.onShowPriceChange
    }
    // New records are always checked
    if (list.show_price_on_menu === undefined || list.show_price_on_menu) {
      showPrice.defaultChecked = 'checked';
    }
    return (
      <li className="list-group-item" data-test="menu-list">
        <RemoveButton onClick={onRemove} listId={list.id} />
        <span className="list-name" data-test="list-name">{list.name}</span>
        <input
          type="hidden"
          name={`${entityName}[${nestedAttrsName}][${index}][show_price_on_menu]`}
          value="0"
        />
        <label
          htmlFor={showPriceInputId}
          className="menu-list-show-price"
          data-test="show-price-label">Display Price
          <input {...showPrice} />
        </label>
        <input
          type="hidden"
          name={`${entityName}[${nestedAttrsName}][${index}][id]`}
          value={list[nestedEntityIdName]}
        />
        <input
          type="hidden"
          name={`${entityName}[${nestedAttrsName}][${index}][list_id]`}
          value={list.id}
        />
        <input
          type="hidden"
          name={`${entityName}[${nestedAttrsName}][${index}][position]`}
          value={index}
        />
      </li>
    );
  }
}

ChosenListItem.propTypes = {
  list: PropTypes.object.isRequired,
  index: PropTypes.number.isRequired,
  onRemove: PropTypes.func.isRequired,
  onShowPriceChange: PropTypes.func.isRequired,
  nestedAttrsName: PropTypes.string.isRequired,
  entityName: PropTypes.string.isRequired,
  nestedEntityIdName: PropTypes.string.isRequired
}

export default ChosenListItem;
