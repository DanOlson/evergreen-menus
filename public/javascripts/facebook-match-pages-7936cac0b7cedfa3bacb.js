!function(e){function t(t){for(var r,i,l=t[0],u=t[1],s=t[2],f=0,d=[];f<l.length;f++)i=l[f],a[i]&&d.push(a[i][0]),a[i]=0;for(r in u)Object.prototype.hasOwnProperty.call(u,r)&&(e[r]=u[r]);for(c&&c(t);d.length;)d.shift()();return o.push.apply(o,s||[]),n()}function n(){for(var e,t=0;t<o.length;t++){for(var n=o[t],r=!0,l=1;l<n.length;l++){var u=n[l];0!==a[u]&&(r=!1)}r&&(o.splice(t--,1),e=i(i.s=n[0]))}return e}var r={},a={7:0},o=[];function i(t){if(r[t])return r[t].exports;var n=r[t]={i:t,l:!1,exports:{}};return e[t].call(n.exports,n,n.exports,i),n.l=!0,n.exports}i.m=e,i.c=r,i.d=function(e,t,n){i.o(e,t)||Object.defineProperty(e,t,{enumerable:!0,get:n})},i.r=function(e){"undefined"!=typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(e,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(e,"__esModule",{value:!0})},i.t=function(e,t){if(1&t&&(e=i(e)),8&t)return e;if(4&t&&"object"==typeof e&&e&&e.__esModule)return e;var n=Object.create(null);if(i.r(n),Object.defineProperty(n,"default",{enumerable:!0,value:e}),2&t&&"string"!=typeof e)for(var r in e)i.d(n,r,function(t){return e[t]}.bind(null,r));return n},i.n=function(e){var t=e&&e.__esModule?function(){return e.default}:function(){return e};return i.d(t,"a",t),t},i.o=function(e,t){return Object.prototype.hasOwnProperty.call(e,t)},i.p="";var l=window.webpackJsonp=window.webpackJsonp||[],u=l.push.bind(l);l.push=t,l=l.slice();for(var s=0;s<l.length;s++)t(l[s]);var c=u;o.push([670,0]),n()}({13:function(e,t,n){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var r=function(){function e(e,t){for(var n=0;n<t.length;n++){var r=t[n];r.enumerable=r.enumerable||!1,r.configurable=!0,"value"in r&&(r.writable=!0),Object.defineProperty(e,r.key,r)}}return function(t,n,r){return n&&e(t.prototype,n),r&&e(t,r),t}}(),a=n(1),o=u(a),i=u(n(0)),l=u(n(17));function u(e){return e&&e.__esModule?e:{default:e}}var s=function(e){function t(){return function(e,t){if(!(e instanceof t))throw new TypeError("Cannot call a class as a function")}(this,t),function(e,t){if(!e)throw new ReferenceError("this hasn't been initialised - super() hasn't been called");return!t||"object"!=typeof t&&"function"!=typeof t?e:t}(this,(t.__proto__||Object.getPrototypeOf(t)).apply(this,arguments))}return function(e,t){if("function"!=typeof t&&null!==t)throw new TypeError("Super expression must either be null or a function, not "+typeof t);e.prototype=Object.create(t&&t.prototype,{constructor:{value:e,enumerable:!1,writable:!0,configurable:!0}}),t&&(Object.setPrototypeOf?Object.setPrototypeOf(e,t):e.__proto__=t)}(t,a.Component),r(t,[{key:"render",value:function(){var e=this.props,t=e.dataTest,n=e.title,r=e.children,a=e.className,i=e.headerContent,u=e.onToggleHelp,s=e.icon,c=void 0,f=void 0;return u&&(c=o.default.createElement(l.default,{className:"float-right",onClick:u})),s&&(f=o.default.createElement("span",{className:"panel-header-icon "+s})),o.default.createElement("div",{className:"card "+a,"data-test":t},o.default.createElement("div",{className:"card-header"},c,o.default.createElement("h3",{className:"card-title"},f,n,i)),o.default.createElement("div",{className:"card-body"},r))}}]),t}();s.defaultProps={className:""},s.propTypes={dataTest:i.default.string,title:i.default.string.isRequired,className:i.default.string,headerContent:i.default.element,onToggleHelp:i.default.func,icon:i.default.string},t.default=s},17:function(e,t,n){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var r=function(){function e(e,t){for(var n=0;n<t.length;n++){var r=t[n];r.enumerable=r.enumerable||!1,r.configurable=!0,"value"in r&&(r.writable=!0),Object.defineProperty(e,r.key,r)}}return function(t,n,r){return n&&e(t.prototype,n),r&&e(t,r),t}}(),a=n(1),o=l(a),i=l(n(0));function l(e){return e&&e.__esModule?e:{default:e}}var u=function(e){function t(){return function(e,t){if(!(e instanceof t))throw new TypeError("Cannot call a class as a function")}(this,t),function(e,t){if(!e)throw new ReferenceError("this hasn't been initialised - super() hasn't been called");return!t||"object"!=typeof t&&"function"!=typeof t?e:t}(this,(t.__proto__||Object.getPrototypeOf(t)).apply(this,arguments))}return function(e,t){if("function"!=typeof t&&null!==t)throw new TypeError("Super expression must either be null or a function, not "+typeof t);e.prototype=Object.create(t&&t.prototype,{constructor:{value:e,enumerable:!1,writable:!0,configurable:!0}}),t&&(Object.setPrototypeOf?Object.setPrototypeOf(e,t):e.__proto__=t)}(t,a.Component),r(t,[{key:"render",value:function(){var e=this.props,t=e.onClick,n=e.className;return o.default.createElement("div",{className:n},o.default.createElement("i",{className:"far fa-question-circle fa-2x help-icon","aria-hidden":"true","data-test":"help-icon",onClick:t}))}}]),t}();u.defaultProps={onClick:function(){},className:""},u.propTypes={onClick:i.default.func,className:i.default.string},t.default=u},261:function(e,t,n){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var r=function(){function e(e,t){for(var n=0;n<t.length;n++){var r=t[n];r.enumerable=r.enumerable||!1,r.configurable=!0,"value"in r&&(r.writable=!0),Object.defineProperty(e,r.key,r)}}return function(t,n,r){return n&&e(t.prototype,n),r&&e(t,r),t}}(),a=n(1),o=function(e){return e&&e.__esModule?e:{default:e}}(a);var i=function(e){function t(){return function(e,t){if(!(e instanceof t))throw new TypeError("Cannot call a class as a function")}(this,t),function(e,t){if(!e)throw new ReferenceError("this hasn't been initialised - super() hasn't been called");return!t||"object"!=typeof t&&"function"!=typeof t?e:t}(this,(t.__proto__||Object.getPrototypeOf(t)).apply(this,arguments))}return function(e,t){if("function"!=typeof t&&null!==t)throw new TypeError("Super expression must either be null or a function, not "+typeof t);e.prototype=Object.create(t&&t.prototype,{constructor:{value:e,enumerable:!1,writable:!0,configurable:!0}}),t&&(Object.setPrototypeOf?Object.setPrototypeOf(e,t):e.__proto__=t)}(t,a.PureComponent),r(t,[{key:"render",value:function(){var e=this.props,t=e.establishments,n=e.onChange,r=e.selected,a=t.map(function(e){return o.default.createElement("option",{value:e.id,key:e.id},e.name)}),i=o.default.createElement("option",{value:null,key:"null"});return o.default.createElement("select",{defaultValue:r&&r.id,className:"form-control",onChange:n},[i].concat(function(e){if(Array.isArray(e)){for(var t=0,n=Array(e.length);t<e.length;t++)n[t]=e[t];return n}return Array.from(e)}(a)))}}]),t}();t.default=i},670:function(e,t,n){"use strict";var r=i(n(1)),a=n(4),o=i(n(671));function i(e){return e&&e.__esModule?e:{default:e}}!function(){var e=document.getElementById("facebook-match-pages-app-root");(0,a.render)(r.default.createElement(o.default,window._EVERGREEN),e)}()},671:function(e,t,n){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var r=function(){function e(e,t){for(var n=0;n<t.length;n++){var r=t[n];r.enumerable=r.enumerable||!1,r.configurable=!0,"value"in r&&(r.writable=!0),Object.defineProperty(e,r.key,r)}}return function(t,n,r){return n&&e(t.prototype,n),r&&e(t,r),t}}(),a=n(1),o=s(a),i=s(n(0)),l=s(n(13)),u=s(n(672));function s(e){return e&&e.__esModule?e:{default:e}}var c=function(e){function t(){return function(e,t){if(!(e instanceof t))throw new TypeError("Cannot call a class as a function")}(this,t),function(e,t){if(!e)throw new ReferenceError("this hasn't been initialised - super() hasn't been called");return!t||"object"!=typeof t&&"function"!=typeof t?e:t}(this,(t.__proto__||Object.getPrototypeOf(t)).apply(this,arguments))}return function(e,t){if("function"!=typeof t&&null!==t)throw new TypeError("Super expression must either be null or a function, not "+typeof t);e.prototype=Object.create(t&&t.prototype,{constructor:{value:e,enumerable:!1,writable:!0,configurable:!0}}),t&&(Object.setPrototypeOf?Object.setPrototypeOf(e,t):e.__proto__=t)}(t,a.Component),r(t,[{key:"renderPages",value:function(){var e=this.props,t=e.pages,n=e.establishments,r=e.updateAssociationPath,a=e.tabRestrictionsPath,i=e.addTabPath,l=e.csrfToken;return t.map(function(e){return o.default.createElement(u.default,{page:e,establishmentOpts:n,updateAssociationPath:r,tabRestrictionsPath:a,addTabPath:i,csrfToken:l,key:e.id})})}},{key:"render",value:function(){var e=this.renderPages();return o.default.createElement(l.default,{title:"Associate Facebook Pages"},o.default.createElement("table",{className:"table"},o.default.createElement("thead",null,o.default.createElement("tr",null,o.default.createElement("th",null,"Page"),o.default.createElement("th",null,"Fans"),o.default.createElement("th",null,"Establishment"),o.default.createElement("th",null,"Linked"),o.default.createElement("th",null,"Action"))),o.default.createElement("tbody",null,e)))}}]),t}();c.propTypes={pages:i.default.array.isRequired,establishments:i.default.array.isRequired,updateAssociationPath:i.default.string.isRequired,addTabPath:i.default.string.isRequired,tabRestrictionsPath:i.default.string.isRequired,csrfToken:i.default.string.isRequired},t.default=c},672:function(e,t,n){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var r=function(){function e(e,t){for(var n=0;n<t.length;n++){var r=t[n];r.enumerable=r.enumerable||!1,r.configurable=!0,"value"in r&&(r.writable=!0),Object.defineProperty(e,r.key,r)}}return function(t,n,r){return n&&e(t.prototype,n),r&&e(t,r),t}}(),a=n(1),o=u(a),i=u(n(0)),l=u(n(261));function u(e){return e&&e.__esModule?e:{default:e}}n(332);var s={id:""},c=function(e){function t(e){!function(e,t){if(!(e instanceof t))throw new TypeError("Cannot call a class as a function")}(this,t);var n=function(e,t){if(!e)throw new ReferenceError("this hasn't been initialised - super() hasn't been called");return!t||"object"!=typeof t&&"function"!=typeof t?e:t}(this,(t.__proto__||Object.getPrototypeOf(t)).call(this,e));n.handleLink=n.handleLink.bind(n),n.handleEstablishmentChange=n.handleEstablishmentChange.bind(n),n.confirmRestrictionWorkaround=n.confirmRestrictionWorkaround.bind(n);var r=e.establishmentOpts.find(function(t){return t.facebook_page_id===e.page.id})||s;return n.state={persistedSelectedEstablishmentId:r.id.toString(),selectedEstablishment:r},n}return function(e,t){if("function"!=typeof t&&null!==t)throw new TypeError("Super expression must either be null or a function, not "+typeof t);e.prototype=Object.create(t&&t.prototype,{constructor:{value:e,enumerable:!1,writable:!0,configurable:!0}}),t&&(Object.setPrototypeOf?Object.setPrototypeOf(e,t):e.__proto__=t)}(t,a.Component),r(t,[{key:"handleLink",value:function(e){var t=this;e.preventDefault();var n=this.props.updateAssociationPath,r=this.state.selectedEstablishment.id.toString(),a=this.props.page.id,o=this.props.csrfToken;fetch(n,{credentials:"same-origin",method:"post",headers:{"Content-Type":"application/json"},body:JSON.stringify({authenticity_token:o,establishment_id:r,facebook_page_id:a})}).then(function(e){e.ok&&t.setState(function(e){return{persistedSelectedEstablishmentId:r}})}).catch(console.error)}},{key:"handleEstablishmentChange",value:function(e){var t=e.target.value,n=this.props.establishmentOpts.find(function(e){return e.id.toString()===t})||s;this.setState(function(){return{selectedEstablishment:n}})}},{key:"renderLinkStatus",value:function(){return this.isAssociationDirty()?o.default.createElement("i",{className:"fas fa-2x fa-times status-unlinked","aria-hidden":!0,title:"Not Linked"}):o.default.createElement("i",{className:"fas fa-2x fa-check status-linked","aria-hidden":!0,title:"Linked"})}},{key:"confirmRestrictionWorkaround",value:function(e){if(!confirm("Have you applied the workaround for Facebook's restrictions?")){e.preventDefault();var t=e.target.querySelector('input[type="submit"]');setTimeout(function(e){t.disabled=!1},100)}}},{key:"renderActionButton",value:function(){if(this.isEstablishmentLinked()){if(this.isAssociationDirty())return o.default.createElement("a",{href:"",onClick:this.handleLink,className:"btn btn-evrgn-primary"},"Link");var e=this.props,t=e.tabRestrictionsPath,n=e.addTabPath,r=e.csrfToken,i=this.state.persistedSelectedEstablishmentId,l=this.restrictionApplies()?this.confirmRestrictionWorkaround:function(){},u=void 0;return this.restrictionApplies()&&(u=o.default.createElement("a",{target:"_blank",href:t},o.default.createElement("i",{className:"icon fas fa-2x fa-exclamation-triangle",title:"Restrictions Apply"}))),o.default.createElement(a.Fragment,null,o.default.createElement("form",{method:"post",action:n,onSubmit:l,className:"btn--add-menu"},o.default.createElement("input",{type:"hidden",name:"authenticity_token",value:r}),o.default.createElement("input",{type:"hidden",name:"establishment_id",value:i}),o.default.createElement("input",{type:"submit",name:"commit",className:"btn btn-evrgn-primary",value:"Add Menu Tab"})),u)}}},{key:"isAssociationDirty",value:function(){var e=this.state;return e.persistedSelectedEstablishmentId!==e.selectedEstablishment.id.toString()}},{key:"restrictionApplies",value:function(){return this.props.page.fan_count<2e3}},{key:"isEstablishmentLinked",value:function(){var e=this.state,t=e.persistedSelectedEstablishmentId,n=e.selectedEstablishment;return!(!t&&!n.id)}},{key:"render",value:function(){var e=this.props,t=e.page,n=e.establishmentOpts,r=this.state.selectedEstablishment,a=this.renderLinkStatus(),i=this.renderActionButton();return o.default.createElement("tr",null,o.default.createElement("td",null,o.default.createElement("h4",{className:"my-auto"},o.default.createElement("i",{className:"facebook-icon fab fa-2x fa-facebook-square","aria-hidden":!0}),o.default.createElement("span",{className:"page-name"},t.name))),o.default.createElement("td",null,o.default.createElement("span",{style:{color:this.restrictionApplies()?"red":"inherit"}},t.fan_count)),o.default.createElement("td",null,o.default.createElement("div",{className:"form-group my-auto"},o.default.createElement(l.default,{establishments:n,selected:r,onChange:this.handleEstablishmentChange}))),o.default.createElement("td",null,a),o.default.createElement("td",null,i))}}]),t}();c.defaultProps={establishmentOpts:[]},c.propTypes={establishmentOpts:i.default.array,page:i.default.object.isRequired,updateAssociationPath:i.default.string.isRequired,addTabPath:i.default.string.isRequired,csrfToken:i.default.string.isRequired},t.default=c}});
//# sourceMappingURL=facebook-match-pages-7936cac0b7cedfa3bacb.js.map