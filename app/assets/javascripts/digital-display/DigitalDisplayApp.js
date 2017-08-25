import React, { Component, PropTypes } from 'react';
import Panel from '../Panel';
import AvailableListGroup from '../menu/AvailableListGroup';
import ChosenListGroup from '../menu/ChosenListGroup';
import DigitalDisplayPreview from './DigitalDisplayPreview';
import generatePreviewPath from './previewPath';
import { applyFind } from '../polyfills/Array';

applyFind();

class DigitalDisplayApp extends Component {
  constructor(props) {
    super(props);
    const { digitalDisplayMenu } = this.props;
    const { lists, listsAvailable, name } = digitalDisplayMenu;
    const isHorizontal = digitalDisplayMenu.horizontal_orientation;

    this.handleNameChange         = this.handleNameChange.bind(this);
    this.setOrientationHorizontal = this.setOrientationHorizontal.bind(this);
    this.setOrientationVertical   = this.setOrientationVertical.bind(this);
    this.addListToDisplay         = this.addListToDisplay.bind(this);
    this.removeListFromDisplay    = this.removeListFromDisplay.bind(this);
    this.onShowPriceChange        = this.onShowPriceChange.bind(this);

    this.state = {
      lists,
      listsAvailable,
      name,
      isHorizontal
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

  render() {
    const { lists, listsAvailable, name, isHorizontal } = this.state;
    const totalListCount = lists.length + listsAvailable.length;
    const buttons        = this.renderButtons();
    const previewPath    = generatePreviewPath(this.props.digitalDisplayMenu, this.state);
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
                    onChange={this.setOrientationHorizontal}
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
                    onChange={this.setOrientationVertical}
                    data-test="digital-display-menu-horizontal-orientation-false"
                  />
                  Vertical
                </label>
              </div>
            </div>

            <AvailableListGroup
              totalListCount={totalListCount}
              lists={listsAvailable}
              menuType="digitalDisplay"
              onClick={this.addListToDisplay}
            />
            <ChosenListGroup
              lists={lists}
              menuType="digitalDisplay"
              onRemove={this.removeListFromDisplay}
              onShowPriceChange={this.onShowPriceChange}
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
  canDestroy: PropTypes.bool
};

export default DigitalDisplayApp;
