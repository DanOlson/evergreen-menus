import React, { Component } from 'react';
import PropTypes from 'prop-types';
import ListItemNameInput from './ListItemNameInput';
import ListItemPriceInput from './ListItemPriceInput';
import ListItemDescriptionInput from './ListItemDescriptionInput';
import ListItemLabelsInput from './ListItemLabelsInput';
import ListItemAction from './ListItemAction';
import Flyout from './Flyout';
import ToggleFlyoutButton from './ToggleFlyoutButton';

class ListItemInputGroup extends Component {
  constructor (props) {
    super(props);
    this.state = Object.assign({ showFlyout: false }, props.beer);
    this.onRemove = this.onRemove.bind(this);
    this.onKeep = this.onKeep.bind(this);
    this.toggleFlyout = this.toggleFlyout.bind(this);
  }

  onRemove(event) {
    event.preventDefault();
    if (this.state.id) {
      this.markForRemoval();
    } else {
      this.deleteBeer(this.state.appId)
    }
  }

  toggleFlyout() {
    this.setState(prevState => {
      return { showFlyout: !prevState.showFlyout };
    });
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
    const {
      appId,
      markedForRemoval,
      name,
      price,
      description,
      labels,
      showFlyout
    } = this.state;
    const className = markedForRemoval ? 'remove-beer' : '';
    const { menuItemLabels } = this.props;

    return (
      <div data-test="beer-input" className={className}>
        <div className="form-row">
          <ListItemNameInput appId={appId} value={name} className={className} />
          <ListItemPriceInput appId={appId} value={price} />
          <ToggleFlyoutButton
            flyoutShown={showFlyout}
            onClick={this.toggleFlyout}
          />
          <ListItemAction
            appId={appId}
            markedForRemoval={markedForRemoval}
            onKeep={this.onKeep}
            onRemove={this.onRemove}
          />
        </div>
        <Flyout show={showFlyout}>
          <ListItemDescriptionInput appId={appId} value={description} />
          <ListItemLabelsInput appId={appId} menuItemLabels={menuItemLabels} appliedLabels={labels} />
        </Flyout>
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
    );
  }
}

ListItemInputGroup.propTypes = {
  beer: PropTypes.object.isRequired,
  menuItemLabels: PropTypes.array.isRequired,
  deleteBeer: PropTypes.func.isRequired
}

export default ListItemInputGroup
