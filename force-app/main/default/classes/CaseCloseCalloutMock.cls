@isTest
global class CaseCloseCalloutMock implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"success": true,"secretKey":"0986HJK" }');
        response.setStatusCode(200);
        return response; 
    }
}