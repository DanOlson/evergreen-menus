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
/******/ 		"lists": 0
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
/******/ 	deferredModules.push(["./app/assets/javascripts/lists.js","vendor"]);
/******/ 	// run deferred modules when ready
/******/ 	return checkDeferredModules();
/******/ })
/************************************************************************/
/******/ ({

/***/ "./app/assets/javascripts/list/App.js":
/*!********************************************!*\
  !*** ./app/assets/javascripts/list/App.js ***!
  \********************************************/
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

var _List = __webpack_require__(/*! ./List */ "./app/assets/javascripts/list/List.js");

var _List2 = _interopRequireDefault(_List);

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
    key: 'render',
    value: function render() {
      var _props = this.props,
          list = _props.list,
          typeOptions = _props.typeOptions,
          menuItemLabels = _props.menuItemLabels;
      var beers = list.beers,
          name = list.name,
          type = list.type,
          description = list.description;

      var listProps = {
        listId: list.id,
        beers: beers,
        name: name,
        type: type,
        description: description,
        typeOptions: typeOptions,
        menuItemLabels: menuItemLabels
      };

      return _react2.default.createElement(_List2.default, listProps);
    }
  }]);

  return App;
}(_react.Component);

;

App.propTypes = {
  list: _propTypes2.default.object.isRequired,
  typeOptions: _propTypes2.default.array.isRequired,
  menuItemLabels: _propTypes2.default.array.isRequired
};

exports.default = App;

/***/ }),

/***/ "./app/assets/javascripts/list/Flyout.js":
/*!***********************************************!*\
  !*** ./app/assets/javascripts/list/Flyout.js ***!
  \***********************************************/
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

var Flyout = function (_Component) {
  _inherits(Flyout, _Component);

  function Flyout() {
    _classCallCheck(this, Flyout);

    return _possibleConstructorReturn(this, (Flyout.__proto__ || Object.getPrototypeOf(Flyout)).apply(this, arguments));
  }

  _createClass(Flyout, [{
    key: 'render',
    value: function render() {
      var vis = this.props.show ? '' : 'hidden';
      return _react2.default.createElement(
        'div',
        { className: 'flyout form-row ' + vis, 'data-test': 'menu-item-flyout' },
        this.props.children
      );
    }
  }]);

  return Flyout;
}(_react.Component);

Flyout.defaultProps = {
  show: false
};

Flyout.propTypes = {
  show: _propTypes2.default.bool
};

exports.default = Flyout;

/***/ }),

/***/ "./app/assets/javascripts/list/List.js":
/*!*********************************************!*\
  !*** ./app/assets/javascripts/list/List.js ***!
  \*********************************************/
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

var _ListItemInputGroup = __webpack_require__(/*! ./ListItemInputGroup */ "./app/assets/javascripts/list/ListItemInputGroup.js");

var _ListItemInputGroup2 = _interopRequireDefault(_ListItemInputGroup);

var _TypeSelect = __webpack_require__(/*! ./TypeSelect */ "./app/assets/javascripts/list/TypeSelect.js");

var _TypeSelect2 = _interopRequireDefault(_TypeSelect);

var _Panel = __webpack_require__(/*! ../shared/Panel */ "./app/assets/javascripts/shared/Panel.js");

var _Panel2 = _interopRequireDefault(_Panel);

var _reactDnd = __webpack_require__(/*! react-dnd */ "./node_modules/react-dnd/lib/index.js");

var _reactDndHtml5Backend = __webpack_require__(/*! react-dnd-html5-backend */ "./node_modules/react-dnd-html5-backend/lib/index.js");

var _reactDndHtml5Backend2 = _interopRequireDefault(_reactDndHtml5Backend);

var _Object = __webpack_require__(/*! ../polyfills/Object */ "./app/assets/javascripts/polyfills/Object.js");

var _Array = __webpack_require__(/*! ../polyfills/Array */ "./app/assets/javascripts/polyfills/Array.js");

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _toConsumableArray(arr) { if (Array.isArray(arr)) { for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) { arr2[i] = arr[i]; } return arr2; } else { return Array.from(arr); } }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

(0, _Object.applyAssign)();
(0, _Array.applyFind)();
(0, _Array.applyIncludes)();

var List = function (_Component) {
  _inherits(List, _Component);

  function List(props) {
    _classCallCheck(this, List);

    var _this = _possibleConstructorReturn(this, (List.__proto__ || Object.getPrototypeOf(List)).call(this, props));

    var name = props.name,
        type = props.type,
        description = props.description;

    _this.state = {
      beers: _this.sortBeers(_this.props.beers),
      name: name,
      type: type,
      description: description
    };
    _this.deleteBeer = _this.deleteBeer.bind(_this);
    _this.addBeer = _this.addBeer.bind(_this);
    _this.handleTypeChange = _this.handleTypeChange.bind(_this);
    _this.reorderItems = _this.reorderItems.bind(_this);
    return _this;
  }

  _createClass(List, [{
    key: 'reorderItems',
    value: function reorderItems(dragIndex, hoverIndex) {
      this.setState(function (prevState) {
        var items = prevState.beers;
        var dragItem = items[dragIndex];
        var newItems = [].concat(_toConsumableArray(items));
        newItems.splice(dragIndex, 1);
        newItems.splice(hoverIndex, 0, dragItem);
        return { beers: newItems };
      });
    }
  }, {
    key: 'sortBeers',
    value: function sortBeers(beers) {
      var sorted = beers.sort(function (a, b) {
        var aPos = a.position;
        var bPos = b.position;
        if (aPos > bPos) return 1;
        if (aPos < bPos) return -1;
        return 0;
      });
      return this.applyAppId(sorted);
    }
  }, {
    key: 'applyAppId',
    value: function applyAppId(items) {
      return items.map(function (item, index) {
        item.appId = index;
        return item;
      });
    }
  }, {
    key: 'handleTypeChange',
    value: function handleTypeChange(newType) {
      var type = newType.value;
      this.setState(function (prevState) {
        return { type: type };
      });
    }
  }, {
    key: 'deleteBeer',
    value: function deleteBeer(beerAppId) {
      var beers = this.state.beers;
      var newBeerList = beers.filter(function (beer) {
        return beer.appId !== beerAppId;
      });
      this.setState({ beers: newBeerList });
    }
  }, {
    key: 'addBeer',
    value: function addBeer(event) {
      event.preventDefault();
      var beers = this.state.beers;
      var nextAppId = beers.length;
      var nextPosition = beers.length - 1;
      var newBeer = { appId: nextAppId, position: nextPosition };
      this.setState({ beers: [].concat(_toConsumableArray(beers), [newBeer]) });
    }
  }, {
    key: 'render',
    value: function render() {
      var _this2 = this;

      var _props = this.props,
          listId = _props.listId,
          typeOptions = _props.typeOptions,
          menuItemLabels = _props.menuItemLabels;
      var _state = this.state,
          name = _state.name,
          type = _state.type,
          description = _state.description;

      var inputs = this.state.beers.map(function (beer, index, array) {
        var listItemInputProps = {
          beer: beer,
          listId: listId,
          menuItemLabels: menuItemLabels,
          index: index,
          moveItem: _this2.reorderItems,
          deleteBeer: _this2.deleteBeer,
          key: beer.appId,
          isActive: !beer.id && beer.appId === array.length - 1 // last unsaved list item gets autofocused
        };

        return _react2.default.createElement(_ListItemInputGroup2.default, listItemInputProps);
      });

      return _react2.default.createElement(
        _Panel2.default,
        { title: name },
        _react2.default.createElement(
          'div',
          { className: 'establishment-beer-list' },
          _react2.default.createElement(
            'div',
            { className: 'form-group' },
            _react2.default.createElement(
              'div',
              { className: 'form-row' },
              _react2.default.createElement(
                'div',
                { className: 'col-sm-4' },
                _react2.default.createElement(
                  'label',
                  { htmlFor: 'list_name' },
                  'List Name'
                ),
                _react2.default.createElement('input', {
                  type: 'text',
                  name: 'list[name]',
                  id: 'list_name',
                  className: 'form-control',
                  'data-test': 'list-name',
                  defaultValue: name
                })
              ),
              _react2.default.createElement(_TypeSelect2.default, {
                className: 'col-sm-2',
                options: typeOptions,
                value: type,
                onChange: this.handleTypeChange
              })
            ),
            _react2.default.createElement(
              'div',
              { className: 'form-row' },
              _react2.default.createElement(
                'div',
                { className: 'col-sm-9 list-description-input' },
                _react2.default.createElement(
                  'label',
                  { htmlFor: 'list_description' },
                  'Description'
                ),
                _react2.default.createElement('textarea', {
                  name: 'list[description]',
                  id: 'list_description',
                  className: 'form-control',
                  'data-test': 'list-description',
                  defaultValue: description
                })
              )
            )
          ),
          _react2.default.createElement(
            'div',
            { className: 'form-group' },
            inputs
          ),
          _react2.default.createElement(
            'div',
            { className: 'form-group' },
            _react2.default.createElement(
              'button',
              {
                'data-test': 'add-beer',
                id: 'add-beer-button',
                title: 'Add item',
                onClick: this.addBeer,
                className: 'btn btn-success' },
              _react2.default.createElement('span', { className: 'fas fa-plus fa-lg' })
            )
          )
        )
      );
    }
  }]);

  return List;
}(_react.Component);

List.propTypes = {
  beers: _propTypes2.default.array.isRequired,
  name: _propTypes2.default.string.isRequired,
  description: _propTypes2.default.string,
  typeOptions: _propTypes2.default.array.isRequired,
  menuItemLabels: _propTypes2.default.array.isRequired,
  listId: _propTypes2.default.number
};

exports.default = (0, _reactDnd.DragDropContext)(_reactDndHtml5Backend2.default)(List);

/***/ }),

/***/ "./app/assets/javascripts/list/ListItemAction.js":
/*!*******************************************************!*\
  !*** ./app/assets/javascripts/list/ListItemAction.js ***!
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

var ListItemAction = function (_Component) {
  _inherits(ListItemAction, _Component);

  function ListItemAction() {
    _classCallCheck(this, ListItemAction);

    return _possibleConstructorReturn(this, (ListItemAction.__proto__ || Object.getPrototypeOf(ListItemAction)).apply(this, arguments));
  }

  _createClass(ListItemAction, [{
    key: 'render',
    value: function render() {
      var _props = this.props,
          markedForRemoval = _props.markedForRemoval,
          appId = _props.appId,
          onKeep = _props.onKeep,
          onRemove = _props.onRemove;

      var link = void 0;
      if (markedForRemoval) {
        link = _react2.default.createElement(
          'a',
          { href: '',
            onClick: onKeep,
            'data-test': 'keep-beer-' + appId,
            className: 'btn btn-danger' },
          'Keep'
        );
      } else {
        link = _react2.default.createElement(
          'a',
          { href: '',
            title: 'Remove',
            onClick: onRemove,
            'data-test': 'remove-beer-' + appId,
            className: 'btn btn-outline-secondary' },
          _react2.default.createElement('span', { className: 'fas fa-times' })
        );
      }
      return _react2.default.createElement(
        'div',
        { className: 'col-sm-1 col-xs-4 remove' },
        link
      );
    }
  }]);

  return ListItemAction;
}(_react.Component);

ListItemAction.defaultProps = {
  markedForRemoval: false
};

ListItemAction.propTypes = {
  markedForRemoval: _propTypes2.default.bool,
  appId: _propTypes2.default.number.isRequired,
  onKeep: _propTypes2.default.func.isRequired,
  onRemove: _propTypes2.default.func.isRequired
};

exports.default = ListItemAction;

/***/ }),

/***/ "./app/assets/javascripts/list/ListItemDescriptionInput.js":
/*!*****************************************************************!*\
  !*** ./app/assets/javascripts/list/ListItemDescriptionInput.js ***!
  \*****************************************************************/
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

var ListItemDescriptionInput = function (_Component) {
  _inherits(ListItemDescriptionInput, _Component);

  function ListItemDescriptionInput() {
    _classCallCheck(this, ListItemDescriptionInput);

    return _possibleConstructorReturn(this, (ListItemDescriptionInput.__proto__ || Object.getPrototypeOf(ListItemDescriptionInput)).apply(this, arguments));
  }

  _createClass(ListItemDescriptionInput, [{
    key: 'render',
    value: function render() {
      var _props = this.props,
          appId = _props.appId,
          value = _props.value,
          className = _props.className;

      return _react2.default.createElement(
        'div',
        { className: className },
        _react2.default.createElement(
          'label',
          { htmlFor: 'list_beers_attributes_' + appId + '_description', className: 'sr-only' },
          'Description'
        ),
        _react2.default.createElement('textarea', {
          'data-test': 'beer-description-input-' + appId,
          placeholder: 'Description',
          defaultValue: value,
          rows: '3',
          name: 'list[beers_attributes][' + appId + '][description]',
          id: 'list_beers_attributes_' + appId + '_description',
          className: 'form-control' })
      );
    }
  }]);

  return ListItemDescriptionInput;
}(_react.Component);

ListItemDescriptionInput.defaultProps = {
  value: '',
  className: 'col-sm-4 col-xs-8'
};

ListItemDescriptionInput.propTypes = {
  appId: _propTypes2.default.number.isRequired,
  value: _propTypes2.default.string,
  className: _propTypes2.default.string
};

exports.default = ListItemDescriptionInput;

/***/ }),

/***/ "./app/assets/javascripts/list/ListItemImageInput.js":
/*!***********************************************************!*\
  !*** ./app/assets/javascripts/list/ListItemImageInput.js ***!
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

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; } /* global FileReader */


var defaultLabelText = 'Choose image...';
var maxFileSize = 1000000; // 1MB
var validTypes = ['image/jpeg', 'image/jpg', 'image/png'];

function applyImageSrc(file, callback) {
  var reader = new FileReader();
  reader.onload = function (e) {
    callback(e.target.result);
  };
  reader.readAsDataURL(file);
}

var ListItemImageInput = function (_Component) {
  _inherits(ListItemImageInput, _Component);

  function ListItemImageInput(props) {
    _classCallCheck(this, ListItemImageInput);

    var _this = _possibleConstructorReturn(this, (ListItemImageInput.__proto__ || Object.getPrototypeOf(ListItemImageInput)).call(this, props));

    _this.state = {
      labelText: props.filename || defaultLabelText,
      isValid: true,
      url: props.url
    };
    _this.handleFileChange = _this.handleFileChange.bind(_this);
    _this.handleUrlChange = _this.handleUrlChange.bind(_this);
    return _this;
  }

  _createClass(ListItemImageInput, [{
    key: 'handleUrlChange',
    value: function handleUrlChange(url) {
      this.setState(function () {
        return { url: url };
      });
    }
  }, {
    key: 'handleFileChange',
    value: function handleFileChange(e) {
      var _this2 = this;

      var file = e.target.files[0];
      if (file) {
        this.setState(function () {
          var labelText = file.name;
          var isValid = _this2.isFileValid(file);
          if (isValid) {
            applyImageSrc(file, _this2.handleUrlChange);
          }
          return { labelText: labelText, isValid: isValid, file: file };
        });
      } else {
        this.setState(function () {
          return { labelText: defaultLabelText, isValid: true };
        });
      }
    }
  }, {
    key: 'isFileValid',
    value: function isFileValid(file) {
      var size = file.size;

      var isValidSize = size <= maxFileSize;
      var isValidType = validTypes.includes(file.type);
      return isValidSize && isValidType;
    }
  }, {
    key: 'render',
    value: function render() {
      var _props = this.props,
          appId = _props.appId,
          className = _props.className;
      var _state = this.state,
          labelText = _state.labelText,
          isValid = _state.isValid,
          url = _state.url;

      return _react2.default.createElement(
        'div',
        { className: className },
        _react2.default.createElement(
          'div',
          { className: 'custom-file ' + (isValid ? '' : 'invalid') },
          _react2.default.createElement('input', {
            type: 'file',
            name: 'list[beers_attributes][' + appId + '][image]',
            'data-test': 'beer-image-input',
            id: 'list_beers_attributes_' + appId + '_image',
            className: 'custom-file-input ' + (isValid ? '' : 'js-invalid'),
            onChange: this.handleFileChange
          }),
          _react2.default.createElement(
            'label',
            {
              htmlFor: 'list_beers_attributes_' + appId + '_image',
              className: 'custom-file-label',
              'data-test': 'beer-image-label' },
            labelText
          ),
          _react2.default.createElement(
            'div',
            { className: 'invalid-feedback' },
            'File must be PNG or JPG and no larger than 1MB'
          )
        ),
        _react2.default.createElement(
          'div',
          { className: 'list-item-image-frame' },
          _react2.default.createElement('img', { className: 'list-item-image', src: url })
        )
      );
    }
  }]);

  return ListItemImageInput;
}(_react.Component);

ListItemImageInput.defaultProps = {
  className: 'col'
};
ListItemImageInput.propTypes = {
  appId: _propTypes2.default.number.isRequired,
  filename: _propTypes2.default.string,
  url: _propTypes2.default.string,
  className: _propTypes2.default.string
};

exports.default = ListItemImageInput;

/***/ }),

/***/ "./app/assets/javascripts/list/ListItemInputGroup.js":
/*!***********************************************************!*\
  !*** ./app/assets/javascripts/list/ListItemInputGroup.js ***!
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

var _ListItemNameInput = __webpack_require__(/*! ./ListItemNameInput */ "./app/assets/javascripts/list/ListItemNameInput.js");

var _ListItemNameInput2 = _interopRequireDefault(_ListItemNameInput);

var _PriceOptions = __webpack_require__(/*! ./PriceOptions */ "./app/assets/javascripts/list/PriceOptions.js");

var _PriceOptions2 = _interopRequireDefault(_PriceOptions);

var _ListItemDescriptionInput = __webpack_require__(/*! ./ListItemDescriptionInput */ "./app/assets/javascripts/list/ListItemDescriptionInput.js");

var _ListItemDescriptionInput2 = _interopRequireDefault(_ListItemDescriptionInput);

var _ListItemLabelsInput = __webpack_require__(/*! ./ListItemLabelsInput */ "./app/assets/javascripts/list/ListItemLabelsInput.js");

var _ListItemLabelsInput2 = _interopRequireDefault(_ListItemLabelsInput);

var _ListItemImageInput = __webpack_require__(/*! ./ListItemImageInput */ "./app/assets/javascripts/list/ListItemImageInput.js");

var _ListItemImageInput2 = _interopRequireDefault(_ListItemImageInput);

var _ListItemAction = __webpack_require__(/*! ./ListItemAction */ "./app/assets/javascripts/list/ListItemAction.js");

var _ListItemAction2 = _interopRequireDefault(_ListItemAction);

var _Flyout = __webpack_require__(/*! ./Flyout */ "./app/assets/javascripts/list/Flyout.js");

var _Flyout2 = _interopRequireDefault(_Flyout);

var _ToggleFlyoutButton = __webpack_require__(/*! ./ToggleFlyoutButton */ "./app/assets/javascripts/list/ToggleFlyoutButton.js");

var _ToggleFlyoutButton2 = _interopRequireDefault(_ToggleFlyoutButton);

var _itemTypes = __webpack_require__(/*! ../shared/item-types */ "./app/assets/javascripts/shared/item-types.js");

var _itemTypes2 = _interopRequireDefault(_itemTypes);

var _reactDnd = __webpack_require__(/*! react-dnd */ "./node_modules/react-dnd/lib/index.js");

var _reactDom = __webpack_require__(/*! react-dom */ "./node_modules/react-dom/index.js");

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var itemSource = {
  beginDrag: function beginDrag(props) {
    return {
      id: props.beer.appId,
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

var ListItemInputGroup = function (_Component) {
  _inherits(ListItemInputGroup, _Component);

  function ListItemInputGroup(props) {
    _classCallCheck(this, ListItemInputGroup);

    var _this = _possibleConstructorReturn(this, (ListItemInputGroup.__proto__ || Object.getPrototypeOf(ListItemInputGroup)).call(this, props));

    _this.state = Object.assign({ showFlyout: !props.beer.id }, props.beer);
    _this.onRemove = _this.onRemove.bind(_this);
    _this.onKeep = _this.onKeep.bind(_this);
    _this.toggleFlyout = _this.toggleFlyout.bind(_this);
    return _this;
  }

  _createClass(ListItemInputGroup, [{
    key: 'onRemove',
    value: function onRemove(event) {
      event.preventDefault();
      if (this.state.id) {
        this.markForRemoval();
      } else {
        this.deleteBeer(this.state.appId);
      }
    }
  }, {
    key: 'toggleFlyout',
    value: function toggleFlyout() {
      this.setState(function (prevState) {
        return { showFlyout: !prevState.showFlyout };
      });
    }
  }, {
    key: 'deleteBeer',
    value: function deleteBeer(appId) {
      this.props.deleteBeer(appId);
    }
  }, {
    key: 'markForRemoval',
    value: function markForRemoval() {
      this.setState({ markedForRemoval: true });
    }
  }, {
    key: 'onKeep',
    value: function onKeep(event) {
      event.preventDefault();
      this.setState({ markedForRemoval: false });
    }
  }, {
    key: 'render',
    value: function render() {
      var _state = this.state,
          appId = _state.appId,
          markedForRemoval = _state.markedForRemoval,
          name = _state.name,
          price = _state.price,
          priceOptions = _state.priceOptions,
          description = _state.description,
          labels = _state.labels,
          showFlyout = _state.showFlyout,
          imageUrl = _state.imageUrl,
          imageFilename = _state.imageFilename;

      var className = markedForRemoval ? 'remove-beer' : '';
      var _props = this.props,
          menuItemLabels = _props.menuItemLabels,
          connectDragSource = _props.connectDragSource,
          connectDropTarget = _props.connectDropTarget,
          isDragging = _props.isDragging,
          isActive = _props.isActive,
          index = _props.index;


      var style = {
        opacity: isDragging ? 0 : 1,
        cursor: 'move'
      };

      return connectDragSource(connectDropTarget(_react2.default.createElement(
        'div',
        { 'data-test': 'beer-input', className: 'list-item-input ' + className, style: style },
        _react2.default.createElement(
          'div',
          { className: 'drag-handle' },
          _react2.default.createElement('span', { className: 'fas fa-bars' })
        ),
        _react2.default.createElement(
          'div',
          { className: 'item-input-wrap' },
          _react2.default.createElement(
            'div',
            { className: 'form-row' },
            _react2.default.createElement(_ListItemNameInput2.default, {
              appId: appId,
              value: name,
              className: className,
              focus: isActive
            }),
            _react2.default.createElement(_ToggleFlyoutButton2.default, {
              flyoutShown: showFlyout,
              onClick: this.toggleFlyout
            }),
            _react2.default.createElement(_ListItemAction2.default, {
              appId: appId,
              markedForRemoval: markedForRemoval,
              onKeep: this.onKeep,
              onRemove: this.onRemove
            })
          ),
          _react2.default.createElement(
            _Flyout2.default,
            { show: showFlyout },
            _react2.default.createElement(_ListItemImageInput2.default, {
              appId: appId,
              filename: imageFilename,
              url: imageUrl,
              className: 'col-sm-3 col-xs-8'
            }),
            _react2.default.createElement(
              'div',
              { className: 'col-sm-6' },
              _react2.default.createElement(
                'div',
                { className: 'row' },
                _react2.default.createElement(_ListItemDescriptionInput2.default, { appId: appId, value: description, className: 'col' })
              ),
              _react2.default.createElement(
                'div',
                { className: 'row' },
                _react2.default.createElement(_PriceOptions2.default, { options: priceOptions, className: 'col-sm-10 menu-item-price-options', appId: appId, theLegacyPrice: price })
              )
            ),
            _react2.default.createElement(
              'div',
              { className: 'col' },
              _react2.default.createElement(_ListItemLabelsInput2.default, {
                appId: appId,
                menuItemLabels: menuItemLabels,
                appliedLabels: labels,
                className: ''
              })
            )
          ),
          _react2.default.createElement(
            'div',
            { className: 'form-row' },
            _react2.default.createElement('div', { className: 'col-sm-10 col-xs-12 beer-separator' })
          ),
          _react2.default.createElement('input', {
            type: 'hidden',
            defaultValue: this.state.id,
            name: 'list[beers_attributes][' + appId + '][id]',
            id: 'list_beers_attributes_' + appId + '_id'
          }),
          _react2.default.createElement('input', {
            type: 'hidden',
            defaultValue: index,
            name: 'list[beers_attributes][' + appId + '[position]'
          }),
          _react2.default.createElement('input', {
            type: 'hidden',
            'data-test': 'marked-for-removal',
            defaultValue: markedForRemoval,
            name: 'list[beers_attributes][' + appId + '][_destroy]'
          })
        )
      )));
    }
  }]);

  return ListItemInputGroup;
}(_react.Component);

ListItemInputGroup.propTypes = {
  beer: _propTypes2.default.object.isRequired,
  index: _propTypes2.default.number.isRequired,
  menuItemLabels: _propTypes2.default.array.isRequired,
  deleteBeer: _propTypes2.default.func.isRequired,
  connectDragSource: _propTypes2.default.func.isRequired,
  isDragging: _propTypes2.default.bool.isRequired,
  moveItem: _propTypes2.default.func.isRequired,
  isActive: _propTypes2.default.bool
};

var dropTarget = (0, _reactDnd.DropTarget)(_itemTypes2.default.listItem, itemTarget, dropCollect)(ListItemInputGroup);

exports.default = (0, _reactDnd.DragSource)(_itemTypes2.default.listItem, itemSource, dragCollect)(dropTarget);

/***/ }),

/***/ "./app/assets/javascripts/list/ListItemLabelInput.js":
/*!***********************************************************!*\
  !*** ./app/assets/javascripts/list/ListItemLabelInput.js ***!
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

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var ListItemLabelInput = function (_Component) {
  _inherits(ListItemLabelInput, _Component);

  function ListItemLabelInput() {
    _classCallCheck(this, ListItemLabelInput);

    return _possibleConstructorReturn(this, (ListItemLabelInput.__proto__ || Object.getPrototypeOf(ListItemLabelInput)).apply(this, arguments));
  }

  _createClass(ListItemLabelInput, [{
    key: 'render',
    value: function render() {
      var _props = this.props,
          appId = _props.appId,
          label = _props.label,
          checked = _props.checked;

      var inputId = label.name + '-' + appId;

      return _react2.default.createElement(
        'div',
        { className: 'form-check' },
        _react2.default.createElement('input', {
          'data-test': 'menu-item-label-input',
          type: 'checkbox',
          defaultChecked: checked,
          id: inputId,
          name: 'list[beers_attributes][' + appId + '][labels][]',
          value: label.name
        }),
        _react2.default.createElement(
          'label',
          { className: 'form-check-label', htmlFor: inputId },
          _react2.default.createElement('span', { className: 'fa glyphter-' + label.icon }),
          ' ',
          label.name
        )
      );
    }
  }]);

  return ListItemLabelInput;
}(_react.Component);

ListItemLabelInput.defaultProps = {
  checked: false
};

ListItemLabelInput.propTypes = {
  appId: _propTypes2.default.number.isRequired,
  label: _propTypes2.default.object.isRequired,
  checked: _propTypes2.default.bool
};

exports.default = ListItemLabelInput;

/***/ }),

/***/ "./app/assets/javascripts/list/ListItemLabelsInput.js":
/*!************************************************************!*\
  !*** ./app/assets/javascripts/list/ListItemLabelsInput.js ***!
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

var _ListItemLabelInput = __webpack_require__(/*! ./ListItemLabelInput */ "./app/assets/javascripts/list/ListItemLabelInput.js");

var _ListItemLabelInput2 = _interopRequireDefault(_ListItemLabelInput);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var ListItemLabelsInput = function (_Component) {
  _inherits(ListItemLabelsInput, _Component);

  function ListItemLabelsInput() {
    _classCallCheck(this, ListItemLabelsInput);

    return _possibleConstructorReturn(this, (ListItemLabelsInput.__proto__ || Object.getPrototypeOf(ListItemLabelsInput)).apply(this, arguments));
  }

  _createClass(ListItemLabelsInput, [{
    key: 'render',
    value: function render() {
      var _props = this.props,
          appId = _props.appId,
          menuItemLabels = _props.menuItemLabels,
          appliedLabels = _props.appliedLabels,
          className = _props.className;

      var labelInputs = menuItemLabels.map(function (label, idx) {
        var isChecked = !!appliedLabels.find(function (l) {
          return l.name === label.name;
        });
        var labelProps = {
          appId: appId,
          label: label,
          checked: isChecked,
          key: idx
        };
        return _react2.default.createElement(_ListItemLabelInput2.default, labelProps);
      });

      return _react2.default.createElement(
        'div',
        { className: className },
        _react2.default.createElement('input', { type: 'hidden', name: 'list[beers_attributes][' + appId + '][labels][]' }),
        labelInputs
      );
    }
  }]);

  return ListItemLabelsInput;
}(_react.Component);

ListItemLabelsInput.defaultProps = {
  appliedLabels: [],
  className: 'col-sm-2 col-xs-8'
};

ListItemLabelsInput.propTypes = {
  appId: _propTypes2.default.number.isRequired,
  menuItemLabels: _propTypes2.default.array.isRequired,
  appliedLabels: _propTypes2.default.array,
  className: _propTypes2.default.string
};

exports.default = ListItemLabelsInput;

/***/ }),

/***/ "./app/assets/javascripts/list/ListItemNameInput.js":
/*!**********************************************************!*\
  !*** ./app/assets/javascripts/list/ListItemNameInput.js ***!
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

var ListItemNameInput = function (_Component) {
  _inherits(ListItemNameInput, _Component);

  function ListItemNameInput() {
    _classCallCheck(this, ListItemNameInput);

    return _possibleConstructorReturn(this, (ListItemNameInput.__proto__ || Object.getPrototypeOf(ListItemNameInput)).apply(this, arguments));
  }

  _createClass(ListItemNameInput, [{
    key: 'render',
    value: function render() {
      var _props = this.props,
          appId = _props.appId,
          value = _props.value,
          className = _props.className,
          focus = _props.focus;

      return _react2.default.createElement(
        'div',
        { className: 'col col-xs-8' },
        _react2.default.createElement(
          'label',
          { htmlFor: 'list_beers_attributes_' + appId + '_name', className: 'sr-only' },
          'Name'
        ),
        _react2.default.createElement('input', {
          type: 'text',
          placeholder: 'Name',
          'data-test': 'beer-name-input-' + appId,
          defaultValue: value,
          name: 'list[beers_attributes][' + appId + '][name]',
          id: 'list_beers_attributes_' + appId + '_name',
          className: 'form-control ' + className,
          autoFocus: focus
        })
      );
    }
  }]);

  return ListItemNameInput;
}(_react.Component);

ListItemNameInput.defaultProps = {
  name: '',
  className: '',
  focus: false
};

ListItemNameInput.propTypes = {
  appId: _propTypes2.default.number.isRequired,
  value: _propTypes2.default.string,
  className: _propTypes2.default.string,
  focus: _propTypes2.default.bool
};
exports.default = ListItemNameInput;

/***/ }),

/***/ "./app/assets/javascripts/list/ListItemPriceInput.js":
/*!***********************************************************!*\
  !*** ./app/assets/javascripts/list/ListItemPriceInput.js ***!
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

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var ListItemPriceInput = function (_Component) {
  _inherits(ListItemPriceInput, _Component);

  function ListItemPriceInput(props) {
    _classCallCheck(this, ListItemPriceInput);

    var _this = _possibleConstructorReturn(this, (ListItemPriceInput.__proto__ || Object.getPrototypeOf(ListItemPriceInput)).call(this, props));

    _this.handlePriceChange = _this.handlePriceChange.bind(_this);
    _this.handleUnitChange = _this.handleUnitChange.bind(_this);
    _this.remove = _this.remove.bind(_this);
    return _this;
  }

  _createClass(ListItemPriceInput, [{
    key: 'handlePriceChange',
    value: function handlePriceChange(event) {
      var _props = this.props,
          onChange = _props.onChange,
          id = _props.id;

      onChange(id, { price: event.target.value });
    }
  }, {
    key: 'handleUnitChange',
    value: function handleUnitChange(event) {
      var _props2 = this.props,
          onChange = _props2.onChange,
          id = _props2.id;

      onChange(id, { unit: event.target.value });
    }
  }, {
    key: 'remove',
    value: function remove(event) {
      event.preventDefault();
      var _props3 = this.props,
          onRemove = _props3.onRemove,
          id = _props3.id;

      onRemove(id);
    }
  }, {
    key: 'render',
    value: function render() {
      var _props4 = this.props,
          value = _props4.value,
          unit = _props4.unit;

      return _react2.default.createElement(
        'div',
        { className: 'form-row menu-item-price-option', 'data-test': 'menu-item-price-option' },
        _react2.default.createElement(
          'div',
          { className: 'input-group' },
          _react2.default.createElement(
            'label',
            { className: 'sr-only' },
            'Price'
          ),
          _react2.default.createElement(
            'div',
            { className: 'input-group-prepend' },
            _react2.default.createElement(
              'span',
              { className: 'beer-input-price-currency input-group-text' },
              '$'
            )
          ),
          _react2.default.createElement('input', {
            type: 'number',
            step: '0.01',
            min: '0',
            defaultValue: value,
            className: 'form-control price-input',
            'data-test': 'price-input-amount',
            onChange: this.handlePriceChange
          }),
          _react2.default.createElement(
            'div',
            { className: 'input-group-prepend' },
            _react2.default.createElement(
              'span',
              { className: 'input-group-text' },
              'per'
            )
          ),
          _react2.default.createElement('input', {
            type: 'text',
            defaultValue: unit,
            className: 'form-control',
            'data-test': 'price-input-unit',
            onChange: this.handleUnitChange
          }),
          _react2.default.createElement(
            'div',
            { className: 'remove-price-option' },
            _react2.default.createElement(
              'a',
              {
                href: '',
                onClick: this.remove,
                'data-test': 'remove-price-option',
                className: 'btn btn-outline-secondary' },
              _react2.default.createElement('span', { className: 'fas fa-times' })
            )
          )
        )
      );
    }
  }]);

  return ListItemPriceInput;
}(_react.Component);

ListItemPriceInput.defaultProps = {
  value: null,
  unit: 'Serving',
  className: 'col-sm-2 col-xs-4'
};

ListItemPriceInput.propTypes = {
  value: _propTypes2.default.number,
  unit: _propTypes2.default.string,
  className: _propTypes2.default.string,
  id: _propTypes2.default.number.isRequired,
  onChange: _propTypes2.default.func.isRequired,
  onRemove: _propTypes2.default.func.isRequired
};

exports.default = ListItemPriceInput;

/***/ }),

/***/ "./app/assets/javascripts/list/PriceOptions.js":
/*!*****************************************************!*\
  !*** ./app/assets/javascripts/list/PriceOptions.js ***!
  \*****************************************************/
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

var _ListItemPriceInput = __webpack_require__(/*! ./ListItemPriceInput */ "./app/assets/javascripts/list/ListItemPriceInput.js");

var _ListItemPriceInput2 = _interopRequireDefault(_ListItemPriceInput);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _toConsumableArray(arr) { if (Array.isArray(arr)) { for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) { arr2[i] = arr[i]; } return arr2; } else { return Array.from(arr); } }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var PriceOptions = function (_Component) {
  _inherits(PriceOptions, _Component);

  function PriceOptions(props) {
    _classCallCheck(this, PriceOptions);

    var _this = _possibleConstructorReturn(this, (PriceOptions.__proto__ || Object.getPrototypeOf(PriceOptions)).call(this, props));

    _this.state = {
      options: _this.options()
    };

    _this.addPrice = _this.addPrice.bind(_this);
    _this.handlePriceOptionChange = _this.handlePriceOptionChange.bind(_this);
    _this.removePriceOption = _this.removePriceOption.bind(_this);
    return _this;
  }

  _createClass(PriceOptions, [{
    key: 'newPriceOption',
    value: function newPriceOption() {
      return { price: null, unit: 'Serving ' };
    }
  }, {
    key: 'addPrice',
    value: function addPrice(event) {
      var _this2 = this;

      event.preventDefault();
      this.setState(function (prevState) {
        return { options: prevState.options.concat(_this2.newPriceOption()) };
      });
    }
  }, {
    key: 'handlePriceOptionChange',
    value: function handlePriceOptionChange(position, data) {
      this.setState(function (prevState) {
        var newOptions = [].concat(_toConsumableArray(prevState.options));
        var changedOption = newOptions[position];
        var updated = Object.assign({}, changedOption, data);
        newOptions.splice(position, 1, updated);
        return { options: newOptions };
      });
    }
  }, {
    key: 'removePriceOption',
    value: function removePriceOption(position) {
      this.setState(function (prevState) {
        var newOptions = [].concat(_toConsumableArray(prevState.options));
        newOptions.splice(position, 1);
        return { options: newOptions };
      });
    }
  }, {
    key: 'options',
    value: function options() {
      var options = this.props.options;

      if (options.length) {
        return options;
      } else {
        return [{
          price: this.props.theLegacyPrice,
          unit: 'Serving'
        }];
      }
    }
  }, {
    key: 'render',
    value: function render() {
      var _this3 = this;

      var options = this.state.options;
      var appId = this.props.appId;

      var value = JSON.stringify(options);
      var priceInputs = options.map(function (option, index) {
        return _react2.default.createElement(_ListItemPriceInput2.default, {
          key: index,
          id: index,
          value: option.price,
          unit: option.unit,
          onChange: _this3.handlePriceOptionChange,
          onRemove: _this3.removePriceOption
        });
      });
      return _react2.default.createElement(
        'div',
        { className: this.props.className },
        priceInputs,
        _react2.default.createElement(
          'div',
          { className: 'add-price' },
          _react2.default.createElement(
            'a',
            {
              href: '',
              onClick: this.addPrice,
              'data-test': 'add-price-option',
              className: 'btn btn-sm btn-outline-secondary'
            },
            _react2.default.createElement('span', { className: 'fas fa-plus' })
          )
        ),
        _react2.default.createElement('input', { type: 'hidden', value: value, name: 'list[beers_attributes][' + appId + '][price_options]' })
      );
    }
  }]);

  return PriceOptions;
}(_react.Component);

PriceOptions.propTypes = {
  options: _propTypes2.default.array,
  appId: _propTypes2.default.number.isRequired
};

PriceOptions.defaultProps = {
  options: []
};

exports.default = PriceOptions;

/***/ }),

/***/ "./app/assets/javascripts/list/ToggleFlyoutButton.js":
/*!***********************************************************!*\
  !*** ./app/assets/javascripts/list/ToggleFlyoutButton.js ***!
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

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var ToggleFlyoutButton = function (_Component) {
  _inherits(ToggleFlyoutButton, _Component);

  function ToggleFlyoutButton(props) {
    _classCallCheck(this, ToggleFlyoutButton);

    var _this = _possibleConstructorReturn(this, (ToggleFlyoutButton.__proto__ || Object.getPrototypeOf(ToggleFlyoutButton)).call(this, props));

    _this.onClick = _this.onClick.bind(_this);
    return _this;
  }

  _createClass(ToggleFlyoutButton, [{
    key: 'onClick',
    value: function onClick(event) {
      event.preventDefault();
      this.props.onClick();
    }
  }, {
    key: 'render',
    value: function render() {
      var flyoutShown = this.props.flyoutShown;

      var icon = flyoutShown ? 'fa-angle-up' : 'fa-angle-down';
      var activeState = flyoutShown ? 'active' : '';
      return _react2.default.createElement(
        'a',
        { href: '',
          title: 'Expand',
          onClick: this.onClick,
          'data-test': 'expand-list-item',
          className: 'btn btn-outline-secondary ' + activeState,
          'aria-pressed': flyoutShown },
        _react2.default.createElement('span', { className: 'fas ' + icon })
      );
    }
  }]);

  return ToggleFlyoutButton;
}(_react.Component);

ToggleFlyoutButton.propTypes = {
  flyoutShown: _propTypes2.default.bool.isRequired,
  onClick: _propTypes2.default.func.isRequired
};

exports.default = ToggleFlyoutButton;

/***/ }),

/***/ "./app/assets/javascripts/list/TypeSelect.js":
/*!***************************************************!*\
  !*** ./app/assets/javascripts/list/TypeSelect.js ***!
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

var TypeSelect = function (_Component) {
  _inherits(TypeSelect, _Component);

  function TypeSelect(props) {
    _classCallCheck(this, TypeSelect);

    var _this = _possibleConstructorReturn(this, (TypeSelect.__proto__ || Object.getPrototypeOf(TypeSelect)).call(this, props));

    _this.handleChange = _this.handleChange.bind(_this);
    return _this;
  }

  _createClass(TypeSelect, [{
    key: 'handleChange',
    value: function handleChange(event) {
      var choice = event.target.value;
      var newType = this.props.options.find(function (opt) {
        return opt.value === choice;
      });
      this.props.onChange(newType);
    }
  }, {
    key: 'render',
    value: function render() {
      var _props = this.props,
          className = _props.className,
          value = _props.value;

      var typeOptions = this.props.options.map(function (type, index) {
        return _react2.default.createElement(
          'option',
          { value: type.value, key: index },
          type.name
        );
      });

      return _react2.default.createElement(
        'div',
        { className: className },
        _react2.default.createElement(
          'label',
          { htmlFor: 'list_type' },
          'List Type'
        ),
        _react2.default.createElement(
          'select',
          {
            id: 'list_type',
            'data-test': 'list-type',
            name: 'list[type]',
            className: 'form-control',
            value: value,
            onChange: this.handleChange },
          typeOptions
        )
      );
    }
  }]);

  return TypeSelect;
}(_react.Component);

TypeSelect.defaultProps = {
  className: '',
  onChange: function onChange() {}
};

TypeSelect.propTypes = {
  options: _propTypes2.default.array.isRequired,
  onChange: _propTypes2.default.func,
  value: _propTypes2.default.string.isRequired,
  className: _propTypes2.default.string
};

exports.default = TypeSelect;

/***/ }),

/***/ "./app/assets/javascripts/lists.js":
/*!*****************************************!*\
  !*** ./app/assets/javascripts/lists.js ***!
  \*****************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


var _react = __webpack_require__(/*! react */ "./node_modules/react/index.js");

var _react2 = _interopRequireDefault(_react);

var _reactDom = __webpack_require__(/*! react-dom */ "./node_modules/react-dom/index.js");

var _App = __webpack_require__(/*! ./list/App */ "./app/assets/javascripts/list/App.js");

var _App2 = _interopRequireDefault(_App);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

(function bootstrap() {
  var listRoot = document.getElementById('app-root');

  (0, _reactDom.render)(_react2.default.createElement(_App2.default, window._EVERGREEN), listRoot);
})();

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

/***/ "./app/assets/javascripts/polyfills/Object.js":
/*!****************************************************!*\
  !*** ./app/assets/javascripts/polyfills/Object.js ***!
  \****************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
function applyAssign() {
  if (typeof Object.assign !== 'function') {
    // Must be writable: true, enumerable: false, configurable: true
    Object.defineProperty(Object, 'assign', {
      value: function assign(target, varArgs) {
        // .length of function is 2
        'use strict';

        if (target == null) {
          // TypeError if undefined or null
          throw new TypeError('Cannot convert undefined or null to object');
        }

        var to = Object(target);

        for (var index = 1; index < arguments.length; index++) {
          var nextSource = arguments[index];

          if (nextSource != null) {
            // Skip over if undefined or null
            for (var nextKey in nextSource) {
              // Avoid bugs when hasOwnProperty is shadowed
              if (Object.prototype.hasOwnProperty.call(nextSource, nextKey)) {
                to[nextKey] = nextSource[nextKey];
              }
            }
          }
        }
        return to;
      },
      writable: true,
      configurable: true
    });
  }
}

exports.applyAssign = applyAssign;

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

/***/ })

/******/ });
//# sourceMappingURL=lists.js.map