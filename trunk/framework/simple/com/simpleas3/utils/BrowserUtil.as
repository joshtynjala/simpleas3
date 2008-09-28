package com.simpleas3.utils
{
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	
	/**
	 * Utility functions for communicating with the browser.
	 * 
	 * @author Josh Tynjala
	 */
	public class BrowserUtil
	{
		/**
		 * Loads a URL in the browser. Shorthand for navigateToURL.
		 * 
		 * @param url		The URL of the webpage to load.
		 * @param window	The window in which to load the URL.
		 * @param params	The parameters to pass with the URL.
		 * @param method	The method in which to send the data.
		 */
		public static function getURL(url:String, window:String = "_self", params:Object = null, method:String = "GET"):void
		{
			var vars:URLVariables = new URLVariables();
			for(var propName:String in params)
			{
				vars[propName] = params[propName];
			}
			var request:URLRequest = new URLRequest(url);
			request.method = method;
			request.data = vars;
			navigateToURL(request, window);
		}
	}
}