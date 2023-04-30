public with sharing class TriggerRunner {
    public static void execute(TriggerHandler handler) {
		if (Trigger.isBefore) {
			handler.bulkBefore();
			if (Trigger.isDelete) {
				for (SObject so : Trigger.old) {
					handler.beforeDelete(so);
				}
			} else if (Trigger.isInsert) {
				for (SObject so : Trigger.new) {
					handler.beforeInsert(so);
				}
			} else if (Trigger.isUpdate) {
				for (SObject so : Trigger.old) {
					handler.beforeUpdate(so, Trigger.newMap.get(so.Id));
				}
			}
		} else {
			handler.bulkAfter();
			if (Trigger.isDelete) {
				for (SObject so : Trigger.old) {
					handler.afterDelete(so);
				}
			} else if (Trigger.isInsert) {
				for (SObject so : Trigger.new) {
					handler.afterInsert(so);
				}
			} else if (Trigger.isUpdate) {
				for (SObject so : Trigger.old) {
					handler.afterUpdate(so, Trigger.newMap.get(so.Id));
				}
			}
			handler.andFinally();
		}
	}
}