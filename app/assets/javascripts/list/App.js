import React, { Component } from 'react';
import PropTypes from 'prop-types';
import List from './List';

class App extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    const { list, typeOptions, menuItemLabels } = this.props;
    const { beers, name, type } = list;
    const listProps = {
      listId: list.id,
      beers,
      name,
      type,
      typeOptions,
      menuItemLabels
    };

    return <List {...listProps} />;
  }
};

App.propTypes = {
  list: PropTypes.object.isRequired,
  typeOptions: PropTypes.array.isRequired,
  menuItemLabels: PropTypes.array.isRequired
};

export default App;
