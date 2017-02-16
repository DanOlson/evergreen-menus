import debounce from 'lodash/debounce'

export default React => (props) => {
  let actionable;
  const { beer, onRemoveBeer, onKeepBeer, shouldFocus } = props;
  const { appId }   = beer;
  const className   = beer.markedForRemoval ? 'remove-beer' : '';
  const onChange    = debounce(props.onChange, 180);
  const changeProxy = (event) => onChange(appId, event.target.value);
  const onRemove    = (event) => {
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
      <div data-test="beer-name-input">
        <div className="col-sm-4">
          <input
            type="text"
            data-test={`beer-name-input-${appId}`}
            defaultValue={beer.name}
            onChange={changeProxy}
            name={`establishment[beers_attributes][${appId}][name]`}
            id={`establishment_beers_attributes_${appId}_name`}
            className={`form-control ${className}`}
            autoFocus={shouldFocus}
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
