import React from "react";
import { Route, Redirect, Switch } from "react-router-dom";
import Dashboard from "../pages/Dashboard/Dashboard";
import DashboardTwo from "../pages/Dashboard/DashboardTwo";
import DashboardThree from "../pages/Dashboard/DashboardThree";
import Inbox from "../pages/Inbox/Inbox";
import Chat from "../pages/Chat/Chat";
import Todos from "../pages/Todos";
import Notes from "../pages/Notes";
// import Calendar from "../pages/Calendar";
import Search from "../pages/Search";
import Alerts from "../pages/UI-Components/Alerts";
import Badges from "../pages/UI-Components/Badges";
import Buttons from "../pages/UI-Components/Buttons";
import Cards from "../pages/UI-Components/Cards";
import Dropdowns from "../pages/UI-Components/Dropdowns";
import Forms from "../pages/UI-Components/Forms";
import ListGroups from "../pages/UI-Components/ListGroups";
import Modals from "../pages/UI-Components/Modals";
import ProgressBars from "../pages/UI-Components/ProgressBars";
import Tables from "../pages/UI-Components/Tables";
import TemplateTabs from "../pages/UI-Components/TemplateTabs";
import Signup from "../pages/Signup";
import Login from "../pages/Login";
import ForgotPassword from "../pages/ForgotPassword";
import Profile from "../pages/Profile";
import ProfileSettings from "../pages/ProfileSettings";
import LineCharts from "../pages/Apex-Charts/LineCharts";
import AreaCharts from "../pages/Apex-Charts/AreaCharts";
import ColumnCharts from "../pages/Apex-Charts/ColumnCharts";
import BarCharts from "../pages/Apex-Charts/BarCharts";
import MixedCharts from "../pages/Apex-Charts/MixedCharts";
import PieDonutsCharts from "../pages/Apex-Charts/PieDonutsCharts";
import CustomGoogleMap from "../pages/Map/CustomGoogleMap";
import CustomJVectorMap from "../pages/Map/CustomJVectorMap";
import FeatherIcons from "../pages/Icons/FeatherIcons";
import IcofontIcons from "../pages/Icons/IcofontIcons";
import Notification from "../pages/Notification";
import UsersCard from "../pages/UsersCard";
import TimeLine from "../pages/TimeLine";
import InvoiceTemplate from "../pages/InvoiceTemplate";
import CustomGallery from "../pages/Gallery/CustomGallery";
import Faq from "../pages/Faq";
import Pricing from "../pages/Pricing";
import FourHandedFourError from "../pages/FourHandedFourError";

import "../assets/css/style.css";
import "../assets/css/responsive.css";
import Beers from "../../components/Beers";
import Brand from "../../components/Brand";

const AppRouter = () => (
  <Switch>
    <Route exact path="/" render={() => <Redirect to="/dashboard/" />} />
    <Route path="/dashboard/" exact component={Dashboard} />
    <Route path="/dashboard-two/" exact component={DashboardTwo} />
    <Route path="/dashboard-three/" exact component={DashboardThree} />
    <Route path="/signup/" component={Signup} />
    <Route path="/login/" component={Login} />
    <Route path="/forgot-password/" component={ForgotPassword} />
    <Route path="/profile/" component={Profile} />
    <Route path="/profile-settings/" component={ProfileSettings} />
    <Route path="/gallery/" component={CustomGallery} />
    <Route path="/ui-components/cards/" component={Cards} />
    <Route path="/inbox/" component={Inbox} />
    <Route path="/chat/" component={Chat} />
    <Route path="/todos/" component={Todos} />
    <Route path="/notes/" component={Notes} />
    {/* <Route path="/calendar/" component={Calendar} /> */}
    <Route path="/search/" component={Search} />
    <Route path="/error-404/" component={FourHandedFourError} />
    <Route path="/notifications/" component={Notification} />
    <Route path="/pricing/" component={Pricing} />
    <Route path="/users-card/" component={UsersCard} />
    <Route path="/ui-components/alerts/" component={Alerts} />
    <Route path="/invoice-template/" component={InvoiceTemplate} />
    <Route path="/faq/" component={Faq} />
    <Route path="/ui-components/badges/" component={Badges} />
    <Route path="/ui-components/buttons/" component={Buttons} />
    <Route path="/ui-components/dropdowns/" component={Dropdowns} />
    <Route path="/ui-components/forms/" component={Forms} />
    <Route path="/ui-components/list-groups/" component={ListGroups} />
    <Route path="/ui-components/modals/" component={Modals} />
    <Route path="/ui-components/progress-bars/" component={ProgressBars} />
    <Route path="/ui-components/tables/" component={Tables} />
    <Route path="/ui-components/tabs/" component={TemplateTabs} />
    <Route path="/time-line/" component={TimeLine} />
    <Route path="/line-charts/" component={LineCharts} />
    <Route path="/area-charts/" component={AreaCharts} />
    <Route path="/column-charts/" component={ColumnCharts} />
    <Route path="/bar-charts/" component={BarCharts} />
    <Route path="/mixed-charts/" component={MixedCharts} />
    <Route path="/pie-donuts-Charts/" component={PieDonutsCharts} />
    <Route path="/google-map/" component={CustomGoogleMap} />
    <Route path="/vector-map/" component={CustomJVectorMap} />
    <Route path="/feather-icons/" component={FeatherIcons} />
    <Route path="/icofont-icons/" component={IcofontIcons} />
  </Switch>
);

export default AppRouter;
