import flash.events.ErrorEvent;
import flash.events.Event;
import flash.net.*;

simpleas3 = {};

/**
 * A global reference to the root of the SWF.
 */
simpleas3.root = null;

/**
 * A global reference to the root of the main SWF.
 */
simpleas3.stage = null;

/**
 * If true, debug messages will appear in the trace() output. Debug messages
 * are used when a class is sealed and SimpleAS3 is unable to add dynamic properties.
 */
simpleas3.debugMode = true;

/**
 * Loads a URL in the browser. Shorthand for navigateToURL.
 */
getURL = function(url:String, window:String = "_self", method:String = "GET"):void
{
	var request:URLRequest = new URLRequest(url);
	request.method = method;
	navigateToURL(request, window);
}

/**
 * Loads an external XML file and returns to onCompleteMethod as E4X.
 */
loadXML = function(url:String, onCompleteMethod:Function = null, onErrorMethod:Function = null):URLLoader
{
	var loader:URLLoader = new URLLoader();
	if(onCompleteMethod != null)
	{
		loader.onComplete(function(event:Event):void
		{
			if(onErrorMethod != null)
			{
				loader.endOnIoError(onErrorMethod);
				loader.endOnSecurityError(onErrorMethod);
			}
			
			var xml:XML = new XML(loader.data);
			onCompleteMethod(xml, event);
		});
	}
	
	if(onErrorMethod != null)
	{
		loader.onIoError(onErrorMethod);
		loader.onSecurityError(onErrorMethod);
	}
	
	loader.load(new URLRequest(url));
	return loader;
}