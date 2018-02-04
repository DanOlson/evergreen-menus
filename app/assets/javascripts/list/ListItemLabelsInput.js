import React, { Component } from 'react';
import PropTypes from 'prop-types';

class ListItemLabelsInput extends Component {
  render () {
    return (
      <div className="col-sm-4 col-xs-8">
        <div className="form-check">
          <input type="hidden" value="0" />
          <input className="" type="checkbox" value="1" id="spicy" />
          <label className="form-check-label" htmlFor="spicy">
            Spicy
          </label>
        </div>
        <div className="form-check">
          <input type="hidden" value="0" />
          <input className="" type="checkbox" value="1" id="gf" />
          <label className="form-check-label" htmlFor="gf">
            Gluten Free
          </label>
        </div>
        <div className="form-check">
          <input type="hidden" value="0" />
          <input className="" type="checkbox" value="1" id="vegan" />
          <label className="form-check-label" htmlFor="vegan">
            Vegan
          </label>
        </div>
      </div>
    );
  }
}

export default ListItemLabelsInput;
