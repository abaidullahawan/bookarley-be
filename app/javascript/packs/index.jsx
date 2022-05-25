// import React from "react";
// import { render } from "react-dom";
// import App from "../routes/index";
// import { BrowserRouter as Router, Route, Switch } from "react-router-dom";

// document.addEventListener("DOMContentLoaded", () => {

// 	render( 
// 	<Router>
// 		<Route path="/" component={App}/>
// 	  </Router>
// 	  , document.body.appendChild(document.createElement("div")));
// });

import React from 'react'
import ReactDOM from 'react-dom'
import App from "../components/App";
import {BrowserRouter as Router, Route, Switch} from "react-router-dom";


document.addEventListener('DOMContentLoaded', () => {
 ReactDOM.render(
	 <Router>
		 <Route path="/" component={App}/>
	 </Router>,
   document.body.appendChild(document.createElement('div')),
 )
})