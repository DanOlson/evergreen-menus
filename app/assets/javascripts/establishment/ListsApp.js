import React, { Component } from 'react';
import PropTypes from 'prop-types';
import ListItem from './EstablishmentListItem';

class ListsApp extends Component {
  render() {
    const lists = this.props.lists.map(list => {
      return (
        <ListItem
          name={list.name}
          listType={list.type}
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

ListsApp.propTypes = {
  lists: PropTypes.array.isRequired
}

export default ListsApp;
