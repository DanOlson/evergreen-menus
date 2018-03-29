import React, { Component } from 'react';
import PropTypes from 'prop-types';
import AddButton from './AddButton';
import { DragSource } from 'react-dnd';
import itemTypes from './item-types';
import pluralize from './pluralize';
import ListTypeIcon from './ListTypeIcon';
import constants from './constants';

class AvailableListItem extends Component {
  constructor(props) {
    super(props);
    this.onClick = this.onClick.bind(this);
  }

  onClick(event) {
    if (!confirm(constants.CONFIRM_TEXT)) {
      event.preventDefault()
    }
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

    const badgeContent = `${list.itemCount} ${pluralize('item', list.itemCount)}`;

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
      <li className="list-group-item list-group-item-action" data-test="menu-list" style={style}>
        <div className="valign-wrapper-w60">
          <AddButton onClick={onAdd} listId={list.id} />
          <a
            href={list.href}
            onClick={this.onClick}
            className="list-name"
            data-test="list-name">
            {list.name}
          </a>
        </div>
        <div className="valign-wrapper-w40">
          <ListTypeIcon listType={list.type} />
          <span
            data-test="list-badge"
            className="badge badge-pill badge-secondary float-right mr-2"
          >{badgeContent}</span>
        </div>
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
