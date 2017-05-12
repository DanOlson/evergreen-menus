import React, { PropTypes } from 'react';

class MenuForm extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    const { name } = this.props.menu;
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
      </div>
    );
  }
}

export default MenuForm;
