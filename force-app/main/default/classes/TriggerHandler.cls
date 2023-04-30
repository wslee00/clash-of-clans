public virtual class TriggerHandler {
    public virtual void bulkBefore() { }
	public virtual void bulkAfter() { }
	public virtual void beforeInsert(SObject so) { }
	public virtual void beforeUpdate(SObject oldSo, SObject so) { }
	public virtual void beforeDelete(SObject so) { }
	public virtual void afterInsert(SObject so) { }
	public virtual void afterUpdate(SObject oldSo, SObject so) { }
	public virtual void afterDelete(SObject so) { }
	public virtual void andFinally() { }
}