import React, { Component } from 'react';
import PropTypes from 'prop-types';
import WebMenu from './WebMenu';

class WebMenusApp extends Component {
  render() {
    const menus = this.props.webMenus.map(webMenu => {
      return (
        <WebMenu
          name={webMenu.name}
          editPath={webMenu.editPath}
          embedCode={webMenu.embedCode}
          canShowCode={!!webMenu.embedCode}
          key={webMenu.id}
        />
      );
    });

    return (
      <div className="list-group">
        {menus}
      </div>
    );
  }
}

WebMenusApp.propTypes = {
  webMenus: PropTypes.array.isRequired
}

export default WebMenusApp;
