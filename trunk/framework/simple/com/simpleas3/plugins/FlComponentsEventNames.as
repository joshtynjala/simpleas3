package com.simpleas3.plugins
{
	import com.simpleas3.core.IPlugin;
	import com.simpleas3.core.SimpleAS3;

	/**
	 * A SimpleAS3 plugin that adds <code>on<i>EventName</i></code> methods to
	 * the components in the <code>fl.*</code> namespace.
	 * 
	 * @author Josh Tynjala
	 */
	public class FlComponentsEventNames implements IPlugin
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
			
			//creates the "on" event functions for the core types
			for(var classToInit:Object in classToEvents)
			{
				var events:Array = classToEvents[classToInit];
				var eventCount:int = events.length;
				for(var j:int = 0; j < eventCount; j++)
				{
					var eventName:String = events[j];
					OnEventName.createEvent(eventName, Class(classToInit));
				}
			}
		}
		
	}
}
	import flash.utils.Dictionary;
	

var classToEvents:Dictionary = new Dictionary();