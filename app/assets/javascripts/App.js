import createInput from './BeerInput';

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
      onChange: onBeerDidChange,
      shouldFocus: isLastElement,
      key: `${beer}-${index}`
    };

    return <BeerInput {...beerInputProps} />;
  });

  return (
    <div className='establishment-beer-list'>
      {inputs}
      <button data-test="add-beer" onClick={onAddBeer}>Add Beer</button>
    </div>
  );
};
