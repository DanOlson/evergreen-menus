import React, { PropTypes } from 'react';
import AvailableListGroup from './AvailableListGroup';
import ChosenListGroup from './ChosenListGroup';
import Preview from './MenuPreview';
import { applyFind } from '../polyfills/Array';

applyFind();

class MenuForm extends React.Component {
  constructor(props) {
    super(props);
    const { lists, listsAvailable, name } = this.props.menu;

    this.addListToMenu        = this.addListToMenu.bind(this);
    this.removeListFromMenu   = this.removeListFromMenu.bind(this);
    this.generatePreviewPath  = this.generatePreviewPath.bind(this);
    this.handleMenuNameChange = this.handleMenuNameChange.bind(this);
    this.onShowPriceChange    = this.onShowPriceChange.bind(this);

    this.state = {
      lists,
      listsAvailable,
      name,
      previewPath: this.generatePreviewPath(lists, name)
    };
  }

  addListToMenu(listId) {
    this.setState(prevState => {
      const { lists, listsAvailable, name } = prevState;
      const listToAdd = listsAvailable.find(list => list.id === listId);
      const newLists = [...lists, listToAdd];
      return {
        listsAvailable: listsAvailable.filter(list => list.id !== listId),
        lists: newLists,
        previewPath: this.generatePreviewPath(newLists, name)
      }
    });
  }

  removeListFromMenu(listId) {
    this.setState(prevState => {
      const { lists, listsAvailable, name } = prevState;
      const listToRemove = lists.find(list => list.id === listId);
      const newLists = lists.filter(list => list.id !== listId);
      return {
        listsAvailable: [...listsAvailable, listToRemove],
        lists: newLists,
        previewPath: this.generatePreviewPath(newLists, name)
      };
    });
  }

  handleMenuNameChange(event) {
    const newName = event.target.value;
    this.setState(prevState => {
      return {
        name: newName,
        previewPath: this.generatePreviewPath(prevState.lists, newName)
      };
    });
  }

  onShowPriceChange(listId, showPrice) {
    this.setState(prevState => {
      const prevLists = prevState.lists;
      const lists = [...prevLists];
      const list = lists.find(list => list.id === listId);
      list.show_price_on_menu = showPrice;
      return {
        lists,
        previewPath: this.generatePreviewPath(prevState.lists, prevState.name)
      };
    });
  }

  generatePreviewPath(lists, name) {
    const { previewPath, id } = this.props.menu;
    const queryString = lists.reduce((acc, list, idx) => {
      const listRep = `menu[menu_lists_attributes][${idx}]`;
      const showPrice = list.show_price_on_menu === undefined ? true : list.show_price_on_menu;
      let qs = `&${listRep}[list_id]=${list.id}&${listRep}[position]=${idx}&${listRep}[show_price_on_menu]=${showPrice}`;
      if (list.menu_list_id) {
        qs = qs + `&${listRep}[id]=${list.menu_list_id}`;
      }
      return acc + qs;
    }, `?menu[name]=${name}`);
    if (id) {
      return previewPath + queryString + `&menu[id]=${id}`;
    } else {
      return previewPath + queryString;
    }
  }

  render() {
    const { name } = this.props.menu;
    const { lists, listsAvailable, previewPath } = this.state;
    const totalListCount = lists.length + listsAvailable.length;
    return (
      <div className="row">
        <div className="col-sm-6">
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

          <AvailableListGroup totalListCount={totalListCount} lists={listsAvailable} onClick={this.addListToMenu} />
          <ChosenListGroup lists={lists} onRemove={this.removeListFromMenu} onShowPriceChange={this.onShowPriceChange} />
        </div>
        <div className="col-sm-6">
          <Preview previewPath={previewPath} />
        </div>
      </div>
    );
  }
}

MenuForm.propTypes = {
  menu: PropTypes.object.isRequired
}

export default MenuForm;
