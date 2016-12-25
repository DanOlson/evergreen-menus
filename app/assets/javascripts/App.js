import createInput from './beer-input';

export default React => (props) => {
  const BeerInput = createInput(React);
  const inputs = props.beers.map((beer, index) => {
    return <BeerInput beer={beer} index={index} key={`${beer}-${index}`} />;
  });

  return (
    <div className='establishment-beer-list'>
      {inputs}
    </div>
  );
};
