import React, { Component } from 'react'
import PropTypes from 'prop-types'
import ColumnsInput from './ColumnsInput'
import ShowLogoInput from './ShowLogoInput'
import AvailabilityInput from '../shared/AvailabilityInput'
import AvailableListGroup from '../shared/AvailableListGroup'
import ChosenListGroup from '../shared/ChosenListGroup'
import Preview from './MenuPreview'
import Panel from '../shared/Panel'
import generatePreviewPath from './previewPath'
import Buttons from '../shared/MenuFormButtons'
import { applyFind, applyIncludes } from '../polyfills/Array'
import { DragDropContext } from 'react-dnd'
import HTML5Backend from 'react-dnd-html5-backend'

applyFind()
applyIncludes()

class MenuApp extends Component {
  constructor (props) {
    super(props)
    const { menu } = this.props
    const {
      lists,
      listsAvailable,
      name,
      font,
      fontSize,
      numberOfColumns,
      template,
      availabilityStartTime,
      availabilityEndTime,
      restrictedAvailability,
      showLogo
    } = menu

    this.handleMenuNameChange = this.handleMenuNameChange.bind(this)
    this.handleTemplateChange = this.handleTemplateChange.bind(this)
    this.handleFontChange = this.handleFontChange.bind(this)
    this.handleFontSizeChange = this.handleFontSizeChange.bind(this)
    this.handleColumnsChange = this.handleColumnsChange.bind(this)
    this.handleStartTimeChange = this.handleStartTimeChange.bind(this)
    this.handleEndTimeChange = this.handleEndTimeChange.bind(this)
    this.handleRestrictedAvailChange = this.handleRestrictedAvailChange.bind(this)
    this.handleShowLogoChange = this.handleShowLogoChange.bind(this)
    this.addListToMenu = this.addListToMenu.bind(this)
    this.removeListFromMenu = this.removeListFromMenu.bind(this)
    this.onShowPriceChange = this.onShowPriceChange.bind(this)
    this.onImagesListChange = this.onImagesListChange.bind(this)
    this.moveChosenList = this.moveChosenList.bind(this)

    this.state = {
      lists,
      listsAvailable,
      name,
      template,
      font,
      fontSize,
      numberOfColumns,
      availabilityStartTime,
      availabilityEndTime,
      restrictedAvailability,
      showLogo
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

  handleMenuNameChange (event) {
    const name = event.target.value
    this.setState(prevState => {
      return { name }
    })
  }

  handleTemplateChange (event) {
    const template = event.target.value
    this.setState(prevState => {
      return { template }
    })
  }

  handleFontChange (event) {
    const font = event.target.value
    this.setState(prevState => {
      return { font }
    })
  }

  handleFontSizeChange (event) {
    let fontSize = event.target.value
    if (parseInt(fontSize, 10) > 20) {
      fontSize = 20
    } else if (parseInt(fontSize, 10) < 4) {
      fontSize = 4
    }
    this.setState(prevState => {
      return { fontSize }
    })
  }

  handleColumnsChange (event) {
    let numberOfColumns = Number(event.target.value)
    this.setState(prevState => {
      return { numberOfColumns }
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

  onImagesListChange (listId, itemIds) {
    this.setState(prevState => {
      const { lists } = prevState
      const list = lists.find(list => list.id === listId)
      list.items_with_images = itemIds
      return { lists }
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
    this.setState(prevState => {
      return { restrictedAvailability: checked }
    })
  }

  handleShowLogoChange (event) {
    const { checked } = event.target
    this.setState(prevState => {
      return { showLogo: checked }
    })
  }

  renderOptions (choices) {
    return choices.map((option, index) => {
      return <option value={option} key={index}>{option}</option>
    })
  }

  render () {
    const {
      lists,
      listsAvailable,
      font,
      fontSize,
      numberOfColumns,
      name,
      template,
      availabilityStartTime,
      availabilityEndTime,
      restrictedAvailability,
      showLogo
    } = this.state
    const {
      fontOptions,
      templateOptions,
      downloadMenuPath,
      canDestroyMenu,
      menuFormSubmitText,
      cancelEditMenuPath,
      menu
    } = this.props
    const fontOpts = this.renderOptions(fontOptions)
    const templateOpts = this.renderOptions(templateOptions)
    const totalListCount = lists.length + listsAvailable.length
    const previewPath = generatePreviewPath(this.props.menu, this.state)
    const columnsDisabled = template === 'Centered'
    let downloadButton
    if (downloadMenuPath) {
      downloadButton = (
        <a href={downloadMenuPath}
          className='btn btn-success pull-right'
          data-test='menu-download-button'>Download</a>
      )
    }
    return (
      <div className='form-row'>
        <div className='col-sm-6'>
          <Panel title={name} icon="fa-file-pdf-o">
            <div className='form-group'>
              <div className='form-row'>
                <div className='col-sm-8'>
                  <label htmlFor='menu_name'>Name</label>
                  <input
                    id='menu_name'
                    name='menu[name]'
                    className='form-control'
                    data-test='menu-name'
                    type='text'
                    defaultValue={name}
                    onChange={this.handleMenuNameChange}
                  />
                </div>

                <div className='col-sm-4'>
                  <label htmlFor='menu_template'>Template</label>
                  <select
                    id='menu_template'
                    data-test='menu-template'
                    name='menu[template]'
                    className='form-control'
                    defaultValue={template}
                    onChange={this.handleTemplateChange}>
                    {templateOpts}
                  </select>
                </div>
              </div>
            </div>

            <div className='form-group'>
              <div className='form-row'>
                <ShowLogoInput
                  hasLogo={menu.hasLogo}
                  checked={showLogo}
                  onChange={this.handleShowLogoChange}
                />

                <div className='col-sm-4'>
                  <label htmlFor='menu_font'>Font</label>
                  <select
                    id='menu_font'
                    data-test='menu-font'
                    name='menu[font]'
                    className='form-control'
                    defaultValue={font}
                    onChange={this.handleFontChange}>
                    {fontOpts}
                  </select>
                </div>

                <div className='col'>
                  <label htmlFor='menu_font_size'>Font Size</label>
                  <input
                    id='menu_font_size'
                    data-test='menu-font-size'
                    name='menu[font_size]'
                    className='form-control'
                    type='number'
                    min='4'
                    max='20'
                    defaultValue={fontSize}
                    onChange={this.handleFontSizeChange}
                  />
                </div>

                <ColumnsInput
                  className='col menu-columns-input'
                  onChange={this.handleColumnsChange}
                  columns={numberOfColumns}
                  disabled={columnsDisabled}
                />
              </div>
            </div>

            <div className='form-group form-row'>
              <div className='col-sm-3'>
                <input
                  type='hidden'
                  name='menu[restricted_availability]'
                  value='0'
                />
                <label htmlFor='menu-restricted-availability'>
                  <span>Restrict <span className='fa fa-clock-o fa-lg' aria-hidden='true' /></span>
                </label>
                <input
                  type='checkbox'
                  name='menu[restricted_availability]'
                  data-test='menu-restricted-availability'
                  id='menu-restricted-availability'
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
                name='menu[availability_start_time]'
                labelText='Availability Start'
              />

              <AvailabilityInput
                show={restrictedAvailability}
                time={availabilityEndTime}
                onChange={this.handleEndTimeChange}
                className='col-sm-4'
                name='menu[availability_end_time]'
                labelText='Availability End'
              />
            </div>

            <AvailableListGroup
              totalListCount={totalListCount}
              lists={listsAvailable}
              menuType='pdf'
              onAdd={this.addListToMenu}
              onDrop={this.removeListFromMenu}
            />
            <ChosenListGroup
              lists={lists}
              menuType='pdf'
              onRemove={this.removeListFromMenu}
              onShowPriceChange={this.onShowPriceChange}
              onImagesListChange={this.onImagesListChange}
              moveItem={this.moveChosenList}
              onDrop={this.addListToMenu}
            />

            <Buttons
              menuType='menu'
              canDestroy={!!canDestroyMenu}
              submitButtonText={menuFormSubmitText}
              cancelEditPath={cancelEditMenuPath}>
              {downloadButton}
            </Buttons>
          </Panel>
        </div>
        <div className='col-sm-6'>
          <Preview previewPath={previewPath} />
        </div>
      </div>
    )
  }
}

MenuApp.propTypes = {
  menu: PropTypes.object.isRequired,
  cancelEditMenuPath: PropTypes.string.isRequired,
  downloadMenuPath: PropTypes.string,
  menuFormSubmitText: PropTypes.string.isRequired,
  canDestroyMenu: PropTypes.bool,
  fontOptions: PropTypes.array.isRequired,
  templateOptions: PropTypes.array.isRequired
}

export default DragDropContext(HTML5Backend)(MenuApp)
