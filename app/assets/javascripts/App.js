import React from 'react';
import List from './List';

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = { lists: props.lists };
  }

  render() {
    const listIds = Object.keys(this.state.lists);
    const lists = listIds.map((listId, index) => {
      const listProps = {
        listId,
        beers: this.state.lists[listId],
        key: `${listId}-${index}`
      };

      return <List {...listProps} />;
    });

    return <div>{lists}</div>;
  }
};

export default App;
