import React from 'react';

class BeerInput extends React.Component {
  constructor(props) {
    super(props);
    this.state        = props.beer;
    this.onRemoveBeer = this.onRemoveBeer.bind(this);
    this.onKeepBeer   = this.onKeepBeer.bind(this);
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

  render() {
    const { appId, markedForRemoval, name, price } = this.state;
    const className = markedForRemoval ? 'remove-beer' : '';
    let actionable;

    if (markedForRemoval) {
      actionable = (
        <a href=''
           onClick={this.onKeepBeer}
           data-test={`keep-beer-${appId}`}
           className="btn btn-danger">Keep</a>
      )
    } else {
      actionable = (
        <a href=''
           onClick={this.onRemoveBeer}
           data-test={`remove-beer-${appId}`}
           className="btn btn-default">
          <span className="glyphicon glyphicon-remove"></span>
        </a>
      )
    }

    return (
      <div data-test={`beer-${appId}`} className={`${className} row`}>
        <div data-test="beer-input">
          <div className="col-sm-4">
            <input
              type="text"
              data-test={`beer-name-input-${appId}`}
              defaultValue={name}
              name={`establishment[beers_attributes][${appId}][name]`}
              id={`establishment_beers_attributes_${appId}_name`}
              className={`form-control ${className}`}
            />
          </div>
          <div className="col-sm-1">
            <input
              type="number"
              step="0.01"
              min="0"
              data-test={`beer-price-input-${appId}`}
              defaultValue={price}
              name={`establishment[beers_attributes][${appId}][price]`}
              id={`establishment_beers_attributes_${appId}_price`}
              className="form-control price-input"
            />
          </div>
          <div className="col-sm-7">
            {actionable}
          </div>
        </div>
        <input
          type="hidden"
          defaultValue={this.state.id}
          name={`establishment[beers_attributes][${appId}][id]`}
          id={`establishment_beers_attributes_${appId}_id`}
        />
        <input
          type="hidden"
          defaultValue={markedForRemoval}
          name={`establishment[beers_attributes][${appId}][_destroy]`}
        />
      </div>
    );
  }
};

export default BeerInput;
