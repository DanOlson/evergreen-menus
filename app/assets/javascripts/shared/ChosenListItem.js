import React, { Component } from 'react';
import PropTypes from 'prop-types';
import RemoveButton from './RemoveButton';
import { findDOMNode } from 'react-dom';
import itemTypes from './item-types';
import { DragSource, DropTarget } from 'react-dnd';
import pluralize from './pluralize';
import ListTypeIcon from './ListTypeIcon';
import ShowPriceCheckbox from './ShowPriceCheckbox';
import ShowDescriptionCheckbox from './ShowDescriptionCheckbox';

const itemSource = {
  beginDrag(props) {
    return {
      id: props.list.id,
      index: props.index
    };
  }
};

const itemTarget = {
  hover(props, monitor, component) {
    const dragIndex = monitor.getItem().index;
    const hoverIndex = props.index;

    // Don't replace items with themselves
    if (dragIndex === hoverIndex) {
      return;
    }

    // Determine rectangle on screen
    const hoverBoundingRect = findDOMNode(component).getBoundingClientRect();

    // Get vertical middle
    const hoverMiddleY = (hoverBoundingRect.bottom - hoverBoundingRect.top) / 2;

    // Determine mouse position
    const clientOffset = monitor.getClientOffset();

    // Get pixels to the top
    const hoverClientY = clientOffset.y - hoverBoundingRect.top;

    // Only perform the move when the mouse has crossed half of the items height
    // When dragging downwards, only move when the cursor is below 50%
    // When dragging upwards, only move when the cursor is above 50%

    // Dragging downwards
    if (dragIndex < hoverIndex && hoverClientY < hoverMiddleY) {
      return;
    }

    // Dragging upwards
    if (dragIndex > hoverIndex && hoverClientY > hoverMiddleY) {
      return;
    }

    // Time to actually perform the action
    props.moveItem(dragIndex, hoverIndex);

    // Note: we're mutating the monitor item here!
    // Generally it's better to avoid mutations,
    // but it's good here for the sake of performance
    // to avoid expensive index searches.
    monitor.getItem().index = hoverIndex;
  }
};

// specifies which props to inject
function dragCollect(connect, monitor) {
  return {
    connectDragSource: connect.dragSource(),
    isDragging: monitor.isDragging()
  };
}

// specifies which props to inject
function dropCollect(connect) {
  return {
    connectDropTarget: connect.dropTarget()
  };
}

class ChosenListItem extends Component {
  constructor(props) {
    super(props);
    this.onShowPriceChange = this.onShowPriceChange.bind(this);
    this.onShowDescriptionChange = this.onShowDescriptionChange.bind(this);
  }

  onShowPriceChange(event) {
    const { list, onShowPriceChange } = this.props;
    onShowPriceChange(list.id, event.target.checked);
  }

  onShowDescriptionChange(event) {
    const { list, onShowDescriptionChange } = this.props;
    onShowDescriptionChange(list.id, event.target.checked);
  }

  render() {
    const {
      index,
      list,
      nestedAttrsName,
      entityName,
      nestedEntityIdName,
      onRemove,
      connectDragSource,
      connectDropTarget,
      isDragging
    } = this.props;

    let showDescriptionInput;

    if (this.props.onShowDescriptionChange) {
      showDescriptionInput = (
        <ShowDescriptionCheckbox
          entityName={entityName}
          nestedAttrsName={nestedAttrsName}
          index={index}
          onChange={this.onShowDescriptionChange}
          value={list.show_description_on_menu}
        />
      );
    }

    const badgeContent = `${list.beerCount} ${pluralize('item', list.beerCount)}`;

    const style = {
      opacity: isDragging ? 0 : 1,
      cursor: 'move'
    };
    return connectDragSource(connectDropTarget(
      <li className="list-group-item" data-test="menu-list" style={style}>
        <div className="valign-wrapper-w50">
          <RemoveButton onClick={onRemove} listId={list.id} />
          <span className="list-name" data-test="list-name">{list.name}</span>
        </div>
        <div className="valign-wrapper-w50">
          <ShowPriceCheckbox
            entityName={entityName}
            nestedAttrsName={nestedAttrsName}
            index={index}
            onChange={this.onShowPriceChange}
            value={list.show_price_on_menu}
          />
          {showDescriptionInput}
          <ListTypeIcon listType={list.type} />
          <span
            data-test="list-badge"
            className="badge badge-pill badge-success float-right mr-2"
          >{badgeContent}</span>
        </div>
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
    ));
  }
}

ChosenListItem.propTypes = {
  list: PropTypes.object.isRequired,
  index: PropTypes.number.isRequired,
  onRemove: PropTypes.func.isRequired,
  onShowPriceChange: PropTypes.func.isRequired,
  onShowDescriptionChange: PropTypes.func,
  nestedAttrsName: PropTypes.string.isRequired,
  entityName: PropTypes.string.isRequired,
  nestedEntityIdName: PropTypes.string.isRequired,
  connectDragSource: PropTypes.func.isRequired,
  isDragging: PropTypes.bool.isRequired,
  moveItem: PropTypes.func.isRequired
};

const dragSource = DragSource(
  itemTypes.chosenListItem,
  itemSource,
  dragCollect
)(ChosenListItem);

export default DropTarget(
  itemTypes.chosenListItem,
  itemTarget,
  dropCollect
)(dragSource);
