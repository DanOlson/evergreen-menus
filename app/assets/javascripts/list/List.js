import React, { Component } from 'react'
import PropTypes from 'prop-types'
import ListItemInputGroup from './ListItemInputGroup'
import TypeSelect from './TypeSelect'
import Panel from '../shared/Panel'
import { DragDropContext } from 'react-dnd'
import HTML5Backend from 'react-dnd-html5-backend'
import { applyAssign } from '../polyfills/Object'
import { applyFind, applyIncludes } from '../polyfills/Array'

applyAssign()
applyFind()
applyIncludes()

class List extends Component {
  constructor (props) {
    super(props)
    const { name, type, description, notes } = props
    this.state = {
      beers: this.sortBeers(this.props.beers),
      name,
      type,
      description,
      notes
    }
    this.deleteBeer = this.deleteBeer.bind(this)
    this.addBeer = this.addBeer.bind(this)
    this.handleTypeChange = this.handleTypeChange.bind(this)
    this.reorderItems = this.reorderItems.bind(this)
  }

  reorderItems (dragIndex, hoverIndex) {
    this.setState(prevState => {
      const items = prevState.beers
      const dragItem = items[dragIndex]
      const newItems = [...items]
      newItems.splice(dragIndex, 1)
      newItems.splice(hoverIndex, 0, dragItem)
      return { beers: newItems }
    })
  }

  sortBeers (beers) {
    const sorted = beers.sort((a, b) => {
      const aPos = a.position
      const bPos = b.position
      if (aPos > bPos) return 1
      if (aPos < bPos) return -1
      return 0
    })
    return this.applyAppId(sorted)
  }

  applyAppId (items) {
    return items.map((item, index) => {
      item.appId = index
      return item
    })
  }

  handleTypeChange (newType) {
    const type = newType.value
    this.setState(prevState => {
      return { type }
    })
  }

  deleteBeer (beerAppId) {
    const beers = this.state.beers
    const newBeerList = beers.filter(beer => beer.appId !== beerAppId)
    this.setState({ beers: newBeerList })
  }

  addBeer (event) {
    event.preventDefault()
    const beers = this.state.beers
    const nextAppId = beers.length
    const nextPosition = beers.length - 1
    const newBeer = { appId: nextAppId, position: nextPosition }
    this.setState({ beers: [...beers, newBeer] })
  }

  render () {
    const { listId, typeOptions, menuItemLabels } = this.props
    const { name, type, description, notes } = this.state
    const inputs = this.state.beers.map((beer, index, array) => {
      const listItemInputProps = {
        beer,
        listId,
        menuItemLabels,
        index,
        moveItem: this.reorderItems,
        deleteBeer: this.deleteBeer,
        key: beer.appId,
        isActive: !beer.id && beer.appId === array.length - 1 // last unsaved list item gets autofocused
      }

      return <ListItemInputGroup {...listItemInputProps} />
    })

    return (
      <Panel title={name}>
        <div className='establishment-beer-list'>
          <div className='form-group'>
            <div className='form-row'>
              <div className='col-sm-4'>
                <label htmlFor='list_name'>List Name</label>
                <input
                  type='text'
                  name='list[name]'
                  id='list_name'
                  className='form-control'
                  data-test='list-name'
                  defaultValue={name}
                />
              </div>

              <TypeSelect
                className='col-sm-2'
                options={typeOptions}
                value={type}
                onChange={this.handleTypeChange}
              />
            </div>

            <div className='form-row'>
              <div className='col-sm-6 list-description-input'>
                <label htmlFor='list_description'>Description</label>
                <textarea
                  name='list[description]'
                  id='list_description'
                  className='form-control'
                  data-test='list-description'
                  defaultValue={description}
                  aria-describedby='list-description-help-text'
                />
                <small id='list-description-help-text' className='form-text text-muted'>
                  (Optional) Use this to describe your list. You might use this to describe your
                  ingredients or cooking methods, or that each item includes your choice of sides.
                  Appears below the list name on a menu.
                </small>
              </div>
              <div className='col-sm-6 list-description-input'>
                <label htmlFor='list_notes'>Notes</label>
                <textarea
                  name='list[notes]'
                  id='list_notes'
                  className='form-control'
                  data-test='list-notes'
                  defaultValue={notes}
                  aria-describedby='list-notes-help-text'
                />
                <small id='list-notes-help-text' className='form-text text-muted'>
                  (Optional) Notes typically appear below a list on a menu. You might use
                  this to warn customers about consuming raw or undercooked meat, for example.
                </small>
              </div>
            </div>
          </div>
          <div className='form-group'>
            {inputs}
          </div>
          <div className='form-group'>
            <button
              data-test='add-beer'
              id='add-beer-button'
              title='Add item'
              onClick={this.addBeer}
              className='btn btn-success'>
              <span className='fas fa-plus fa-lg' />
            </button>
          </div>
        </div>
      </Panel>
    )
  }
}

List.propTypes = {
  beers: PropTypes.array.isRequired,
  name: PropTypes.string.isRequired,
  description: PropTypes.string,
  typeOptions: PropTypes.array.isRequired,
  menuItemLabels: PropTypes.array.isRequired,
  listId: PropTypes.number
}

export default DragDropContext(HTML5Backend)(List)
