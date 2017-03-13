import React from 'react';
import BeerInput from './BeerInput';

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state      = { beers: this.props.beers };
    this.deleteBeer = this.deleteBeer.bind(this);
    this.addBeer    = this.addBeer.bind(this);
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
    const inputs = this.state.beers.map((beer, index, array) => {
      const beerInputProps = {
        beer,
        deleteBeer: this.deleteBeer,
        key: `${beer}-${index}`
      };

      return <BeerInput {...beerInputProps} />;
    });

    return (
      <div className="establishment-beer-list">
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
      </div>
    );
  }
};

export default App;
