export default React => (props) => {
  const { beer, index } = props;
  return (
    <div>
      <div className="form-group">
        <input
          type="text"
          data-test="beer"
          defaultValue={beer.name}
          name={`establishment[beers_attributes][${index}][name]`}
          id={`establishment_beers_attributes_${index}_name`} />
      </div>
      <input
        type="hidden"
        defaultValue={beer.id}
        name={`establishment[beers_attributes][${index}][id]`}
        id={`establishment_beers_attributes_${index}_id`} />
    </div>
  );
};
