package com.simpleas3.utils
{
	import com.simpleas3.core.SimpleAS3;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Utility functions for working with and modifying the display list.
	 * 
	 * @author Josh Tynjala
	 */
	public class DisplayListUtil
	{
		/**
		 * @private
		 * The URL to use when explaining runtime errors when debug mode is active.
		 */
		private static const RUNTIME_ERRORS_URL:String = "http://livedocs.adobe.com/flex/3/langref/runtimeErrors.html#";
		
		 /**
		 * Creates a new instance of an item from the library and adds it as a child.
		 * Similar to attachMovie() in AS2.
		 */
		public static function attachChild(symbol:Object, parent:DisplayObjectContainer, name:String = null,
			initObject:Object = null, depth:int = -1):DisplayObject
		{
			if(depth < 0)
			{
				depth = parent.numChildren;
			}
			
			if(symbol is String)
			{
				symbol = getDefinitionByName(symbol as String);
			}
			
			if(!(symbol is Class) && !(symbol is Function))
			{
				throw new ArgumentError("Invalid symbol passed to attachChild(). Must be a String, Function, or Class.");
			}
			
			var child:DisplayObject = createChild(symbol, name, initObject);
			DisplayListUtil.createChildProperty(parent, child);
			
			if(child)
			{
				return parent.addChildAt(child, depth);
			}
			return null;
		}
		
		/**
		 * Loads an external resource such as a SWF file or an image (JPG, GIF, or PNG)
		 * and adds it as a child.
		 * 
		 * Similar to loadMovie() in AS2, but it doesn't replace content.
		 */
		public static function loadChild(url:String, parent:DisplayObjectContainer, name:String = null,
			onCompleteMethod:Function = null, onProgressMethod:Function = null, onIoErrorMethod:Function = null):Loader
		{
			function loaderCompleteHandler(event:Event):void
			{
				//clear listeners!
				if(onProgressMethod != null)
				{
					loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgressMethod);
				}
				if(onIoErrorMethod != null)
				{
					loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIoErrorMethod);
				}
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
				onCompleteMethod(event);
			}
			
			var loader:Loader = new Loader();
			if(onCompleteMethod != null)
			{
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			}
			if(onProgressMethod != null)
			{
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressMethod);
			}
			if(onIoErrorMethod != null)
			{
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIoErrorMethod);
			}
			loader.load(new URLRequest(url));
			
			if(name)
			{
				loader.name = name;
				DisplayListUtil.createChildProperty(parent, loader);
			}
			
			parent.addChild(loader);
			return loader;
		}
		
		private static function createChild(TheClass:Object, name:String = null, initObject:Object = null):DisplayObject
		{
			if(!(TheClass is Class) && !(TheClass is Function))
			{
				return null;
			}
			
			var child:DisplayObject = new TheClass();
			if(name)
			{
				child.name = name;
			}
			
			if(initObject)
			{
				var isDynamic:Boolean = describeType(child).@isDynamic.toString() == "true";
				for(var propName:String in initObject)
				{
					if(isDynamic || child.hasOwnProperty(propName))
					{
						child[propName] = initObject[propName];
					}
					else if(SimpleAS3.debugMode)
					{
						var className:String = getQualifiedClassName(child); 
						trace("Warning: Cannot assign \"" + initObject[propName] + "\" to variable \"" + propName + "\" on an object of type " + className + ". Variable \"" + propName + "\" cannot be created because the class \"" + className + "\" is sealed. See " + RUNTIME_ERRORS_URL + "1056");
					}
				}
			}
			return child;
		}
		
		private static function createChildProperty(parent:DisplayObjectContainer, child:DisplayObject):Boolean
		{
			if(!child || !child.name)
			{
				return false;
			}
			
			var parentIsDynamic:Boolean = describeType(parent).@isDynamic.toString() == "true";
			if(parentIsDynamic && !parent.hasOwnProperty(child.name))
			{
				parent[child.name] = child;
				function childRemovedHandler(event:Event):void
				{
					if(event.target == child && parent.hasOwnProperty(child.name))
					{
						delete parent[child.name];
					}
					child.removeEventListener(Event.REMOVED, childRemovedHandler);
				}
				child.addEventListener(Event.REMOVED, childRemovedHandler);
			}
			else if(SimpleAS3.debugMode)
			{
				var className:String = getQualifiedClassName(parent); 
				trace("Warning: Unable to create property \"" + child.name + "\". The class " + className + " may be sealed, or the property \"" + child.name + "\" may already exist on the parent.");
				return false;
			}
			
			return true;
		}
	}
}