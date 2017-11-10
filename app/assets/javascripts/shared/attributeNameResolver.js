const attrNamesByMenuType = {
  pdf: 'menu_lists_attributes',
  digitalDisplay: 'digital_display_menu_lists_attributes',
  web: 'web_menu_lists_attributes'
};

const entityNamesByMenuType = {
  pdf: 'menu',
  digitalDisplay: 'digital_display_menu',
  web: 'web_menu'
};

const resolveEntityIdName = {
  pdf: 'menu_list_id',
  digitalDisplay: 'digital_display_menu_list_id',
  web: 'web_menu_list_id'
};

function resolveNestedAttrName(menuType) {
  return attrNamesByMenuType[menuType];
}

function resolveEntityName(menuType) {
  return entityNamesByMenuType[menuType];
}

function resolveNestedEntityIdName(menuType) {
  return resolveEntityIdName[menuType];
}

export default {
  resolveNestedAttrName,
  resolveEntityName,
  resolveNestedEntityIdName
};
