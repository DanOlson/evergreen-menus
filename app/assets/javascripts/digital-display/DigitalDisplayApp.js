import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Panel from '../shared/Panel'
import AvailableListGroup from '../shared/AvailableListGroup'
import ChosenListGroup from '../shared/ChosenListGroup'
import DigitalDisplayPreview from './DigitalDisplayPreview'
import generatePreviewPath from './previewPath'
import { applyFind } from '../polyfills/Array'
import { DragDropContext } from 'react-dnd'
import HTML5Backend from 'react-dnd-html5-backend'
import ColorPickerInput from '../shared/ColorPickerInput'
import ThemeSelect from './ThemeSelect'
import FontSelect from './FontSelect'
import RotationIntervalSelect from './RotationIntervalSelect'
import OrientationInput from './OrientationInput'
import Buttons from '../shared/MenuFormButtons'

applyFind()

class DigitalDisplayApp extends Component {
  constructor (props) {
    super(props)
    const {
      lists,
      listsAvailable,
      name,
      rotationInterval,
      isHorizontal,
      backgroundColor,
      textColor,
      listTitleColor,
      font,
      theme
    } = props.digitalDisplayMenu

    this.handleNameChange = this.handleNameChange.bind(this)
    this.handleFontChange = this.handleFontChange.bind(this)
    this.handleThemeChange = this.handleThemeChange.bind(this)
    this.handleBackgroundColorChange = this.handleBackgroundColorChange.bind(this)
    this.handleTextColorChange = this.handleTextColorChange.bind(this)
    this.handleListTitleColorChange = this.handleListTitleColorChange.bind(this)
    this.handleOrientationChange = this.handleOrientationChange.bind(this)
    this.handleRotationIntervalChange = this.handleRotationIntervalChange.bind(this)
    this.addListToDisplay = this.addListToDisplay.bind(this)
    this.removeListFromDisplay = this.removeListFromDisplay.bind(this)
    this.handleShowPriceChange = this.handleShowPriceChange.bind(this)
    this.handleDisplayNameChange = this.handleDisplayNameChange.bind(this)
    this.moveChosenList = this.moveChosenList.bind(this)

    this.state = {
      lists,
      listsAvailable,
      name,
      isHorizontal,
      rotationInterval,
      backgroundColor,
      textColor,
      listTitleColor,
      font,
      theme
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

  addListToDisplay (listId) {
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

  removeListFromDisplay (listId) {
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

  handleFontChange (chosenFont) {
    const font = chosenFont.value
    this.setState(prevState => {
      return { font }
    })
  }

  handleThemeChange (theme) {
    const newState = { theme: theme.name };
    [
      'font',
      'backgroundColor',
      'textColor',
      'listTitleColor'
    ].forEach(attr => {
      if (theme[attr]) {
        newState[attr] = theme[attr]
      }
    })
    this.setState(prevState => newState)
  }

  handleOrientationChange (orientation) {
    const isHorizontal = orientation === 'horizontal'
    this.setState(prevState => {
      return { isHorizontal }
    })
  }

  handleBackgroundColorChange (color) {
    const backgroundColor = color.hex
    this.setState(prevState => {
      return { backgroundColor }
    })
  }

  handleTextColorChange (color) {
    const textColor = color.hex
    this.setState(prevState => {
      return { textColor }
    })
  }

  handleListTitleColorChange (color) {
    const listTitleColor = color.hex
    this.setState(prevState => {
      return { listTitleColor }
    })
  }

  handleRotationIntervalChange (chosenInterval) {
    const rotationInterval = chosenInterval.value
    this.setState(prevState => {
      return { rotationInterval }
    })
  }

  handleShowPriceChange (listId, showPrice) {
    this.setState(prevState => {
      const { lists } = prevState
      const list = lists.find(list => list.id === listId)
      list.show_price_on_menu = showPrice
      return { lists }
    })
  }

  handleDisplayNameChange (listId, displayName) {
    this.setState(prevState => {
      const { lists } = prevState
      const list = lists.find(list => list.id === listId)
      list.displayName = displayName
      return { lists }
    })
  }

  render () {
    const {
      lists,
      listsAvailable,
      name,
      isHorizontal,
      rotationInterval,
      backgroundColor,
      textColor,
      listTitleColor,
      font,
      theme
    } = this.state
    const showCustomThemeFields = theme === 'Custom'
    const customThemeFieldClass = showCustomThemeFields ? 'visible' : 'invisible'
    const totalListCount = lists.length + listsAvailable.length
    const previewPath = generatePreviewPath(this.props.digitalDisplayMenu, this.state)
    let viewDisplayButton
    if (this.props.viewDisplayPath) {
      viewDisplayButton = (
        <a href={this.props.viewDisplayPath}
          target='_blank'
          className='btn btn-success pull-right'
          data-test='view-digital-display-menu'>View</a>
      )
    }

    return (
      <div className='form-row'>
        <div className='col-sm-6'>
          <Panel title={name} icon='fas fa-tv'>
            <div className='form-group'>
              <label htmlFor='digital_display_menu_name'>Name</label>
              <input
                id='digital_display_menu_name'
                name='digital_display_menu[name]'
                className='form-control'
                data-test='digital-display-menu-name'
                type='text'
                defaultValue={name}
                onChange={this.handleNameChange}
              />
            </div>

            <OrientationInput
              className='form-group'
              onChange={this.handleOrientationChange}
              isHorizontal={isHorizontal}
            />

            <div className='form-row'>
              <ThemeSelect
                className='form-group col-sm-4'
                onChange={this.handleThemeChange}
                options={this.props.themeOptions}
                value={theme}
              />

              <RotationIntervalSelect
                className='form-group col-sm-4'
                onChange={this.handleRotationIntervalChange}
                options={this.props.rotationIntervalOptions}
                value={rotationInterval}
              />

              <FontSelect
                className={`form-group col-sm-4 ${customThemeFieldClass}`}
                onChange={this.handleFontChange}
                options={this.props.fontOptions}
                value={font}
              />
            </div>

            <div className={`form-row ${customThemeFieldClass}`}>
              <ColorPickerInput
                id='digital_display_menu_background_color'
                name='digital_display_menu[background_color]'
                className='form-group col-sm-4'
                dataTest='digital-display-menu-background-color'
                label='Background Color'
                onChangeComplete={this.handleBackgroundColorChange}
                color={backgroundColor}
              />

              <ColorPickerInput
                id='digital_display_menu_text_color'
                name='digital_display_menu[text_color]'
                className='form-group col-sm-4'
                dataTest='digital-display-menu-text-color'
                label='Text Color'
                onChangeComplete={this.handleTextColorChange}
                color={textColor}
              />

              <ColorPickerInput
                id='digital_display_menu_list_title_color'
                name='digital_display_menu[list_title_color]'
                className='form-group col-sm-4'
                dataTest='digital-display-menu-list-title-color'
                label='List Title Color'
                onChangeComplete={this.handleListTitleColorChange}
                color={listTitleColor}
              />
            </div>

            <AvailableListGroup
              totalListCount={totalListCount}
              lists={listsAvailable}
              menuType='digitalDisplay'
              onAdd={this.addListToDisplay}
              onDrop={this.removeListFromDisplay}
            />
            <ChosenListGroup
              lists={lists}
              menuType='digitalDisplay'
              onRemove={this.removeListFromDisplay}
              onShowPriceChange={this.handleShowPriceChange}
              onDisplayNameChange={this.handleDisplayNameChange}
              moveItem={this.moveChosenList}
              onDrop={this.addListToDisplay}
            />

            <Buttons {...this.props} menuType='digital-display-menu'>
              {viewDisplayButton}
            </Buttons>
          </Panel>
        </div>
        <div className='col-sm-6'>
          <DigitalDisplayPreview {...{ previewPath, isHorizontal }} />
        </div>
      </div>
    )
  }
}

DigitalDisplayApp.propTypes = {
  digitalDisplayMenu: PropTypes.object.isRequired,
  rotationIntervalOptions: PropTypes.array,
  fontOptions: PropTypes.array,
  themeOptions: PropTypes.array
}

export default DragDropContext(HTML5Backend)(DigitalDisplayApp)
