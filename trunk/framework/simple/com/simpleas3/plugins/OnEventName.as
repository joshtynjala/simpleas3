package com.simpleas3.plugins
{
	import com.simpleas3.core.IPlugin;
	import com.simpleas3.core.SimpleAS3;
	import com.simpleas3.utils.EventUtil;
	
	import flash.events.EventDispatcher;

	/**
	 * A SimpleAS3 plugin that provides the ability to add <code>on<i>EventName</i></code>
	 * methods to class prototypes. This plugin does not actually add any
	 * methods itself. Instead, other plugins should do that.
	 * 
	 * @author Josh Tynjala
	 */
	public class OnEventName implements IPlugin
	{
		/**
		 * @inheritDoc
		 */
		public function initialize():void
		{	
			if(!SimpleAS3.invadePrototypes)
			{
				//if we can't invade the class prototypes, then there's nothing
				//for us to do here.
				return;
			}
			
			EventDispatcher.prototype.createEvent = function(eventName:String):void
			{
				OnEventName.createEvent(eventName, this.constructor);
			}
		}
		
		//unlike the other static functions used by SimpleAS3 plugins, I'm
		//leaving this one on the plugin because it specifically modifies a
		//class prototype
		/**
		 * Adds an "on" function for an event to the prototype of the
		 * specified class.
		 * 
		 * @param eventName		The name of the event to create an <code>on<i>EventName</i></code> function.
		 * @param onClass		The class to which to add the event.
		 */
		public static function createEvent(eventName:String, onClass:Class):void
		{
			var onEventName:String = OnEventName.createPrefixedEventFunction(eventName, "on");
			var endEventName:String = OnEventName.createPrefixedEventFunction(eventName, "end");
			
			if(onClass.prototype.hasOwnProperty(onEventName))
			{
				//already added, and we can safely return without causing errors
				return;
			}
			
			onClass.prototype[onEventName] = function(func:Function, ...extraParameters:Array):void
			{
				var params:Array = extraParameters.concat();
				params.unshift(this, eventName, func);
				EventUtil.on.apply(this, params);
			}
			
			onClass.prototype[endEventName] = function(func:Function, ...extraParameters:Array):void
			{
				var params:Array = extraParameters.concat();
				params.unshift(this, eventName, func);
				//might as well eat our own dogfood
				EventUtil.end.apply(this, params);
			}
		}
		
		/**
		 * @private
		 * Converts an event name to the corresponding "on" event function name.
		 */
		private static function createPrefixedEventFunction(eventName:String, prefix:String):String
		{
			var capitalizedLetter:String = String.fromCharCode(eventName.charCodeAt(0) - 32);
			return prefix + capitalizedLetter + eventName.substr(1);
		}
	}
}