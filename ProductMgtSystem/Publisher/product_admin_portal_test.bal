// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/test;
import ballerina/http;

// Unit test for 'productAdminService'
function testProductAdminService () {
    // HTTP endpoint
    endpoint http:Client httpEndpoint {
        url:"http://localhost:9090/product"
    };
    // Initialize the empty http requests and responses
    http:Request request = new;
    http:Response response = new;
    http:HttpConnectorError err;

    // Test the 'updatePrice' resource
    // Construct a valid request payload
    request.setJsonPayload({"Username":"Admin", "Password":"Admin", "Product":"ABC", "Price":100.00});
    // Send a 'post' request and obtain the response
    response = clientEndpoint -> post("/updatePrice", request=request);
    match response {
        http:Response resp => {
            var msg = resp.getJsonPayload();
            match msg {
                json jsonPayload => {
                    io:println(jsonPayload);
                }
                http:PayloadError payloadError => {
                    io:println(payloadError.message);
                }
            }
        }
        http:HttpConnectorError err => {
            self.err = err;
            io:println(err.message);
        }
    }

    // 'err' is expected to be null
    test:assertTrue(err == null, "Cannot update price! Error: " + err.msg);
    // Expected response code is 200
    test:assertIntEquals(response.statusCode, 200, "product admin service did not respond with 200 OK signal!");
    // Check whether the response is as expected
    test:assertStringEquals(response.getJsonPayload().toString(), "{\"Status\":\"Success\"}", "Response mismatch!");
}
