import React, { Component } from 'react';
import PropTypes from 'prop-types';
import update from 'react/lib/update';
import Panel from '../Panel';
import AvailableListGroup from '../shared/AvailableListGroup';
import ChosenListGroup from '../shared/ChosenListGroup';
import DigitalDisplayPreview from './DigitalDisplayPreview';
import generatePreviewPath from './previewPath';
import { applyFind } from '../polyfills/Array';
import { DragDropContext } from 'react-dnd';
import HTML5Backend from 'react-dnd-html5-backend';
import { ChromePicker } from 'react-color';

applyFind();

class DigitalDisplayApp extends Component {
  constructor(props) {
    super(props);
    const {
      lists,
      listsAvailable,
      name,
      rotationInterval,
      isHorizontal,
      backgroundColor,
      textColor
    } = this.props.digitalDisplayMenu;

    this.handleNameChange             = this.handleNameChange.bind(this);
    this.handleBackgroundColorChange  = this.handleBackgroundColorChange.bind(this);
    this.handleTextColorChange        = this.handleTextColorChange.bind(this);
    this.setOrientationHorizontal     = this.setOrientationHorizontal.bind(this);
    this.setOrientationVertical       = this.setOrientationVertical.bind(this);
    this.handleRotationIntervalChange = this.handleRotationIntervalChange.bind(this);
    this.addListToDisplay             = this.addListToDisplay.bind(this);
    this.removeListFromDisplay        = this.removeListFromDisplay.bind(this);
    this.onShowPriceChange            = this.onShowPriceChange.bind(this);
    this.moveChosenList               = this.moveChosenList.bind(this);

    this.state = {
      lists,
      listsAvailable,
      name,
      isHorizontal,
      rotationInterval,
      backgroundColor,
      textColor
    };
  }

  addListToDisplay(listId) {
    this.setState(prevState => {
      const { lists, listsAvailable } = prevState;
      const listToAdd = listsAvailable.find(list => list.id === listId);
      const newLists = [...lists, listToAdd];
      return {
        listsAvailable: listsAvailable.filter(list => list.id !== listId),
        lists: newLists
      }
    });
  }

  moveChosenList(dragIndex, hoverIndex) {
    this.setState(prevState => {
      const { lists } = prevState;
      const dragList = lists[dragIndex];
      const newLists = [...lists];
      newLists.splice(dragIndex, 1);
      newLists.splice(hoverIndex, 0, dragList);
      return { lists: newLists };
    });
  }

  removeListFromDisplay(listId) {
    this.setState(prevState => {
      const { lists, listsAvailable } = prevState;
      const listToRemove = lists.find(list => list.id === listId);
      const newLists = lists.filter(list => list.id !== listId);
      return {
        listsAvailable: [...listsAvailable, listToRemove],
        lists: newLists
      };
    });
  }

  handleNameChange(event) {
    const name = event.target.value;
    this.setState(prevState => {
      return { name };
    });
  }

  setOrientationHorizontal(event) {
    this.setState(prevState => {
      return { isHorizontal: true };
    });
  }

  setOrientationVertical(event) {
    this.setState(prevState => {
      return { isHorizontal: false };
    });
  }

  handleBackgroundColorChange(color, event) {
    const backgroundColor = color.hex;
    this.setState(prevState => {
      return { backgroundColor };
    });
  }

  handleTextColorChange(event) {
    const textColor = event.target.value;
    this.setState(prevState => {
      return { textColor };
    });
  }

  handleRotationIntervalChange(event) {
    const rotationInterval = event.target.value;
    this.setState(prevState => {
      return { rotationInterval };
    });
  }

  onShowPriceChange(listId, showPrice) {
    this.setState(prevState => {
      const prevLists = prevState.lists;
      const { lists, name, font } = prevState;
      const list = lists.find(list => list.id === listId);
      list.show_price_on_menu = showPrice;
      return { lists };
    });
  }

  renderButtons() {
    let deleteButton, viewDisplayButton;
    if (!!this.props.canDestroy) {
      deleteButton = (
        <label
          htmlFor="digital-display-menu-form-delete"
          className="btn btn-danger menu-form-action"
          data-test="digital-display-menu-form-delete">
          Delete
        </label>
      );
    }
    if (this.props.viewDisplayPath) {
      viewDisplayButton = (
        <a href={this.props.viewDisplayPath}
           className="btn btn-success pull-right"
           data-test="view-digital-display-menu">View Display</a>
      )
    }
    return (
      <div className="form-group">
        <input
          type="submit"
          name="commit"
          value={this.props.submitButtonText}
          className="btn btn-primary menu-form-action"
          data-test="digital-display-menu-form-submit"
          data-disable-with="Create"
        />
        <a href={this.props.cancelEditPath}
           className="btn btn-default menu-form-action"
           data-test="digital-display-menu-form-cancel">Cancel</a>
        {deleteButton}
        {viewDisplayButton}
      </div>
    );
  }

  renderRotationIntervalOptions() {
    return this.props.rotationIntervalOptions.map((option, index) => {
      return <option value={option.value} key={index}>{option.name}</option>
    });
  }

  render() {
    const {
      lists,
      listsAvailable,
      name,
      isHorizontal,
      rotationInterval,
      backgroundColor,
      textColor
    } = this.state;
    const totalListCount          = lists.length + listsAvailable.length;
    const buttons                 = this.renderButtons();
    const rotationIntervalOptions = this.renderRotationIntervalOptions();
    const previewPath             = generatePreviewPath(this.props.digitalDisplayMenu, this.state);

    return (
      <div className="row">
        <div className="col-sm-6">
          <Panel title={name}>
            <div className="form-group">
              <label htmlFor="digital_display_menu_name">Name</label>
              <input
                id="digital_display_menu_name"
                name="digital_display_menu[name]"
                className="form-control"
                data-test="digital-display-menu-name"
                type="text"
                defaultValue={name}
                onChange={this.handleNameChange}
              />
            </div>

            <div className="form-group">
              <label>Orientation</label>
              <div className="radio">
                <label>
                  <input
                    type="radio"
                    name="digital_display_menu[horizontal_orientation]"
                    value="true"
                    defaultChecked={isHorizontal}
                    onClick={this.setOrientationHorizontal}
                    data-test="digital-display-menu-horizontal-orientation-true"
                  />
                  Horizontal
                </label>
              </div>
              <div className="radio">
                <label>
                  <input
                    type="radio"
                    name="digital_display_menu[horizontal_orientation]"
                    value="false"
                    defaultChecked={!isHorizontal}
                    onClick={this.setOrientationVertical}
                    data-test="digital-display-menu-horizontal-orientation-false"
                  />
                  Vertical
                </label>
              </div>
            </div>

            <div className="form-group">
              <label>Background Color</label>
              <ChromePicker
                color={backgroundColor}
                onChangeComplete={this.handleBackgroundColorChange}
              />

              <input
                id="digital_display_menu_background_color"
                name="digital_display_menu[background_color]"
                data-test="digital-display-menu-background-color"
                type="hidden"
                defaultValue={backgroundColor}
              />
            </div>

            <div className="form-group">
              <label htmlFor="menu_font">Rotation Interval</label>
              <select
                id="digital_display_menu_rotation_interval"
                data-test="digital-display-menu-rotation-interval"
                name="digital_display_menu[rotation_interval]"
                className="form-control"
                defaultValue={rotationInterval}
                onChange={this.handleRotationIntervalChange}>
                {rotationIntervalOptions}
              </select>
            </div>

            <AvailableListGroup
              totalListCount={totalListCount}
              lists={listsAvailable}
              menuType="digitalDisplay"
              onAdd={this.addListToDisplay}
              onDrop={this.removeListFromDisplay}
            />
            <ChosenListGroup
              lists={lists}
              menuType="digitalDisplay"
              onRemove={this.removeListFromDisplay}
              onShowPriceChange={this.onShowPriceChange}
              moveItem={this.moveChosenList}
              onDrop={this.addListToDisplay}
            />

            {buttons}
          </Panel>
        </div>
        <div className="col-sm-6">
          <DigitalDisplayPreview {...{ previewPath, isHorizontal }} />
        </div>
      </div>
    );
  }
}

DigitalDisplayApp.propTypes = {
  digitalDisplayMenu: PropTypes.object.isRequired,
  cancelEditPath: PropTypes.string.isRequired,
  viewDisplayPath: PropTypes.string,
  submitButtonText: PropTypes.string.isRequired,
  canDestroy: PropTypes.bool,
  rotationIntervalOptions: PropTypes.array,
  backgroundColor: PropTypes.string,
  textColor: PropTypes.string
};

export default DragDropContext(HTML5Backend)(DigitalDisplayApp);
