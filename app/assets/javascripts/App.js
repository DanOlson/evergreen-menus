import createInput from './beer-input';

export default React => (props) => {
  const inputs = props.beers.map((beer, index) => {
    const BeerInput = createInput(React);
    return <BeerInput beer={beer} index={index} />;
  })
  return (
    <div className='establishment-beer-list'>
      {inputs}
    </div>
  );
};
