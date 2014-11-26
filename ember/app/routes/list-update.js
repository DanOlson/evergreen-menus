import AuthenticatedRoute from '../routes/authenticated';
import ResetScroll from '../mixins/reset-scroll';

var ListUpdateRoute = AuthenticatedRoute.extend(ResetScroll, {
  model: function(params){
    return this.store.find('list_update', params.id);
  }
});

export default ListUpdateRoute;
