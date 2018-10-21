import initPreviewUtils from '../shared/previewPathUtils'

const {
  buildMenuListId,
  buildMenuListListId,
  buildMenuListPosition,
  buildMenuListShowPrice,
  buildMenuListItemsWithImages,
  buildMenuListDisplayName
} = initPreviewUtils('pdf')

function buildQueryString (lists, base) {
  return lists.reduce((acc, list, idx) => {
    let params = [
      buildMenuListListId(list, idx),
      buildMenuListPosition(list, idx),
      buildMenuListShowPrice(list, idx),
      buildMenuListItemsWithImages(list, idx),
      buildMenuListDisplayName(list, idx, list.displayName)
    ]
    if (list.menu_list_id) {
      params.push(buildMenuListId(list, idx))
    }
    return acc + '&' + params.join('&')
  }, base)
}

function generatePreviewPath (menu, formState) {
  const {
    lists,
    name,
    font,
    fontSize,
    numberOfColumns,
    template,
    availabilityStartTime,
    availabilityEndTime,
    restrictedAvailability,
    showLogo
  } = formState
  const { previewPath, id } = menu
  const seed = [
    `?menu[name]=${name}`,
    `menu[template]=${template}`,
    `menu[font]=${font}`,
    `menu[font_size]=${fontSize}`,
    `menu[number_of_columns]=${numberOfColumns}`,
    `menu[availability_start_time]=${availabilityStartTime}`,
    `menu[availability_end_time]=${availabilityEndTime}`,
    `menu[restricted_availability]=${restrictedAvailability}`,
    `menu[show_logo]=${showLogo}`
  ].join('&')
  const queryString = buildQueryString(lists, seed)
  if (id) {
    return previewPath + queryString + `&menu[id]=${id}`
  } else {
    return previewPath + queryString
  }
}

export default generatePreviewPath
