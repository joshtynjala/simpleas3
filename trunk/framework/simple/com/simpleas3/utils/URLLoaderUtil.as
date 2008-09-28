package com.simpleas3.utils
{
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * Utility functions that make loading data with a URLLoader easier.
	 * 
	 * @see flash.net.URLLoader
	 * @author Josh Tynjala
	 */
	public class URLLoaderUtil
	{
		/**
		 * Loads an external XML file and returns to onCompleteMethod as E4X.
		 * 
		 * @param url					The location of the XML file.
		 * @param onCompleteMethod		The event handler for the Event.COMPLETE event type.
		 * @param onErrorMethod			The event handler for the IOErrorEvent.IO_ERROR and the SecurityErrorEvent.SECURITY_ERROR event types.
		 * @return						The URLLoader used to load the file
		 */
		public static function loadXML(url:String, onCompleteMethod:Function = null, onErrorMethod:Function = null):URLLoader
		{
			function xmlParser(result:String):XML
			{
				return new XML(result);
			}
			return createURLLoader(url, onCompleteMethod, onErrorMethod, xmlParser);
		}
		
		/**
		 * Loads an external text file and returns to onCompleteMethod as a String.
		 * 
		 * @param url					The location of the text file.
		 * @param onCompleteMethod		The event handler for the Event.COMPLETE event type.
		 * @param onErrorMethod			The event handler for the IOErrorEvent.IO_ERROR and the SecurityErrorEvent.SECURITY_ERROR event types.
		 * @return						The URLLoader used to load the file
		 */
		public static function loadPlainText(url:String, onCompleteMethod:Function = null, onErrorMethod:Function = null):URLLoader
		{
			return createURLLoader(url, onCompleteMethod, onErrorMethod);
		}
		
		/**
		 * Loads an external JSON file and returns to onCompleteMethod as an ActionScript Object.
		 * 
		 * @param url					The location of the JSON file.
		 * @param onCompleteMethod		The event handler for the Event.COMPLETE event type.
		 * @param onErrorMethod			The event handler for the IOErrorEvent.IO_ERROR and the SecurityErrorEvent.SECURITY_ERROR event types.
		 * @return						The URLLoader used to load the file
		 */
		public static function loadJSON(url:String, onCompleteMethod:Function = null, onErrorMethod:Function = null):URLLoader
		{
			function jsonParser(result:String):Object
			{
				return JSON.decode(result);
			}
			return createURLLoader(url, onCompleteMethod, onErrorMethod, jsonParser);
		}
		
		/**
		 * @private
		 * Generic URLLoader creator for the load*() functions.
		 * 
		 * @param url					The location of the file.
		 * @param onCompleteMethod		The event handler for the Event.COMPLETE event type.
		 * @param onErrorMethod			The event handler for the IOErrorEvent.IO_ERROR and the SecurityErrorEvent.SECURITY_ERROR event types.
		 * @param resultParser			Converts the data returned by the URLLoader to the expected result format.
		 * @return						The URLLoader used to load the file
		 */
		private static function createURLLoader(url:String, onCompleteMethod:Function, onErrorMethod:Function, resultParser:Function = null):URLLoader
		{
			var loader:URLLoader = new URLLoader();
			if(onCompleteMethod != null)
			{
				function completeHandler(event:Event):void
				{
					loader.removeEventListener(Event.COMPLETE, completeHandler);
					if(onErrorMethod != null)
					{
						loader.removeEventListener(IOErrorEvent.IO_ERROR, onErrorMethod);
						loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorMethod);
					}
					
				
					var result:Object = loader.data;
					if(resultParser != null)
					{
						result = resultParser(result);
					}
					onCompleteMethod(result, event);
				}
				
				loader.addEventListener(Event.COMPLETE, completeHandler);
			}
			
			if(onErrorMethod != null)
			{
				loader.addEventListener(IOErrorEvent.IO_ERROR, onErrorMethod);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorMethod);
			}
			
			loader.load(new URLRequest(url));
			return loader;
		}
	}
}