import React from 'react';
import BeerInput from './BeerInput';

class List extends React.Component {
  constructor(props) {
    super(props);
    this.state      = { beers: this.sortBeers(this.props.beers) };
    this.deleteBeer = this.deleteBeer.bind(this);
    this.addBeer    = this.addBeer.bind(this);
  }

  sortBeers(beers) {
    const sorted = beers.sort((a, b) => {
      const aName = a.name.toLowerCase();
      const bName = b.name.toLowerCase();
      if (aName > bName) return 1;
      if (aName < bName) return -1;
      return 0;
    });
    return sorted.map((beer, index) => {
      beer.appId = index;
      return beer;
    });
  }

  deleteBeer(beerAppId) {
    const beers       = this.state.beers;
    const newBeerList = beers.filter(beer => beer.appId !== beerAppId);
    this.setState({ beers: newBeerList });
  }

  addBeer(event) {
    event.preventDefault();
    const beers     = this.state.beers;
    const nextAppId = beers.length;
    const newBeer   = { name: '', appId: nextAppId };
    this.setState({ beers: [...beers, newBeer] });
  }

  render() {
    const { listId } = this.props;
    const inputs = this.state.beers.map((beer, index, array) => {
      const beerInputProps = {
        beer,
        listId: listId,
        deleteBeer: this.deleteBeer,
        key: `${beer}-${index}`
      };

      return <BeerInput {...beerInputProps} />;
    });

    return (
      <div className="panel panel-info">
        <div className="panel-heading">
          <h3 className="panel-title">{`List ${this.props.listId}`}</h3>
        </div>
        <div className="panel-body row">
          <div className="establishment-beer-list col-sm-offset-1">
            <div className="form-group">
              {inputs}
            </div>
            <div className="form-group">
              <button
                data-test="add-beer"
                onClick={this.addBeer}
                className="btn btn-success">
                <span className="glyphicon glyphicon-plus"></span>
              </button>
            </div>
            <input
              type="hidden"
              defaultValue={listId}
              name={`establishment[lists_attributes][${listId}][id]`}
              id={`establishment_lists_attributes_${listId}_id`}
            />
            <input
              type="hidden"
              defaultValue=""
              name={`establishment[lists_attributes][${listId}][_destroy]`}
            />
          </div>
        </div>
      </div>
    );
  }
}

export default List;
