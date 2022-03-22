public with sharing class CaseCloseCalloutService {
    
    public static String getRequestBody(Case obj){
        String jsonReqBody = JSON.serialize(
    		new Map<String, Object> {
            'id' => obj.Id, 
            'agentid' => obj.case_closed_by__c
            });
        return jsonReqBody;
    }
    
    public static void  caseCloseCalloutToWorkforce(List<sObject> scope){   

        CaseCloseCallout caseCloseCallout = new CaseCloseCallout();
        CaseCloseCallout.CaseCloseResponse caseCloseRes= new CaseCloseCallout.CaseCloseResponse();
        List<Case> casesToUpdate= new List<Case>();
        Case caseObj;
        String request;
        for(sObject obj:scope){
            caseObj=(Case) obj;
            request=getRequestBody(caseObj);
            caseCloseRes=caseCloseCallout.pushCaseToWorkForce(request);
            if(caseCloseRes.success){
                caseObj.Secret_Key__c=caseCloseRes.secretKey;
                casesToUpdate.add(caseObj);
            }
        }
        DMLUtils.objToUpdate(casesToUpdate);
    }
}