import AuthenticatedRoute from '../routes/authenticated';

var ListUpdatesRoute = AuthenticatedRoute.extend({
  model: function(params){
    var rest;
    if(params){
      rest = {
        establishment_id: params.establishmentId,
        status: params.status,
        start_date: params.startDate,
        end_date: params.endDate
      };
    }
    return this.store.find('list_update', rest);
  },

  actions: {
    queryParamsDidChange: function(){
      this.refresh();
    }
  }
});

export default ListUpdatesRoute;
