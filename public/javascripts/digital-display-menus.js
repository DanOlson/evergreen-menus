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
/******/ 		"digital-display-menus": 0
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
/******/ 	deferredModules.push(["./app/assets/javascripts/digital-display-menus.js","vendor"]);
/******/ 	// run deferred modules when ready
/******/ 	return checkDeferredModules();
/******/ })
/************************************************************************/
/******/ ({

/***/ "./app/assets/javascripts/digital-display-menus.js":
/*!*********************************************************!*\
  !*** ./app/assets/javascripts/digital-display-menus.js ***!
  \*********************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


var _react = __webpack_require__(/*! react */ "./node_modules/react/index.js");

var _react2 = _interopRequireDefault(_react);

var _reactDom = __webpack_require__(/*! react-dom */ "./node_modules/react-dom/index.js");

var _DigitalDisplayApp = __webpack_require__(/*! ./digital-display/DigitalDisplayApp */ "./app/assets/javascripts/digital-display/DigitalDisplayApp.js");

var _DigitalDisplayApp2 = _interopRequireDefault(_DigitalDisplayApp);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

(function bootstrap() {
  var digitalDisplayRoot = document.getElementById('digital-display-app-root');

  (0, _reactDom.render)(_react2.default.createElement(_DigitalDisplayApp2.default, window._EVERGREEN), digitalDisplayRoot);
})();

/***/ }),

/***/ "./app/assets/javascripts/digital-display/DigitalDisplayApp.js":
/*!*********************************************************************!*\
  !*** ./app/assets/javascripts/digital-display/DigitalDisplayApp.js ***!
  \*********************************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _react = __webpack_require__(/*! react */ "./node_modules/react/index.js");

var _react2 = _interopRequireDefault(_react);

var _propTypes = __webpack_require__(/*! prop-types */ "./node_modules/prop-types/index.js");

var _propTypes2 = _interopRequireDefault(_propTypes);

var _Panel = __webpack_require__(/*! ../shared/Panel */ "./app/assets/javascripts/shared/Panel.js");

var _Panel2 = _interopRequireDefault(_Panel);

var _AvailableListGroup = __webpack_require__(/*! ../shared/AvailableListGroup */ "./app/assets/javascripts/shared/AvailableListGroup.js");

var _AvailableListGroup2 = _interopRequireDefault(_AvailableListGroup);

var _ChosenListGroup = __webpack_require__(/*! ../shared/ChosenListGroup */ "./app/assets/javascripts/shared/ChosenListGroup.js");

var _ChosenListGroup2 = _interopRequireDefault(_ChosenListGroup);

var _DigitalDisplayPreview = __webpack_require__(/*! ./DigitalDisplayPreview */ "./app/assets/javascripts/digital-display/DigitalDisplayPreview.js");

var _DigitalDisplayPreview2 = _interopRequireDefault(_DigitalDisplayPreview);

var _previewPath = __webpack_require__(/*! ./previewPath */ "./app/assets/javascripts/digital-display/previewPath.js");

var _previewPath2 = _interopRequireDefault(_previewPath);

var _Array = __webpack_require__(/*! ../polyfills/Array */ "./app/assets/javascripts/polyfills/Array.js");

var _reactDnd = __webpack_require__(/*! react-dnd */ "./node_modules/react-dnd/lib/index.js");

var _reactDndHtml5Backend = __webpack_require__(/*! react-dnd-html5-backend */ "./node_modules/react-dnd-html5-backend/lib/index.js");

var _reactDndHtml5Backend2 = _interopRequireDefault(_reactDndHtml5Backend);

var _ColorPickerInput = __webpack_require__(/*! ../shared/ColorPickerInput */ "./app/assets/javascripts/shared/ColorPickerInput.js");

var _ColorPickerInput2 = _interopRequireDefault(_ColorPickerInput);

var _ThemeSelect = __webpack_require__(/*! ./ThemeSelect */ "./app/assets/javascripts/digital-display/ThemeSelect.js");

var _ThemeSelect2 = _interopRequireDefault(_ThemeSelect);

var _FontSelect = __webpack_require__(/*! ./FontSelect */ "./app/assets/javascripts/digital-display/FontSelect.js");

var _FontSelect2 = _interopRequireDefault(_FontSelect);

var _RotationIntervalSelect = __webpack_require__(/*! ./RotationIntervalSelect */ "./app/assets/javascripts/digital-display/RotationIntervalSelect.js");

var _RotationIntervalSelect2 = _interopRequireDefault(_RotationIntervalSelect);

var _OrientationInput = __webpack_require__(/*! ./OrientationInput */ "./app/assets/javascripts/digital-display/OrientationInput.js");

var _OrientationInput2 = _interopRequireDefault(_OrientationInput);

var _MenuFormButtons = __webpack_require__(/*! ../shared/MenuFormButtons */ "./app/assets/javascripts/shared/MenuFormButtons.js");

var _MenuFormButtons2 = _interopRequireDefault(_MenuFormButtons);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _toConsumableArray(arr) { if (Array.isArray(arr)) { for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) { arr2[i] = arr[i]; } return arr2; } else { return Array.from(arr); } }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

(0, _Array.applyFind)();

var DigitalDisplayApp = function (_Component) {
  _inherits(DigitalDisplayApp, _Component);

  function DigitalDisplayApp(props) {
    _classCallCheck(this, DigitalDisplayApp);

    var _this = _possibleConstructorReturn(this, (DigitalDisplayApp.__proto__ || Object.getPrototypeOf(DigitalDisplayApp)).call(this, props));

    var _props$digitalDisplay = props.digitalDisplayMenu,
        lists = _props$digitalDisplay.lists,
        listsAvailable = _props$digitalDisplay.listsAvailable,
        name = _props$digitalDisplay.name,
        rotationInterval = _props$digitalDisplay.rotationInterval,
        isHorizontal = _props$digitalDisplay.isHorizontal,
        backgroundColor = _props$digitalDisplay.backgroundColor,
        textColor = _props$digitalDisplay.textColor,
        listTitleColor = _props$digitalDisplay.listTitleColor,
        font = _props$digitalDisplay.font,
        theme = _props$digitalDisplay.theme;


    _this.handleNameChange = _this.handleNameChange.bind(_this);
    _this.handleFontChange = _this.handleFontChange.bind(_this);
    _this.handleThemeChange = _this.handleThemeChange.bind(_this);
    _this.handleBackgroundColorChange = _this.handleBackgroundColorChange.bind(_this);
    _this.handleTextColorChange = _this.handleTextColorChange.bind(_this);
    _this.handleListTitleColorChange = _this.handleListTitleColorChange.bind(_this);
    _this.handleOrientationChange = _this.handleOrientationChange.bind(_this);
    _this.handleRotationIntervalChange = _this.handleRotationIntervalChange.bind(_this);
    _this.addListToDisplay = _this.addListToDisplay.bind(_this);
    _this.removeListFromDisplay = _this.removeListFromDisplay.bind(_this);
    _this.handleShowPriceChange = _this.handleShowPriceChange.bind(_this);
    _this.handleDisplayNameChange = _this.handleDisplayNameChange.bind(_this);
    _this.moveChosenList = _this.moveChosenList.bind(_this);

    _this.state = {
      lists: lists,
      listsAvailable: listsAvailable,
      name: name,
      isHorizontal: isHorizontal,
      rotationInterval: rotationInterval,
      backgroundColor: backgroundColor,
      textColor: textColor,
      listTitleColor: listTitleColor,
      font: font,
      theme: theme
    };
    return _this;
  }

  _createClass(DigitalDisplayApp, [{
    key: 'moveChosenList',
    value: function moveChosenList(dragIndex, hoverIndex) {
      this.setState(function (prevState) {
        var lists = prevState.lists;

        var dragList = lists[dragIndex];
        var newLists = [].concat(_toConsumableArray(lists));
        newLists.splice(dragIndex, 1);
        newLists.splice(hoverIndex, 0, dragList);
        return { lists: newLists };
      });
    }
  }, {
    key: 'addListToDisplay',
    value: function addListToDisplay(listId) {
      this.setState(function (prevState) {
        var lists = prevState.lists,
            listsAvailable = prevState.listsAvailable;

        var listToAdd = listsAvailable.find(function (list) {
          return list.id === listId;
        });
        var newLists = [].concat(_toConsumableArray(lists), [listToAdd]);
        return {
          listsAvailable: listsAvailable.filter(function (list) {
            return list.id !== listId;
          }),
          lists: newLists
        };
      });
    }
  }, {
    key: 'removeListFromDisplay',
    value: function removeListFromDisplay(listId) {
      this.setState(function (prevState) {
        var lists = prevState.lists,
            listsAvailable = prevState.listsAvailable;

        var listToRemove = lists.find(function (list) {
          return list.id === listId;
        });
        var newLists = lists.filter(function (list) {
          return list.id !== listId;
        });
        return {
          listsAvailable: [].concat(_toConsumableArray(listsAvailable), [listToRemove]),
          lists: newLists
        };
      });
    }
  }, {
    key: 'handleNameChange',
    value: function handleNameChange(event) {
      var name = event.target.value;
      this.setState(function (prevState) {
        return { name: name };
      });
    }
  }, {
    key: 'handleFontChange',
    value: function handleFontChange(chosenFont) {
      var font = chosenFont.value;
      this.setState(function (prevState) {
        return { font: font };
      });
    }
  }, {
    key: 'handleThemeChange',
    value: function handleThemeChange(theme) {
      var newState = { theme: theme.name };
      ['font', 'backgroundColor', 'textColor', 'listTitleColor'].forEach(function (attr) {
        if (theme[attr]) {
          newState[attr] = theme[attr];
        }
      });
      this.setState(function (prevState) {
        return newState;
      });
    }
  }, {
    key: 'handleOrientationChange',
    value: function handleOrientationChange(orientation) {
      var isHorizontal = orientation === 'horizontal';
      this.setState(function (prevState) {
        return { isHorizontal: isHorizontal };
      });
    }
  }, {
    key: 'handleBackgroundColorChange',
    value: function handleBackgroundColorChange(color) {
      var backgroundColor = color.hex;
      this.setState(function (prevState) {
        return { backgroundColor: backgroundColor };
      });
    }
  }, {
    key: 'handleTextColorChange',
    value: function handleTextColorChange(color) {
      var textColor = color.hex;
      this.setState(function (prevState) {
        return { textColor: textColor };
      });
    }
  }, {
    key: 'handleListTitleColorChange',
    value: function handleListTitleColorChange(color) {
      var listTitleColor = color.hex;
      this.setState(function (prevState) {
        return { listTitleColor: listTitleColor };
      });
    }
  }, {
    key: 'handleRotationIntervalChange',
    value: function handleRotationIntervalChange(chosenInterval) {
      var rotationInterval = chosenInterval.value;
      this.setState(function (prevState) {
        return { rotationInterval: rotationInterval };
      });
    }
  }, {
    key: 'handleShowPriceChange',
    value: function handleShowPriceChange(listId, showPrice) {
      this.setState(function (prevState) {
        var lists = prevState.lists;

        var list = lists.find(function (list) {
          return list.id === listId;
        });
        list.show_price_on_menu = showPrice;
        return { lists: lists };
      });
    }
  }, {
    key: 'handleDisplayNameChange',
    value: function handleDisplayNameChange(listId, displayName) {
      this.setState(function (prevState) {
        var lists = prevState.lists;

        var list = lists.find(function (list) {
          return list.id === listId;
        });
        list.displayName = displayName;
        return { lists: lists };
      });
    }
  }, {
    key: 'render',
    value: function render() {
      var _state = this.state,
          lists = _state.lists,
          listsAvailable = _state.listsAvailable,
          name = _state.name,
          isHorizontal = _state.isHorizontal,
          rotationInterval = _state.rotationInterval,
          backgroundColor = _state.backgroundColor,
          textColor = _state.textColor,
          listTitleColor = _state.listTitleColor,
          font = _state.font,
          theme = _state.theme;

      var showCustomThemeFields = theme === 'Custom';
      var customThemeFieldClass = showCustomThemeFields ? 'visible' : 'invisible';
      var totalListCount = lists.length + listsAvailable.length;
      var previewPath = (0, _previewPath2.default)(this.props.digitalDisplayMenu, this.state);
      var viewDisplayButton = void 0;
      if (this.props.viewDisplayPath) {
        viewDisplayButton = _react2.default.createElement(
          'a',
          { href: this.props.viewDisplayPath,
            target: '_blank',
            className: 'btn btn-success pull-right',
            'data-test': 'view-digital-display-menu' },
          'View'
        );
      }

      return _react2.default.createElement(
        'div',
        { className: 'form-row' },
        _react2.default.createElement(
          'div',
          { className: 'col-sm-6' },
          _react2.default.createElement(
            _Panel2.default,
            { title: name, icon: 'fas fa-tv' },
            _react2.default.createElement(
              'div',
              { className: 'form-group' },
              _react2.default.createElement(
                'label',
                { htmlFor: 'digital_display_menu_name' },
                'Name'
              ),
              _react2.default.createElement('input', {
                id: 'digital_display_menu_name',
                name: 'digital_display_menu[name]',
                className: 'form-control',
                'data-test': 'digital-display-menu-name',
                type: 'text',
                defaultValue: name,
                onChange: this.handleNameChange
              })
            ),
            _react2.default.createElement(_OrientationInput2.default, {
              className: 'form-group',
              onChange: this.handleOrientationChange,
              isHorizontal: isHorizontal
            }),
            _react2.default.createElement(
              'div',
              { className: 'form-row' },
              _react2.default.createElement(_ThemeSelect2.default, {
                className: 'form-group col-sm-4',
                onChange: this.handleThemeChange,
                options: this.props.themeOptions,
                value: theme
              }),
              _react2.default.createElement(_RotationIntervalSelect2.default, {
                className: 'form-group col-sm-4',
                onChange: this.handleRotationIntervalChange,
                options: this.props.rotationIntervalOptions,
                value: rotationInterval
              }),
              _react2.default.createElement(_FontSelect2.default, {
                className: 'form-group col-sm-4 ' + customThemeFieldClass,
                onChange: this.handleFontChange,
                options: this.props.fontOptions,
                value: font
              })
            ),
            _react2.default.createElement(
              'div',
              { className: 'form-row ' + customThemeFieldClass },
              _react2.default.createElement(_ColorPickerInput2.default, {
                id: 'digital_display_menu_background_color',
                name: 'digital_display_menu[background_color]',
                className: 'form-group col-sm-4',
                dataTest: 'digital-display-menu-background-color',
                label: 'Background Color',
                onChangeComplete: this.handleBackgroundColorChange,
                color: backgroundColor
              }),
              _react2.default.createElement(_ColorPickerInput2.default, {
                id: 'digital_display_menu_text_color',
                name: 'digital_display_menu[text_color]',
                className: 'form-group col-sm-4',
                dataTest: 'digital-display-menu-text-color',
                label: 'Text Color',
                onChangeComplete: this.handleTextColorChange,
                color: textColor
              }),
              _react2.default.createElement(_ColorPickerInput2.default, {
                id: 'digital_display_menu_list_title_color',
                name: 'digital_display_menu[list_title_color]',
                className: 'form-group col-sm-4',
                dataTest: 'digital-display-menu-list-title-color',
                label: 'List Title Color',
                onChangeComplete: this.handleListTitleColorChange,
                color: listTitleColor
              })
            ),
            _react2.default.createElement(_AvailableListGroup2.default, {
              totalListCount: totalListCount,
              lists: listsAvailable,
              menuType: 'digitalDisplay',
              onAdd: this.addListToDisplay,
              onDrop: this.removeListFromDisplay
            }),
            _react2.default.createElement(_ChosenListGroup2.default, {
              lists: lists,
              menuType: 'digitalDisplay',
              onRemove: this.removeListFromDisplay,
              onShowPriceChange: this.handleShowPriceChange,
              onDisplayNameChange: this.handleDisplayNameChange,
              moveItem: this.moveChosenList,
              onDrop: this.addListToDisplay
            }),
            _react2.default.createElement(
              _MenuFormButtons2.default,
              _extends({}, this.props, { menuType: 'digital-display-menu' }),
              viewDisplayButton
            )
          )
        ),
        _react2.default.createElement(
          'div',
          { className: 'col-sm-6' },
          _react2.default.createElement(_DigitalDisplayPreview2.default, { previewPath: previewPath, isHorizontal: isHorizontal })
        )
      );
    }
  }]);

  return DigitalDisplayApp;
}(_react.Component);

DigitalDisplayApp.propTypes = {
  digitalDisplayMenu: _propTypes2.default.object.isRequired,
  rotationIntervalOptions: _propTypes2.default.array,
  fontOptions: _propTypes2.default.array,
  themeOptions: _propTypes2.default.array
};

exports.default = (0, _reactDnd.DragDropContext)(_reactDndHtml5Backend2.default)(DigitalDisplayApp);

/***/ }),

/***/ "./app/assets/javascripts/digital-display/DigitalDisplayPreview.js":
/*!*************************************************************************!*\
  !*** ./app/assets/javascripts/digital-display/DigitalDisplayPreview.js ***!
  \*************************************************************************/
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

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var DigitalDisplayPreview = function (_Component) {
  _inherits(DigitalDisplayPreview, _Component);

  function DigitalDisplayPreview(props) {
    _classCallCheck(this, DigitalDisplayPreview);

    var _this = _possibleConstructorReturn(this, (DigitalDisplayPreview.__proto__ || Object.getPrototypeOf(DigitalDisplayPreview)).call(this, props));

    _this.configureOrientation = _this.configureOrientation.bind(_this);
    _this.setWidth = _this.setWidth.bind(_this);
    _this.state = { height: '100%', width: '100%' };
    return _this;
  }

  _createClass(DigitalDisplayPreview, [{
    key: 'configureOrientation',
    value: function configureOrientation(isHorizontal) {
      var initialWidth = this.width;
      // Calculate 16:9 aspect ratio
      var height = (initialWidth * 0.5625).toString().split('.')[0];
      var horizontalSize = void 0,
          verticalSize = void 0;

      if (isHorizontal) {
        horizontalSize = initialWidth;
        verticalSize = height;
      } else {
        horizontalSize = height;
        verticalSize = initialWidth;
      }

      this.setState(function (prevState) {
        return { height: verticalSize, width: horizontalSize + 'px' };
      });
    }
  }, {
    key: 'componentWillReceiveProps',
    value: function componentWillReceiveProps(nextProps) {
      if (this.props !== nextProps && !!this.width) {
        var isHorizontal = nextProps.isHorizontal;

        this.configureOrientation(isHorizontal);
      }
    }
  }, {
    key: 'componentDidMount',
    value: function componentDidMount() {
      var isHorizontal = this.props.isHorizontal;

      this.configureOrientation(isHorizontal);
    }
  }, {
    key: 'setWidth',
    value: function setWidth(obj) {
      this.width = obj.offsetWidth;
    }
  }, {
    key: 'render',
    value: function render() {
      var _state = this.state,
          height = _state.height,
          width = _state.width;

      var className = this.props.isHorizontal ? 'preview-horizontal' : 'preview-vertical';

      return _react2.default.createElement(
        _Panel2.default,
        { className: 'sticky-top', title: 'Preview', dataTest: 'digital-display-menu-preview-panel' },
        _react2.default.createElement(
          'div',
          { className: 'digital-display-menu-preview-wrapper', ref: this.setWidth },
          _react2.default.createElement('object', {
            className: className,
            data: this.props.previewPath,
            type: 'text/html',
            style: { width: width },
            height: height,
            'data-test': 'digital-display-menu-preview' })
        )
      );
    }
  }]);

  return DigitalDisplayPreview;
}(_react.Component);

DigitalDisplayPreview.propTypes = {
  previewPath: _propTypes2.default.string.isRequired,
  isHorizontal: _propTypes2.default.bool.isRequired
};

exports.default = DigitalDisplayPreview;

/***/ }),

/***/ "./app/assets/javascripts/digital-display/FontSelect.js":
/*!**************************************************************!*\
  !*** ./app/assets/javascripts/digital-display/FontSelect.js ***!
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

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var FontSelect = function (_Component) {
  _inherits(FontSelect, _Component);

  function FontSelect(props) {
    _classCallCheck(this, FontSelect);

    var _this = _possibleConstructorReturn(this, (FontSelect.__proto__ || Object.getPrototypeOf(FontSelect)).call(this, props));

    _this.handleChange = _this.handleChange.bind(_this);
    return _this;
  }

  _createClass(FontSelect, [{
    key: 'handleChange',
    value: function handleChange(event) {
      var fontName = event.target.value;
      var font = this.props.options.find(function (opt) {
        return opt.value === fontName;
      });
      this.props.onChange(font);
    }
  }, {
    key: 'render',
    value: function render() {
      var _props = this.props,
          value = _props.value,
          className = _props.className;

      var fontOptions = this.props.options.map(function (option, index) {
        return _react2.default.createElement(
          'option',
          { value: option.value, key: index },
          option.name
        );
      });

      return _react2.default.createElement(
        'div',
        { className: className },
        _react2.default.createElement(
          'label',
          { htmlFor: 'digital_display_menu_font' },
          'Font'
        ),
        _react2.default.createElement(
          'select',
          {
            id: 'digital_display_menu_font',
            'data-test': 'digital-display-menu-font',
            name: 'digital_display_menu[font]',
            className: 'form-control',
            value: value,
            onChange: this.handleChange },
          fontOptions
        )
      );
    }
  }]);

  return FontSelect;
}(_react.Component);

;

FontSelect.propTypes = {
  options: _propTypes2.default.array.isRequired,
  onChange: _propTypes2.default.func.isRequired,
  value: _propTypes2.default.string.isRequired,
  className: _propTypes2.default.string
};

exports.default = FontSelect;

/***/ }),

/***/ "./app/assets/javascripts/digital-display/OrientationInput.js":
/*!********************************************************************!*\
  !*** ./app/assets/javascripts/digital-display/OrientationInput.js ***!
  \********************************************************************/
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

var OrientationInput = function (_Component) {
  _inherits(OrientationInput, _Component);

  function OrientationInput(props) {
    _classCallCheck(this, OrientationInput);

    var _this = _possibleConstructorReturn(this, (OrientationInput.__proto__ || Object.getPrototypeOf(OrientationInput)).call(this, props));

    _this.handleChange = _this.handleChange.bind(_this);
    return _this;
  }

  _createClass(OrientationInput, [{
    key: 'handleChange',
    value: function handleChange(event) {
      var val = event.target.value === 'true' ? 'horizontal' : 'vertical';
      this.props.onChange(val);
    }
  }, {
    key: 'render',
    value: function render() {
      var _props = this.props,
          isHorizontal = _props.isHorizontal,
          className = _props.className;

      return _react2.default.createElement(
        'div',
        { className: className },
        _react2.default.createElement(
          'label',
          null,
          'Orientation'
        ),
        _react2.default.createElement(
          'div',
          { className: 'form-check' },
          _react2.default.createElement(
            'label',
            { className: 'form-check-label' },
            _react2.default.createElement('input', {
              type: 'radio',
              name: 'digital_display_menu[horizontal_orientation]',
              className: 'form-check-input',
              value: 'true',
              defaultChecked: isHorizontal,
              onClick: this.handleChange,
              'data-test': 'digital-display-menu-horizontal-orientation-true'
            }),
            'Horizontal'
          )
        ),
        _react2.default.createElement(
          'div',
          { className: 'form-check' },
          _react2.default.createElement(
            'label',
            { className: 'form-check-label' },
            _react2.default.createElement('input', {
              type: 'radio',
              name: 'digital_display_menu[horizontal_orientation]',
              className: 'form-check-input',
              value: 'false',
              defaultChecked: !isHorizontal,
              onClick: this.handleChange,
              'data-test': 'digital-display-menu-horizontal-orientation-false'
            }),
            'Vertical'
          )
        )
      );
    }
  }]);

  return OrientationInput;
}(_react.Component);

OrientationInput.propTypes = {
  className: _propTypes2.default.string,
  onChange: _propTypes2.default.func.isRequired,
  isHorizontal: _propTypes2.default.bool.isRequired
};

OrientationInput.defaultProps = {
  className: 'form-group'
};

exports.default = OrientationInput;

/***/ }),

/***/ "./app/assets/javascripts/digital-display/RotationIntervalSelect.js":
/*!**************************************************************************!*\
  !*** ./app/assets/javascripts/digital-display/RotationIntervalSelect.js ***!
  \**************************************************************************/
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

var RotationIntervalSelect = function (_Component) {
  _inherits(RotationIntervalSelect, _Component);

  function RotationIntervalSelect(props) {
    _classCallCheck(this, RotationIntervalSelect);

    var _this = _possibleConstructorReturn(this, (RotationIntervalSelect.__proto__ || Object.getPrototypeOf(RotationIntervalSelect)).call(this, props));

    _this.handleChange = _this.handleChange.bind(_this);
    return _this;
  }

  _createClass(RotationIntervalSelect, [{
    key: 'handleChange',
    value: function handleChange(event) {
      var chosenInterval = event.target.value;
      var rotationInterval = this.props.options.find(function (opt) {
        return opt.value === Number(chosenInterval);
      });
      this.props.onChange(rotationInterval);
    }
  }, {
    key: 'render',
    value: function render() {
      var _props = this.props,
          value = _props.value,
          className = _props.className;

      var intervalOptions = this.props.options.map(function (option, index) {
        return _react2.default.createElement(
          'option',
          { value: option.value, key: index },
          option.name
        );
      });

      return _react2.default.createElement(
        'div',
        { className: className },
        _react2.default.createElement(
          'label',
          { htmlFor: 'digital_display_menu_rotation_interval' },
          'Rotation Interval'
        ),
        _react2.default.createElement(
          'select',
          {
            id: 'digital_display_menu_rotation_interval',
            'data-test': 'digital-display-menu-rotation-interval',
            name: 'digital_display_menu[rotation_interval]',
            className: 'form-control',
            value: value,
            onChange: this.handleChange },
          intervalOptions
        )
      );
    }
  }]);

  return RotationIntervalSelect;
}(_react.Component);

;

RotationIntervalSelect.propTypes = {
  options: _propTypes2.default.array.isRequired,
  onChange: _propTypes2.default.func.isRequired,
  value: _propTypes2.default.number.isRequired,
  className: _propTypes2.default.string
};

exports.default = RotationIntervalSelect;

/***/ }),

/***/ "./app/assets/javascripts/digital-display/ThemeSelect.js":
/*!***************************************************************!*\
  !*** ./app/assets/javascripts/digital-display/ThemeSelect.js ***!
  \***************************************************************/
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

var ThemeSelect = function (_Component) {
  _inherits(ThemeSelect, _Component);

  function ThemeSelect(props) {
    _classCallCheck(this, ThemeSelect);

    var _this = _possibleConstructorReturn(this, (ThemeSelect.__proto__ || Object.getPrototypeOf(ThemeSelect)).call(this, props));

    _this.handleChange = _this.handleChange.bind(_this);
    return _this;
  }

  _createClass(ThemeSelect, [{
    key: 'handleChange',
    value: function handleChange(event) {
      var themeName = event.target.value;
      var theme = this.props.options.find(function (opt) {
        return opt.name === themeName;
      });
      this.props.onChange(theme);
    }
  }, {
    key: 'render',
    value: function render() {
      var _props = this.props,
          value = _props.value,
          className = _props.className;

      var themeOptions = this.props.options.map(function (theme, index) {
        return _react2.default.createElement(
          'option',
          { value: theme.name, key: index },
          theme.name
        );
      });

      return _react2.default.createElement(
        'div',
        { className: className },
        _react2.default.createElement(
          'label',
          { htmlFor: 'digital_display_menu_theme' },
          'Theme'
        ),
        _react2.default.createElement(
          'select',
          {
            id: 'digital_display_menu_theme',
            'data-test': 'digital-display-menu-theme',
            name: 'digital_display_menu[theme]',
            className: 'form-control',
            value: value,
            onChange: this.handleChange },
          themeOptions
        )
      );
    }
  }]);

  return ThemeSelect;
}(_react.Component);

;

ThemeSelect.propTypes = {
  options: _propTypes2.default.array.isRequired,
  onChange: _propTypes2.default.func.isRequired,
  value: _propTypes2.default.string.isRequired,
  className: _propTypes2.default.string
};

exports.default = ThemeSelect;

/***/ }),

/***/ "./app/assets/javascripts/digital-display/previewPath.js":
/*!***************************************************************!*\
  !*** ./app/assets/javascripts/digital-display/previewPath.js ***!
  \***************************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _previewPathUtils = __webpack_require__(/*! ../shared/previewPathUtils */ "./app/assets/javascripts/shared/previewPathUtils.js");

var _previewPathUtils2 = _interopRequireDefault(_previewPathUtils);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var _initPreviewUtils = (0, _previewPathUtils2.default)('digitalDisplay'),
    buildMenuListId = _initPreviewUtils.buildMenuListId,
    buildMenuListListId = _initPreviewUtils.buildMenuListListId,
    buildMenuListPosition = _initPreviewUtils.buildMenuListPosition,
    buildMenuListShowPrice = _initPreviewUtils.buildMenuListShowPrice,
    buildMenuListDisplayName = _initPreviewUtils.buildMenuListDisplayName;

function buildQueryString(lists, base) {
  return lists.reduce(function (acc, list, idx) {
    var params = [buildMenuListListId(list, idx), buildMenuListPosition(list, idx), buildMenuListShowPrice(list, idx), buildMenuListDisplayName(list, idx, list.displayName)];
    if (list.menu_list_id) {
      params.push(buildMenuListId(list, idx));
    }
    return acc + '&' + params.join('&');
  }, base);
}

function generatePreviewPath(digitalDisplayMenu, formState) {
  var lists = formState.lists,
      isHorizontal = formState.isHorizontal,
      rotationInterval = formState.rotationInterval,
      backgroundColor = formState.backgroundColor,
      textColor = formState.textColor,
      listTitleColor = formState.listTitleColor,
      font = formState.font,
      theme = formState.theme;
  var previewPath = digitalDisplayMenu.previewPath,
      id = digitalDisplayMenu.id;

  var orientationParam = 'digital_display_menu[horizontal_orientation]=' + isHorizontal;
  var rotationIntervalParam = 'digital_display_menu[rotation_interval]=' + rotationInterval;
  var backgroundColorParam = 'digital_display_menu[background_color]=' + encodeURIComponent(backgroundColor);
  var textColorParam = 'digital_display_menu[text_color]=' + encodeURIComponent(textColor);
  var listTitleColorParam = 'digital_display_menu[list_title_color]=' + encodeURIComponent(listTitleColor);
  var fontParam = 'digital_display_menu[font]=' + font;
  var themeParam = 'digital_display_menu[theme]=' + theme;
  var seed = '?' + [orientationParam, rotationIntervalParam, backgroundColorParam, textColorParam, listTitleColorParam, fontParam, themeParam].join('&');
  var queryString = buildQueryString(lists, seed);
  if (id) {
    // Menu is already persisted
    return previewPath + queryString + ('&digital_display_menu[id]=' + id);
  } else {
    // Menu is not yet saved
    return previewPath + queryString;
  }
}

exports.default = generatePreviewPath;

/***/ }),

/***/ "./app/assets/javascripts/polyfills/Array.js":
/*!***************************************************!*\
  !*** ./app/assets/javascripts/polyfills/Array.js ***!
  \***************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.applyFind = applyFind;
exports.applyIncludes = applyIncludes;
function applyFind() {
  if (!Array.prototype.find) {
    Object.defineProperty(Array.prototype, 'find', { // eslint-disable-line
      value: function value(predicate) {
        // 1. Let O be ? ToObject(this value).
        if (this == null) {
          throw new TypeError('"this" is null or not defined');
        }

        var o = Object(this);

        // 2. Let len be ? ToLength(? Get(O, "length")).
        var len = o.length >>> 0;

        // 3. If IsCallable(predicate) is false, throw a TypeError exception.
        if (typeof predicate !== 'function') {
          throw new TypeError('predicate must be a function');
        }

        // 4. If thisArg was supplied, let T be thisArg; else let T be undefined.
        var thisArg = arguments[1];

        // 5. Let k be 0.
        var k = 0;

        // 6. Repeat, while k < len
        while (k < len) {
          // a. Let Pk be ! ToString(k).
          // b. Let kValue be ? Get(O, Pk).
          // c. Let testResult be ToBoolean(? Call(predicate, T, « kValue, k, O »)).
          // d. If testResult is true, return kValue.
          var kValue = o[k];
          if (predicate.call(thisArg, kValue, k, o)) {
            return kValue;
          }
          // e. Increase k by 1.
          k++;
        }

        // 7. Return undefined.
        return undefined;
      }
    });
  }
}

/* eslint-disable no-extend-native */
function applyIncludes() {
  if (!Array.prototype.includes) {
    Object.defineProperty(Array.prototype, 'includes', {
      value: function value(searchElement, fromIndex) {
        if (this == null) {
          throw new TypeError('"this" is null or not defined');
        }

        // 1. Let O be ? ToObject(this value).
        var o = Object(this);

        // 2. Let len be ? ToLength(? Get(O, "length")).
        var len = o.length >>> 0;

        // 3. If len is 0, return false.
        if (len === 0) {
          return false;
        }

        // 4. Let n be ? ToInteger(fromIndex).
        //    (If fromIndex is undefined, this step produces the value 0.)
        var n = fromIndex | 0;

        // 5. If n ≥ 0, then
        //  a. Let k be n.
        // 6. Else n < 0,
        //  a. Let k be len + n.
        //  b. If k < 0, let k be 0.
        var k = Math.max(n >= 0 ? n : len - Math.abs(n), 0);

        function sameValueZero(x, y) {
          return x === y || typeof x === 'number' && typeof y === 'number' && isNaN(x) && isNaN(y);
        }

        // 7. Repeat, while k < len
        while (k < len) {
          // a. Let elementK be the result of ? Get(O, ! ToString(k)).
          // b. If SameValueZero(searchElement, elementK) is true, return true.
          if (sameValueZero(o[k], searchElement)) {
            return true;
          }
          // c. Increase k by 1.
          k++;
        }

        // 8. Return false
        return false;
      }
    });
  }
}
/* eslint-enable no-extend-native */

/***/ }),

/***/ "./app/assets/javascripts/shared/AddButton.js":
/*!****************************************************!*\
  !*** ./app/assets/javascripts/shared/AddButton.js ***!
  \****************************************************/
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

var AddButton = function (_Component) {
  _inherits(AddButton, _Component);

  function AddButton(props) {
    _classCallCheck(this, AddButton);

    var _this = _possibleConstructorReturn(this, (AddButton.__proto__ || Object.getPrototypeOf(AddButton)).call(this, props));

    _this.handleClick = _this.handleClick.bind(_this);
    return _this;
  }

  _createClass(AddButton, [{
    key: 'handleClick',
    value: function handleClick(event) {
      var listId = this.props.listId;

      event.preventDefault();
      this.props.onClick(listId);
    }
  }, {
    key: 'render',
    value: function render() {
      return _react2.default.createElement(
        'a',
        {
          href: '',
          role: 'button',
          'data-test': 'add-list',
          title: 'Add list',
          onClick: this.handleClick,
          className: 'btn btn-outline-secondary btn-sm move-list-button' },
        _react2.default.createElement('span', { className: 'fas fa-plus fa-lg' })
      );
    }
  }]);

  return AddButton;
}(_react.Component);

AddButton.propTypes = {
  onClick: _propTypes2.default.func.isRequired,
  listId: _propTypes2.default.number.isRequired
};

exports.default = AddButton;

/***/ }),

/***/ "./app/assets/javascripts/shared/AvailableListGroup.js":
/*!*************************************************************!*\
  !*** ./app/assets/javascripts/shared/AvailableListGroup.js ***!
  \*************************************************************/
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

var _attributeNameResolver = __webpack_require__(/*! ./attributeNameResolver */ "./app/assets/javascripts/shared/attributeNameResolver.js");

var _attributeNameResolver2 = _interopRequireDefault(_attributeNameResolver);

var _AvailableListItem = __webpack_require__(/*! ./AvailableListItem */ "./app/assets/javascripts/shared/AvailableListItem.js");

var _AvailableListItem2 = _interopRequireDefault(_AvailableListItem);

var _reactDnd = __webpack_require__(/*! react-dnd */ "./node_modules/react-dnd/lib/index.js");

var _itemTypes = __webpack_require__(/*! ./item-types */ "./app/assets/javascripts/shared/item-types.js");

var _itemTypes2 = _interopRequireDefault(_itemTypes);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var dropTargetSpec = {
  drop: function drop(props, monitor, component) {
    var draggedItem = monitor.getItem();
    var listId = draggedItem.id;
    props.onDrop(listId);
  }
};

// props to be injected
function collect(connect, monitor) {
  return {
    connectDropTarget: connect.dropTarget(),
    isOver: monitor.isOver()
  };
}

var AvailableListGroup = function (_Component) {
  _inherits(AvailableListGroup, _Component);

  function AvailableListGroup(props) {
    _classCallCheck(this, AvailableListGroup);

    var _this = _possibleConstructorReturn(this, (AvailableListGroup.__proto__ || Object.getPrototypeOf(AvailableListGroup)).call(this, props));

    _this.ifEmptyText = 'No lists available';
    return _this;
  }

  _createClass(AvailableListGroup, [{
    key: 'renderList',
    value: function renderList(listGroupItems) {
      var itemsToRender = void 0;
      if (listGroupItems.length === 0) {
        itemsToRender = _react2.default.createElement(
          'li',
          { className: 'list-group-item' },
          this.ifEmptyText
        );
      } else {
        itemsToRender = listGroupItems;
      }

      return _react2.default.createElement(
        'ul',
        { className: 'list-group list-group-flush', style: { maxHeight: '500px', overflow: 'scroll' } },
        itemsToRender
      );
    }
  }, {
    key: 'render',
    value: function render() {
      var _props = this.props,
          lists = _props.lists,
          totalListCount = _props.totalListCount,
          menuType = _props.menuType,
          onAdd = _props.onAdd,
          connectDropTarget = _props.connectDropTarget,
          isOver = _props.isOver;


      var style = {
        opacity: isOver ? 0.5 : 1
      };

      var nestedAttrsName = _attributeNameResolver2.default.resolveNestedAttrName(menuType);
      var entityName = _attributeNameResolver2.default.resolveEntityName(menuType);
      var nestedEntityIdName = _attributeNameResolver2.default.resolveNestedEntityIdName(menuType);
      var sortedLists = lists.sort(function (l1, l2) {
        if (l1.name < l2.name) return -1;
        if (l1.name > l2.name) return 1;
        return 0;
      });
      var listGroupItems = sortedLists.map(function (list, index) {
        var listItemProps = {
          index: index,
          list: list,
          totalListCount: totalListCount,
          nestedAttrsName: nestedAttrsName,
          entityName: entityName,
          nestedEntityIdName: nestedEntityIdName,
          onAdd: onAdd,
          key: list.id
        };

        return _react2.default.createElement(_AvailableListItem2.default, listItemProps);
      });

      return connectDropTarget(_react2.default.createElement(
        'div',
        { className: 'card', 'data-test': 'menu-lists-available', style: style },
        _react2.default.createElement(
          'div',
          { className: 'card-header list-group-heading' },
          _react2.default.createElement(
            'div',
            { className: 'card-title' },
            'Lists Available'
          )
        ),
        this.renderList(listGroupItems)
      ));
    }
  }]);

  return AvailableListGroup;
}(_react.Component);

AvailableListGroup.propTypes = {
  lists: _propTypes2.default.array.isRequired,
  onAdd: _propTypes2.default.func.isRequired,
  menuType: _propTypes2.default.string.isRequired,
  totalListCount: _propTypes2.default.number.isRequired,
  onDrop: _propTypes2.default.func.isRequired,
  connectDropTarget: _propTypes2.default.func.isRequired,
  isOver: _propTypes2.default.bool.isRequired
};

exports.default = (0, _reactDnd.DropTarget)(_itemTypes2.default.chosenListItem, dropTargetSpec, collect)(AvailableListGroup);

/***/ }),

/***/ "./app/assets/javascripts/shared/AvailableListItem.js":
/*!************************************************************!*\
  !*** ./app/assets/javascripts/shared/AvailableListItem.js ***!
  \************************************************************/
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

var _AddButton = __webpack_require__(/*! ./AddButton */ "./app/assets/javascripts/shared/AddButton.js");

var _AddButton2 = _interopRequireDefault(_AddButton);

var _reactDnd = __webpack_require__(/*! react-dnd */ "./node_modules/react-dnd/lib/index.js");

var _itemTypes = __webpack_require__(/*! ./item-types */ "./app/assets/javascripts/shared/item-types.js");

var _itemTypes2 = _interopRequireDefault(_itemTypes);

var _pluralize = __webpack_require__(/*! ./pluralize */ "./app/assets/javascripts/shared/pluralize.js");

var _pluralize2 = _interopRequireDefault(_pluralize);

var _ListTypeIcon = __webpack_require__(/*! ./ListTypeIcon */ "./app/assets/javascripts/shared/ListTypeIcon.js");

var _ListTypeIcon2 = _interopRequireDefault(_ListTypeIcon);

var _constants = __webpack_require__(/*! ./constants */ "./app/assets/javascripts/shared/constants.js");

var _constants2 = _interopRequireDefault(_constants);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var AvailableListItem = function (_Component) {
  _inherits(AvailableListItem, _Component);

  function AvailableListItem(props) {
    _classCallCheck(this, AvailableListItem);

    var _this = _possibleConstructorReturn(this, (AvailableListItem.__proto__ || Object.getPrototypeOf(AvailableListItem)).call(this, props));

    _this.onClick = _this.onClick.bind(_this);
    return _this;
  }

  _createClass(AvailableListItem, [{
    key: 'onClick',
    value: function onClick(event) {
      if (!confirm(_constants2.default.CONFIRM_TEXT)) {
        event.preventDefault();
      }
    }
  }, {
    key: 'render',
    value: function render() {
      var _props = this.props,
          index = _props.index,
          list = _props.list,
          totalListCount = _props.totalListCount,
          nestedAttrsName = _props.nestedAttrsName,
          entityName = _props.entityName,
          nestedEntityIdName = _props.nestedEntityIdName,
          connectDragSource = _props.connectDragSource,
          isDragging = _props.isDragging,
          onAdd = _props.onAdd;


      var style = {
        opacity: isDragging ? 0 : 1,
        cursor: 'move'
      };

      var badgeContent = list.itemCount + ' ' + (0, _pluralize2.default)('item', list.itemCount);

      var menuListIdInput = void 0,
          menuListDestroyInput = void 0;
      if (list[nestedEntityIdName]) {
        // Avoid collisions with nestedAttrsName in ChosenListGroup
        var attrIndex = totalListCount + index;
        menuListIdInput = _react2.default.createElement('input', {
          type: 'hidden',
          name: entityName + '[' + nestedAttrsName + '][' + attrIndex + '][id]',
          value: list[nestedEntityIdName]
        });
        menuListDestroyInput = _react2.default.createElement('input', {
          type: 'hidden',
          name: entityName + '[' + nestedAttrsName + '][' + attrIndex + '][_destroy]',
          value: 'true'
        });
      }

      return connectDragSource(_react2.default.createElement(
        'li',
        { className: 'list-group-item list-group-item-action', 'data-test': 'menu-list', style: style },
        _react2.default.createElement(
          'div',
          { className: 'valign-wrapper-w10' },
          _react2.default.createElement(_AddButton2.default, { onClick: onAdd, listId: list.id })
        ),
        _react2.default.createElement(
          'div',
          { className: 'valign-wrapper-w70' },
          _react2.default.createElement(
            'a',
            {
              href: list.href,
              onClick: this.onClick,
              className: 'list-name',
              'data-test': 'list-name' },
            list.name
          )
        ),
        _react2.default.createElement(
          'div',
          { className: 'valign-wrapper-w20' },
          _react2.default.createElement(_ListTypeIcon2.default, { listType: list.type }),
          _react2.default.createElement(
            'span',
            {
              'data-test': 'list-badge',
              className: 'badge badge-pill badge-secondary float-right mr-2'
            },
            badgeContent
          )
        ),
        menuListIdInput,
        menuListDestroyInput
      ));
    }
  }]);

  return AvailableListItem;
}(_react.Component);

var itemSource = {
  beginDrag: function beginDrag(props) {
    return {
      id: props.list.id,
      index: props.index
    };
  }
};

// specifies which props to inject
function collect(connect, monitor) {
  return {
    connectDragSource: connect.dragSource(),
    isDragging: monitor.isDragging()
  };
}

AvailableListItem.propTypes = {
  index: _propTypes2.default.number.isRequired,
  list: _propTypes2.default.object.isRequired,
  totalListCount: _propTypes2.default.number.isRequired,
  nestedAttrsName: _propTypes2.default.string.isRequired,
  entityName: _propTypes2.default.string.isRequired,
  nestedEntityIdName: _propTypes2.default.string.isRequired,
  connectDragSource: _propTypes2.default.func.isRequired,
  isDragging: _propTypes2.default.bool.isRequired,
  onAdd: _propTypes2.default.func.isRequired
};

exports.default = (0, _reactDnd.DragSource)(_itemTypes2.default.availableListItem, itemSource, collect)(AvailableListItem);

/***/ }),

/***/ "./app/assets/javascripts/shared/ChosenListGroup.js":
/*!**********************************************************!*\
  !*** ./app/assets/javascripts/shared/ChosenListGroup.js ***!
  \**********************************************************/
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

var _attributeNameResolver = __webpack_require__(/*! ./attributeNameResolver */ "./app/assets/javascripts/shared/attributeNameResolver.js");

var _attributeNameResolver2 = _interopRequireDefault(_attributeNameResolver);

var _ChosenListItem = __webpack_require__(/*! ./ChosenListItem */ "./app/assets/javascripts/shared/ChosenListItem.js");

var _ChosenListItem2 = _interopRequireDefault(_ChosenListItem);

var _reactDnd = __webpack_require__(/*! react-dnd */ "./node_modules/react-dnd/lib/index.js");

var _itemTypes = __webpack_require__(/*! ./item-types */ "./app/assets/javascripts/shared/item-types.js");

var _itemTypes2 = _interopRequireDefault(_itemTypes);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var dropTargetSpec = {
  drop: function drop(props, monitor, component) {
    var draggedItem = monitor.getItem();
    var listId = draggedItem.id;
    props.onDrop(listId);
  }
};

// props to be injected
function collect(connect, monitor) {
  return {
    connectDropTarget: connect.dropTarget(),
    isOver: monitor.isOver()
  };
}

var ChosenListGroup = function (_Component) {
  _inherits(ChosenListGroup, _Component);

  function ChosenListGroup(props) {
    _classCallCheck(this, ChosenListGroup);

    var _this = _possibleConstructorReturn(this, (ChosenListGroup.__proto__ || Object.getPrototypeOf(ChosenListGroup)).call(this, props));

    _this.ifEmptyText = 'Choose at least one list';
    return _this;
  }

  _createClass(ChosenListGroup, [{
    key: 'renderList',
    value: function renderList(listGroupItems) {
      var itemsToRender = void 0;
      if (listGroupItems.length === 0) {
        itemsToRender = _react2.default.createElement(
          'li',
          { className: 'list-group-item' },
          this.ifEmptyText
        );
      } else {
        itemsToRender = listGroupItems;
      }

      return _react2.default.createElement(
        'ul',
        { className: 'list-group list-group-flush' },
        itemsToRender
      );
    }
  }, {
    key: 'render',
    value: function render() {
      var _props = this.props,
          lists = _props.lists,
          onShowPriceChange = _props.onShowPriceChange,
          onShowDescriptionChange = _props.onShowDescriptionChange,
          onDisplayNameChange = _props.onDisplayNameChange,
          onHtmlClassesChange = _props.onHtmlClassesChange,
          onImagesListChange = _props.onImagesListChange,
          menuType = _props.menuType,
          onRemove = _props.onRemove,
          moveItem = _props.moveItem,
          connectDropTarget = _props.connectDropTarget,
          isOver = _props.isOver;

      var nestedAttrsName = _attributeNameResolver2.default.resolveNestedAttrName(menuType);
      var entityName = _attributeNameResolver2.default.resolveEntityName(menuType);
      var nestedEntityIdName = _attributeNameResolver2.default.resolveNestedEntityIdName(menuType);
      var listGroupItems = lists.map(function (list, index) {
        var listItemProps = {
          nestedAttrsName: nestedAttrsName,
          entityName: entityName,
          nestedEntityIdName: nestedEntityIdName,
          onShowPriceChange: onShowPriceChange,
          onShowDescriptionChange: onShowDescriptionChange,
          onDisplayNameChange: onDisplayNameChange,
          onHtmlClassesChange: onHtmlClassesChange,
          onImagesListChange: onImagesListChange,
          list: list,
          index: index,
          onRemove: onRemove,
          moveItem: moveItem,
          key: list.id
        };
        return _react2.default.createElement(_ChosenListItem2.default, listItemProps);
      });

      var style = {
        opacity: isOver ? 0.5 : 1
      };

      return connectDropTarget(_react2.default.createElement(
        'div',
        { className: 'card', 'data-test': 'menu-lists-selected', style: style },
        _react2.default.createElement(
          'div',
          { className: 'card-header list-group-heading' },
          _react2.default.createElement(
            'div',
            { className: 'card-title' },
            'Lists Selected'
          )
        ),
        this.renderList(listGroupItems)
      ));
    }
  }]);

  return ChosenListGroup;
}(_react.Component);

ChosenListGroup.propTypes = {
  lists: _propTypes2.default.array.isRequired,
  menuType: _propTypes2.default.string.isRequired,
  onRemove: _propTypes2.default.func.isRequired,
  onShowPriceChange: _propTypes2.default.func.isRequired,
  onShowDescriptionChange: _propTypes2.default.func,
  onDisplayNameChange: _propTypes2.default.func,
  onHtmlClassesChange: _propTypes2.default.func,
  onImagesListChange: _propTypes2.default.func,
  moveItem: _propTypes2.default.func.isRequired,
  onDrop: _propTypes2.default.func.isRequired,
  connectDropTarget: _propTypes2.default.func.isRequired,
  isOver: _propTypes2.default.bool.isRequired
};

exports.default = (0, _reactDnd.DropTarget)(_itemTypes2.default.availableListItem, dropTargetSpec, collect)(ChosenListGroup);

/***/ }),

/***/ "./app/assets/javascripts/shared/ChosenListItem.js":
/*!*********************************************************!*\
  !*** ./app/assets/javascripts/shared/ChosenListItem.js ***!
  \*********************************************************/
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

var _RemoveButton = __webpack_require__(/*! ./RemoveButton */ "./app/assets/javascripts/shared/RemoveButton.js");

var _RemoveButton2 = _interopRequireDefault(_RemoveButton);

var _reactDom = __webpack_require__(/*! react-dom */ "./node_modules/react-dom/index.js");

var _itemTypes = __webpack_require__(/*! ./item-types */ "./app/assets/javascripts/shared/item-types.js");

var _itemTypes2 = _interopRequireDefault(_itemTypes);

var _reactDnd = __webpack_require__(/*! react-dnd */ "./node_modules/react-dnd/lib/index.js");

var _pluralize = __webpack_require__(/*! ./pluralize */ "./app/assets/javascripts/shared/pluralize.js");

var _pluralize2 = _interopRequireDefault(_pluralize);

var _ListTypeIcon = __webpack_require__(/*! ./ListTypeIcon */ "./app/assets/javascripts/shared/ListTypeIcon.js");

var _ListTypeIcon2 = _interopRequireDefault(_ListTypeIcon);

var _ShowPriceInput = __webpack_require__(/*! ./ShowPriceInput */ "./app/assets/javascripts/shared/ShowPriceInput.js");

var _ShowPriceInput2 = _interopRequireDefault(_ShowPriceInput);

var _ShowDescriptionInput = __webpack_require__(/*! ./ShowDescriptionInput */ "./app/assets/javascripts/shared/ShowDescriptionInput.js");

var _ShowDescriptionInput2 = _interopRequireDefault(_ShowDescriptionInput);

var _ListItemImageChoices = __webpack_require__(/*! ./ListItemImageChoices */ "./app/assets/javascripts/shared/ListItemImageChoices.js");

var _ListItemImageChoices2 = _interopRequireDefault(_ListItemImageChoices);

var _constants = __webpack_require__(/*! ./constants */ "./app/assets/javascripts/shared/constants.js");

var _constants2 = _interopRequireDefault(_constants);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var itemSource = {
  beginDrag: function beginDrag(props) {
    return {
      id: props.list.id,
      index: props.index
    };
  }
};

var itemTarget = {
  hover: function hover(props, monitor, component) {
    var item = monitor.getItem();
    var dragIndex = item.index;
    var hoverIndex = props.index;

    // Don't replace items with themselves
    if (dragIndex === hoverIndex) {
      return;
    }

    // Determine rectangle on screen
    var hoverBoundingRect = (0, _reactDom.findDOMNode)(component).getBoundingClientRect();

    // Get vertical middle
    var hoverMiddleY = (hoverBoundingRect.bottom - hoverBoundingRect.top) / 2;

    // Determine mouse position
    var clientOffset = monitor.getClientOffset();

    // Get pixels to the top
    var hoverClientY = clientOffset.y - hoverBoundingRect.top;

    // Only perform the move when the mouse has crossed half of the items height
    // When dragging downwards, only move when the cursor is below 50%
    // When dragging upwards, only move when the cursor is above 50%

    // Dragging downwards
    if (dragIndex < hoverIndex && hoverClientY < hoverMiddleY) {
      return;
    }

    // Dragging upwards
    if (dragIndex > hoverIndex && hoverClientY > hoverMiddleY) {
      return;
    }

    // Time to actually perform the action
    props.moveItem(dragIndex, hoverIndex);

    // Note: we're mutating the monitor item here!
    // Generally it's better to avoid mutations,
    // but it's good here for the sake of performance
    // to avoid expensive index searches.
    item.index = hoverIndex;
  }
};

// specifies which props to inject
function dragCollect(connect, monitor) {
  var isDragging = monitor.isDragging();
  return {
    connectDragSource: connect.dragSource(),
    isDragging: isDragging
  };
}

// specifies which props to inject
function dropCollect(connect) {
  return {
    connectDropTarget: connect.dropTarget()
  };
}

var ChosenListItem = function (_Component) {
  _inherits(ChosenListItem, _Component);

  function ChosenListItem(props) {
    _classCallCheck(this, ChosenListItem);

    var _this = _possibleConstructorReturn(this, (ChosenListItem.__proto__ || Object.getPrototypeOf(ChosenListItem)).call(this, props));

    _this.onShowPriceChange = _this.onShowPriceChange.bind(_this);
    _this.onShowDescriptionChange = _this.onShowDescriptionChange.bind(_this);
    _this.onDisplayNameChange = _this.onDisplayNameChange.bind(_this);
    _this.onHtmlClassesChange = _this.onHtmlClassesChange.bind(_this);
    _this.onImagesListChange = _this.onImagesListChange.bind(_this);
    _this.toggleImages = _this.toggleImages.bind(_this);
    _this.toggleSettings = _this.toggleSettings.bind(_this);
    _this.onClick = _this.onClick.bind(_this);
    _this.state = {
      showImages: false,
      showSettings: false
    };
    return _this;
  }

  _createClass(ChosenListItem, [{
    key: 'onShowPriceChange',
    value: function onShowPriceChange(event) {
      var _props = this.props,
          list = _props.list,
          onShowPriceChange = _props.onShowPriceChange;

      onShowPriceChange(list.id, event.target.checked);
    }
  }, {
    key: 'onShowDescriptionChange',
    value: function onShowDescriptionChange(event) {
      var _props2 = this.props,
          list = _props2.list,
          onShowDescriptionChange = _props2.onShowDescriptionChange;

      onShowDescriptionChange(list.id, event.target.checked);
    }
  }, {
    key: 'onDisplayNameChange',
    value: function onDisplayNameChange(event) {
      var _props3 = this.props,
          list = _props3.list,
          onDisplayNameChange = _props3.onDisplayNameChange;

      onDisplayNameChange(list.id, event.target.value);
    }
  }, {
    key: 'onHtmlClassesChange',
    value: function onHtmlClassesChange(event) {
      var _props4 = this.props,
          list = _props4.list,
          onHtmlClassesChange = _props4.onHtmlClassesChange;

      onHtmlClassesChange(list.id, event.target.value);
    }
  }, {
    key: 'onImagesListChange',
    value: function onImagesListChange(itemIds) {
      var _props5 = this.props,
          list = _props5.list,
          onImagesListChange = _props5.onImagesListChange;

      onImagesListChange(list.id, itemIds);
    }
  }, {
    key: 'toggleImages',
    value: function toggleImages() {
      this.setState(function (prevState) {
        return { showImages: !prevState.showImages };
      });
    }
  }, {
    key: 'toggleSettings',
    value: function toggleSettings() {
      this.setState(function (prevState) {
        return { showSettings: !prevState.showSettings };
      });
    }
  }, {
    key: 'onClick',
    value: function onClick(event) {
      if (!confirm(_constants2.default.CONFIRM_TEXT)) {
        event.preventDefault();
      }
    }
  }, {
    key: 'itemsWithImages',
    value: function itemsWithImages() {
      var list = this.props.list;

      if (!list.beers) return [];
      return list.beers.filter(function (item) {
        return !!item.imageUrl;
      });
    }
  }, {
    key: 'render',
    value: function render() {
      var _props6 = this.props,
          index = _props6.index,
          list = _props6.list,
          nestedAttrsName = _props6.nestedAttrsName,
          entityName = _props6.entityName,
          nestedEntityIdName = _props6.nestedEntityIdName,
          onRemove = _props6.onRemove,
          connectDragSource = _props6.connectDragSource,
          connectDropTarget = _props6.connectDropTarget,
          isDragging = _props6.isDragging;


      var showDescriptionInput = void 0,
          htmlClassesInput = void 0;

      if (this.props.onShowDescriptionChange) {
        showDescriptionInput = _react2.default.createElement(_ShowDescriptionInput2.default, {
          entityName: entityName,
          nestedAttrsName: nestedAttrsName,
          index: index,
          onChange: this.onShowDescriptionChange,
          value: list.show_description_on_menu
        });
      }

      if (this.props.onHtmlClassesChange) {
        htmlClassesInput = _react2.default.createElement(
          'div',
          { className: 'form-group' },
          _react2.default.createElement(
            'label',
            { htmlFor: 'list-html-classes-' + index },
            'HTML classes'
          ),
          _react2.default.createElement('input', {
            id: 'list-html-classes-' + index,
            type: 'text',
            name: entityName + '[' + nestedAttrsName + '][' + index + '][html_classes]',
            className: 'form-control',
            'aria-describedby': 'html-classes-help-' + index,
            defaultValue: list.htmlClasses,
            onBlur: this.onHtmlClassesChange,
            'data-test': 'html-classes-input'
          }),
          _react2.default.createElement(
            'small',
            { id: 'html-classes-help-' + index, className: 'form-text text-muted' },
            'HTML classes to help your designer style this list on your site'
          )
        );
      }

      var imageIcon = _react2.default.createElement(
        'span',
        { className: 'hidden-image-toggle-wrapper ml-2' },
        _react2.default.createElement('i', { className: 'far fa-image fa-lg' })
      );

      if (this.itemsWithImages().length) {
        var wrapperClass = void 0;
        var isActive = this.state.showImages;
        if (isActive) {
          wrapperClass = 'icon-images-shown';
        }
        imageIcon = _react2.default.createElement(
          'span',
          { className: wrapperClass },
          _react2.default.createElement('i', {
            className: 'far fa-image fa-lg image-toggle ml-2',
            title: 'Show Image Options',
            role: 'button',
            'aria-pressed': isActive,
            onClick: this.toggleImages,
            'data-test': 'image-toggle' })
        );
      }
      var settingsCog = _react2.default.createElement(
        'span',
        { className: 'toggle-settings toggle-settings-' + (this.state.showSettings ? 'shown' : 'hidden') },
        _react2.default.createElement('i', {
          className: 'fas fa-cog settings-toggle',
          title: 'Show Settings',
          role: 'button',
          'aria-pressed': this.state.showSettings,
          onClick: this.toggleSettings,
          'data-test': 'settings-toggle' })
      );

      var badgeContent = list.itemCount + ' ' + (0, _pluralize2.default)('item', list.itemCount);

      var style = {
        opacity: isDragging ? 0 : 1,
        cursor: 'move'
      };
      return connectDragSource(connectDropTarget(_react2.default.createElement(
        'li',
        { className: 'list-group-item list-group-item-action', 'data-test': 'menu-list', style: style },
        _react2.default.createElement(
          'div',
          { className: 'valign-wrapper-w10' },
          _react2.default.createElement(_RemoveButton2.default, { onClick: onRemove, listId: list.id })
        ),
        _react2.default.createElement(
          'div',
          { className: 'valign-wrapper-w50' },
          _react2.default.createElement(
            'a',
            {
              href: list.href,
              onClick: this.onClick,
              className: 'list-name',
              'data-test': 'list-name' },
            list.name
          )
        ),
        _react2.default.createElement(
          'div',
          { className: 'valign-wrapper-w40' },
          imageIcon,
          settingsCog,
          _react2.default.createElement(_ListTypeIcon2.default, { listType: list.type }),
          _react2.default.createElement(
            'span',
            {
              'data-test': 'list-badge',
              className: 'badge badge-pill badge-success float-right mr-2'
            },
            badgeContent
          )
        ),
        _react2.default.createElement(
          'div',
          { className: 'settings ' + (this.state.showSettings ? 'show' : 'hidden'), 'data-test': 'list-item-settings' },
          _react2.default.createElement(_ShowPriceInput2.default, {
            entityName: entityName,
            nestedAttrsName: nestedAttrsName,
            index: index,
            onChange: this.onShowPriceChange,
            value: list.show_price_on_menu
          }),
          showDescriptionInput,
          _react2.default.createElement(
            'div',
            { className: 'form-group' },
            _react2.default.createElement(
              'label',
              { htmlFor: 'list-display-name-' + index },
              'Display Name'
            ),
            _react2.default.createElement('input', {
              id: 'list-display-name-' + index,
              type: 'text',
              name: entityName + '[' + nestedAttrsName + '][' + index + '][display_name]',
              className: 'form-control',
              'aria-describedby': 'display-name-help-' + index,
              defaultValue: list.displayName,
              onBlur: this.onDisplayNameChange,
              'data-test': 'display-name-input'
            }),
            _react2.default.createElement(
              'small',
              { id: 'display-name-help-' + index, className: 'form-text text-muted' },
              'Customize your list\'s name for just this menu'
            )
          ),
          htmlClassesInput
        ),
        _react2.default.createElement(_ListItemImageChoices2.default, {
          itemsWithAvailableImages: this.itemsWithImages(),
          chosenItemIds: list.items_with_images,
          entityName: entityName,
          nestedAttrsName: nestedAttrsName,
          index: index,
          show: this.state.showImages,
          onChange: this.onImagesListChange
        }),
        _react2.default.createElement('input', {
          type: 'hidden',
          name: entityName + '[' + nestedAttrsName + '][' + index + '][id]',
          value: list[nestedEntityIdName]
        }),
        _react2.default.createElement('input', {
          type: 'hidden',
          name: entityName + '[' + nestedAttrsName + '][' + index + '][list_id]',
          value: list.id
        }),
        _react2.default.createElement('input', {
          type: 'hidden',
          name: entityName + '[' + nestedAttrsName + '][' + index + '][position]',
          value: index
        })
      )));
    }
  }]);

  return ChosenListItem;
}(_react.Component);

ChosenListItem.defaultProps = {
  onImagesListChange: function onImagesListChange() {}
};

ChosenListItem.propTypes = {
  list: _propTypes2.default.object.isRequired,
  index: _propTypes2.default.number.isRequired,
  onRemove: _propTypes2.default.func.isRequired,
  onShowPriceChange: _propTypes2.default.func.isRequired,
  onShowDescriptionChange: _propTypes2.default.func,
  onDisplayNameChange: _propTypes2.default.func,
  onHtmlClassesChange: _propTypes2.default.func,
  onImagesListChange: _propTypes2.default.func,
  nestedAttrsName: _propTypes2.default.string.isRequired,
  entityName: _propTypes2.default.string.isRequired,
  nestedEntityIdName: _propTypes2.default.string.isRequired,
  connectDragSource: _propTypes2.default.func.isRequired,
  isDragging: _propTypes2.default.bool.isRequired,
  moveItem: _propTypes2.default.func.isRequired
};

var dropTarget = (0, _reactDnd.DropTarget)(_itemTypes2.default.chosenListItem, itemTarget, dropCollect)(ChosenListItem);

exports.default = (0, _reactDnd.DragSource)(_itemTypes2.default.chosenListItem, itemSource, dragCollect)(dropTarget);

/***/ }),

/***/ "./app/assets/javascripts/shared/ColorPickerInput.js":
/*!***********************************************************!*\
  !*** ./app/assets/javascripts/shared/ColorPickerInput.js ***!
  \***********************************************************/
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

var _reactColor = __webpack_require__(/*! react-color */ "./node_modules/react-color/lib/index.js");

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var ColorPickerInput = function (_Component) {
  _inherits(ColorPickerInput, _Component);

  function ColorPickerInput(props) {
    _classCallCheck(this, ColorPickerInput);

    var _this = _possibleConstructorReturn(this, (ColorPickerInput.__proto__ || Object.getPrototypeOf(ColorPickerInput)).call(this, props));

    _this.handleFocus = _this.handleFocus.bind(_this);
    _this.handleClose = _this.handleClose.bind(_this);
    _this.handleColorChange = _this.handleColorChange.bind(_this);

    _this.state = {
      showColorPicker: false
    };
    return _this;
  }

  _createClass(ColorPickerInput, [{
    key: 'handleFocus',
    value: function handleFocus() {
      this.setState(function (prevState) {
        return { showColorPicker: true };
      });
    }
  }, {
    key: 'handleClose',
    value: function handleClose() {
      this.setState(function (prevState) {
        return { showColorPicker: false };
      });
    }
  }, {
    key: 'handleColorChange',
    value: function handleColorChange(event) {
      var color = event.target.value;
      this.props.onChangeComplete({ hex: color });
    }
  }, {
    key: 'renderPicker',
    value: function renderPicker() {
      var _props = this.props,
          onChangeComplete = _props.onChangeComplete,
          color = _props.color;

      var popover = {
        position: 'absolute',
        zIndex: '2'
      };
      var cover = {
        position: 'fixed',
        top: '0px',
        right: '0px',
        bottom: '0px',
        left: '0px'
      };

      var picker = void 0;
      if (this.state.showColorPicker) {
        picker = _react2.default.createElement(
          'div',
          { style: popover },
          _react2.default.createElement('div', { style: cover, onClick: this.handleClose }),
          _react2.default.createElement(_reactColor.ChromePicker, { color: color, onChangeComplete: onChangeComplete, disableAlpha: true })
        );
      }

      return picker;
    }
  }, {
    key: 'render',
    value: function render() {
      var _props2 = this.props,
          label = _props2.label,
          color = _props2.color,
          id = _props2.id,
          name = _props2.name,
          dataTest = _props2.dataTest,
          className = _props2.className;

      var picker = this.renderPicker();

      return _react2.default.createElement(
        'div',
        { className: className },
        _react2.default.createElement(
          'label',
          null,
          label
        ),
        _react2.default.createElement('input', {
          id: id,
          name: name,
          'data-test': dataTest,
          type: 'text',
          className: 'form-control',
          value: color,
          readOnly: true,
          onFocus: this.handleFocus,
          onClick: this.handleFocus
        }),
        picker
      );
    }
  }]);

  return ColorPickerInput;
}(_react.Component);

ColorPickerInput.propTypes = {
  label: _propTypes2.default.string.isRequired,
  color: _propTypes2.default.string.isRequired,
  onChangeComplete: _propTypes2.default.func.isRequired,
  id: _propTypes2.default.string.isRequired,
  name: _propTypes2.default.string.isRequired,
  dataTest: _propTypes2.default.string.isRequired,
  className: _propTypes2.default.string
};

ColorPickerInput.defaultProps = {
  className: 'form-group'
};

exports.default = ColorPickerInput;

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

/***/ "./app/assets/javascripts/shared/ListItemImageChoices.js":
/*!***************************************************************!*\
  !*** ./app/assets/javascripts/shared/ListItemImageChoices.js ***!
  \***************************************************************/
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

var ListItemImageChoices = function (_Component) {
  _inherits(ListItemImageChoices, _Component);

  function ListItemImageChoices(props) {
    _classCallCheck(this, ListItemImageChoices);

    var _this = _possibleConstructorReturn(this, (ListItemImageChoices.__proto__ || Object.getPrototypeOf(ListItemImageChoices)).call(this, props));

    _this.onChange = _this.onChange.bind(_this);
    return _this;
  }

  _createClass(ListItemImageChoices, [{
    key: 'onChange',
    value: function onChange(event) {
      var itemId = Number(event.target.value);
      var chosenItemIds = this.props.chosenItemIds;

      var itemIds = void 0;
      if (chosenItemIds.includes(itemId)) {
        itemIds = chosenItemIds.filter(function (id) {
          return id !== itemId;
        });
      } else {
        itemIds = chosenItemIds.concat([itemId]);
      }
      this.props.onChange(itemIds);
    }
  }, {
    key: 'render',
    value: function render() {
      var _this2 = this;

      var _props = this.props,
          itemsWithAvailableImages = _props.itemsWithAvailableImages,
          chosenItemIds = _props.chosenItemIds,
          entityName = _props.entityName,
          index = _props.index,
          nestedAttrsName = _props.nestedAttrsName,
          show = _props.show;

      var inputs = itemsWithAvailableImages.map(function (item, idx) {
        var isChecked = chosenItemIds.includes(item.id);
        var htmlId = 'show-image-' + item.name;
        return _react2.default.createElement(
          'div',
          { className: 'list-item-image-choice', key: idx, 'data-test': 'list-item-image-option' },
          _react2.default.createElement(
            'label',
            {
              htmlFor: htmlId,
              'data-test': 'show-image-for-item' },
            _react2.default.createElement('input', {
              type: 'checkbox',
              'data-test': 'image-option-input',
              value: item.id,
              name: entityName + '[' + nestedAttrsName + '][' + index + '][items_with_images][]',
              defaultChecked: isChecked,
              onChange: _this2.onChange,
              id: htmlId }),
            item.name
          )
        );
      });
      return _react2.default.createElement(
        'div',
        { className: 'list-item-images-choices ' + (show ? 'show' : 'hidden'), 'data-test': 'list-item-image-choices' },
        inputs
      );
    }
  }]);

  return ListItemImageChoices;
}(_react.Component);

ListItemImageChoices.defaultProps = {
  imagesWithAvailableImages: [],
  chosenItemIds: [],
  show: false
};

ListItemImageChoices.propTypes = {
  itemsWithAvailableImages: _propTypes2.default.array,
  chosenItemIds: _propTypes2.default.array,
  entityName: _propTypes2.default.string.isRequired,
  nestedAttrsName: _propTypes2.default.string.isRequired,
  index: _propTypes2.default.number.isRequired,
  show: _propTypes2.default.bool
};

exports.default = ListItemImageChoices;

/***/ }),

/***/ "./app/assets/javascripts/shared/ListTypeIcon.js":
/*!*******************************************************!*\
  !*** ./app/assets/javascripts/shared/ListTypeIcon.js ***!
  \*******************************************************/
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

var beerGlass = 'fa-beer';
var cutlery = 'fa-utensils';
var coffee = 'fa-coffee';

var ICONS_BY_TYPE = {
  'drink': beerGlass,
  'food': cutlery,
  'other': coffee
};

function iconFromType(type) {
  return ICONS_BY_TYPE[type.replace(/\s+/, '-')] || cutlery;
}

var ListTypeIcon = function (_Component) {
  _inherits(ListTypeIcon, _Component);

  function ListTypeIcon() {
    _classCallCheck(this, ListTypeIcon);

    return _possibleConstructorReturn(this, (ListTypeIcon.__proto__ || Object.getPrototypeOf(ListTypeIcon)).apply(this, arguments));
  }

  _createClass(ListTypeIcon, [{
    key: 'render',
    value: function render() {
      var _props = this.props,
          listType = _props.listType,
          className = _props.className;

      var icon = iconFromType(listType);
      return _react2.default.createElement('span', {
        className: 'fas ' + icon + ' ' + className,
        'aria-hidden': 'true',
        title: listType });
    }
  }]);

  return ListTypeIcon;
}(_react.Component);

ListTypeIcon.propTypes = {
  listType: _propTypes2.default.string.isRequired,
  className: _propTypes2.default.string
};

ListTypeIcon.defaultProps = {
  className: 'fa-lg float-right'
};

exports.default = ListTypeIcon;

/***/ }),

/***/ "./app/assets/javascripts/shared/MenuFormButtons.js":
/*!**********************************************************!*\
  !*** ./app/assets/javascripts/shared/MenuFormButtons.js ***!
  \**********************************************************/
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

var MenuFormButtons = function (_Component) {
  _inherits(MenuFormButtons, _Component);

  function MenuFormButtons() {
    _classCallCheck(this, MenuFormButtons);

    return _possibleConstructorReturn(this, (MenuFormButtons.__proto__ || Object.getPrototypeOf(MenuFormButtons)).apply(this, arguments));
  }

  _createClass(MenuFormButtons, [{
    key: 'render',
    value: function render() {
      var _props = this.props,
          menuType = _props.menuType,
          canDestroy = _props.canDestroy,
          submitButtonText = _props.submitButtonText,
          cancelEditPath = _props.cancelEditPath,
          children = _props.children;

      var deleteButton = void 0;

      if (canDestroy) {
        deleteButton = _react2.default.createElement(
          'label',
          {
            htmlFor: menuType + '-form-delete',
            className: 'btn btn-evrgn-delete menu-form-action',
            'data-test': menuType + '-form-delete' },
          'Delete'
        );
      }

      return _react2.default.createElement(
        'div',
        { className: 'button-wrapper' },
        _react2.default.createElement('input', {
          type: 'submit',
          name: 'commit',
          value: submitButtonText,
          className: 'btn btn-evrgn-primary menu-form-action',
          'data-test': menuType + '-form-submit',
          'data-disable-with': 'Create'
        }),
        _react2.default.createElement(
          'a',
          { href: cancelEditPath,
            className: 'btn btn-outline-secondary menu-form-action',
            'data-test': menuType + '-form-cancel' },
          'Cancel'
        ),
        deleteButton,
        children
      );
    }
  }]);

  return MenuFormButtons;
}(_react.Component);

MenuFormButtons.defaultProps = {
  canDestroy: false
};

MenuFormButtons.propTypes = {
  menuType: _propTypes2.default.string.isRequired,
  canDestroy: _propTypes2.default.bool,
  submitButtonText: _propTypes2.default.string.isRequired,
  cancelEditPath: _propTypes2.default.string.isRequired
};

exports.default = MenuFormButtons;

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

/***/ }),

/***/ "./app/assets/javascripts/shared/RemoveButton.js":
/*!*******************************************************!*\
  !*** ./app/assets/javascripts/shared/RemoveButton.js ***!
  \*******************************************************/
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

var RemoveButton = function (_Component) {
  _inherits(RemoveButton, _Component);

  function RemoveButton(props) {
    _classCallCheck(this, RemoveButton);

    var _this = _possibleConstructorReturn(this, (RemoveButton.__proto__ || Object.getPrototypeOf(RemoveButton)).call(this, props));

    _this.handleClick = _this.handleClick.bind(_this);
    return _this;
  }

  _createClass(RemoveButton, [{
    key: 'handleClick',
    value: function handleClick(event) {
      var listId = this.props.listId;

      event.preventDefault();
      this.props.onClick(listId);
    }
  }, {
    key: 'render',
    value: function render() {
      return _react2.default.createElement(
        'a',
        {
          href: '',
          role: 'button',
          'data-test': 'remove-list',
          title: 'Remove list',
          onClick: this.handleClick,
          className: 'btn btn-outline-secondary btn-sm move-list-button' },
        _react2.default.createElement('span', { className: 'fas fa-minus fa-lg' })
      );
    }
  }]);

  return RemoveButton;
}(_react.Component);

RemoveButton.propTypes = {
  onClick: _propTypes2.default.func.isRequired,
  listId: _propTypes2.default.number.isRequired
};

exports.default = RemoveButton;

/***/ }),

/***/ "./app/assets/javascripts/shared/ShowDescriptionInput.js":
/*!***************************************************************!*\
  !*** ./app/assets/javascripts/shared/ShowDescriptionInput.js ***!
  \***************************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _react = __webpack_require__(/*! react */ "./node_modules/react/index.js");

var _react2 = _interopRequireDefault(_react);

var _propTypes = __webpack_require__(/*! prop-types */ "./node_modules/prop-types/index.js");

var _propTypes2 = _interopRequireDefault(_propTypes);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var ShowDescriptionInput = function (_Component) {
  _inherits(ShowDescriptionInput, _Component);

  function ShowDescriptionInput() {
    _classCallCheck(this, ShowDescriptionInput);

    return _possibleConstructorReturn(this, (ShowDescriptionInput.__proto__ || Object.getPrototypeOf(ShowDescriptionInput)).apply(this, arguments));
  }

  _createClass(ShowDescriptionInput, [{
    key: 'render',
    value: function render() {
      var _props = this.props,
          entityName = _props.entityName,
          nestedAttrsName = _props.nestedAttrsName,
          index = _props.index,
          value = _props.value,
          onChange = _props.onChange;

      var showDescriptionInputId = 'menu_' + nestedAttrsName + '_' + index + '_show_description_on_menu';
      var showDescription = {
        type: 'checkbox',
        name: entityName + '[' + nestedAttrsName + '][' + index + '][show_description_on_menu]',
        id: showDescriptionInputId,
        'data-test': 'show-descriptions',
        value: '1',
        onChange: onChange
        // New records always show description
      };if (value === undefined || value) {
        showDescription.defaultChecked = 'checked';
      }

      return _react2.default.createElement(
        'div',
        { className: 'form-check chosen-list-toggle-detail' },
        _react2.default.createElement('input', {
          type: 'hidden',
          name: entityName + '[' + nestedAttrsName + '][' + index + '][show_description_on_menu]',
          value: '0'
        }),
        _react2.default.createElement('input', _extends({}, showDescription, { className: 'form-check-input' })),
        _react2.default.createElement(
          'label',
          {
            htmlFor: showDescriptionInputId,
            className: 'menu-list-show-description form-check-label',
            'data-test': 'show-descriptions-label' },
          'Show description'
        )
      );
    }
  }]);

  return ShowDescriptionInput;
}(_react.Component);

ShowDescriptionInput.defaultProps = {
  value: true
};

ShowDescriptionInput.propTypes = {
  entityName: _propTypes2.default.string.isRequired,
  nestedAttrsName: _propTypes2.default.string.isRequired,
  index: _propTypes2.default.number.isRequired,
  onChange: _propTypes2.default.func.isRequired,
  value: _propTypes2.default.bool
};

exports.default = ShowDescriptionInput;

/***/ }),

/***/ "./app/assets/javascripts/shared/ShowPriceInput.js":
/*!*********************************************************!*\
  !*** ./app/assets/javascripts/shared/ShowPriceInput.js ***!
  \*********************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _react = __webpack_require__(/*! react */ "./node_modules/react/index.js");

var _react2 = _interopRequireDefault(_react);

var _propTypes = __webpack_require__(/*! prop-types */ "./node_modules/prop-types/index.js");

var _propTypes2 = _interopRequireDefault(_propTypes);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var ShowPriceInput = function (_Component) {
  _inherits(ShowPriceInput, _Component);

  function ShowPriceInput() {
    _classCallCheck(this, ShowPriceInput);

    return _possibleConstructorReturn(this, (ShowPriceInput.__proto__ || Object.getPrototypeOf(ShowPriceInput)).apply(this, arguments));
  }

  _createClass(ShowPriceInput, [{
    key: 'render',
    value: function render() {
      var _props = this.props,
          entityName = _props.entityName,
          nestedAttrsName = _props.nestedAttrsName,
          index = _props.index,
          value = _props.value,
          onChange = _props.onChange;

      var showPriceInputId = 'menu_' + nestedAttrsName + '_' + index + '_show_price_on_menu';
      var showPrice = {
        type: 'checkbox',
        name: entityName + '[' + nestedAttrsName + '][' + index + '][show_price_on_menu]',
        id: showPriceInputId,
        'data-test': 'show-price',
        value: '1',
        onChange: onChange
        // New records always show price
      };if (value === undefined || value) {
        showPrice.defaultChecked = 'checked';
      }

      return _react2.default.createElement(
        'div',
        { className: 'form-check chosen-list-toggle-detail' },
        _react2.default.createElement('input', {
          type: 'hidden',
          name: entityName + '[' + nestedAttrsName + '][' + index + '][show_price_on_menu]',
          value: '0'
        }),
        _react2.default.createElement('input', _extends({}, showPrice, { className: 'form-check-input' })),
        _react2.default.createElement(
          'label',
          {
            htmlFor: showPriceInputId,
            className: 'menu-list-show-price form-check-label',
            'data-test': 'show-price-label' },
          'Show price'
        )
      );
    }
  }]);

  return ShowPriceInput;
}(_react.Component);

ShowPriceInput.defaultProps = {
  value: true
};

ShowPriceInput.propTypes = {
  entityName: _propTypes2.default.string.isRequired,
  nestedAttrsName: _propTypes2.default.string.isRequired,
  index: _propTypes2.default.number.isRequired,
  onChange: _propTypes2.default.func.isRequired,
  value: _propTypes2.default.bool
};

exports.default = ShowPriceInput;

/***/ }),

/***/ "./app/assets/javascripts/shared/attributeNameResolver.js":
/*!****************************************************************!*\
  !*** ./app/assets/javascripts/shared/attributeNameResolver.js ***!
  \****************************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
var attrNamesByMenuType = {
  pdf: 'menu_lists_attributes',
  digitalDisplay: 'digital_display_menu_lists_attributes',
  web: 'web_menu_lists_attributes',
  online: 'online_menu_lists_attributes'
};

var entityNamesByMenuType = {
  pdf: 'menu',
  digitalDisplay: 'digital_display_menu',
  web: 'web_menu',
  online: 'online_menu'
};

var resolveEntityIdName = {
  pdf: 'menu_list_id',
  digitalDisplay: 'digital_display_menu_list_id',
  web: 'web_menu_list_id',
  online: 'online_menu_list_id'
};

function resolveNestedAttrName(menuType) {
  return attrNamesByMenuType[menuType];
}

function resolveEntityName(menuType) {
  return entityNamesByMenuType[menuType];
}

function resolveNestedEntityIdName(menuType) {
  return resolveEntityIdName[menuType];
}

exports.default = {
  resolveNestedAttrName: resolveNestedAttrName,
  resolveEntityName: resolveEntityName,
  resolveNestedEntityIdName: resolveNestedEntityIdName
};

/***/ }),

/***/ "./app/assets/javascripts/shared/constants.js":
/*!****************************************************!*\
  !*** ./app/assets/javascripts/shared/constants.js ***!
  \****************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = {
  CONFIRM_TEXT: 'Are you sure you want to leave this menu? Unsaved changes will be lost.'
};

/***/ }),

/***/ "./app/assets/javascripts/shared/item-types.js":
/*!*****************************************************!*\
  !*** ./app/assets/javascripts/shared/item-types.js ***!
  \*****************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = {
  chosenListItem: 'chosen-list-item',
  availableListItem: 'available-list-item',
  listItem: 'list-item'
};

/***/ }),

/***/ "./app/assets/javascripts/shared/pluralize.js":
/*!****************************************************!*\
  !*** ./app/assets/javascripts/shared/pluralize.js ***!
  \****************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

exports.default = function (word, count) {
  return Number(count) === 1 ? word : word + "s";
};

;

/***/ }),

/***/ "./app/assets/javascripts/shared/previewPathUtils.js":
/*!***********************************************************!*\
  !*** ./app/assets/javascripts/shared/previewPathUtils.js ***!
  \***********************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = initUtils;

var _attributeNameResolver = __webpack_require__(/*! ./attributeNameResolver */ "./app/assets/javascripts/shared/attributeNameResolver.js");

var _attributeNameResolver2 = _interopRequireDefault(_attributeNameResolver);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function shouldShowPrice(list) {
  if (list.show_price_on_menu === undefined) {
    return true;
  } else {
    return list.show_price_on_menu;
  }
}

function shouldShowDescription(list) {
  if (list.show_description_on_menu === undefined) {
    return true;
  } else {
    return list.show_description_on_menu;
  }
}

function initUtils(menuType) {
  var nestedAttrsName = _attributeNameResolver2.default.resolveNestedAttrName(menuType);
  var entityName = _attributeNameResolver2.default.resolveEntityName(menuType);
  var nestedEntityIdName = _attributeNameResolver2.default.resolveNestedEntityIdName(menuType);

  function buildMenuListRep(num) {
    return entityName + '[' + nestedAttrsName + '][' + num + ']';
  }

  return {
    buildMenuListDisplayName: function buildMenuListDisplayName(list, index, displayName) {
      if (!displayName) return '';
      var listRep = buildMenuListRep(index);
      return listRep + '[display_name]=' + displayName;
    },
    buildMenuListHtmlClasses: function buildMenuListHtmlClasses(list, index, htmlClasses) {
      if (!htmlClasses) return '';
      var listRep = buildMenuListRep(index);
      return listRep + '[html_classes]=' + htmlClasses;
    },
    buildMenuListItemsWithImages: function buildMenuListItemsWithImages(list, index) {
      if (!list.items_with_images) return '';

      var listRep = buildMenuListRep(index);
      return list.items_with_images.map(function (itemId) {
        return listRep + '[items_with_images][]=' + itemId;
      }).join('&');
    },
    buildMenuListShowPrice: function buildMenuListShowPrice(list, index) {
      var listRep = buildMenuListRep(index);
      var showPrice = shouldShowPrice(list);
      return listRep + '[show_price_on_menu]=' + showPrice;
    },
    buildMenuListShowDescription: function buildMenuListShowDescription(list, index) {
      var listRep = buildMenuListRep(index);
      var showDesc = shouldShowDescription(list);
      return listRep + '[show_description_on_menu]=' + showDesc;
    },
    buildMenuListPosition: function buildMenuListPosition(list, index) {
      var listRep = buildMenuListRep(index);
      return listRep + '[position]=' + index;
    },
    buildMenuListListId: function buildMenuListListId(list, index) {
      var listRep = buildMenuListRep(index);
      return listRep + '[list_id]=' + list.id;
    },
    buildMenuListId: function buildMenuListId(list, index) {
      var listRep = buildMenuListRep(index);
      return listRep + '[id]=' + list[nestedEntityIdName];
    }
  };
}

/***/ })

/******/ });
//# sourceMappingURL=digital-display-menus.js.map