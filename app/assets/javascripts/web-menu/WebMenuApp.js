import React, { Component } from 'react';
import PropTypes from 'prop-types';
import Panel from '../shared/Panel';
import Buttons from './Buttons';
import EmbedCode from './EmbedCode';
import ShowCodeButton from './ShowCodeButton';
import AvailableListGroup from '../shared/AvailableListGroup';
import ChosenListGroup from '../shared/ChosenListGroup';
import Preview from './Preview';
import generatePreviewPath from './previewPath';
import { applyFind } from '../polyfills/Array';
import { DragDropContext } from 'react-dnd';
import HTML5Backend from 'react-dnd-html5-backend';

applyFind();

class WebMenuApp extends Component {
  constructor(props) {
    super(props);

    const {
      name,
      lists,
      listsAvailable
    } = props.webMenu;

    this.handleNameChange        = this.handleNameChange.bind(this);
    this.addListToMenu           = this.addListToMenu.bind(this);
    this.removeListFromMenu      = this.removeListFromMenu.bind(this);
    this.onShowPriceChange       = this.onShowPriceChange.bind(this);
    this.onShowDescriptionChange = this.onShowDescriptionChange.bind(this);
    this.moveChosenList          = this.moveChosenList.bind(this);
    this.toggleCodeVisibility    = this.toggleCodeVisibility.bind(this);

    this.state = {
      name,
      lists,
      listsAvailable,
      showEmbedCode: false
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

  handleNameChange(event) {
    const name = event.target.value;
    this.setState(prevState => {
      return { name };
    });
  }

  onShowPriceChange(listId, showPrice) {
    this.setState(prevState => {
      const { lists, name, font } = prevState;
      const list = lists.find(list => list.id === listId);
      list.show_price_on_menu = showPrice;
      return { lists };
    });
  }

  onShowDescriptionChange(listId, showDesc) {
    this.setState(prevState => {
      const { lists, name, font } = prevState;
      const list = lists.find(list => list.id === listId);
      list.show_description_on_menu = showDesc;
      return { lists };
    });
  }

  toggleCodeVisibility () {
    this.setState(prevState => {
      return {
        showEmbedCode: !prevState.showEmbedCode
      };
    });
  }

  render() {
    const { lists, listsAvailable, name, showEmbedCode } = this.state;
    const previewPath = generatePreviewPath(this.props.webMenu, this.state);
    const totalListCount = lists.length + listsAvailable.length;
    const { embedCode } = this.props.webMenu;
    const toggleCodeButtonClass = embedCode ? (showEmbedCode ? 'active' : '') : 'hidden';
    return (
      <div className="form-row">
        <div className="col-sm-6">
          <Panel title={name}>
            <div className="form-group">
              <label htmlFor="menu_name">Name</label>
              <input
                id="web_menu_name"
                name="web_menu[name]"
                className="form-control"
                data-test="web-menu-name"
                type="text"
                defaultValue={name}
                onChange={this.handleNameChange}
              />
            </div>

            <AvailableListGroup
              totalListCount={totalListCount}
              lists={listsAvailable}
              menuType="web"
              onAdd={this.addListToMenu}
              onDrop={this.removeListFromMenu}
            />
            <ChosenListGroup
              lists={lists}
              menuType="web"
              onRemove={this.removeListFromMenu}
              onShowPriceChange={this.onShowPriceChange}
              onShowDescriptionChange={this.onShowDescriptionChange}
              moveItem={this.moveChosenList}
              onDrop={this.addListToMenu}
            />

            <Buttons {...this.props}>
              <ShowCodeButton
                onClick={this.toggleCodeVisibility}
                buttonClass={toggleCodeButtonClass}>
                Embed Code
              </ShowCodeButton>
            </Buttons>

            <EmbedCode embedCode={embedCode} show={showEmbedCode} />
          </Panel>
        </div>
        <div className="col-sm-6">
          <Preview previewPath={previewPath} />
        </div>
      </div>
    );
  }
}

export default DragDropContext(HTML5Backend)(WebMenuApp);
