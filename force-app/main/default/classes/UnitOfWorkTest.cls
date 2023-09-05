@isTest
public class UnitOfWorkTest {
    @isTest 
    static void challengeComplete() {
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new Schema.SObjectType[] {
                Account.SObjectType,
                Contact.SObjectType,
                Note.SObjectType
            }
        );

        for (Integer i = 0; i < 100; i++) {
            Account accountItem = new Account(
                Name = 'Test Account #' + i
            );
            uow.registerNew(accountItem);

            for (Integer j = 0; j < 5; j++) {
                Contact contactItem = new Contact(
                    LastName = 'Contact Last Name #' + j
                );
                uow.registerNew(contactItem, Contact.AccountId, accountItem);

                Note noteItem = new Note(
                    Body = 'Test Note Body',
                    Title = 'Note # ' + j
                );
                uow.registerNew(noteItem, Note.ParentId, accountItem);
            }
        }
        uow.commitWork();

        System.assertEquals(100, [SELECT Id FROM Account].size());
        System.assertEquals(500, [SELECT Id FROM Contact].size());
        System.assertEquals(500, [SELECT Id FROM Note].size());
    }
}