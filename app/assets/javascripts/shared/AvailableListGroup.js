import React, { Component } from 'react';
import PropTypes from 'prop-types';
import attributeNameResolver from './attributeNameResolver';
import AvailableListItem from './AvailableListItem';
import { DropTarget } from 'react-dnd';
import itemTypes from './item-types';

const dropTargetSpec = {
  drop(props, monitor, component) {
    const draggedItem = monitor.getItem();
    const listId = draggedItem.id;
    props.onDrop(listId);
  }
};

// props to be injected
function collect(connect, monitor) {
  return {
    connectDropTarget: connect.dropTarget()
  };
}

class AvailableListGroup extends Component {
  constructor(props) {
    super(props);
    this.ifEmptyText = "No lists available"
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
    const {
      lists,
      totalListCount,
      menuType,
      onAdd,
      connectDropTarget,
      onDrop
    } = this.props;
    const nestedAttrsName     = attributeNameResolver.resolveNestedAttrName(menuType);
    const entityName          = attributeNameResolver.resolveEntityName(menuType);
    const nestedEntityIdName  = attributeNameResolver.resolveNestedEntityIdName(menuType);
    const listGroupItems      = lists.map((list, index) => {
      const listItemProps = {
        index,
        list,
        totalListCount,
        nestedAttrsName,
        entityName,
        nestedEntityIdName,
        onAdd,
        key: list.id
      };

      return <AvailableListItem { ...listItemProps } />
    });

    return connectDropTarget(
      <div className="panel panel-default" data-test="menu-lists-available">
        <div className="panel-heading list-group-heading">Lists Available</div>
        {this.renderList(listGroupItems)}
      </div>
    )
  }
}

AvailableListGroup.propTypes = {
  lists: PropTypes.array.isRequired,
  onAdd: PropTypes.func.isRequired,
  menuType: PropTypes.string.isRequired,
  totalListCount: PropTypes.number.isRequired,
  onDrop: PropTypes.func.isRequired,
  connectDropTarget: PropTypes.func.isRequired
};

export default DropTarget(itemTypes.chosenListItem, dropTargetSpec, collect)(AvailableListGroup);
