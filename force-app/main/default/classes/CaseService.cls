public with sharing class CaseService {

    public static void closeCases(Set<Id> caseIds, String closeReason) {
        if (caseIds == null || caseIds.size() == 0) {
            throw new CaseServiceException('Cases not specified.');
        }
        
        if (String.isBlank(closeReason)) {
            throw new CaseServiceException('Invalid close reason to apply.');
        }

        List<Case> closedCasesToUpdate = new List<Case>();
        for (Case caseItem : [SELECT Id, Status, Reason FROM Case WHERE Id IN :caseIds]) {
            caseItem.Status = 'Closed';
            caseItem.Reason = closeReason;

            closedCasesToUpdate.add(caseItem);
        }

        SavePoint savepointBeforeUpdate = Database.setSavepoint();
        if (closedCasesToUpdate.size() > 0) {
            try {
                update closedCasesToUpdate;
            } catch (Exception ex) {
                Database.rollback(savepointBeforeUpdate);
                throw ex;
            }
        }
    }

    public class CaseServiceException extends Exception {}
}