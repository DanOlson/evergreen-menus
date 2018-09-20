import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Panel from '../shared/Panel'

class MenuPreview extends Component {
  render () {
    return (
      <Panel className='sticky-top' title='Preview' dataTest='menu-preview'>
        <div className='menu-preview-wrapper'>
          <object
            data={this.props.previewPath}
            type='application/pdf'
            height='730'
            style={{ width: '100%' }}
            data-test='menu-pdf' />
        </div>
      </Panel>
    )
  }
}

MenuPreview.propTypes = {
  previewPath: PropTypes.string.isRequired
}

export default MenuPreview
