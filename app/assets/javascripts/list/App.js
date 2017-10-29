import React, { Component } from 'react';
import PropTypes from 'prop-types';
import List from './List';

class App extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    const { list, typeOptions } = this.props;
    const { beers, name, type } = list;
    const listProps = {
      listId: list.id,
      beers,
      name,
      showPrice: list.show_price,
      showDescription: list.show_description,
      type,
      typeOptions
    };

    return <List {...listProps} />;
  }
};

App.propTypes = {
  list: PropTypes.object.isRequired,
  typeOptions: PropTypes.array.isRequired
};

export default App;
