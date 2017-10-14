import React, { Component } from 'react';
import PropTypes from 'prop-types';
import AddButton from './AddButton';
import { DragSource } from 'react-dnd';
import itemTypes from './item-types';

class AvailableListItem extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    const {
      index,
      list,
      totalListCount,
      nestedAttrsName,
      entityName,
      nestedEntityIdName,
      connectDragSource,
      isDragging,
      onAdd
    } = this.props;

    const style = {
      opacity: isDragging ? 0 : 1,
      cursor: 'move'
    };

    let menuListIdInput, menuListDestroyInput;
    if (list[nestedEntityIdName]) {
      // Avoid collisions with nestedAttrsName in ChosenListGroup
      const attrIndex = totalListCount + index;
      menuListIdInput = (
        <input
          type="hidden"
          name={`${entityName}[${nestedAttrsName}][${attrIndex}][id]`}
          value={list[nestedEntityIdName]}
        />
      )
      menuListDestroyInput = (
        <input
          type="hidden"
          name={`${entityName}[${nestedAttrsName}][${attrIndex}][_destroy]`}
          value="true"
        />
      )
    }

    return connectDragSource(
      <li className="list-group-item" data-test="menu-list" style={style}>
        <AddButton onClick={onAdd} listId={list.id} />
        <span className="list-name" data-test="list-name">{list.name}</span>
        {menuListIdInput}
        {menuListDestroyInput}
      </li>
    );
  }
}

const itemSource = {
  beginDrag(props) {
    return {
      id: props.list.id,
      index: props.index
    };
  }
};

// specifies which props to inject
function collect(connect, monitor) {
  return {
    connectDragSource: connect.dragSource(),
    isDragging: monitor.isDragging()
  };
}

AvailableListItem.propTypes = {
  index: PropTypes.number.isRequired,
  list: PropTypes.object.isRequired,
  totalListCount: PropTypes.number.isRequired,
  nestedAttrsName: PropTypes.string.isRequired,
  entityName: PropTypes.string.isRequired,
  nestedEntityIdName: PropTypes.string.isRequired,
  connectDragSource: PropTypes.func.isRequired,
  isDragging: PropTypes.bool.isRequired,
  onAdd: PropTypes.func.isRequired,
}

export default DragSource(
  itemTypes.availableListItem,
  itemSource,
  collect
)(AvailableListItem);
