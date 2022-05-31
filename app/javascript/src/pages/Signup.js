import React, { useState } from "react";
import { Link, useHistory } from "react-router-dom";
import { Row, Col, Form, Button, Image } from "react-bootstrap";
import * as Icon from "react-feather";
// Logo image file path
import Logo from "../assets/img/logo.png";
import { user } from "../API/User/index";

const SignUp = () => {
  const [email, setEmail] = useState();
  const [confirmPassword, setConfirmPassword] = useState();

  const [password, setPassword] = useState();
  const [error, setError] = useState("");

  let history = useHistory();

  const createUserAccount = async (e) => {
    e.preventDefault();
    debugger;
    if (password != confirmPassword) {
      setError("password not match");
      return;
    }
    try {
      const result = await user.signUp(email, password, confirmPassword);
      debugger;
      console.log(result);
      result.error == false
        ? history.push("/login")
        : alert("Error user not create");
    } catch (error) {}
  };
  console.log(email, confirmPassword, password);

  return (
    <>
      <div className="auth-main-content auth-bg-image">
        <div className="d-table">
          <div className="d-tablecell">
            <div className="auth-box">
              <Row>
                <Col md={6}>
                  <div className="form-left-content">
                    <div className="auth-logo">
                      <Image src={Logo} alt="Logo" />
                    </div>

                    <div className="login-links">
                      <Link to="/" className="fb">
                        <Icon.Facebook className="icon" />
                        Sign Up with Facebook
                      </Link>
                      <Link to="/" className="twi">
                        <Icon.Twitter className="icon" />
                        Sign Up with Twitter
                      </Link>
                      <Link to="/" className="ema">
                        <Icon.Mail className="icon" />
                        Sign Up with Email
                      </Link>
                      <Link to="/" className="linkd">
                        <Icon.Linkedin className="icon" />
                        Sign Up with Linkedin
                      </Link>
                    </div>
                  </div>
                </Col>

                <Col md={6}>
                  <div className="form-content">
                    <h1 className="heading">Sign Up</h1>
                    <Form>
                      <Form.Group>
                        <Form.Label>Email Address</Form.Label>
                        <Form.Control
                          type="email"
                          onChange={(event) => {
                            setEmail(event.target.value);
                          }}
                        />
                      </Form.Group>

                      <Form.Group>
                        <Form.Label>Password</Form.Label>
                        <Form.Control
                          type="password"
                          onChange={(event) => {
                            setPassword(event.target.value);
                          }}
                        />
                      </Form.Group>

                      <Form.Group>
                        <Form.Label>Confirm Password</Form.Label>
                        <Form.Control
                          type="password"
                          onChange={(event) => {
                            setConfirmPassword(event.target.value);
                          }}
                        />
                      </Form.Group>
                      {error ? (
                        <span className="text-danger">{error}</span>
                      ) : (
                        ""
                      )}
                      <div className="text-center">
                        <Button
                          variant="primary"
                          type="submit"
                          onClick={createUserAccount}
                        >
                          Sign Up
                        </Button>
                      </div>
                    </Form>
                  </div>
                </Col>
              </Row>
            </div>
          </div>
        </div>
      </div>
    </>
  );
};

export default SignUp;
