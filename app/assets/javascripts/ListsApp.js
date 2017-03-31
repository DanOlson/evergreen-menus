import React from 'react';
import ListItem from './EstablishmentListItem';

class ListsApp extends React.Component {
  render() {
    const lists = this.props.lists.map(list => {
      return (
        <ListItem
          name={list.name}
          editPath={list.edit_path}
          htmlSnippet={list.html_snippet}
          canShowSnippet={!!list.html_snippet}
          key={list.id}
        />
      );
    });

    return (
      <div className="list-group">
        {lists}
      </div>
    );
  }
}

export default ListsApp;
