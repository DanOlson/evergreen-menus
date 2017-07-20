import React, { PropTypes } from 'react';

class ChosenListGroup extends React.Component {
  constructor(props) {
    super(props);
    this.ifEmptyText = "Choose at least one list"
  }

  renderRemoveButton(listId) {
    const onClick = (event) => {
      event.preventDefault();
      return this.props.onRemove(listId);
    }
    return (
      <a
        href=""
        role="button"
        data-test="remove-list"
        title="Remove list"
        onClick={onClick}
        className={`btn btn-default btn-sm move-list-button`}>
        <span className="glyphicon glyphicon-minus"></span>
      </a>
    );
  }

  renderList(listGroupItems) {
    let itemsToRender;
    if (listGroupItems.length === 0) {
      itemsToRender = <li className="list-group-item">{this.ifEmptyText}</li>;
    } else {
      itemsToRender = listGroupItems
    }

    return (
      <ul className="list-group">
        {itemsToRender}
      </ul>
    );
  }

  render() {
    const { lists, onShowPriceChange } = this.props;
    const listGroupItems = lists.map((list, index) => {
      const onChange = event => onShowPriceChange(list.id, event.target.checked);
      const removeButton     = this.renderRemoveButton(list.id);
      const showPriceInputId = `menu_menu_lists_attributes_${index}_show_price_on_menu`
      const showPrice = {
        type: 'checkbox',
        name: `menu[menu_lists_attributes][${index}][show_price_on_menu]`,
        id: showPriceInputId,
        'data-test': 'show-price',
        value: '1',
        onChange
      }
      // New records are always checked
      if (list.show_price_on_menu === undefined || list.show_price_on_menu) {
        showPrice.defaultChecked = 'checked';
      }
      return (
        <li className="list-group-item" key={list.id} data-test="menu-list">
          {removeButton}
          <span className="list-name" data-test="list-name">{list.name}</span>
          <input
            type="hidden"
            name={`menu[menu_lists_attributes][${index}][show_price_on_menu]`}
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
            name={`menu[menu_lists_attributes][${index}][id]`}
            value={list.menu_list_id}
          />
          <input
            type="hidden"
            name={`menu[menu_lists_attributes][${index}][list_id]`}
            value={list.id}
          />
          <input
            type="hidden"
            name={`menu[menu_lists_attributes][${index}][position]`}
            value={index}
          />
        </li>
      )
    });

    return (
      <div className="panel panel-default" data-test="menu-lists-selected">
        <div className="panel-heading list-group-heading">Lists Selected</div>
        {this.renderList(listGroupItems)}
      </div>
    )
  }
}

ChosenListGroup.propTypes = {
  lists: PropTypes.array.isRequired,
  onRemove: PropTypes.func.isRequired,
  onShowPriceChange: PropTypes.func.isRequired
};

export default ChosenListGroup;
