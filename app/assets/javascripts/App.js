import createInput from './BeerInput';
import debounce from 'lodash/debounce';

export default React => (props) => {
  const BeerInput = createInput(React);
  const { onRemoveBeer, onKeepBeer, onBeerDidChange } = props;
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
      onChange: debounce(onBeerDidChange, 1000),
      shouldFocus: isLastElement,
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
