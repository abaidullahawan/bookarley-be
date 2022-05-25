
import Routes from "../routes/index";
import "antd/dist/antd.css";
import React from 'react';
import Header from "../components/Header";
import { Layout } from "antd";



const { Content, Footer } = Layout;

const App = ()=>{
   return (

    <Layout className="layout">
		<Content style={{ padding: "0 50px" }}>
                <Header />
                <Routes />
		</Content>
		<Footer style={{ textAlign: "center" }}>
			Honey badger ©2020.
		</Footer>
	</Layout>
     
   )
 
}
export default App;
