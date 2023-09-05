public with sharing class Accounts extends fflib_SObjectDomain {
    public static String description = 'Domain classes rock!';

    public Accounts(List<Account> sObjectList) {
        super(sObjectList);
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new Accounts(sObjectList);
        }
    }

    public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
        for (Account account : (List<Account>) Records) {
            account.AnnualRevenue = description.getLevenshteinDistance(account.Description);
        }
    }
    
    public override void onApplyDefaults() {
        for (Account account : (List<Account>) Records) {
            account.Description = description;
        }
    }
}