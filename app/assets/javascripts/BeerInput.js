export default React => (props) => {
  let actionable;
  const { beer, onRemoveBeer, onKeepBeer, shouldFocus } = props;
  const { appId } = beer;
  const className = beer.markedForRemoval ? 'remove-beer' : '';
  const onChange  = (event) => props.onChange(appId, event.target.value);
  const onRemove  = (event) => {
    event.preventDefault();
    onRemoveBeer(appId);
  };
  const onKeep = (event) => {
    event.preventDefault();
    onKeepBeer(appId);
  };

  if (beer.markedForRemoval) {
    actionable = (
      <a href='' onClick={onKeep} data-test={`keep-beer-${appId}`}>Keep</a>
    )
  } else {
    actionable = (
      <a href='' onClick={onRemove} data-test={`remove-beer-${appId}`}>Remove</a>
    )
  }

  return (
    <div data-test={`beer-${appId}`} className={className}>
      <div className="form-group" data-test="beer-name-input">
        <input
          type="text"
          data-test={`beer-name-input-${appId}`}
          defaultValue={beer.name}
          onChange={onChange}
          name={`establishment[beers_attributes][${appId}][name]`}
          id={`establishment_beers_attributes_${appId}_name`}
          autoFocus={shouldFocus}
        />
        {actionable}
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
