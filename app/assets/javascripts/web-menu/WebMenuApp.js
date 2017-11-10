import React, { Component } from 'react';
import PropTypes from 'prop-types';
import Panel from '../shared/Panel';
import Buttons from './Buttons';
import AvailableListGroup from '../shared/AvailableListGroup';
import ChosenListGroup from '../shared/ChosenListGroup';
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

    this.handleNameChange   = this.handleNameChange.bind(this);
    this.addListToMenu      = this.addListToMenu.bind(this);
    this.removeListFromMenu = this.removeListFromMenu.bind(this);
    this.onShowPriceChange  = this.onShowPriceChange.bind(this);
    this.moveChosenList     = this.moveChosenList.bind(this);

    this.state = {
      name,
      lists,
      listsAvailable
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

  render() {
    const { lists, listsAvailable, name } = this.state;
    const totalListCount = lists.length + listsAvailable.length;
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
              moveItem={this.moveChosenList}
              onDrop={this.addListToMenu}
            />

            <Buttons {...this.props} />
          </Panel>
        </div>
        <div className="col-sm-6">
          <Panel title="Embed Code">
          </Panel>
        </div>
      </div>
    );
  }
}

export default DragDropContext(HTML5Backend)(WebMenuApp);
