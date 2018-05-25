import attributeNameResolver from './attributeNameResolver';

function shouldShowPrice(list) {
  if (list.show_price_on_menu === undefined) {
    return true;
  } else {
    return list.show_price_on_menu;
  }
}

function shouldShowDescription(list) {
  if (list.show_description_on_menu === undefined) {
    return true;
  } else {
    return list.show_description_on_menu;
  }
}


export default function initUtils(menuType) {
  const nestedAttrsName = attributeNameResolver.resolveNestedAttrName(menuType);
  const entityName = attributeNameResolver.resolveEntityName(menuType);
  const nestedEntityIdName = attributeNameResolver.resolveNestedEntityIdName(menuType);

  function buildMenuListRep (num) {
    return `${entityName}[${nestedAttrsName}][${num}]`;
  }

  return {
    buildMenuListShowPrice (list, index) {
      const listRep = buildMenuListRep(index);
      const showPrice = shouldShowPrice(list);
      return `${listRep}[show_price_on_menu]=${showPrice}`;
    },

    buildMenuListShowDescription(list, index) {
      const listRep = buildMenuListRep(index);
      const showPrice = shouldShowDescription(list);
      return `${listRep}[show_description_on_menu]=${showPrice}`;
    },

    buildMenuListPosition (list, index) {
      const listRep = buildMenuListRep(index);
      return `${listRep}[position]=${index}`;
    },

    buildMenuListListId (list, index) {
      const listRep = buildMenuListRep(index);
      return `${listRep}[list_id]=${list.id}`
    },

    buildMenuListId (list, index) {
      const listRep = buildMenuListRep(index);
      return `${listRep}[id]=${list[nestedEntityIdName]}`;
    }
  }
}
