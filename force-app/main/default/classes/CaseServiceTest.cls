@isTest
public class CaseServiceTest {

    @TestSetup
    static void makeData() {
        List<Case> testCases = new List<Case>();
        
        for (Integer i = 0; i < 10; i++) {
            testCases.add(new Case(
            	Subject = 'Test Subject #' + i,
                Status = 'New'
            ));
        }
        insert testCases;
    }

    @isTest
    public static void testCloseCasesWithSpecifiedReason() {

        Set<Id> casesIds = (new Map<Id, Case>([SELECT Id FROM Case])).keySet();
        String closeReason = 'Test Reason';

        Test.startTest();
        CaseService.closeCases(casesIds, closeReason);
        Test.stopTest();

        System.assertEquals(10, [SELECT Id FROM Case WHERE Status = 'Closed' AND Reason = :closeReason].size());
    }
    
    @isTest
    public static void testNoCasesToCloseException() {
        String closeReason = 'Test Reason';

        Test.startTest();
        try {
            CaseService.closeCases(new Set<Id>(), closeReason);
        } catch (CaseService.CaseServiceException ex) {
            System.assertEquals('Cases not specified.', ex.getMessage());
        }
        Test.stopTest();
    }
    
    
    @isTest
    public static void testNoCloseReasonException() {
        Set<Id> casesIds = (new Map<Id, Case>([SELECT Id FROM Case])).keySet();
        String closeReason = '';

        Test.startTest();
        try {
            CaseService.closeCases(casesIds, closeReason);
        } catch (CaseService.CaseServiceException ex) {
            System.assertEquals('Invalid close reason to apply.', ex.getMessage());
        }
        Test.stopTest();
    }
}