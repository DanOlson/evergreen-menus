import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Panel from '../shared/Panel'
const FB_TAB_WIDTH = 820

class Preview extends Component {
  constructor (props) {
    super(props)

    this.setWidth = this.setWidth.bind(this)
    this.state = {
      width: 100
    }
  }

  setWidth (obj) {
    this.width = obj.offsetWidth
  }

  componentDidMount () {
    this.setState({ width: this.width })
  }

  componentWillReceiveProps (nextProps) {
    if (this.props !== nextProps && !!this.width) {
      this.setState({ width: this.width })
    }
  }

  render () {
    const { width } = this.state
    const scale = width / FB_TAB_WIDTH
    return (
      <Panel className='sticky-top' title='Preview' onToggleHelp={this.handleToggleHelp}>
        <div className='menu-preview-wrapper' ref={this.setWidth}>
          <object
            data={this.props.previewPath}
            type='text/html'
            height='600'
            style={{ width: FB_TAB_WIDTH, transform: `translate(-19%, -19%) scale(${scale})` }}
            data-test='online-menu-preview' />
        </div>
      </Panel>
    )
  }
}

Preview.propTypes = {
  previewPath: PropTypes.string.isRequired
}

export default Preview
