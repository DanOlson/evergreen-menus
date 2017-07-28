import React, { PropTypes } from 'react';
import AvailableListGroup from './AvailableListGroup';
import ChosenListGroup from './ChosenListGroup';
import Preview from './MenuPreview';
import Panel from '../Panel';
import generatePreviewPath from './previewPath';
import { applyFind } from '../polyfills/Array';

applyFind();

class MenuApp extends React.Component {
  constructor(props) {
    super(props);
    const { lists, listsAvailable, name, font } = this.props.menu;

    this.handleMenuNameChange = this.handleMenuNameChange.bind(this);
    this.handleFontChange     = this.handleFontChange.bind(this);
    this.addListToMenu        = this.addListToMenu.bind(this);
    this.removeListFromMenu   = this.removeListFromMenu.bind(this);
    this.onShowPriceChange    = this.onShowPriceChange.bind(this);

    this.state = {
      lists,
      listsAvailable,
      name,
      font
    };
  }

  addListToMenu(listId) {
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

  removeListFromMenu(listId) {
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

  handleMenuNameChange(event) {
    const name = event.target.value;
    this.setState(prevState => {
      return { name };
    });
  }

  handleFontChange(event) {
    const font = event.target.value;
    this.setState(prevState => {
      return { font };
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

  renderFontOptions() {
    return this.props.fontOptions.map((option, index) => {
      return <option value={option} key={index}>{option}</option>
    });
  }

  renderButtons() {
    let deleteButton, downloadButton;
    if (!!this.props.canDestroyMenu) {
      deleteButton = (
        <label
          htmlFor="menu-form-delete"
          className="btn btn-danger menu-form-action"
          data-test="menu-form-delete">
          Delete
        </label>
      );
    }
    if (!!this.props.downloadMenuPath) {
      downloadButton = (
        <a href={this.props.downloadMenuPath}
           className="btn btn-success pull-right"
           data-test="menu-download-button">Download</a>
      );
    }
    return (
      <div className="form-group">
        <input
          type="submit"
          name="commit"
          value={this.props.menuFormSubmitText}
          className="btn btn-primary menu-form-action"
          data-test="menu-form-submit"
          data-disable-with="Create"
        />
        <a href={this.props.cancelEditMenuPath}
           className="btn btn-default menu-form-action"
           data-test="menu-form-cancel">Cancel</a>
        {deleteButton}
        {downloadButton}
      </div>
    );
  }

  render() {
    const { lists, listsAvailable, font, name } = this.state;
    const fontOptions    = this.renderFontOptions();
    const totalListCount = lists.length + listsAvailable.length;
    const buttons        = this.renderButtons();
    const previewPath    = generatePreviewPath(this.props.menu, this.state);
    return (
      <div className="row">
        <div className="col-sm-6">
          <Panel title={name}>
            <div className="form-group">
              <label htmlFor="menu_name">Name</label>
              <input
                id="menu_name"
                name="menu[name]"
                className="form-control"
                data-test="menu-name"
                type="text"
                defaultValue={name}
                onChange={this.handleMenuNameChange}
              />
            </div>

            <div className="form-group">
              <label htmlFor="menu_font">Font</label>
              <select
                id="menu_font"
                data-test="menu-font"
                name="menu[font]"
                className="form-control"
                defaultValue={font}
                onChange={this.handleFontChange}>
                {fontOptions}
              </select>
            </div>

            <AvailableListGroup
              totalListCount={totalListCount}
              lists={listsAvailable}
              onClick={this.addListToMenu}
            />
            <ChosenListGroup
              lists={lists}
              onRemove={this.removeListFromMenu}
              onShowPriceChange={this.onShowPriceChange}
            />

            {buttons}
          </Panel>
        </div>
        <div className="col-sm-6">
          <Panel title='Preview' dataTest="menu-preview">
            <Preview previewPath={previewPath} />
          </Panel>
        </div>
      </div>
    );
  }
}

MenuApp.propTypes = {
  menu: PropTypes.object.isRequired,
  cancelEditMenuPath: PropTypes.string.isRequired,
  downloadMenuPath: PropTypes.string,
  menuFormSubmitText: PropTypes.string.isRequired,
  canDestroyMenu: PropTypes.bool
};

export default MenuApp;
