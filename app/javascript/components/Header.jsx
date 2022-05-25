import React from "react";
import { Layout, Menu } from "antd";
import {Link} from "react-router-dom"

const { Header } = Layout;

export default () => (
	<Header>
		<div className="logo" />
		<Menu theme="dark" mode="horizontal" >
			<Menu.Item ><Link to='/'>Home</Link></Menu.Item>
			<Menu.Item ><Link to='/brands'>Brand</Link></Menu.Item>
			
		</Menu>
	</Header>
);
