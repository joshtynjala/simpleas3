package com.simpleas3.core
{
	import flash.errors.IllegalOperationError;
	
	/**
	 * The heart of the SimpleAS3 framework. Includes a few useful shortcut
	 * properties.
	 * 
	 * <p>Thanks to Flash Player's ApplicationDomain architecture, each SWF can
	 * have its own copy of SimpleAS3 without interfering with different
	 * versions in different SWFs.</p>
	 * 
	 * @author Josh Tynjala
	 */
	public class SimpleAS3
	{	
		/**
		 * If true, SimpleAS3 may use the <code>trace()</code> output for
		 * error and warning messages when it encounters problems. When false,
		 * SimpleAS3 is silent.
		 */
		public static var debugMode:Boolean = false;
		
		/**
		 * The "top level" variable used for quick access to simpleas3 functionality.
		 */
		public static var quickScope:Object = simple;
		
		/**
		 * If true, SimpleAS3 plugins are allowed to modify class prototypes. If
		 * false, they must not modify class prototypes.
		 */
		public static var invadePrototypes:Boolean = true;
		
		/**
		 * @private
		 * Flag indicating whether SimpleAS3 has been initialized.
		 */
		private static var _initialized:Boolean = false;
		
		/**
		 * @private
		 * Storage for the registered plugins.
		 */
		private static var _plugins:Array = [];

		/**
		 * Initializes the SimpleAS3 framework and its registered plugins.
		 */
		public static function initialize():void
		{
			if(SimpleAS3._initialized)
			{
				//we can't reinitialize
				throw new IllegalOperationError("SimpleAS3 has already been initialized. You may only call SimpleAS3.initialize() once.");
			}
			SimpleAS3._initialized = true;
			
			for each(var plugin:IPlugin in SimpleAS3._plugins)
			{
				plugin.initialize();
			}
		}
		
		/**
		 * Adds a plugin to SimpleAS3. Each type of functionality that SimpleAS3
		 * adds to AS3 is separated into its own plugin.
		 * 
		 * <p>All plugins must be registered before calling <code>initialize()</code>.</p>
		 * 
		 * @param plugin		The plugin instance to register
		 */
		public static function registerPlugin(plugin:IPlugin):void
		{
			if(SimpleAS3._initialized)
			{
				//we can't reinitialize
				throw new IllegalOperationError("SimpleAS3 has been initialized. You may only call SimpleAS3.registerPlugin() before SimpleAS3.initialize() has been called.");
			}
			SimpleAS3._plugins.push(plugin);
		}
	}
}