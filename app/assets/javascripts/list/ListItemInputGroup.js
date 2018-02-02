import React, { Component } from 'react';
import PropTypes from 'prop-types';
import ListItemNameInput from './ListItemNameInput';
import ListItemPriceInput from './ListItemPriceInput';
import ListItemDescriptionInput from './ListItemDescriptionInput';
import ListItemAction from './ListItemAction';

class ListItemInputGroup extends Component {
  constructor (props) {
    super(props);
    this.state = props.beer;
    this.onRemove = this.onRemove.bind(this);
    this.onKeep = this.onKeep.bind(this);
  }

  onRemove(event) {
    event.preventDefault();
    if (this.state.id) {
      this.markForRemoval();
    } else {
      this.deleteBeer(this.state.appId)
    }
  }

  deleteBeer(appId) {
    this.props.deleteBeer(appId);
  }

  markForRemoval() {
    this.setState({ markedForRemoval: true });
  }

  onKeep(event) {
    event.preventDefault();
    this.setState({ markedForRemoval: false });
  }

  render() {
    const { appId, markedForRemoval, name, price, description } = this.state;
    const className = markedForRemoval ? 'remove-beer' : '';

    return (
      <div data-test={`beer-${appId}`} className={className}>
        <div data-test="beer-input">
          <div className="form-row">
            <ListItemNameInput appId={appId} value={name} className={className} />
            <ListItemPriceInput appId={appId} value={price} />
            <ListItemDescriptionInput appId={appId} value={description} />
            <ListItemAction
              appId={appId}
              markedForRemoval={markedForRemoval}
              onKeep={this.onKeep}
              onRemove={this.onRemove}
            />
          </div>
          <div className="form-row">
            <div className="col-sm-10 col-xs-12 beer-separator"></div>
          </div>
          <input
            type="hidden"
            defaultValue={this.state.id}
            name={`list[beers_attributes][${appId}][id]`}
            id={`list_beers_attributes_${appId}_id`}
          />
          <input
            type="hidden"
            data-test="marked-for-removal"
            defaultValue={markedForRemoval}
            name={`list[beers_attributes][${appId}][_destroy]`}
          />
        </div>
      </div>
    );
  }
}

ListItemInputGroup.propTypes = {
  beer: PropTypes.object.isRequired,
  deleteBeer: PropTypes.func.isRequired
}

export default ListItemInputGroup
