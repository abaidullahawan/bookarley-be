import { Table, message, Popconfirm } from "antd";
import React from "react";
import AddBeerModal from "../AddBeerModal";

class Brands extends React.Component {
	columns = [
		{
			title: "Brand",
			dataIndex: "name",
			key: "brand",
		},
	
		{
			title: "Country",
			dataIndex: "country",
			key: "country",
		},
		{
			title: "Description",
			dataIndex: "description",
			key: "description",
		},
		{
			title: "",
			key: "action",
			render: (_text, record) => (
				<Popconfirm
					title="Are you sure delete this beer?"
					onConfirm={() => this.deleteBeer(record.id)}
					okText="Yes"
					cancelText="No"
				>
					<a href="#" type="danger">
						Delete{" "}
					</a>
				</Popconfirm>
			),
		},
	];

	state = {
		beers: [],
	};

	componentDidMount() {
		this.loadBeers();
	}

	loadBeers = () => {
		const url = "api/v1/brands";
		fetch(url)
			.then((data) => {
				if (data.ok) {
					return data.json();
				}
				throw new Error("Network error.");
			})
			.then((data) => {
				data.forEach((beer) => {
					const newEl = {
						key: beer.id,
						id: beer.id,
						name: beer.name,
						country: beer.country,
						description: beer.description,
					};

					this.setState((prevState) => ({
						beers: [...prevState.beers, newEl],
					}));
				});
			})
			.catch((err) => message.error("Error: " + err));
	};

	reloadBeers = () => {
		this.setState({ beers: [] });
		this.loadBeers();
	};

	deleteBeer = (id) => {
		const url = `api/v1/brands/${id}`;

		fetch(url, {
			method: "delete",
		})
			.then((data) => {
				if (data.ok) {
					this.reloadBeers();
					return data.json();
				}
				throw new Error("Network error.");
			})
			.catch((err) => message.error("Error: " + err));
	};

	render() {
		return (
			<>
				<Table
					className="table-striped-rows"
					dataSource={this.state.beers}
					columns={this.columns}
					pagination={{ pageSize: 5 }}
				/>

				<AddBeerModal reloadBeers={this.reloadBrands} />
			</>
		);
	}
}

export default Brands;
