package com.simpleas3.plugins
{
	import com.simpleas3.core.IPlugin;
	import com.simpleas3.core.SimpleAS3;

	/**
	 * A SimpleAS3 plugin that adds <code>on<i>EventName</i></code> methods to
	 * the native <em>playerglobal</em> classes.
	 * 
	 * @author Josh Tynjala
	 */
	public class PlayerGlobalEventNames implements IPlugin
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

import flash.display.*;
import flash.events.*;
import flash.media.*;
import flash.net.*;
import flash.text.*;
import flash.ui.*;
import flash.utils.*;
	
//too bad event metadata isn't kept in playerglobal.
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
	//seriously, adobe? you put "on" in some of the event names?
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