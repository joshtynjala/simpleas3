package com.simpleas3.utils
{
	import com.simpleas3.events.DynamicEvent;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	 * Utility functions dealing with events.
	 * 
	 * @author Josh Tynjala
	 */
	public class EventUtil
	{
		/**
		 * @private
		 * Lookup table for event listeners added with <code>on()</code>.
		 */
		private static var dispatcherToListeners:Dictionary = new Dictionary(true);
		
		/**
		 * Adds an event listener and accepts additional parameters that will be
		 * passed to the handler function.
		 * 
		 * <p>Any additional arguments passed after the <code>handler</code>
		 * argument will be added to the listener call.</p>
		 * 
		 * <p><strong>Important:</strong> To remove an event listener added with
		 * <code>on()</code>, you <em>must</em> use <code>end()</code> or your
		 * SWF may have memory leaks.</p>
		 * 
		 * @param dispatcher		The event dispatcher to which we'll be
		 * 							adding a listener.
		 * @param type				The event type
		 * @param handler			The function that will be called when the
		 * 							event is fired.
		 * 
		 * @see #end()
		 */
		public static function on(dispatcher:IEventDispatcher, type:String, handler:Function, ...extraParameters:Array):void
		{
			var wrapper:Function = function(event:Event):void
			{
				var params:Array = extraParameters.concat();
				params.unshift(event); //add the event argument to the beginning
				handler.apply(null, params);
			}
			if(!dispatcherToListeners[dispatcher])
			{
				dispatcherToListeners[dispatcher] = {};
			}
			var listeners:Object = dispatcherToListeners[dispatcher];
			
			if(!listeners.hasOwnProperty(type))
			{
				listeners[type] = new Dictionary();
			}
			var lookup:Dictionary = Dictionary(listeners[type]);
			lookup[handler] = wrapper;
			
			dispatcher.addEventListener(type, wrapper);
		}
		
		/**
		 * Removes an event listener that was added with <code>on()</code>.
		 * 
		 * @see #on()
		 */
		public static function end(dispatcher:IEventDispatcher, type:String, handler:Function):void
		{
			//if an event was added using on(), the actual event handler is a wrapper
			//function. We used savedEventHandlers to store a lookup table find the wrapper
			//so that we can remove the event handler
			var listeners:Object = dispatcherToListeners[dispatcher];
			if(listeners.hasOwnProperty(type))
			{
				var lookup:Dictionary = Dictionary(listeners[type]);
				if(lookup[handler] != null)
				{
					handler = lookup[handler];
					delete lookup[handler];
				}
			}
			dispatcher.removeEventListener(type, handler);
		}
		
		/**
		 * Dispatches a dynamic event object with the properties specified in
		 * <code>initObj</code>.
		 * 
		 * @param dispatcher		The event dispatcher that will fire the
		 * 							event.
		 * @param type				The type of event to fire.
		 * @param initObj			A set of name values pair with which to
		 * 							initialize the event instance's properties.
		 * @param bubbles			If true, the event will bubble.
		 * @param cancelable		If true, the event may be canceled.
		 */
		public static function fireEvent(dispatcher:IEventDispatcher, type:String, initObj:Object = null, bubbles:Boolean = false, cancelable:Boolean = false):Boolean
		{
			return dispatcher.dispatchEvent(new DynamicEvent(type, initObj, bubbles, cancelable));
		}

	}
}