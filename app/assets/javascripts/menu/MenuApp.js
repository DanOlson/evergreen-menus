import React, { Component } from 'react';
import PropTypes from 'prop-types';
import ColumnsInput from './ColumnsInput';
import AvailableListGroup from '../shared/AvailableListGroup';
import ChosenListGroup from '../shared/ChosenListGroup';
import Preview from './MenuPreview';
import Panel from '../Panel';
import generatePreviewPath from './previewPath';
import { applyFind } from '../polyfills/Array';
import { DragDropContext } from 'react-dnd';
import HTML5Backend from 'react-dnd-html5-backend';

applyFind();

class MenuApp extends Component {
  constructor(props) {
    super(props);
    const { menu } = this.props;
    const { lists, listsAvailable, name, font, template } = menu;
    const fontSize = menu.font_size;
    const columns = menu.number_of_columns;

    this.handleMenuNameChange = this.handleMenuNameChange.bind(this);
    this.handleTemplateChange = this.handleTemplateChange.bind(this);
    this.handleFontChange     = this.handleFontChange.bind(this);
    this.handleFontSizeChange = this.handleFontSizeChange.bind(this);
    this.handleColumnsChange  = this.handleColumnsChange.bind(this);
    this.addListToMenu        = this.addListToMenu.bind(this);
    this.removeListFromMenu   = this.removeListFromMenu.bind(this);
    this.onShowPriceChange    = this.onShowPriceChange.bind(this);
    this.moveChosenList       = this.moveChosenList.bind(this);

    this.state = {
      lists,
      listsAvailable,
      name,
      template,
      font,
      fontSize,
      columns
    };
  }

  moveChosenList(dragIndex, hoverIndex) {
    const { lists } = this.state;
    const dragList = lists[dragIndex];

    this.setState(prevState => {
      const newLists = [...lists];
      newLists.splice(dragIndex, 1);
      newLists.splice(hoverIndex, 0, dragList);
      return { lists: newLists };
    });
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

  handleTemplateChange(event) {
    const template = event.target.value;
    this.setState(prevState => {
      return { template };
    });
  }

  handleFontChange(event) {
    const font = event.target.value;
    this.setState(prevState => {
      return { font };
    });
  }

  handleFontSizeChange(event) {
    let fontSize = event.target.value;
    if (parseInt(fontSize, 10) > 20) {
      fontSize = 20;
    } else if (parseInt(fontSize, 10) < 4) {
      fontSize = 4;
    }
    this.setState(prevState => {
      return { fontSize };
    });
  }

  handleColumnsChange(event) {
    let columns = Number(event.target.value);
    this.setState(prevState => {
      return { columns };
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

  renderOptions(choices) {
    return choices.map((option, index) => {
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
    const { lists, listsAvailable, font, fontSize, columns, name, template } = this.state;
    const fontOptions     = this.renderOptions(this.props.fontOptions);
    const templateOptions = this.renderOptions(this.props.templateOptions);
    const totalListCount  = lists.length + listsAvailable.length;
    const buttons         = this.renderButtons();
    const previewPath     = generatePreviewPath(this.props.menu, this.state);
    const columnsDisabled = template === 'Centered';
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
              <div className="row">
                <div className="col-sm-3">
                  <label htmlFor="menu_font">Template</label>
                  <select
                    id="menu_template"
                    data-test="menu-template"
                    name="menu[template]"
                    className="form-control"
                    defaultValue={template}
                    onChange={this.handleTemplateChange}>
                    {templateOptions}
                  </select>
                </div>

                <div className="col-sm-4">
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

                <div className="col-sm-2">
                  <label htmlFor="menu_font_size">Font Size</label>
                  <input
                    id="menu_font_size"
                    data-test="menu-font-size"
                    name="menu[font_size]"
                    className="form-control"
                    type="number"
                    min="4"
                    max="20"
                    defaultValue={fontSize}
                    onChange={this.handleFontSizeChange}
                  />
                </div>

                <ColumnsInput
                  className="col-sm-3"
                  onChange={this.handleColumnsChange}
                  columns={columns}
                  disabled={columnsDisabled}
                />
              </div>
            </div>

            <AvailableListGroup
              totalListCount={totalListCount}
              lists={listsAvailable}
              menuType="pdf"
              onAdd={this.addListToMenu}
              onDrop={this.removeListFromMenu}
            />
            <ChosenListGroup
              lists={lists}
              menuType="pdf"
              onRemove={this.removeListFromMenu}
              onShowPriceChange={this.onShowPriceChange}
              moveItem={this.moveChosenList}
              onDrop={this.addListToMenu}
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
  canDestroyMenu: PropTypes.bool,
  fontOptions: PropTypes.array.isRequired,
  templateOptions: PropTypes.array.isRequired
};

export default DragDropContext(HTML5Backend)(MenuApp);
