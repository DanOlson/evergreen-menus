import initPreviewUtils from '../shared/previewPathUtils'

const {
  buildMenuListId,
  buildMenuListListId,
  buildMenuListPosition,
  buildMenuListShowPrice,
  buildMenuListDisplayName
} = initPreviewUtils('digitalDisplay')

function buildQueryString (lists, base) {
  return lists.reduce((acc, list, idx) => {
    let params = [
      buildMenuListListId(list, idx),
      buildMenuListPosition(list, idx),
      buildMenuListShowPrice(list, idx),
      buildMenuListDisplayName(list, idx, list.displayName)
    ]
    if (list.menu_list_id) {
      params.push(buildMenuListId(list, idx))
    }
    return acc + '&' + params.join('&')
  }, base)
}

function generatePreviewPath (digitalDisplayMenu, formState) {
  const {
    lists,
    isHorizontal,
    rotationInterval,
    backgroundColor,
    textColor,
    listTitleColor,
    font,
    theme
  } = formState
  const { previewPath, id } = digitalDisplayMenu
  const orientationParam = `digital_display_menu[horizontal_orientation]=${isHorizontal}`
  const rotationIntervalParam = `digital_display_menu[rotation_interval]=${rotationInterval}`
  const backgroundColorParam = `digital_display_menu[background_color]=${encodeURIComponent(backgroundColor)}`
  const textColorParam = `digital_display_menu[text_color]=${encodeURIComponent(textColor)}`
  const listTitleColorParam = `digital_display_menu[list_title_color]=${encodeURIComponent(listTitleColor)}`
  const fontParam = `digital_display_menu[font]=${font}`
  const themeParam = `digital_display_menu[theme]=${theme}`
  const seed = '?' + [
    orientationParam,
    rotationIntervalParam,
    backgroundColorParam,
    textColorParam,
    listTitleColorParam,
    fontParam,
    themeParam
  ].join('&')
  const queryString = buildQueryString(lists, seed)
  if (id) {
    // Menu is already persisted
    return previewPath + queryString + `&digital_display_menu[id]=${id}`
  } else {
    // Menu is not yet saved
    return previewPath + queryString
  }
}

export default generatePreviewPath
