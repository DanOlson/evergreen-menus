import React, { Component } from 'react';
import PropTypes from 'prop-types';
import BeerInput from './BeerInput';
import Panel from './Panel';

class List extends Component {
  constructor(props) {
    super(props);
    this.state = {
      beers: this.sortBeers(this.props.beers),
      name: this.props.name,
      showPrice: this.props.showPrice,
      showDescription: this.props.showDescription
    };
    this.deleteBeer = this.deleteBeer.bind(this);
    this.addBeer    = this.addBeer.bind(this);
    this.handleShowPriceChange = this.handleShowPriceChange.bind(this);
    this.handleShowDescriptionChange = this.handleShowDescriptionChange.bind(this);
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

  handleShowPriceChange(event) {
    this.setState({ showPrice: event.target.checked })
  }

  handleShowDescriptionChange(event) {
    this.setState({ showDescription: event.target.checked })
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
    const { name, showPrice, showDescription } = this.state;
    const inputs = this.state.beers.map((beer, index, array) => {
      const beerInputProps = {
        beer,
        listId,
        showPrice,
        showDescription,
        deleteBeer: this.deleteBeer,
        key: `${beer}-${index}`
      };

      return <BeerInput {...beerInputProps} />;
    });

    return (
      <Panel title={name}>
        <div className="establishment-beer-list">
          <div className="form-group">
            <div className="form-row">
              <div className="col-sm-4">
                <label htmlFor="list_name">List Name</label>
                <input
                  type="text"
                  name="list[name]"
                  id="list_name"
                  className="form-control"
                  data-test="list-name"
                  defaultValue={name}
                />
              </div>
            </div>

            <div className="form-check">
              <label className="form-check-label" htmlFor="list_show_price">
                <input
                  type="checkbox"
                  id="list_show_price"
                  data-test="list-show-price"
                  className="form-check-input"
                  checked={showPrice}
                  value={showPrice}
                  onChange={this.handleShowPriceChange}
                />
                <input
                  type="hidden"
                  name="list[show_price]"
                  id="list_show_price"
                  value={showPrice}
                />
                Show Price
              </label>
            </div>

            <div className="form-check">
              <label className="form-check-label" htmlFor="list_show_description">
                <input
                  type="checkbox"
                  id="list_show_description"
                  data-test="list-show-description"
                  className="form-check-input"
                  checked={showDescription}
                  value={showDescription}
                  onChange={this.handleShowDescriptionChange}
                />
                <input
                  type="hidden"
                  name="list[show_description]"
                  id="list_show_description"
                  value={showDescription}
                />
                Show Description
              </label>
            </div>
          </div>
          <div className="form-group">
            {inputs}
          </div>
          <div className="form-group">
            <button
              data-test="add-beer"
              id="add-beer-button"
              title="Add item"
              onClick={this.addBeer}
              className="btn btn-success">
              <span className="fa fa-plus fa-lg"></span>
            </button>
          </div>
        </div>
      </Panel>
    );
  }
}

List.propTypes = {
  beers: PropTypes.array.isRequired,
  name: PropTypes.string.isRequired,
  showPrice: PropTypes.bool.isRequired,
  showDescription: PropTypes.bool.isRequired,
  listId: PropTypes.number
}

export default List;
