function shouldShowPrice(list) {
  if (list.show_price_on_menu === undefined) {
    return true;
  } else {
    return list.show_price_on_menu;
  }
}

function buildMenuListShowPrice(list, index) {
  const listRep = buildMenuListRep(index);
  const showPrice = shouldShowPrice(list);
  return `${listRep}[show_price_on_menu]=${showPrice}`;
}

function buildMenuListPosition(list, index) {
  const listRep = buildMenuListRep(index);
  return `${listRep}[position]=${index}`;
}

function buildMenuListListId(list, index) {
  const listRep = buildMenuListRep(index);
  return `${listRep}[list_id]=${list.id}`
}

function buildMenuListRep(num) {
  return `digital_display_menu[digital_display_menu_lists_attributes][${num}]`;
}

function buildMenuListId(list, index) {
  const listRep = buildMenuListRep(index);
  return `${listRep}[id]=${list.digital_display_menu_list_id}`;
}

function buildQueryString(lists, base) {
  return lists.reduce((acc, list, idx) => {
    let params = [
      buildMenuListListId(list, idx),
      buildMenuListPosition(list, idx),
      buildMenuListShowPrice(list, idx)
    ]
    if (list.menu_list_id) {
      params.push(buildMenuListId(list, idx));
    }
    return acc + '&' + params.join('&');
  }, base);
}

function generatePreviewPath(digitalDisplayMenu, formState) {
  const { lists, isHorizontal, rotationInterval } = formState;
  const { previewPath, id } = digitalDisplayMenu;
  const orientationParam = `digital_display_menu[horizontal_orientation]=${isHorizontal}`;
  const rotationIntervalParam = `digital_display_menu[rotation_interval]=${rotationInterval}`;
  const seed = `?${orientationParam}&${rotationIntervalParam}`;
  const queryString = buildQueryString(lists, seed);
  if (id) {
    // Menu is already persisted
    return previewPath + queryString + `&digital_display_menu[id]=${id}`;
  } else {
    // Menu is not yet saved
    return previewPath + queryString;
  }
}

export default generatePreviewPath;
