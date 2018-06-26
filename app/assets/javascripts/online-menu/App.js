import React, { Component } from 'react';
import PropTypes from 'prop-types';
import Panel from '../shared/Panel';
import Buttons from '../shared/MenuFormButtons';
import AvailableListGroup from '../shared/AvailableListGroup';
import AvailabilityInput from '../shared/AvailabilityInput';
import ChosenListGroup from '../shared/ChosenListGroup';
import Preview from './Preview';
import generatePreviewPath from './previewPath';
import { applyFind } from '../polyfills/Array';
import { DragDropContext } from 'react-dnd';
import HTML5Backend from 'react-dnd-html5-backend';

applyFind();

class App extends Component {
  constructor (props) {
    super(props);

    const {
      lists,
      listsAvailable
    } = props.menu;

    this.addListToMenu = this.addListToMenu.bind(this);
    this.removeListFromMenu = this.removeListFromMenu.bind(this);
    this.onShowPriceChange = this.onShowPriceChange.bind(this);
    this.onShowDescriptionChange = this.onShowDescriptionChange.bind(this);
    this.moveChosenList = this.moveChosenList.bind(this);

    this.state = {
      lists,
      listsAvailable
    };
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

  render () {
    const {
      lists,
      listsAvailable
    } = this.state;
    const { name } = this.props;

    const previewPath = generatePreviewPath(this.props.menu, this.state);
    const totalListCount = lists.length + listsAvailable.length;

    return (
      <div className="form-row">
        <div className="col-sm-6">
          <Panel title="Online Menu">
            <AvailableListGroup
              totalListCount={totalListCount}
              lists={listsAvailable}
              menuType="online"
              onAdd={this.addListToMenu}
              onDrop={this.removeListFromMenu}
            />
            <ChosenListGroup
              lists={lists}
              menuType="online"
              onRemove={this.removeListFromMenu}
              onShowPriceChange={this.onShowPriceChange}
              onShowDescriptionChange={this.onShowDescriptionChange}
              moveItem={this.moveChosenList}
              onDrop={this.addListToMenu}
            />

            <Buttons {...this.props} menuType="online-menu" />
          </Panel>
        </div>
        <div className="col-sm-6">
          <Preview previewPath={previewPath} />
        </div>
      </div>
    );
  }
}

App.propTypes = {
  menu: PropTypes.object.isRequired
}

export default DragDropContext(HTML5Backend)(App);
