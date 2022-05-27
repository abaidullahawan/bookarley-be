import React from 'react';
import { Modal, Container, Row, Col, ButtonToolbar, Button} from 'react-bootstrap';

class DefaultModal extends React.Component {
    render() {
        return (
            <Modal {...this.props} size="lg" aria-labelledby="contained-modal-title-vcenter">
                <Modal.Header closeButton>
                    <Modal.Title id="contained-modal-title-vcenter">
                        Using Grid in Modal
                    </Modal.Title>
                </Modal.Header>

                <Modal.Body>
                    <Container>
                        <Row className="show-grid">
                                <Col xs={12} md={8}>
                                <code>.col-xs-12 .col-md-8</code>
                            </Col>
                            <Col xs={6} md={4}>
                                <code>.col-xs-6 .col-md-4</code>
                            </Col>
                        </Row>

                        <Row className="show-grid">
                            <Col xs={6} md={4}>
                                <code>.col-xs-6 .col-md-4</code>
                            </Col>
                            <Col xs={6} md={4}>
                                <code>.col-xs-6 .col-md-4</code>
                            </Col>
                            <Col xs={6} md={4}>
                                <code>.col-xs-6 .col-md-4</code>
                            </Col>
                        </Row>
                    </Container>
                </Modal.Body>

                <Modal.Footer>
                    <Button onClick={this.props.onHide}>Close</Button>
                </Modal.Footer>
            </Modal>
        );
    }
}

class ModalWithGrid extends React.Component {
    constructor(...args) {
        super(...args);
        this.state = { modalShow: false };
    }

    render() {
        let modalClose = () => this.setState({ modalShow: false });
        return (
            <ButtonToolbar>
                <Button
                    variant="primary"
                    onClick={() => this.setState({ modalShow: true })}
                >
                    Launch Modal With Grid
                </Button>
                <DefaultModal show={this.state.modalShow} onHide={modalClose} />
            </ButtonToolbar>
        );
    }
}

export default ModalWithGrid;