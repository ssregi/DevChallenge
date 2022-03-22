@isTest
global class CaseCloseCalloutFailMock implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"success": false,"error":"Error Message" }');
        response.setStatusCode(200);
        return response; 
    }
}