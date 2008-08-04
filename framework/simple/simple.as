import flash.display.*;
import flash.events.*;
import flash.net.*;
import flash.text.*;
import flash.utils.*;

SIMPLEAS3_VERSION = "0.1.0";

include "global.as"
include "privateclasses.as"

//anything in this block is private rather than global.
//you learn cool stuff when you play with JavaScript sometimes.
//flash cs3, however, doesn't handle it properly and throws errors
//flex sdk 3 works fine
(function():void
{
	include "events.as"
	include "displaylist.as"
})();