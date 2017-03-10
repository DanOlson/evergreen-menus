import createInput from './BeerInput';

export default React => (props) => {
  const BeerInput = createInput(React);
  const { onRemoveBeer, onKeepBeer, onBeerNameDidChange, onBeerPriceDidChange } = props;
  const onAddBeer = (event) => {
    event.preventDefault();
    props.onAddBeer();
  };
  const inputs = props.beers.map((beer, index, array) => {
    const isLastElement = index === array.length - 1;
    const beerInputProps = {
      beer,
      index,
      onRemoveBeer,
      onKeepBeer,
      onNameChange: onBeerNameDidChange,
      onPriceChange: onBeerPriceDidChange,
      shouldFocusName: (beer.focusName || isLastElement && !beer.id),
      shouldFocusPrice: beer.focusPrice,
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
          onClick={onAddBeer}
          className="btn btn-success">
          <span className="glyphicon glyphicon-plus"></span>
        </button>
      </div>
    </div>
  );
};
