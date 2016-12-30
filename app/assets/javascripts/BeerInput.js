export default React => (props) => {
  const { beer, index, onRemoveBeer } = props;
  const className = beer.markedForRemoval ? 'remove-beer' : '';
  const inputTestValue = beer.id ? `beer-name-input-${beer.id}` : 'new-beer-input';
  const onRemove = (event) => {
    event.preventDefault();
    onRemoveBeer(beer.id);
  }

  return (
    <div data-test={`beer-${beer.id}`} className={className}>
      <div className="form-group" data-test="beer-name-input">
        <input
          type="text"
          data-test={inputTestValue}
          defaultValue={beer.name}
          name={`establishment[beers_attributes][${index}][name]`}
          id={`establishment_beers_attributes_${index}_name`}
        />
        <a href='' onClick={onRemove} data-test={`remove-beer-${beer.id}`}>Remove</a>
      </div>
      <input
        type="hidden"
        defaultValue={beer.id}
        name={`establishment[beers_attributes][${index}][id]`}
        id={`establishment_beers_attributes_${index}_id`}
      />
      <input
        type="hidden"
        defaultValue={beer.markedForRemoval}
        name={`establishment[beers_attributes][${index}][_destroy]`}
      />
    </div>
  );
};
