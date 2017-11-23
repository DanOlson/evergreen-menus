import React, { Component } from 'react';
import PropTypes from 'prop-types';
import BeerInput from './BeerInput';
import TypeSelect from './TypeSelect';
import Panel from '../shared/Panel';

class List extends Component {
  constructor(props) {
    super(props);
    const { name, type } = props;
    this.state = {
      beers: this.sortBeers(this.props.beers),
      name,
      type
    };
    this.deleteBeer       = this.deleteBeer.bind(this);
    this.addBeer          = this.addBeer.bind(this);
    this.handleTypeChange = this.handleTypeChange.bind(this);
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

  handleTypeChange(newType) {
    const type = newType.value;
    this.setState(prevState => {
      return { type };
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
    const { listId, typeOptions } = this.props;
    const { name, type } = this.state;
    const inputs = this.state.beers.map((beer, index, array) => {
      const beerInputProps = {
        beer,
        listId,
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

              <TypeSelect
                className="col-sm-2"
                options={typeOptions}
                value={type}
                onChange={this.handleTypeChange}
              />
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
  typeOptions: PropTypes.array.isRequired,
  listId: PropTypes.number
}

export default List;
