import React, { Component } from 'react'
import PropTypes from 'prop-types'
import ListItemNameInput from './ListItemNameInput'
import PriceOptions from './PriceOptions'
import ListItemDescriptionInput from './ListItemDescriptionInput'
import ListItemLabelsInput from './ListItemLabelsInput'
import ListItemImageInput from './ListItemImageInput'
import ListItemAction from './ListItemAction'
import Flyout from './Flyout'
import ToggleFlyoutButton from './ToggleFlyoutButton'
import itemTypes from '../shared/item-types'
import { DragSource, DropTarget } from 'react-dnd'
import { findDOMNode } from 'react-dom'

const itemSource = {
  beginDrag (props) {
    return {
      id: props.beer.appId,
      index: props.index
    }
  }
}

const itemTarget = {
  hover (props, monitor, component) {
    const item = monitor.getItem()
    const dragIndex = item.index
    const hoverIndex = props.index

    // Don't replace items with themselves
    if (dragIndex === hoverIndex) {
      return
    }

    // Determine rectangle on screen
    const hoverBoundingRect = findDOMNode(component).getBoundingClientRect()

    // Get vertical middle
    const hoverMiddleY = (hoverBoundingRect.bottom - hoverBoundingRect.top) / 2

    // Determine mouse position
    const clientOffset = monitor.getClientOffset()

    // Get pixels to the top
    const hoverClientY = clientOffset.y - hoverBoundingRect.top

    // Only perform the move when the mouse has crossed half of the items height
    // When dragging downwards, only move when the cursor is below 50%
    // When dragging upwards, only move when the cursor is above 50%

    // Dragging downwards
    if (dragIndex < hoverIndex && hoverClientY < hoverMiddleY) {
      return
    }

    // Dragging upwards
    if (dragIndex > hoverIndex && hoverClientY > hoverMiddleY) {
      return
    }

    // Time to actually perform the action
    props.moveItem(dragIndex, hoverIndex)

    // Note: we're mutating the monitor item here!
    // Generally it's better to avoid mutations,
    // but it's good here for the sake of performance
    // to avoid expensive index searches.
    item.index = hoverIndex
  }
}

// specifies which props to inject
function dragCollect (connect, monitor) {
  const isDragging = monitor.isDragging()
  return {
    connectDragSource: connect.dragSource(),
    isDragging
  }
}

// specifies which props to inject
function dropCollect (connect) {
  return {
    connectDropTarget: connect.dropTarget()
  }
}

class ListItemInputGroup extends Component {
  constructor (props) {
    super(props)
    this.state = Object.assign({ showFlyout: !props.beer.id }, props.beer)
    this.onRemove = this.onRemove.bind(this)
    this.onKeep = this.onKeep.bind(this)
    this.toggleFlyout = this.toggleFlyout.bind(this)
  }

  onRemove (event) {
    event.preventDefault()
    if (this.state.id) {
      this.markForRemoval()
    } else {
      this.deleteBeer(this.state.appId)
    }
  }

  toggleFlyout () {
    this.setState(prevState => {
      return { showFlyout: !prevState.showFlyout }
    })
  }

  deleteBeer (appId) {
    this.props.deleteBeer(appId)
  }

  markForRemoval () {
    this.setState({ markedForRemoval: true })
  }

  onKeep (event) {
    event.preventDefault()
    this.setState({ markedForRemoval: false })
  }

  render () {
    const {
      appId,
      markedForRemoval,
      name,
      price,
      priceOptions,
      description,
      labels,
      showFlyout,
      imageUrl,
      imageFilename
    } = this.state
    const className = markedForRemoval ? 'remove-beer' : ''
    const {
      menuItemLabels,
      connectDragSource,
      connectDropTarget,
      isDragging,
      isActive,
      index
    } = this.props

    const style = {
      opacity: isDragging ? 0 : 1,
      cursor: 'move'
    }

    return connectDragSource(connectDropTarget(
      <div data-test='beer-input' className={`list-item-input ${className}`} style={style}>
        <div className='drag-handle'>
          <span className='fas fa-bars' />
        </div>
        <div className='item-input-wrap'>
          <div className='form-row'>
            <ListItemNameInput
              appId={appId}
              value={name}
              className={className}
              focus={isActive}
            />
            <ToggleFlyoutButton
              flyoutShown={showFlyout}
              onClick={this.toggleFlyout}
            />
            <ListItemAction
              appId={appId}
              markedForRemoval={markedForRemoval}
              onKeep={this.onKeep}
              onRemove={this.onRemove}
            />
          </div>
          <Flyout show={showFlyout}>
            <ListItemImageInput
              appId={appId}
              filename={imageFilename}
              url={imageUrl}
              className='col-sm-3 col-xs-8'
            />
            <div className='col-sm-6'>
              <div className='row'>
                <ListItemDescriptionInput appId={appId} value={description} className='col' />
              </div>
              <div className='row'>
                <PriceOptions options={priceOptions} className='col-sm-10 menu-item-price-options' appId={appId} theLegacyPrice={price} />
              </div>
            </div>
            <div className='col'>
              <ListItemLabelsInput
                appId={appId}
                menuItemLabels={menuItemLabels}
                appliedLabels={labels}
                className=''
              />
            </div>
          </Flyout>
          <div className='form-row'>
            <div className='col-sm-10 col-xs-12 beer-separator' />
          </div>
          <input
            type='hidden'
            defaultValue={this.state.id}
            name={`list[beers_attributes][${appId}][id]`}
            id={`list_beers_attributes_${appId}_id`}
          />
          <input
            type='hidden'
            defaultValue={index}
            name={`list[beers_attributes][${appId}[position]`}
          />
          <input
            type='hidden'
            data-test='marked-for-removal'
            defaultValue={markedForRemoval}
            name={`list[beers_attributes][${appId}][_destroy]`}
          />
        </div>
      </div>
    ))
  }
}

ListItemInputGroup.propTypes = {
  beer: PropTypes.object.isRequired,
  index: PropTypes.number.isRequired,
  menuItemLabels: PropTypes.array.isRequired,
  deleteBeer: PropTypes.func.isRequired,
  connectDragSource: PropTypes.func.isRequired,
  isDragging: PropTypes.bool.isRequired,
  moveItem: PropTypes.func.isRequired,
  isActive: PropTypes.bool
}

const dropTarget = DropTarget(
  itemTypes.listItem,
  itemTarget,
  dropCollect
)(ListItemInputGroup)

export default DragSource(
  itemTypes.listItem,
  itemSource,
  dragCollect
)(dropTarget)
