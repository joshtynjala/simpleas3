package com.simpleas3.core
{
	/**
	 * A SimpleAS3 plugin modifies class prototypes and the global object. The
	 * plugin should only make these modifications when <code>initializePlugin()</code>
	 * is called by the SimpleAS3 core, and it should only be called by the
	 * SimpleAS3 core.
	 * 
	 * <p>The SimpleAS3 core becomes aware of plugins by passing a plugin instance
	 * to <code>SimpleAS3.registerPlugin()</code>.</p>
	 * 
	 * @author Josh Tynjala
	 */
	public interface IPlugin
	{
		/**
		 * When called, a plugin may make modifications to class prototypes
		 * and the global object.
		 */
		function initialize():void;
	}
}