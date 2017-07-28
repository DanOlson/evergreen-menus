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
  return `menu[menu_lists_attributes][${num}]`;
}

function buildMenuListId(list, index) {
  const listRep = buildMenuListRep(index);
  return `${listRep}[id]=${list.menu_list_id}`;
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

function generatePreviewPath(menu, formState) {
  const { lists, name, font } = formState;
  const { previewPath, id } = menu;
  const seed = `?menu[name]=${name}&menu[font]=${font}`;
  const queryString = buildQueryString(lists, seed);
  if (id) {
    return previewPath + queryString + `&menu[id]=${id}`;
  } else {
    return previewPath + queryString;
  }
}

export default generatePreviewPath;
