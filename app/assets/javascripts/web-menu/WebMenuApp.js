import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Panel from '../shared/Panel'
import Buttons from '../shared/MenuFormButtons'
import EmbedCodeOptions from './EmbedCodeOptions'
import ShowCodeButton from './ShowCodeButton'
import AvailableListGroup from '../shared/AvailableListGroup'
import AvailabilityInput from '../shared/AvailabilityInput'
import ChosenListGroup from '../shared/ChosenListGroup'
import Preview from './Preview'
import generatePreviewPath from './previewPath'
import { applyFind, applyIncludes } from '../polyfills/Array'
import { DragDropContext } from 'react-dnd'
import HTML5Backend from 'react-dnd-html5-backend'

applyFind()
applyIncludes()

class WebMenuApp extends Component {
  constructor (props) {
    super(props)

    const {
      name,
      availabilityStartTime,
      availabilityEndTime,
      restrictedAvailability,
      lists,
      listsAvailable
    } = props.webMenu

    this.handleNameChange = this.handleNameChange.bind(this)
    this.handleStartTimeChange = this.handleStartTimeChange.bind(this)
    this.handleEndTimeChange = this.handleEndTimeChange.bind(this)
    this.handleRestrictedAvailChange = this.handleRestrictedAvailChange.bind(this)
    this.addListToMenu = this.addListToMenu.bind(this)
    this.removeListFromMenu = this.removeListFromMenu.bind(this)
    this.onShowPriceChange = this.onShowPriceChange.bind(this)
    this.onShowDescriptionChange = this.onShowDescriptionChange.bind(this)
    this.onShowNotesChange = this.onShowNotesChange.bind(this)
    this.onDisplayNameChange = this.onDisplayNameChange.bind(this)
    this.onHtmlClassesChange = this.onHtmlClassesChange.bind(this)
    this.onImagesListChange = this.onImagesListChange.bind(this)
    this.moveChosenList = this.moveChosenList.bind(this)
    this.toggleCodeVisibility = this.toggleCodeVisibility.bind(this)

    this.state = {
      name,
      lists,
      listsAvailable,
      availabilityStartTime,
      availabilityEndTime,
      restrictedAvailability,
      showEmbedCode: false
    }
  }

  moveChosenList (dragIndex, hoverIndex) {
    this.setState(prevState => {
      const { lists } = prevState
      const dragList = lists[dragIndex]
      const newLists = [...lists]
      newLists.splice(dragIndex, 1)
      newLists.splice(hoverIndex, 0, dragList)
      return { lists: newLists }
    })
  }

  addListToMenu (listId) {
    this.setState(prevState => {
      const { lists, listsAvailable } = prevState
      const listToAdd = listsAvailable.find(list => list.id === listId)
      const newLists = [...lists, listToAdd]
      return {
        listsAvailable: listsAvailable.filter(list => list.id !== listId),
        lists: newLists
      }
    })
  }

  removeListFromMenu (listId) {
    this.setState(prevState => {
      const { lists, listsAvailable } = prevState
      const listToRemove = lists.find(list => list.id === listId)
      const newLists = lists.filter(list => list.id !== listId)
      return {
        listsAvailable: [...listsAvailable, listToRemove],
        lists: newLists
      }
    })
  }

  handleNameChange (event) {
    const name = event.target.value
    this.setState(prevState => {
      return { name }
    })
  }

  handleStartTimeChange (newStartTime) {
    this.setState(prevState => {
      return { availabilityStartTime: newStartTime }
    })
  }

  handleEndTimeChange (newEndTime) {
    this.setState(prevState => {
      return { availabilityEndTime: newEndTime }
    })
  }

  handleRestrictedAvailChange (event) {
    const { checked } = event.target
    this.setState(() => {
      return { restrictedAvailability: checked }
    })
  }

  onShowPriceChange (listId, showPrice) {
    this.setState(prevState => {
      const { lists } = prevState
      const list = lists.find(list => list.id === listId)
      list.show_price_on_menu = showPrice
      return { lists }
    })
  }

  onShowDescriptionChange (listId, showDesc) {
    this.setState(prevState => {
      const { lists } = prevState
      const list = lists.find(list => list.id === listId)
      list.show_description_on_menu = showDesc
      return { lists }
    })
  }

  onShowNotesChange (listId, showNotes) {
    this.setState(prevState => {
      const { lists } = prevState
      const list = lists.find(list => list.id === listId)
      list.show_notes_on_menu = showNotes
      return { lists }
    })
  }

  onDisplayNameChange (listId, displayName) {
    this.setState(prevState => {
      const { lists } = prevState
      const list = lists.find(list => list.id === listId)
      list.displayName = displayName
      return { lists }
    })
  }

  onHtmlClassesChange (listId, htmlClasses) {
    this.setState(prevState => {
      const { lists } = prevState
      const list = lists.find(list => list.id === listId)
      list.htmlClasses = htmlClasses
      return { lists }
    })
  }

  onImagesListChange (listId, itemIds) {
    this.setState(prevState => {
      const { lists } = prevState
      const list = lists.find(list => list.id === listId)
      list.items_with_images = itemIds
      return { lists }
    })
  }

  toggleCodeVisibility () {
    this.setState(prevState => {
      return {
        showEmbedCode: !prevState.showEmbedCode
      }
    })
  }

  render () {
    const {
      lists,
      listsAvailable,
      name,
      showEmbedCode,
      availabilityStartTime,
      availabilityEndTime,
      restrictedAvailability
    } = this.state
    const previewPath = generatePreviewPath(this.props.webMenu, this.state)
    const totalListCount = lists.length + listsAvailable.length
    const { embedCode, ampEmbedCode, ampHeadEmbedCode } = this.props.webMenu
    const toggleCodeButtonClass = embedCode ? (showEmbedCode ? 'active' : '') : 'hidden'

    return (
      <div className='form-row'>
        <div className='col-sm-6'>
          <Panel title={name} icon='fas fa-code'>
            <div className='form-group'>
              <label htmlFor='menu_name'>Name</label>
              <input
                id='web_menu_name'
                name='web_menu[name]'
                className='form-control'
                data-test='web-menu-name'
                type='text'
                defaultValue={name}
                onChange={this.handleNameChange}
              />
            </div>

            <div className='form-group form-row'>
              <div className='col-sm-3'>
                <input
                  type='hidden'
                  name='web_menu[restricted_availability]'
                  value='0'
                />
                <label htmlFor='web-menu-restricted-availability'>
                  <span>Restrict <span className='far fa-clock fa-lg' aria-hidden='true' /></span>
                </label>
                <input
                  type='checkbox'
                  name='web_menu[restricted_availability]'
                  data-test='menu-restricted-availability'
                  id='web-menu-restricted-availability'
                  className='d-block'
                  value='1'
                  defaultChecked={restrictedAvailability ? 'checked' : undefined}
                  onChange={this.handleRestrictedAvailChange}
                />
              </div>

              <AvailabilityInput
                show={restrictedAvailability}
                time={availabilityStartTime}
                onChange={this.handleStartTimeChange}
                className='col-sm-4'
                name='web_menu[availability_start_time]'
                labelText='Availability Start'
              />

              <AvailabilityInput
                show={restrictedAvailability}
                time={availabilityEndTime}
                onChange={this.handleEndTimeChange}
                className='col-sm-4'
                name='web_menu[availability_end_time]'
                labelText='Availability End'
              />
            </div>

            <AvailableListGroup
              totalListCount={totalListCount}
              lists={listsAvailable}
              menuType='web'
              onAdd={this.addListToMenu}
              onDrop={this.removeListFromMenu}
            />
            <ChosenListGroup
              lists={lists}
              menuType='web'
              onRemove={this.removeListFromMenu}
              onShowPriceChange={this.onShowPriceChange}
              onShowDescriptionChange={this.onShowDescriptionChange}
              onShowNotesChange={this.onShowNotesChange}
              onImagesListChange={this.onImagesListChange}
              onDisplayNameChange={this.onDisplayNameChange}
              onHtmlClassesChange={this.onHtmlClassesChange}
              moveItem={this.moveChosenList}
              onDrop={this.addListToMenu}
            />

            <Buttons {...this.props} menuType='web-menu'>
              <ShowCodeButton
                onClick={this.toggleCodeVisibility}
                buttonClass={toggleCodeButtonClass}>
                Embed Code
              </ShowCodeButton>
            </Buttons>

            <EmbedCodeOptions
              canonicalCode={embedCode}
              ampBodyCode={ampEmbedCode}
              ampHeadCode={ampHeadEmbedCode}
              show={showEmbedCode}
            />
          </Panel>
        </div>
        <div className='col-sm-6'>
          <Preview previewPath={previewPath} />
        </div>
      </div>
    )
  }
}

WebMenuApp.defaultProps = {
  canDestroy: false
}

WebMenuApp.propTypes = {
  webMenu: PropTypes.object.isRequired,
  cancelEditPath: PropTypes.string.isRequired,
  submitButtonText: PropTypes.string.isRequired,
  canDestroy: PropTypes.bool
}

export default DragDropContext(HTML5Backend)(WebMenuApp)
