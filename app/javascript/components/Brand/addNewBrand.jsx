import { Button, Form, Input, Modal, Select } from "antd";
import React from "react";

const { Option } = Select;

class AddBrandsModel extends React.Component {
	formRef = React.createRef();
	state = {
		visible: false,
	};

	onFinish = (values) => {
		const url = "api/v1/brands/";
		fetch(url, {
			method: "post",
			headers: {
				"Content-Type": "application/json",
			},
			body: JSON.stringify(values),
		})
			.then((data) => {
				if (data.ok) {
					this.handleCancel();

					return data.json();
				}
				throw new Error("Network error.");
			})
			.then(() => {
				this.props.reloadBrands();
			})
			.catch((err) => console.error("Error: " + err));
	};

	showModal = () => {
		this.setState({
			visible: true,
		});
	};

	handleCancel = () => {
		this.setState({
			visible: false,
		});
	};

	render() {
		return (
			<>
				<Button type="primary" onClick={this.showModal}>
					Create New +
				</Button>

				<Modal
					title="Add New Brand ..."
					visible={this.state.visible}
					onCancel={this.handleCancel}
					footer={null}
				>
					<Form ref={this.formRef} layout="vertical" onFinish={this.onFinish}>
						<Form.Item
							name="name"
							label="Brand"
							rules={[
								{ required: true, message: "Please input your tractor brand!" },
							]}
						>
							<Input placeholder="Input your  brand name" />
						</Form.Item>

						<Form.Item
							name="country"
							label="Country"
							rules={[
								{
									required: true,
									message: "Please input your brand's country!",
								},
							]}
						>
							<Select
								showSearch
								placeholder="Select your brand country"
								optionFilterProp="children"
								style={{ width: "100%" }}
							>
								<Option value="Finland">Finland</Option>
								<Option value="Germany">Germany</Option>
								<Option value="Netherlands">Netherlands</Option>
								<Option value="UK">UK</Option>
								<Option value="USA">USA</Option>
								<Option value="Other">Other</Option>
							</Select>
						</Form.Item>

						<Form.Item
							name="description"
							label="Description"
							rules={[
								{ required: true, message: "Please input the Description!" },
							]}
						>
							<Input type="text" placeholder="How many Brands you desire?" />
						</Form.Item>

						<Form.Item>
							<Button type="primary" htmlType="submit">
								Submit
							</Button>
						</Form.Item>
					</Form>
				</Modal>
			</>
		);
	}
}

export default AddBrandsModel;
