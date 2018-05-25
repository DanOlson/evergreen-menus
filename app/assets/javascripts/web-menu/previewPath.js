import initPreviewUtils from '../shared/previewPathUtils';

const {
  buildMenuListId,
  buildMenuListListId,
  buildMenuListPosition,
  buildMenuListShowPrice,
  buildMenuListShowDescription
} = initPreviewUtils('web');

function buildQueryString(lists, base) {
  return lists.reduce((acc, list, idx) => {
    let params = [
      buildMenuListListId(list, idx),
      buildMenuListPosition(list, idx),
      buildMenuListShowPrice(list, idx),
      buildMenuListShowDescription(list, idx)
    ];
    if (list.web_menu_list_id) {
      params.push(buildMenuListId(list, idx));
    }
    return acc + '&' + params.join('&');
  }, base);
}

function generatePreviewPath(webMenu, formState) {
  const {
    lists,
    name,
    restrictedAvailability,
    availabilityStartTime,
    availabilityEndTime
  } = formState;
  const { previewPath, id } = webMenu;
  const seed = [
    `?web_menu[name]=${name}`,
    `web_menu[restricted_availability]=${restrictedAvailability}`,
    `web_menu[availability_start_time]=${availabilityStartTime}`,
    `web_menu[availability_end_time]=${availabilityEndTime}`,
  ].join('&');
  const queryString = buildQueryString(lists, seed);
  if (id) {
    // Menu is already persisted
    return previewPath + queryString + `&web_menu[id]=${id}`;
  } else {
    // Menu is not yet saved
    return previewPath + queryString;
  }
}

export default generatePreviewPath;
