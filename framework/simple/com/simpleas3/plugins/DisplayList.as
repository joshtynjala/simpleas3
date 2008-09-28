package com.simpleas3.plugins
{
	import com.simpleas3.core.IPlugin;
	import com.simpleas3.core.SimpleAS3;
	import com.simpleas3.utils.DisplayListUtil;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Stage;
	import flash.events.Event;
	
	/**
	 * A SimpleAS3 plugin that adds functionality to display objects.
	 * 
	 * @author Josh Tynjala
	 */
	public class DisplayList implements IPlugin
	{
		/**
		 * Constructor.
		 * 
		 * @param root		The root of this SWF's display list.
		 */
		public function DisplayList(root:DisplayObject)
		{
			this._root = root;
			if(this._root.root != this._root)
			{
				//does this really need to be enforced?
				throw new ArgumentError("Supplied root is not actually the root.");
			}
		}
		
		/**
		 * @private
		 * Storage for the root and stage properties.
		 */
		private var _root:DisplayObject;
		
		/**
		 * A global reference to the root of the SWF in which this instance of
		 * SimpleAS3 was initialized.
		 */
		public function get root():DisplayObject
		{
			return this._root;
		}
		
		/**
		 * A global reference to the <code>stage</code>. This value may be null
		 * if the SWF is loaded into another SWF.
		 */
		public function get stage():Stage
		{
			return this._root.stage;
		}
		
		/**
		 * @inheritDoc
		 */
		public function initialize():void
		{
			//put root and stage into the global scope
			SimpleAS3.quickScope.root = this.root;
			this.root.addEventListener(Event.REMOVED_FROM_STAGE, rootRemovedFromStageHandler, false, 0, true);
			this.initializeStage();
			
			if(!SimpleAS3.invadePrototypes)
			{
				//if we can't invade the class prototypes, then there's nothing
				//else for us to do here.
				return;
			}
			
			DisplayObjectContainer.prototype.attachChild = function(symbol:Object, name:String = null,
				initObject:Object = null, depth:int = -1):DisplayObject
			{
				return DisplayListUtil.attachChild.call(symbol, this, name, initObject, depth);
			};
			
			DisplayObjectContainer.prototype.loadChild = function(url:String, name:String = null,
				onCompleteMethod:Function = null, onProgressMethod:Function = null, onIoErrorMethod:Function = null):Loader
			{
				return DisplayListUtil.loadChild(url, this, name, onCompleteMethod, onProgressMethod, onIoErrorMethod);
			};
		}
		
		/**
		 * @private
		 * Sets the top-level stage object or waits until the supplied root has
		 * been added to the stage (if we're loading a new SWF).
		 */
		private function initializeStage():void
		{
			SimpleAS3.quickScope.stage = this.stage;
			
			if(!this.stage)
			{
				this.root.addEventListener(Event.ADDED_TO_STAGE, rootAddedToStageHandler, false, 0, true);
			}
		}
		
		/**
		 * @private
		 * Once the root has been added to the stage, try initializing again.
		 */
		private function rootAddedToStageHandler(event:Event):void
		{
			this.root.removeEventListener(Event.ADDED_TO_STAGE, rootAddedToStageHandler);
			this.initializeStage();
		}
		
		/**
		 * @private
		 * Once the root has been removed from the stage, we'll need to listen
		 * for the new stage.
		 */
		private function rootRemovedFromStageHandler(event:Event):void
		{
			this.initializeStage();
		}
	}
}