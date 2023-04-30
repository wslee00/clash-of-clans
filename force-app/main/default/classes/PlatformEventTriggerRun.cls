public with sharing class PlatformEventTriggerRun {
	public static void execute(PlatformEventHandler handler) {
		// Because platform events don't emit emails for unhandled exceptions, we must catch everything
		// and do our own logging.
		try {
			handler.bulkAfter();
			for (SObject so : Trigger.new) {
				handler.afterInsert(so);
			}
			handler.andFinally();
		} catch (Exception ex) {
			if (!(ex instanceOf EventBus.RetryableException)) {
				Logger.debug('Trigger.new', Trigger.new);
				Logger.error('Error on platform event trigger run', ex);
				Logger.saveLog();
			}
			throw ex;
		}
	}
}
