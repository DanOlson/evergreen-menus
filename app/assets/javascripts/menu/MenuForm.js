import React, { PropTypes } from 'react';
import AvailableListGroup from './AvailableListGroup';
import ChosenListGroup from './ChosenListGroup';
import Preview from './MenuPreview';
import { applyFind } from '../polyfills/Array';

applyFind();

class MenuForm extends React.Component {
  constructor(props) {
    super(props);
    const { lists, listsAvailable } = this.props.menu;

    this.addListToMenu      = this.addListToMenu.bind(this);
    this.removeListFromMenu = this.removeListFromMenu.bind(this);
    this.generatePreviewPath = this.generatePreviewPath.bind(this);

    this.state = { lists, listsAvailable, previewPath: this.generatePreviewPath(lists) };
  }

  addListToMenu(listId) {
    this.setState(prevState => {
      const { lists, listsAvailable } = prevState;
      const listToAdd = listsAvailable.find(list => list.id === listId);
      const newLists = [...lists, listToAdd];
      return {
        listsAvailable: listsAvailable.filter(list => list.id !== listId),
        lists: newLists,
        previewPath: this.generatePreviewPath(newLists)
      }
    });
  }

  removeListFromMenu(listId) {
    this.setState(prevState => {
      const { lists, listsAvailable } = prevState;
      const listToRemove = lists.find(list => list.id === listId);
      const newLists = lists.filter(list => list.id !== listId)
      return {
        listsAvailable: [...listsAvailable, listToRemove],
        lists: newLists,
        previewPath: this.generatePreviewPath(newLists)
      }
    });
  }

  generatePreviewPath(lists) {
    const { previewPath, id } = this.props.menu;
    const queryString = lists.reduce((acc, list, idx) => {
      const listRep = `menu[menu_lists_attributes][${idx}]`
      const qs = `&${listRep}[list_id]=${list.id}&${listRep}[position]=${idx}&${listRep}[id]=${list.menu_list_id}`
      return acc + qs;
    }, `?menu[id]=${id}`);
    return previewPath + queryString;
  }

  render() {
    const { name } = this.props.menu;
    const { lists, listsAvailable, previewPath } = this.state;
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
        <Preview previewPath={previewPath} />
      </div>
    );
  }
}

MenuForm.propTypes = {
  menu: PropTypes.object.isRequired
}

export default MenuForm;
