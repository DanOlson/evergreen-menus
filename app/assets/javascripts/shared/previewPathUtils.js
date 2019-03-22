import attributeNameResolver from './attributeNameResolver'

function shouldShowPrice (list) {
  if (list.show_price_on_menu === undefined) {
    return true
  } else {
    return list.show_price_on_menu
  }
}

function shouldShowDescription (list) {
  if (list.show_description_on_menu === undefined) {
    return true
  } else {
    return list.show_description_on_menu
  }
}

function shouldShowNotes (list) {
  if (list.show_notes_on_menu === undefined) {
    return true
  } else {
    return list.show_notes_on_menu
  }
}

export default function initUtils (menuType) {
  const nestedAttrsName = attributeNameResolver.resolveNestedAttrName(menuType)
  const entityName = attributeNameResolver.resolveEntityName(menuType)
  const nestedEntityIdName = attributeNameResolver.resolveNestedEntityIdName(menuType)

  function buildMenuListRep (num) {
    return `${entityName}[${nestedAttrsName}][${num}]`
  }

  return {
    buildMenuListDisplayName (list, index, displayName) {
      if (!displayName) return ''
      const listRep = buildMenuListRep(index)
      return `${listRep}[display_name]=${displayName}`
    },

    buildMenuListHtmlClasses (list, index, htmlClasses) {
      if (!htmlClasses) return ''
      const listRep = buildMenuListRep(index)
      return `${listRep}[html_classes]=${htmlClasses}`
    },

    buildMenuListItemsWithImages (list, index) {
      if (!list.items_with_images) return ''

      const listRep = buildMenuListRep(index)
      return list.items_with_images.map(itemId => {
        return `${listRep}[items_with_images][]=${itemId}`
      }).join('&')
    },

    buildMenuListShowPrice (list, index) {
      const listRep = buildMenuListRep(index)
      const showPrice = shouldShowPrice(list)
      return `${listRep}[show_price_on_menu]=${showPrice}`
    },

    buildMenuListShowDescription (list, index) {
      const listRep = buildMenuListRep(index)
      const showDesc = shouldShowDescription(list)
      return `${listRep}[show_description_on_menu]=${showDesc}`
    },

    buildMenuListShowNotes (list, index) {
      const listRep = buildMenuListRep(index)
      const showNotes = shouldShowNotes(list)
      return `${listRep}[show_notes_on_menu]=${showNotes}`
    },

    buildMenuListPosition (list, index) {
      const listRep = buildMenuListRep(index)
      return `${listRep}[position]=${index}`
    },

    buildMenuListListId (list, index) {
      const listRep = buildMenuListRep(index)
      return `${listRep}[list_id]=${list.id}`
    },

    buildMenuListId (list, index) {
      const listRep = buildMenuListRep(index)
      return `${listRep}[id]=${list[nestedEntityIdName]}`
    }
  }
}
