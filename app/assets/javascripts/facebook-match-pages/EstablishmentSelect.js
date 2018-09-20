import React, { PureComponent } from 'react'

export default class EstablishmentSelect extends PureComponent {
  render () {
    const { establishments, onChange, selected } = this.props
    const options = establishments.map(est => {
      return <option value={est.id} key={est.id}>{est.name}</option>
    })
    const blank = <option value={null} key='null' />

    return (
      <select defaultValue={selected && selected.id} className='form-control' onChange={onChange}>
        {[blank, ...options]}
      </select>
    )
  }
}
