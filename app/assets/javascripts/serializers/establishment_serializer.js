Beermapper.EstablishmentSerializer = DS.ActiveModelSerializer.extend(DS.EmbeddedRecordsMixin, {
  serialize: function(establishment, options){
    var json = this._super(establishment, options);
    json.scraper_id = establishment.get('scraper').get('id');
    return json;
  }
})
