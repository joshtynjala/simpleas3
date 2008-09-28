package com.simpleas3.events
{
	import flash.events.Event;
	
	/**
	 * A special Event subclass that is dynamic rather than static. Designed
	 * for easily adding new properties to an event without needing to create a
	 * new Event subclass.
	 * 
	 * @author Josh Tynjala
	 */
	public dynamic class DynamicEvent extends Event
	{
		/**
		 * Constructor.
		 */
		public function DynamicEvent(type:String, initObj:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
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
		 * @private
		 * Stores the initObj in case we need it for cloning.
		 */
		private var _initObj:Object;
		
		/**
		 * Clones the event object.
		 */
		override public function clone():Event
		{
			return new DynamicEvent(this.type, this.bubbles, this.cancelable, this._initObj);
		}
	}
}