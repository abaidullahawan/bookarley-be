import React from "react";
import { Route, Switch } from "react-router-dom";
import Brand from "../components/Brand"
import Beers from "../components/Beers";

const Routes = () => {

	return(
		<>
		 <Switch>
                <Route path="/" exact component={Beers}/>
                <Route path="/brands" component={Brand} />
        </Switch>
		
		</>
	)

}
export default Routes;