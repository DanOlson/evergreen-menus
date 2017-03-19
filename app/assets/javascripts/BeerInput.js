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
    const { appId, markedForRemoval, name, price, description } = this.state;
    const { listId } = this.props;
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
          <div className="row">
            <div className="col-sm-4">
              <label htmlFor={`establishment_lists_attributes_${listId}_beers_attributes_${appId}_name`}>
                Name
              </label>
              <input
                type="text"
                data-test={`beer-name-input-${appId}`}
                defaultValue={name}
                name={`establishment[lists_attributes][${listId}][beers_attributes][${appId}][name]`}
                id={`establishment_lists_attributes_${listId}_beers_attributes_${appId}_name`}
                className={`form-control ${className}`}
              />
            </div>
            <div className="col-sm-1">
              <label htmlFor={`establishment_lists_attributes_${listId}_beers_attributes_${appId}_price`}>
                Price
              </label>
              <input
                type="number"
                step="0.01"
                min="0"
                data-test={`beer-price-input-${appId}`}
                defaultValue={price}
                name={`establishment[lists_attributes][${listId}][beers_attributes][${appId}][price]`}
                id={`establishment_lists_attributes_${listId}_beers_attributes_${appId}_price`}
                className="form-control price-input"
              />
            </div>
            <div className="col-sm-5">
              <label htmlFor={`establishment_lists_attributes_${listId}_beers_attributes_${appId}_description`}>
                Description
              </label>
              <input
                data-test={`beer-description-input-${appId}`}
                defaultValue={description}
                name={`establishment[lists_attributes][${listId}][beers_attributes][${appId}][description]`}
                id={`establishment_lists_attributes_${listId}_beers_attributes_${appId}_description`}
                className="form-control"
              />
            </div>
            <div className="col-sm-1 remove">
              {actionable}
            </div>
          </div>
          <div className="row">
            <hr className="col-sm-10" />
          </div>
        </div>
        <input
          type="hidden"
          defaultValue={this.state.id}
          name={`establishment[lists_attributes][${listId}][beers_attributes][${appId}][id]`}
          id={`establishment_lists_attributes_${listId}_beers_attributes_${appId}_id`}
        />
        <input
          type="hidden"
          defaultValue={markedForRemoval}
          name={`establishment[lists_attributes][${listId}][beers_attributes][${appId}][_destroy]`}
        />
      </div>
    );
  }
};

export default BeerInput;
