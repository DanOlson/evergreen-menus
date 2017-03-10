import debounce from 'lodash/debounce'

export default React => (props) => {
  let actionable;
  const { beer, onRemoveBeer, onKeepBeer, shouldFocusName, shouldFocusPrice } = props;
  const { appId }        = beer;
  const className        = beer.markedForRemoval ? 'remove-beer' : '';
  const onNameChange     = debounce(props.onNameChange, 180);
  const onPriceChange    = debounce(props.onPriceChange, 10)
  const nameChangeProxy  = (event) => onNameChange(appId, event.target.value);
  const priceChangeProxy = (event) => onPriceChange(appId, event.target.value);
  const onRemove         = (event) => {
    event.preventDefault();
    onRemoveBeer(appId);
  };
  const onKeep = (event) => {
    event.preventDefault();
    onKeepBeer(appId);
  };

  if (beer.markedForRemoval) {
    actionable = (
      <a href=''
         onClick={onKeep}
         data-test={`keep-beer-${appId}`}
         className="btn btn-danger">Keep</a>
    )
  } else {
    actionable = (
      <a href=''
         onClick={onRemove}
         data-test={`remove-beer-${appId}`}
         className="btn btn-default">
        <span className="glyphicon glyphicon-remove"></span>
      </a>
    )
  }

  return (
    <div data-test={`beer-${appId}`} className={`${className} row`}>
      <div data-test="beer-input">
        <div className="col-sm-4">
          <input
            type="text"
            data-test={`beer-name-input-${appId}`}
            defaultValue={beer.name}
            onChange={nameChangeProxy}
            name={`establishment[beers_attributes][${appId}][name]`}
            id={`establishment_beers_attributes_${appId}_name`}
            className={`form-control ${className}`}
            autoFocus={shouldFocusName}
          />
        </div>
        <div className="col-sm-1">
          <input
            type="number"
            data-test={`beer-price-input-${appId}`}
            value={beer.price}
            onChange={priceChangeProxy}
            name={`establishment[beers_attributes][${appId}][price]`}
            id={`establishment_beers_attributes_${appId}_price`}
            className="form-control"
            autoFocus={shouldFocusPrice}
          />
        </div>
        <div className="col-sm-7">
          {actionable}
        </div>
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
