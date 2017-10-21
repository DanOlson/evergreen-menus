import React, { Component } from 'react';
import PropTypes from 'prop-types';
import attributeNameResolver from './attributeNameResolver';
import ChosenListItem from './ChosenListItem';
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

class ChosenListGroup extends Component {
  constructor(props) {
    super(props);
    this.ifEmptyText = "Choose at least one list";
  }

  renderList(listGroupItems) {
    let itemsToRender;
    if (listGroupItems.length === 0) {
      itemsToRender = <li className="list-group-item">{this.ifEmptyText}</li>;
    } else {
      itemsToRender = listGroupItems;
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
      onShowPriceChange,
      menuType,
      onRemove,
      moveItem,
      connectDropTarget,
      isOver
    } = this.props;
    const nestedAttrsName    = attributeNameResolver.resolveNestedAttrName(menuType);
    const entityName         = attributeNameResolver.resolveEntityName(menuType);
    const nestedEntityIdName = attributeNameResolver.resolveNestedEntityIdName(menuType);
    const listGroupItems = lists.map((list, index) => {
      const listItemProps = {
        nestedAttrsName,
        entityName,
        nestedEntityIdName,
        onShowPriceChange,
        list,
        index,
        onRemove,
        moveItem,
        key: list.id
      };
      return <ChosenListItem { ...listItemProps } />
    });

    const style = {
      opacity: isOver ? 0.5 : 1
    };

    return connectDropTarget(
      <div className="card" data-test="menu-lists-selected" style={style}>
        <div className="card-header list-group-heading">
          <div className="card-title">Lists Selected</div>
        </div>
        {this.renderList(listGroupItems)}
      </div>
    );
  }
}

ChosenListGroup.propTypes = {
  lists: PropTypes.array.isRequired,
  menuType: PropTypes.string.isRequired,
  onRemove: PropTypes.func.isRequired,
  onShowPriceChange: PropTypes.func.isRequired,
  moveItem: PropTypes.func.isRequired,
  onDrop: PropTypes.func.isRequired,
  connectDropTarget: PropTypes.func.isRequired,
  isOver: PropTypes.bool.isRequired
};

export default DropTarget(
  itemTypes.availableListItem,
  dropTargetSpec,
  collect
)(ChosenListGroup);
