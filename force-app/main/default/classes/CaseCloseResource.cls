@RestResource(URLMapping = '/case/*/close')
global with sharing class CaseCloseResource {
    @HttpPost
    global static void closeCase(String closeReason){
        RestRequest req = RestContext.request;
        String[] idsList = req.requestURI.split('/');
        Id caseId = idsList[2];

        CaseService.closeCases(new Set<ID> { caseId }, closeReason);
    }
}