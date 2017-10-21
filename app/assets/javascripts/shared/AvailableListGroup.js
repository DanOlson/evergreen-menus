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
    connectDropTarget: connect.dropTarget(),
    isOver: monitor.isOver()
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
      <ul className="list-group list-group-flush">
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
      isOver,
      onDrop
    } = this.props;

    const style = {
      opacity: isOver ? 0.5 : 1
    };

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
      <div className="card" data-test="menu-lists-available" style={style}>
        <div className="card-header list-group-heading">
          <div className="card-title">Lists Available</div>
        </div>
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
  connectDropTarget: PropTypes.func.isRequired,
  isOver: PropTypes.bool.isRequired
};

export default DropTarget(
  itemTypes.chosenListItem,
  dropTargetSpec,
  collect
)(AvailableListGroup);
