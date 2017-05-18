import React, { PropTypes } from 'react';

class AvailableListGroup extends React.Component {
  constructor(props) {
    super(props);
    this.ifEmptyText = "No lists available"
  }

  renderAddButton(listId) {
    const onClick = (event) => {
      event.preventDefault();
      return this.props.onClick(listId);
    }
    return (
      <a
        href=""
        role="button"
        data-test="add-list"
        title="Add list"
        onClick={onClick}
        className={`btn btn-default btn-sm move-list-button`}>
        <span className="glyphicon glyphicon-plus"></span>
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
    const { lists } = this.props;
    const listGroupItems = lists.map((list, index) => {
      const addListButton = this.renderAddButton(list.id);
      let menuListIdInput, menuListDestroyInput;
      if (list.menu_list_id) {
        // Avoid collisions with menu_lists_attributes in ChosenListGroup
        const attrIndex = this.props.totalListCount + index
        menuListIdInput = (
          <input
            type="hidden"
            name={`menu[menu_lists_attributes][${attrIndex}][id]`}
            value={list.menu_list_id}
          />
        )
        menuListDestroyInput = (
          <input
            type="hidden"
            name={`menu[menu_lists_attributes][${attrIndex}][_destroy]`}
            value="true"
          />
        )
      }
      return (
        <li className="list-group-item" key={list.id} data-test="menu-list">
          {addListButton}
          {list.name}
          {menuListIdInput}
          {menuListDestroyInput}
        </li>
      )
    });

    return (
      <div className="panel panel-default" data-test="menu-lists-available">
        <div className="panel-heading list-group-heading">Lists Available</div>
        {this.renderList(listGroupItems)}
      </div>
    )
  }
}

AvailableListGroup.propTypes = {
  lists: PropTypes.array.isRequired,
  onClick: PropTypes.func.isRequired,
  totalListCount: PropTypes.number.isRequired
};

export default AvailableListGroup;
