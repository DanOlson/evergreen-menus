import React, { PropTypes } from 'react';

class AvailableListGroup extends React.Component {
  constructor(props) {
    super(props);
    this.clickHandler = this.clickHandler.bind(this);
    this.ifEmptyText = "No lists available"
  }

  clickHandler(listId) {
    return this.props.onClick(listId) || (() => {});
  }

  renderList(listGroupItems) {
    let itemsToRender;
    if (listGroupItems.length === 0) {
      itemsToRender = <li className="list-group-item">{this.ifEmptyText}</li>;
    } else {
      itemsToRender = listGroupItems
    }

    return (
      <ul className="list-group">
        {itemsToRender}
      </ul>
    );
  }

  render() {
    const { lists } = this.props;
    const listGroupItems = lists.map(list => {
      const onClick = this.clickHandler.bind(null, list.id)
      return (
        <li className="list-group-item" onClick={onClick} key={list.id}>
          {list.name}
        </li>
      )
    });

    return (
      <div className="panel panel-default">
        <div className="panel-heading">Lists Available</div>
        {this.renderList(listGroupItems)}
      </div>
    )
  }
}

AvailableListGroup.propTypes = {
  lists: PropTypes.array.isRequired,
  onClick: PropTypes.func
};

export default AvailableListGroup;
