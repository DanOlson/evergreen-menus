import initPreviewUtils from '../shared/previewPathUtils';

const {
  buildMenuListId,
  buildMenuListListId,
  buildMenuListPosition,
  buildMenuListShowPrice,
  buildMenuListShowDescription
} = initPreviewUtils('google');

function buildQueryString(lists, base) {
  return lists.reduce((acc, list, idx) => {
    let params = [
      buildMenuListListId(list, idx),
      buildMenuListPosition(list, idx),
      buildMenuListShowPrice(list, idx),
      buildMenuListShowDescription(list, idx)
    ];
    if (list.google_menu_list_id) {
      params.push(buildMenuListId(list, idx));
    }
    return acc + '&' + params.join('&');
  }, base);
}

function generatePreviewPath(menu, formState) {
  const { lists } = formState;
  const { previewPath, id } = menu;
  const queryString = buildQueryString(lists, '?');
  if (id) {
    // Menu is already persisted
    return previewPath + queryString + `&google_menu[id]=${id}`;
  } else {
    // Menu is not yet saved
    return previewPath + queryString;
  }
}

export default generatePreviewPath;
