export default React => (props) => {
  const { beer, onRemoveBeer } = props;
  const { appId } = beer;
  const className = beer.markedForRemoval ? 'remove-beer' : '';
  const onBlur    = (event) => props.onBlur(appId, event.target.value);
  const onRemove  = (event) => {
    event.preventDefault();
    onRemoveBeer(appId);
  }

  return (
    <div data-test={`beer-${appId}`} className={className}>
      <div className="form-group" data-test="beer-name-input">
        <input
          type="text"
          data-test={`beer-name-input-${appId}`}
          defaultValue={beer.name}
          onBlur={onBlur}
          name={`establishment[beers_attributes][${appId}][name]`}
          id={`establishment_beers_attributes_${appId}_name`}
        />
        <a href='' onClick={onRemove} data-test={`remove-beer-${appId}`}>Remove</a>
      </div>
      <input
        type="hidden"
        defaultValue={beer.id}
        name={`establishment[beers_attributes][${appId}][id]`}
        id={`establishment_beers_attributes_${appId}_id`}
      />
      <input
        type="hidden"
        defaultValue={beer.markedForRemoval}
        name={`establishment[beers_attributes][${appId}][_destroy]`}
      />
    </div>
  );
};
