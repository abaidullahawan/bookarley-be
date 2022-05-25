import { Table, message, Popconfirm } from "antd";
import React from "react";
import AddBrandsModel from "./Brand/addNewBrand";

class Brand extends React.Component {
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
					onConfirm={() => this.deleteBrands(record.id)}
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
		brands: [],
	};

	componentDidMount() {
		this.loadBrands();
	}

	loadBrands = () => {
		const url = "api/v1/brands";
		fetch(url)
			.then((data) => {
				if (data.ok) {
					return data.json();
				}
				throw new Error("Network error.");
			})
			.then((data) => {
				data.forEach((brand) => {
					const newEl = {
						key: brand.id,
						id: brand.id,
						name: brand.name,
						country: brand.country,
						description: brand.description,
					};

					this.setState((prevState) => ({
						brands: [...prevState.brands, newEl],
					}));
				});
			})
			.catch((err) => message.error("Error: " + err));
	};

	reloadBrands = () => {
		this.setState({ brands: [] });
		this.loadBrands();
	};

	deleteBrands = (id) => {
		const url = `api/v1/brands/${id}`;

		fetch(url, {
			method: "delete",
		})
			.then((data) => {
				if (data.ok) {
					this.reloadBrands();
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
					dataSource={this.state.brands}
					columns={this.columns}
					pagination={{ pageSize: 5 }}
				/>
                <AddBrandsModel reloadBrands={this.reloadBrands} />

			</>
		);
	}
}

export default Brand;
