/******/ (function(modules) { // webpackBootstrap
/******/ 	// install a JSONP callback for chunk loading
/******/ 	function webpackJsonpCallback(data) {
/******/ 		var chunkIds = data[0];
/******/ 		var moreModules = data[1];
/******/ 		var executeModules = data[2];
/******/
/******/ 		// add "moreModules" to the modules object,
/******/ 		// then flag all "chunkIds" as loaded and fire callback
/******/ 		var moduleId, chunkId, i = 0, resolves = [];
/******/ 		for(;i < chunkIds.length; i++) {
/******/ 			chunkId = chunkIds[i];
/******/ 			if(installedChunks[chunkId]) {
/******/ 				resolves.push(installedChunks[chunkId][0]);
/******/ 			}
/******/ 			installedChunks[chunkId] = 0;
/******/ 		}
/******/ 		for(moduleId in moreModules) {
/******/ 			if(Object.prototype.hasOwnProperty.call(moreModules, moduleId)) {
/******/ 				modules[moduleId] = moreModules[moduleId];
/******/ 			}
/******/ 		}
/******/ 		if(parentJsonpFunction) parentJsonpFunction(data);
/******/
/******/ 		while(resolves.length) {
/******/ 			resolves.shift()();
/******/ 		}
/******/
/******/ 		// add entry modules from loaded chunk to deferred list
/******/ 		deferredModules.push.apply(deferredModules, executeModules || []);
/******/
/******/ 		// run deferred modules when all chunks ready
/******/ 		return checkDeferredModules();
/******/ 	};
/******/ 	function checkDeferredModules() {
/******/ 		var result;
/******/ 		for(var i = 0; i < deferredModules.length; i++) {
/******/ 			var deferredModule = deferredModules[i];
/******/ 			var fulfilled = true;
/******/ 			for(var j = 1; j < deferredModule.length; j++) {
/******/ 				var depId = deferredModule[j];
/******/ 				if(installedChunks[depId] !== 0) fulfilled = false;
/******/ 			}
/******/ 			if(fulfilled) {
/******/ 				deferredModules.splice(i--, 1);
/******/ 				result = __webpack_require__(__webpack_require__.s = deferredModule[0]);
/******/ 			}
/******/ 		}
/******/ 		return result;
/******/ 	}
/******/
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// object to store loaded and loading chunks
/******/ 	// undefined = chunk not loaded, null = chunk preloaded/prefetched
/******/ 	// Promise = chunk loading, 0 = chunk loaded
/******/ 	var installedChunks = {
/******/ 		"google-match-locations": 0
/******/ 	};
/******/
/******/ 	var deferredModules = [];
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, { enumerable: true, get: getter });
/******/ 		}
/******/ 	};
/******/
/******/ 	// define __esModule on exports
/******/ 	__webpack_require__.r = function(exports) {
/******/ 		if(typeof Symbol !== 'undefined' && Symbol.toStringTag) {
/******/ 			Object.defineProperty(exports, Symbol.toStringTag, { value: 'Module' });
/******/ 		}
/******/ 		Object.defineProperty(exports, '__esModule', { value: true });
/******/ 	};
/******/
/******/ 	// create a fake namespace object
/******/ 	// mode & 1: value is a module id, require it
/******/ 	// mode & 2: merge all properties of value into the ns
/******/ 	// mode & 4: return value when already ns object
/******/ 	// mode & 8|1: behave like require
/******/ 	__webpack_require__.t = function(value, mode) {
/******/ 		if(mode & 1) value = __webpack_require__(value);
/******/ 		if(mode & 8) return value;
/******/ 		if((mode & 4) && typeof value === 'object' && value && value.__esModule) return value;
/******/ 		var ns = Object.create(null);
/******/ 		__webpack_require__.r(ns);
/******/ 		Object.defineProperty(ns, 'default', { enumerable: true, value: value });
/******/ 		if(mode & 2 && typeof value != 'string') for(var key in value) __webpack_require__.d(ns, key, function(key) { return value[key]; }.bind(null, key));
/******/ 		return ns;
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/ 	var jsonpArray = window["webpackJsonp"] = window["webpackJsonp"] || [];
/******/ 	var oldJsonpFunction = jsonpArray.push.bind(jsonpArray);
/******/ 	jsonpArray.push = webpackJsonpCallback;
/******/ 	jsonpArray = jsonpArray.slice();
/******/ 	for(var i = 0; i < jsonpArray.length; i++) webpackJsonpCallback(jsonpArray[i]);
/******/ 	var parentJsonpFunction = oldJsonpFunction;
/******/
/******/
/******/ 	// add entry module to deferred list
/******/ 	deferredModules.push(["./app/assets/javascripts/google-match-locations.js","vendor"]);
/******/ 	// run deferred modules when ready
/******/ 	return checkDeferredModules();
/******/ })
/************************************************************************/
/******/ ({

/***/ "./app/assets/javascripts/facebook-match-pages/EstablishmentSelect.js":
/*!****************************************************************************!*\
  !*** ./app/assets/javascripts/facebook-match-pages/EstablishmentSelect.js ***!
  \****************************************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _react = __webpack_require__(/*! react */ "./node_modules/react/index.js");

var _react2 = _interopRequireDefault(_react);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _toConsumableArray(arr) { if (Array.isArray(arr)) { for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) { arr2[i] = arr[i]; } return arr2; } else { return Array.from(arr); } }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var EstablishmentSelect = function (_PureComponent) {
  _inherits(EstablishmentSelect, _PureComponent);

  function EstablishmentSelect() {
    _classCallCheck(this, EstablishmentSelect);

    return _possibleConstructorReturn(this, (EstablishmentSelect.__proto__ || Object.getPrototypeOf(EstablishmentSelect)).apply(this, arguments));
  }

  _createClass(EstablishmentSelect, [{
    key: 'render',
    value: function render() {
      var _props = this.props,
          establishments = _props.establishments,
          onChange = _props.onChange,
          selected = _props.selected;

      var options = establishments.map(function (est) {
        return _react2.default.createElement(
          'option',
          { value: est.id, key: est.id },
          est.name
        );
      });
      var blank = _react2.default.createElement('option', { value: null, key: 'null' });

      return _react2.default.createElement(
        'select',
        { defaultValue: selected && selected.id, className: 'form-control', onChange: onChange },
        [blank].concat(_toConsumableArray(options))
      );
    }
  }]);

  return EstablishmentSelect;
}(_react.PureComponent);

exports.default = EstablishmentSelect;

/***/ }),

/***/ "./app/assets/javascripts/google-match-locations.js":
/*!**********************************************************!*\
  !*** ./app/assets/javascripts/google-match-locations.js ***!
  \**********************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


var _react = __webpack_require__(/*! react */ "./node_modules/react/index.js");

var _react2 = _interopRequireDefault(_react);

var _reactDom = __webpack_require__(/*! react-dom */ "./node_modules/react-dom/index.js");

var _App = __webpack_require__(/*! ./google-match-locations/App */ "./app/assets/javascripts/google-match-locations/App.js");

var _App2 = _interopRequireDefault(_App);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

(function bootstrap() {
  var root = document.getElementById('google-match-locations-app-root');

  (0, _reactDom.render)(_react2.default.createElement(_App2.default, window._EVERGREEN), root);
})();

/***/ }),

/***/ "./app/assets/javascripts/google-match-locations/App.js":
/*!**************************************************************!*\
  !*** ./app/assets/javascripts/google-match-locations/App.js ***!
  \**************************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _react = __webpack_require__(/*! react */ "./node_modules/react/index.js");

var _react2 = _interopRequireDefault(_react);

var _propTypes = __webpack_require__(/*! prop-types */ "./node_modules/prop-types/index.js");

var _propTypes2 = _interopRequireDefault(_propTypes);

var _Panel = __webpack_require__(/*! ../shared/Panel */ "./app/assets/javascripts/shared/Panel.js");

var _Panel2 = _interopRequireDefault(_Panel);

var _Location = __webpack_require__(/*! ./Location */ "./app/assets/javascripts/google-match-locations/Location.js");

var _Location2 = _interopRequireDefault(_Location);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var App = function (_Component) {
  _inherits(App, _Component);

  function App() {
    _classCallCheck(this, App);

    return _possibleConstructorReturn(this, (App.__proto__ || Object.getPrototypeOf(App)).apply(this, arguments));
  }

  _createClass(App, [{
    key: 'renderLocations',
    value: function renderLocations() {
      var _props = this.props,
          locations = _props.locations,
          establishments = _props.establishments,
          updateAssociationPath = _props.updateAssociationPath,
          csrfToken = _props.csrfToken;


      return locations.map(function (location) {
        return _react2.default.createElement(_Location2.default, {
          location: location,
          establishmentOpts: establishments,
          updateAssociationPath: updateAssociationPath,
          csrfToken: csrfToken,
          key: location.name
        });
      });
    }
  }, {
    key: 'render',
    value: function render() {
      var locations = this.renderLocations();
      return _react2.default.createElement(
        _Panel2.default,
        { title: 'Associate Google My Business Locations' },
        _react2.default.createElement(
          'table',
          { className: 'table' },
          _react2.default.createElement(
            'thead',
            null,
            _react2.default.createElement(
              'tr',
              null,
              _react2.default.createElement(
                'th',
                null,
                'Location'
              ),
              _react2.default.createElement(
                'th',
                null,
                'Establishment'
              ),
              _react2.default.createElement(
                'th',
                null,
                'Linked'
              ),
              _react2.default.createElement(
                'th',
                null,
                'Action'
              )
            )
          ),
          _react2.default.createElement(
            'tbody',
            null,
            locations
          )
        )
      );
    }
  }]);

  return App;
}(_react.Component);

App.propTypes = {
  locations: _propTypes2.default.array.isRequired,
  establishments: _propTypes2.default.array.isRequired,
  updateAssociationPath: _propTypes2.default.string.isRequired,
  csrfToken: _propTypes2.default.string.isRequired
};

exports.default = App;

/***/ }),

/***/ "./app/assets/javascripts/google-match-locations/Location.js":
/*!*******************************************************************!*\
  !*** ./app/assets/javascripts/google-match-locations/Location.js ***!
  \*******************************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _react = __webpack_require__(/*! react */ "./node_modules/react/index.js");

var _react2 = _interopRequireDefault(_react);

var _propTypes = __webpack_require__(/*! prop-types */ "./node_modules/prop-types/index.js");

var _propTypes2 = _interopRequireDefault(_propTypes);

var _EstablishmentSelect = __webpack_require__(/*! ../facebook-match-pages/EstablishmentSelect */ "./app/assets/javascripts/facebook-match-pages/EstablishmentSelect.js");

var _EstablishmentSelect2 = _interopRequireDefault(_EstablishmentSelect);

__webpack_require__(/*! whatwg-fetch */ "./node_modules/whatwg-fetch/fetch.js");

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var nullEstablishment = { id: '' };

var Location = function (_Component) {
  _inherits(Location, _Component);

  function Location(props) {
    _classCallCheck(this, Location);

    var _this = _possibleConstructorReturn(this, (Location.__proto__ || Object.getPrototypeOf(Location)).call(this, props));

    _this.handleLink = _this.handleLink.bind(_this);
    _this.handleEstablishmentChange = _this.handleEstablishmentChange.bind(_this);

    var selectedEstablishment = props.establishmentOpts.find(function (e) {
      return e.google_my_business_location_id === props.location.name;
    }) || nullEstablishment;
    _this.state = {
      persistedSelectedEstablishmentId: selectedEstablishment.id.toString(),
      selectedEstablishment: selectedEstablishment
    };
    return _this;
  }

  _createClass(Location, [{
    key: 'handleLink',
    value: function handleLink(event) {
      var _this2 = this;

      event.preventDefault();
      var path = this.props.updateAssociationPath;
      var establishmentId = this.state.selectedEstablishment.id.toString();
      var locationId = this.props.location.name;
      var csrfToken = this.props.csrfToken;

      fetch(path, {
        credentials: 'same-origin', // send cookies
        method: 'post',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          authenticity_token: csrfToken,
          establishment_id: establishmentId,
          location_id: locationId
        })
      }).then(function (res) {
        if (res.ok) {
          _this2.setState(function () {
            return {
              persistedSelectedEstablishmentId: establishmentId
            };
          });
        }
      }).catch(console.error);
    }
  }, {
    key: 'handleEstablishmentChange',
    value: function handleEstablishmentChange(event) {
      var newValue = event.target.value;
      var selectedEstablishment = this.props.establishmentOpts.find(function (e) {
        return e.id.toString() === newValue;
      }) || nullEstablishment;

      this.setState(function () {
        return { selectedEstablishment: selectedEstablishment };
      });
    }
  }, {
    key: 'renderLinkStatus',
    value: function renderLinkStatus() {
      if (this.isAssociationDirty()) {
        return _react2.default.createElement('i', { className: 'fas fa-2x fa-times status-unlinked', 'aria-hidden': true, title: 'Not Linked' });
      } else {
        return _react2.default.createElement('i', { className: 'fas fa-2x fa-check status-linked', 'aria-hidden': true, title: 'Linked' });
      }
    }
  }, {
    key: 'renderActionButton',
    value: function renderActionButton() {
      if (!this.isEstablishmentLinked()) return;
      if (this.isAssociationDirty()) {
        return _react2.default.createElement(
          'a',
          {
            href: '',
            onClick: this.handleLink,
            className: 'btn btn-evrgn-primary' },
          'Link'
        );
      }
    }
  }, {
    key: 'isAssociationDirty',
    value: function isAssociationDirty() {
      var _state = this.state,
          persistedSelectedEstablishmentId = _state.persistedSelectedEstablishmentId,
          selectedEstablishment = _state.selectedEstablishment;

      return persistedSelectedEstablishmentId !== selectedEstablishment.id.toString();
    }
  }, {
    key: 'isEstablishmentLinked',
    value: function isEstablishmentLinked() {
      var _state2 = this.state,
          persistedSelectedEstablishmentId = _state2.persistedSelectedEstablishmentId,
          selectedEstablishment = _state2.selectedEstablishment;

      return !!(persistedSelectedEstablishmentId || selectedEstablishment.id);
    }
  }, {
    key: 'render',
    value: function render() {
      var _props = this.props,
          location = _props.location,
          establishmentOpts = _props.establishmentOpts;
      var selectedEstablishment = this.state.selectedEstablishment;

      var linkStatus = this.renderLinkStatus();
      var actionButton = this.renderActionButton();
      return _react2.default.createElement(
        'tr',
        null,
        _react2.default.createElement(
          'td',
          null,
          _react2.default.createElement(
            'h4',
            { className: 'my-auto' },
            _react2.default.createElement('i', { className: 'google-icon fab fa-2x fa-google', 'aria-hidden': true }),
            _react2.default.createElement(
              'span',
              { className: 'location-name' },
              location.location_name
            )
          )
        ),
        _react2.default.createElement(
          'td',
          null,
          _react2.default.createElement(
            'div',
            { className: 'form-group my-auto' },
            _react2.default.createElement(_EstablishmentSelect2.default, {
              establishments: establishmentOpts,
              selected: selectedEstablishment,
              onChange: this.handleEstablishmentChange
            })
          )
        ),
        _react2.default.createElement(
          'td',
          null,
          linkStatus
        ),
        _react2.default.createElement(
          'td',
          null,
          actionButton
        )
      );
    }
  }]);

  return Location;
}(_react.Component);

Location.defaultProps = {
  establishmentOpts: []
};

Location.propTypes = {
  establishmentOpts: _propTypes2.default.array,
  location: _propTypes2.default.object.isRequired,
  updateAssociationPath: _propTypes2.default.string.isRequired,
  csrfToken: _propTypes2.default.string.isRequired
};

exports.default = Location;

/***/ }),

/***/ "./app/assets/javascripts/shared/HelpIcon.js":
/*!***************************************************!*\
  !*** ./app/assets/javascripts/shared/HelpIcon.js ***!
  \***************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _react = __webpack_require__(/*! react */ "./node_modules/react/index.js");

var _react2 = _interopRequireDefault(_react);

var _propTypes = __webpack_require__(/*! prop-types */ "./node_modules/prop-types/index.js");

var _propTypes2 = _interopRequireDefault(_propTypes);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var HelpIcon = function (_Component) {
  _inherits(HelpIcon, _Component);

  function HelpIcon() {
    _classCallCheck(this, HelpIcon);

    return _possibleConstructorReturn(this, (HelpIcon.__proto__ || Object.getPrototypeOf(HelpIcon)).apply(this, arguments));
  }

  _createClass(HelpIcon, [{
    key: 'render',
    value: function render() {
      var _props = this.props,
          onClick = _props.onClick,
          className = _props.className;

      return _react2.default.createElement(
        'div',
        { className: className },
        _react2.default.createElement('i', {
          className: 'far fa-question-circle fa-2x help-icon',
          'aria-hidden': 'true',
          'data-test': 'help-icon',
          onClick: onClick })
      );
    }
  }]);

  return HelpIcon;
}(_react.Component);

HelpIcon.defaultProps = {
  onClick: function onClick() {},
  className: ''
};

HelpIcon.propTypes = {
  onClick: _propTypes2.default.func,
  className: _propTypes2.default.string
};

exports.default = HelpIcon;

/***/ }),

/***/ "./app/assets/javascripts/shared/Panel.js":
/*!************************************************!*\
  !*** ./app/assets/javascripts/shared/Panel.js ***!
  \************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _react = __webpack_require__(/*! react */ "./node_modules/react/index.js");

var _react2 = _interopRequireDefault(_react);

var _propTypes = __webpack_require__(/*! prop-types */ "./node_modules/prop-types/index.js");

var _propTypes2 = _interopRequireDefault(_propTypes);

var _HelpIcon = __webpack_require__(/*! ./HelpIcon */ "./app/assets/javascripts/shared/HelpIcon.js");

var _HelpIcon2 = _interopRequireDefault(_HelpIcon);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var Panel = function (_Component) {
  _inherits(Panel, _Component);

  function Panel() {
    _classCallCheck(this, Panel);

    return _possibleConstructorReturn(this, (Panel.__proto__ || Object.getPrototypeOf(Panel)).apply(this, arguments));
  }

  _createClass(Panel, [{
    key: 'render',
    value: function render() {
      var _props = this.props,
          dataTest = _props.dataTest,
          title = _props.title,
          children = _props.children,
          className = _props.className,
          headerContent = _props.headerContent,
          onToggleHelp = _props.onToggleHelp,
          icon = _props.icon;


      var helpIcon = void 0,
          headerIcon = void 0;
      if (onToggleHelp) {
        helpIcon = _react2.default.createElement(_HelpIcon2.default, { className: 'float-right', onClick: onToggleHelp });
      }
      if (icon) {
        headerIcon = _react2.default.createElement('span', { className: 'panel-header-icon ' + icon });
      }
      return _react2.default.createElement(
        'div',
        { className: 'card ' + className, 'data-test': dataTest },
        _react2.default.createElement(
          'div',
          { className: 'card-header' },
          helpIcon,
          _react2.default.createElement(
            'h3',
            { className: 'card-title' },
            headerIcon,
            title,
            headerContent
          )
        ),
        _react2.default.createElement(
          'div',
          { className: 'card-body' },
          children
        )
      );
    }
  }]);

  return Panel;
}(_react.Component);

Panel.defaultProps = {
  className: ''
};

Panel.propTypes = {
  dataTest: _propTypes2.default.string,
  title: _propTypes2.default.string.isRequired,
  className: _propTypes2.default.string,
  headerContent: _propTypes2.default.element,
  onToggleHelp: _propTypes2.default.func,
  icon: _propTypes2.default.string
};

exports.default = Panel;

/***/ })

/******/ });
//# sourceMappingURL=google-match-locations.js.map