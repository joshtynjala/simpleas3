/**
 * An event type that allows any extra property to be added.
 */
dynamic class DynamicEvent extends Event
{
	/**
	 * Constructor.
	 */
	public function DynamicEvent(type:String, bubbles:Boolean, cancelable:Boolean, initObj:Object)
	{
		super(type, bubbles, cancelable);
		
		if(initObj)
		{
			this.initObj = initObj
			for(var propName:String in initObj)
			{
				this[propName] = initObj[propName];
			}
		}
	}
	
	/**
	 * Stores the initObj in case we need it for cloning.
	 */
	private var initObj:Object;
	
	/**
	 * Clones the event object.
	 */
	override public function clone():Event
	{
		return new DynamicEvent(this.type, this.bubbles, this.cancelable, this.initObj);
	}
}