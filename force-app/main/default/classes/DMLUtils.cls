public with sharing class DMLUtils {

    public static void objToUpdate(List<sObject> objToUpdate) {
        Database.SaveResult[] srList;
        if (!objToUpdate.isEmpty()) {
            srList = Database.Update(objToUpdate, False);
            // Iterate through each returned result
            for (Database.SaveResult sr: srList) {
                if (!sr.isSuccess()) {
                    // Operation failed, so get all errors                
                    for (Database.Error err: sr.getErrors()) {
                        System.debug('The following error has occurred.');
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    }
                }
            }
        }
    }

}