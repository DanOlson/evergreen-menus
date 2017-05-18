import React, { PropTypes } from 'react';
import AvailableListGroup from './AvailableListGroup';
import ChosenListGroup from './ChosenListGroup';
import { applyFind } from '../polyfills/Array';

applyFind();

class MenuForm extends React.Component {
  constructor(props) {
    super(props);
    const { lists, listsAvailable } = this.props.menu;
    this.state = { lists, listsAvailable };

    this.addListToMenu      = this.addListToMenu.bind(this);
    this.removeListFromMenu = this.removeListFromMenu.bind(this);
  }

  addListToMenu(listId) {
    this.setState(prevState => {
      const { lists, listsAvailable } = prevState;
      const listToAdd = listsAvailable.find(list => list.id === listId);
      return {
        listsAvailable: listsAvailable.filter(list => list.id !== listId),
        lists: [...lists, listToAdd]
      }
    });
  }

  removeListFromMenu(listId) {
    this.setState(prevState => {
      const { lists, listsAvailable } = prevState;
      const listToRemove = lists.find(list => list.id === listId);
      return {
        listsAvailable: [...listsAvailable, listToRemove],
        lists: lists.filter(list => list.id !== listId)
      }
    });
  }

  render() {
    const { name } = this.props.menu;
    const { lists, listsAvailable } = this.state;
    const totalListCount = lists.length + listsAvailable.length;
    return (
      <div>
        <div className="form-group">
          <label htmlFor="menu_name">Name</label>
          <input
            id="menu_name"
            name="menu[name]"
            className="form-control"
            data-test="menu-name"
            type="text"
            defaultValue={name}
          />
        </div>

        <AvailableListGroup totalListCount={totalListCount} lists={listsAvailable} onClick={this.addListToMenu} />
        <ChosenListGroup lists={lists} onRemove={this.removeListFromMenu} />
      </div>
    );
  }
}

MenuForm.propTypes = {
  menu: PropTypes.object.isRequired
}

export default MenuForm;
