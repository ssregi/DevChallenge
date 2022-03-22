public abstract with sharing class BaseCallout {
    protected final String HEADER_CONTENT_TYPE = 'Content-Type';
    protected final String HEADER_CONTENT_TYPE_APPLICATION_JSON = 'application/json';
    protected final String HEADER_AUTHORIZATION = 'Authorization';
    protected final String HEADER_BEARER_AUTHORIZATION = 'Bearer';
    protected final String HTTP_METHOD_GET = 'GET';
    protected final String HTTP_METHOD_POST = 'POST';
    protected final Integer DEFAULT_TIMEOUT = 30000;
    protected HttpRequest request;
    protected HttpResponse response;
    protected void doCallout() {
        this.response = new Http().send(request);
    }
    protected Boolean isStatusCodeOk() {
        return response.getStatusCode() == 200;
    }
    protected Integer getResponseStatusCode() {
        return response.getStatusCode();
    }
    protected String getResponseBody() {
        return response.getBody();
    }
    protected virtual HttpRequest createRequest(String method) {
        request = new HttpRequest();
        request.setMethod(method);
        return request;
    }
    protected abstract Object getResponseObject();
    public class BaseCalloutException extends Exception {}
}