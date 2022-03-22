public with sharing class CaseCloseCallout extends BaseCallout {
    private static final String BASE_ENDPOINT = 'callout:Workforce_Planning_API';
    private static String ENDPOINT = '';
    private String caseCloseRequest;
    
    
    public CaseCloseResponse pushCaseToWorkForce(String request) {
       	generateRequest(request);
        createRequest();
        doCallout();
        return handleResponse();
    }
    
    public override Object getResponseObject() {
        try {
            return JSON.deserialize(getResponseBody(), CaseCloseResponse.class);
        } catch (JSONException ex) {
            throw new JSONException('Response deserialization has failed.');
        }
    }
    private void generateRequest(String requestBody) {
        caseCloseRequest = requestBody;
    }
    
    private void createRequest() {
        system.debug('AAA '+caseCloseRequest);
        request = super.createRequest(HTTP_METHOD_POST);
        request.setEndpoint(BASE_ENDPOINT + ENDPOINT);
        request.setHeader(HEADER_CONTENT_TYPE,HEADER_CONTENT_TYPE_APPLICATION_JSON);
        request.setBody(caseCloseRequest);
    }
    private CaseCloseResponse handleResponse() {
        if (isStatusCodeOk()) {
            return (CaseCloseResponse) getResponseObject();
        } else {
            system.debug('Invalid status code: ' + getResponseStatusCode());
            return (CaseCloseResponse) getResponseObject();
        }
    }
    
    public class CaseCloseResponse {
        public boolean success;
        public String secretKey;
    }
}