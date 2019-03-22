import React, { Component } from 'react'
import PropTypes from 'prop-types'
import RemoveButton from './RemoveButton'
import { findDOMNode } from 'react-dom'
import itemTypes from './item-types'
import { DragSource, DropTarget } from 'react-dnd'
import pluralize from './pluralize'
import ListTypeIcon from './ListTypeIcon'
import ShowPriceInput from './ShowPriceInput'
import ShowDescriptionInput from './ShowDescriptionInput'
import ShowNotesInput from './ShowNotesInput'
import ListItemImageChoices from './ListItemImageChoices'
import constants from './constants'

const itemSource = {
  beginDrag (props) {
    return {
      id: props.list.id,
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

class ChosenListItem extends Component {
  constructor (props) {
    super(props)
    this.onShowPriceChange = this.onShowPriceChange.bind(this)
    this.onShowDescriptionChange = this.onShowDescriptionChange.bind(this)
    this.onShowNotesChange = this.onShowNotesChange.bind(this)
    this.onDisplayNameChange = this.onDisplayNameChange.bind(this)
    this.onHtmlClassesChange = this.onHtmlClassesChange.bind(this)
    this.onImagesListChange = this.onImagesListChange.bind(this)
    this.toggleImages = this.toggleImages.bind(this)
    this.toggleSettings = this.toggleSettings.bind(this)
    this.onClick = this.onClick.bind(this)
    this.state = {
      showImages: false,
      showSettings: false
    }
  }

  onShowPriceChange (event) {
    const { list, onShowPriceChange } = this.props
    onShowPriceChange(list.id, event.target.checked)
  }

  onShowDescriptionChange (event) {
    const { list, onShowDescriptionChange } = this.props
    onShowDescriptionChange(list.id, event.target.checked)
  }

  onShowNotesChange (event) {
    const { list, onShowNotesChange } = this.props
    onShowNotesChange(list.id, event.target.checked)
  }

  onDisplayNameChange (event) {
    const { list, onDisplayNameChange } = this.props
    onDisplayNameChange(list.id, event.target.value)
  }

  onHtmlClassesChange (event) {
    const { list, onHtmlClassesChange } = this.props
    onHtmlClassesChange(list.id, event.target.value)
  }

  onImagesListChange (itemIds) {
    const { list, onImagesListChange } = this.props
    onImagesListChange(list.id, itemIds)
  }

  toggleImages () {
    this.setState(prevState => {
      return { showImages: !prevState.showImages }
    })
  }

  toggleSettings () {
    this.setState(prevState => {
      return { showSettings: !prevState.showSettings }
    })
  }

  onClick (event) {
    if (!confirm(constants.CONFIRM_TEXT)) {
      event.preventDefault()
    }
  }

  itemsWithImages () {
    const { list } = this.props
    if (!list.beers) return []
    return list.beers.filter(item => !!item.imageUrl)
  }

  render () {
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
    } = this.props

    let showDescriptionInput, showNotesInput, htmlClassesInput

    if (this.props.onShowDescriptionChange) {
      showDescriptionInput = (
        <ShowDescriptionInput
          entityName={entityName}
          nestedAttrsName={nestedAttrsName}
          index={index}
          onChange={this.onShowDescriptionChange}
          value={list.show_description_on_menu}
        />
      )
    }

    if (this.props.onShowNotesChange) {
      showNotesInput = (
        <ShowNotesInput
          entityName={entityName}
          nestedAttrsName={nestedAttrsName}
          index={index}
          onChange={this.onShowNotesChange}
          value={list.show_notes_on_menu}
        />
      )
    }

    if (this.props.onHtmlClassesChange) {
      htmlClassesInput = (
        <div className='form-group'>
          <label htmlFor={`list-html-classes-${index}`}>HTML classes</label>
          <input
            id={`list-html-classes-${index}`}
            type='text'
            name={`${entityName}[${nestedAttrsName}][${index}][html_classes]`}
            className='form-control'
            aria-describedby={`html-classes-help-${index}`}
            defaultValue={list.htmlClasses}
            onBlur={this.onHtmlClassesChange}
            data-test='html-classes-input'
          />
          <small id={`html-classes-help-${index}`} className='form-text text-muted'>
            HTML classes to help your designer style this list on your site
          </small>
        </div>
      )
    }

    let imageIcon = (
      <span className='hidden-image-toggle-wrapper ml-2'>
        <i className='far fa-image fa-lg' />
      </span>
    )

    if (this.itemsWithImages().length) {
      let wrapperClass
      const isActive = this.state.showImages
      if (isActive) {
        wrapperClass = 'icon-images-shown'
      }
      imageIcon = (
        <span className={wrapperClass}>
          <i
            className='far fa-image fa-lg image-toggle ml-2'
            title='Show Image Options'
            role='button'
            aria-pressed={isActive}
            onClick={this.toggleImages}
            data-test='image-toggle' />
        </span>
      )
    }
    const settingsCog = (
      <span className={`toggle-settings toggle-settings-${this.state.showSettings ? 'shown' : 'hidden'}`}>
        <i
          className='fas fa-cog settings-toggle'
          title='Show Settings'
          role='button'
          aria-pressed={this.state.showSettings}
          onClick={this.toggleSettings}
          data-test='settings-toggle' />
      </span>
    )

    const badgeContent = `${list.itemCount} ${pluralize('item', list.itemCount)}`

    const style = {
      opacity: isDragging ? 0 : 1,
      cursor: 'move'
    }
    return connectDragSource(connectDropTarget(
      <li className='list-group-item list-group-item-action' data-test='menu-list' style={style}>
        <div className='valign-wrapper-w10'>
          <RemoveButton onClick={onRemove} listId={list.id} />
        </div>
        <div className='valign-wrapper-w50'>
          <a
            href={list.href}
            onClick={this.onClick}
            className='list-name'
            data-test='list-name'>
            {list.name}
          </a>
        </div>
        <div className='valign-wrapper-w40'>
          {imageIcon}
          {settingsCog}
          <ListTypeIcon listType={list.type} />
          <span
            data-test='list-badge'
            className='badge badge-pill badge-success float-right mr-2'
          >{badgeContent}</span>
        </div>
        <div className={`settings ${this.state.showSettings ? 'show' : 'hidden'}`} data-test='list-item-settings'>
          <ShowPriceInput
            entityName={entityName}
            nestedAttrsName={nestedAttrsName}
            index={index}
            onChange={this.onShowPriceChange}
            value={list.show_price_on_menu}
          />
          {showDescriptionInput}
          {showNotesInput}
          <div className='form-group'>
            <label htmlFor={`list-display-name-${index}`}>Display Name</label>
            <input
              id={`list-display-name-${index}`}
              type='text'
              name={`${entityName}[${nestedAttrsName}][${index}][display_name]`}
              className='form-control'
              aria-describedby={`display-name-help-${index}`}
              defaultValue={list.displayName}
              onBlur={this.onDisplayNameChange}
              data-test='display-name-input'
            />
            <small id={`display-name-help-${index}`} className='form-text text-muted'>
              Customize your list's name for just this menu
            </small>
          </div>
          {htmlClassesInput}
        </div>
        <ListItemImageChoices
          itemsWithAvailableImages={this.itemsWithImages()}
          chosenItemIds={list.items_with_images}
          entityName={entityName}
          nestedAttrsName={nestedAttrsName}
          index={index}
          show={this.state.showImages}
          onChange={this.onImagesListChange}
        />
        <input
          type='hidden'
          name={`${entityName}[${nestedAttrsName}][${index}][id]`}
          value={list[nestedEntityIdName]}
        />
        <input
          type='hidden'
          name={`${entityName}[${nestedAttrsName}][${index}][list_id]`}
          value={list.id}
        />
        <input
          type='hidden'
          name={`${entityName}[${nestedAttrsName}][${index}][position]`}
          value={index}
        />
      </li>
    ))
  }
}

ChosenListItem.defaultProps = {
  onImagesListChange: () => {}
}

ChosenListItem.propTypes = {
  list: PropTypes.object.isRequired,
  index: PropTypes.number.isRequired,
  onRemove: PropTypes.func.isRequired,
  onShowPriceChange: PropTypes.func.isRequired,
  onShowDescriptionChange: PropTypes.func,
  onShowNotesChange: PropTypes.func,
  onDisplayNameChange: PropTypes.func,
  onHtmlClassesChange: PropTypes.func,
  onImagesListChange: PropTypes.func,
  nestedAttrsName: PropTypes.string.isRequired,
  entityName: PropTypes.string.isRequired,
  nestedEntityIdName: PropTypes.string.isRequired,
  connectDragSource: PropTypes.func.isRequired,
  isDragging: PropTypes.bool.isRequired,
  moveItem: PropTypes.func.isRequired
}

const dropTarget = DropTarget(
  itemTypes.chosenListItem,
  itemTarget,
  dropCollect
)(ChosenListItem)

export default DragSource(
  itemTypes.chosenListItem,
  itemSource,
  dragCollect
)(dropTarget)
