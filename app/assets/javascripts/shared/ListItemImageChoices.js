import React, { Component } from 'react'
import PropTypes from 'prop-types'

class ListItemImageChoices extends Component {
  constructor (props) {
    super(props)
    this.onChange = this.onChange.bind(this)
  }

  onChange (event) {
    const itemId = Number(event.target.value)
    const { chosenItemIds } = this.props
    console.log(itemId)
    console.log(chosenItemIds)
    let itemIds
    if (chosenItemIds.includes(itemId)) {
      itemIds = chosenItemIds.filter(id => id !== itemId)
    } else {
      itemIds = chosenItemIds.concat([itemId])
    }
    console.log(`newIds: ${itemIds}`)
    this.props.onChange(itemIds)
  }

  render () {
    const {
      itemsWithAvailableImages,
      chosenItemIds,
      entityName,
      index,
      nestedAttrsName,
      show
    } = this.props
    const inputs = itemsWithAvailableImages.map((item, idx) => {
      const isChecked = chosenItemIds.includes(item.id)
      const htmlId = `show-image-${item.name}`
      return (
        <div className="list-item-image-choice" key={idx} data-test="list-item-image-option">
          <label
            htmlFor={htmlId}
            data-test="show-image-for-item">
            <input
              type="checkbox"
              data-test="image-option-input"
              value={item.id}
              name={`${entityName}[${nestedAttrsName}][${index}][items_with_images][]`}
              defaultChecked={isChecked}
              onChange={this.onChange}
              id={htmlId} />
            {item.name}
          </label>
        </div>
      )
    })
    if (show) {
      return (
        <div className="list-item-images-choices" data-test="list-item-image-choices">
          {inputs}
        </div>
      )
    } else {
      return null
    }
  }
}

ListItemImageChoices.defaultProps = {
  imagesWithAvailableImages: [],
  chosenItemIds: [],
  show: false
}

ListItemImageChoices.propTypes = {
  itemsWithAvailableImages: PropTypes.array,
  chosenItemIds: PropTypes.array,
  entityName: PropTypes.string.isRequired,
  nestedAttrsName: PropTypes.string.isRequired,
  index: PropTypes.number.isRequired,
  show: PropTypes.bool
}

export default ListItemImageChoices
