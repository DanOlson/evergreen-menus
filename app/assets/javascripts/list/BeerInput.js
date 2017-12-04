import React, { Component } from 'react';
import PropTypes from 'prop-types';

class BeerInput extends Component {
  constructor(props) {
    super(props);
    this.state        = props.beer;
    this.onRemoveBeer = this.onRemoveBeer.bind(this);
    this.onKeepBeer   = this.onKeepBeer.bind(this);
    this.renderAction = this.renderAction.bind(this);
    this.renderPriceInput       = this.renderPriceInput.bind(this);
    this.renderDescriptionInput = this.renderDescriptionInput.bind(this);
    this.renderNameInput        = this.renderNameInput.bind(this);
  }

  onRemoveBeer(event) {
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

  onKeepBeer(event) {
    event.preventDefault();
    this.setState({ markedForRemoval: false });
  }

  renderAction() {
    const { markedForRemoval, appId } = this.state;
    if (markedForRemoval) {
      return (
        <a href=""
           onClick={this.onKeepBeer}
           data-test={`keep-beer-${appId}`}
           className="btn btn-danger">Keep</a>
      )
    } else {
      return (
        <a href=""
           title="Remove"
           onClick={this.onRemoveBeer}
           data-test={`remove-beer-${appId}`}
           className="btn btn-outline-secondary">
          <span className="fa fa-remove fa-lg"></span>
        </a>
      )
    }
  }

  renderNameInput(className) {
    const { appId, name } = this.state;
    return (
      <div className="col-sm-3 col-xs-8">
        <label htmlFor={`list_beers_attributes_${appId}_name`} className="sr-only">
          Name
        </label>
        <input
          type="text"
          placeholder="Name"
          data-test={`beer-name-input-${appId}`}
          defaultValue={name}
          name={`list[beers_attributes][${appId}][name]`}
          id={`list_beers_attributes_${appId}_name`}
          className={`form-control ${className}`}
        />
      </div>
    );
  }

  renderPriceInput() {
    const { appId, price } = this.state;
    return (
      <div className="col-sm-2 col-xs-4">
        <div className="input-group">
          <label htmlFor={`list_beers_attributes_${appId}_price`} className="sr-only">
            Price
          </label>
          <span className="beer-input-price-currency input-group-addon">$</span>
          <input
            type="number"
            step="0.01"
            min="0"
            data-test={`beer-price-input-${appId}`}
            defaultValue={price}
            name={`list[beers_attributes][${appId}][price]`}
            id={`list_beers_attributes_${appId}_price`}
            className="form-control price-input"
          />
        </div>
      </div>
    );
  }

  renderDescriptionInput() {
    const { appId, description } = this.state;
    return (
      <div className="col-sm-6 col-xs-8">
        <label htmlFor={`list_beers_attributes_${appId}_description`} className="sr-only">
          Description
        </label>
        <input
          data-test={`beer-description-input-${appId}`}
          placeholder="Description"
          defaultValue={description}
          name={`list[beers_attributes][${appId}][description]`}
          id={`list_beers_attributes_${appId}_description`}
          className="form-control"
        />
      </div>
    );
  }

  render() {
    const { appId, markedForRemoval } = this.state;
    const className        = markedForRemoval ? 'remove-beer' : '';
    const actionable       = this.renderAction();
    const nameInput        = this.renderNameInput(className);
    const priceInput       = this.renderPriceInput();
    const descriptionInput = this.renderDescriptionInput();

    return (
      <div data-test={`beer-${appId}`} className={className}>
        <div data-test="beer-input">
          <div className="form-row">
            {nameInput}
            {priceInput}
            {descriptionInput}
            <div className="col-sm-1 col-xs-4 remove">
              {actionable}
            </div>
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
};

BeerInput.propTypes = {
  beer: PropTypes.object.isRequired,
  deleteBeer: PropTypes.func.isRequired
}

export default BeerInput;