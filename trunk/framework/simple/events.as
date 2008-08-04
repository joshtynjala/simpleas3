import flash.display.*;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.media.*;
import flash.net.*;
import flash.ui.ContextMenu;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;
	
//too bad event metadata isn't kept.
//it sure would save me the hassle of writing out all the event names here!
var classToEvents:Dictionary = new Dictionary();
classToEvents[EventDispatcher] =
[
	"activate",
	"deactivate"
];

classToEvents[DisplayObject] = 
[
	"added",
	"addedToStage",
	"enterFrame",
	"removed",
	"removedFromStage",
	"render"
];

classToEvents[InteractiveObject] =
[
	"click",
	"doubleClick",
	"focusIn",
	"focusOut",
	"keyDown",
	"keyFocusChange",
	"keyUp",
	"mouseDown",
	"mouseFocusChange",
	"mouseMove",
	"mouseOut",
	"mouseOver",
	"mouseUp",
	"mouseWheel",
	"rollOut",
	"rollOver",
	"tabChildrenChange",
	"tabEnabledChange",
	"tabIndexChange"
];

classToEvents[TextField] =
[
	"change",
	"link",
	"scroll",
	"textInput"
];

classToEvents[LoaderInfo] =
[
	"complete",
	"httpStatus",
	"init",
	"ioError",
	"open",
	"progress",
	"unload"
];

classToEvents[Timer] =
[
	"timer",
	"timerComplete"
];

classToEvents[Sound] =
[
	"complete",
	"id3",
	"ioError",
	"open",
	"progress"
];

classToEvents[Camera] =
[
	"activity",
	"status"
];

classToEvents[Microphone] =
[
	"activity",
	"status"
];

classToEvents[SoundChannel] =
[
	"soundComplete"
];

classToEvents[ContextMenu] =
[
	"menuSelect"
];

classToEvents[FileReference] =
[
	"cancel",
	"complete",
	"httpStatus",
	"ioError",
	"open",
	"progress",
	"securityError",
	"select",
	"uploadCompleteData"
];

classToEvents[FileReferenceList] =
[
	"cancel",
	"select"
];

classToEvents[LocalConnection] =
[
	"asyncError",
	"securityError",
	"status"
];

classToEvents[NetConnection] =
[
	"asyncError",
	"ioError",
	"netStatus",
	"securityError"
];

classToEvents[NetStream] =
[
	"asyncError",
	"ioError",
	"netStatus",
	//seriously, adobe? you put "on" in some event names?
	"onCuePoint",
	"onImageData",
	"onMetaData",
	"onPlayStatus",
	"onTextData"
];

classToEvents[SharedObject] =
[
	"asyncError",
	"netStatus",
	"sync"
];

classToEvents[Socket] =
[
	"close",
	"connect",
	"ioError",
	"securityError",
	"socketData"
];

classToEvents[URLLoader] =
[
	"complete",
	"httpStatus",
	"ioError",
	"open",
	"progress",
	"securityError"
];

classToEvents[URLStream] =
[
	"complete",
	"httpStatus",
	"ioError",
	"open",
	"progress",
	"securityError"
];

classToEvents[XMLSocket] =
[
	"close",
	"connect",
	"data",
	"ioError",
	"securityError"
];

/**
 * Converts an event name to the corresponding "on" event function name.
 */
function getEventFunctionName(eventName:String, prefix:String = "on"):String
{
	var capitalizedLetter:String = String.fromCharCode(eventName.charCodeAt(0) - 32);
	return prefix + capitalizedLetter + eventName.substr(1);
}

function createEvent(eventName:String, toClass:Class):void
{
	var onEventName:String = getEventFunctionName(eventName);
	var endEventName:String = getEventFunctionName(eventName, "end");
	
	if(toClass.prototype.hasOwnProperty(onEventName))
	{
		//already added, so let's skip this
		return;
	}
	
	toClass.prototype[onEventName] = function(func:Function, ...extraParameters:Array):void
	{
		var params:Array = extraParameters.concat();
		params.unshift(eventName, func);
		this.on.apply(this, params);
	}
	
	toClass.prototype[endEventName] = function(func:Function, ...extraParameters:Array):void
	{
		var params:Array = extraParameters.concat();
		params.unshift(eventName, func);
		this.end.apply(this, params);
	}
}

var savedEventHandlers:Object = {};

/**
 * Shorthand for adding an event listener. Any parameters other than the first two
 * will be included in the call to the handler function when the event is fired.
 * 
 * @param eventName		The name of the event for which to listen.
 * @param handler		The function to call when the event is fired.
 */
EventDispatcher.prototype.on = function(type:String, handler:Function, ...extraParameters:Array):void
{
	var wrapper:Function = function(event:Event):void
	{
		var params:Array = extraParameters.concat();
		params.unshift(event);
		handler.apply(null, params);
	}
	
	if(!savedEventHandlers[type])
	{
		savedEventHandlers[type] = new Dictionary();
	}
	var lookup:Dictionary = Dictionary(savedEventHandlers[type]);
	lookup[handler] = wrapper;
	
	this.addEventListener(type, wrapper);
};

EventDispatcher.prototype.end = function(type:String, handler:Function, ...extraParameters:Array):void
{
	//if an event was added using on(), the actual event handler is a wrapper
	//function. We used savedEventHandlers to store a lookup table find the wrapper
	//so that we can remove the event handler
	if(savedEventHandlers[type])
	{
		var lookup:Dictionary = Dictionary(savedEventHandlers[type]);
		if(lookup[handler])
		{
			handler = lookup[handler];
			delete lookup[handler];
		}
	}
	this.removeEventListener(type, handler);
};

/**
 * Fires an event with extra properties specified in initObj.
 */
EventDispatcher.prototype.fireEvent = function(type:String, initObj:Object = null, bubbles:Boolean = false, cancelable:Boolean = false):Boolean
{
	return this.dispatchEvent(new DynamicEvent(type, bubbles, cancelable, initObj));
}

/**
 * Adds an "on" function for an event to the prototype of the
 * specified class.
 */
EventDispatcher.prototype.createEvent = function(eventName:String, toClass:Class):void
{
	createEvent(eventName, toClass);
}

//creates the "on" event functions for the core types
for(var classToInit:Class in classToEvents)
{
	var events:Array = classToEvents[classToInit];
	var eventCount:int = events.length;
	for(var j:int = 0; j < eventCount; j++)
	{
		var eventName:String = events[j];
		createEvent(eventName, classToInit);
	}
}