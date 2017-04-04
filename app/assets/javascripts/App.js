import React, { PropTypes } from 'react';
import List from './List';

class App extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    const { list } = this.props;
    const listProps = {
      listId: list.id,
      beers: list.beers,
      name: list.name,
      showPrice: list.show_price,
      showDescription: list.show_description
    };

    return <List {...listProps} />;
  }
};

App.propTypes = {
  list: PropTypes.object.isRequired
};

export default App;
