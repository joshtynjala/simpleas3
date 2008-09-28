package com.simpleas3.plugins
{
	import com.simpleas3.core.IPlugin;
	import com.simpleas3.core.SimpleAS3;
	import com.simpleas3.utils.EventUtil;
	
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;

	/**
	 * A SimpleAS3 plugin that adds functionality to ActionScript 3.0's native
	 * event system.
	 * 
	 * @author Josh Tynjala
	 */
	public class Events implements IPlugin
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
			
			EventDispatcher.prototype.on = function(type:String, handler:Function, ...extraParameters:Array):void
			{
				var params:Array = extraParameters.concat();
				params.unshift(this, type, handler);
				EventUtil.on.apply(null, params);
			}
			
			EventDispatcher.prototype.end = function(type:String, handler:Function):void
			{
				EventUtil.end(this, type, handler);
			}
			
			EventDispatcher.prototype.fireEvent = function(type:String, initObj:Object = null, bubbles:Boolean = false, cancelable:Boolean = false):void
			{
				EventUtil.fireEvent(this, type, initObj, bubbles, cancelable);
			}
		}
	}
}