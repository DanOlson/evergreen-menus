import createInput from './BeerInput';

export default React => (props) => {
  const BeerInput = createInput(React);
  const { onRemoveBeer, onBeerDidChange } = props;
  const onAddBeer = (event) => {
    event.preventDefault();
    props.onAddBeer();
  };
  const inputs = props.beers.map((beer, index) => {
    return <BeerInput
             beer={beer}
             index={index}
             onRemoveBeer={onRemoveBeer}
             onBlur={onBeerDidChange}
             key={`${beer}-${index}`}
           />;
  });

  return (
    <div className='establishment-beer-list'>
      {inputs}
      <button data-test="add-beer" onClick={onAddBeer}>Add Beer</button>
    </div>
  );
};