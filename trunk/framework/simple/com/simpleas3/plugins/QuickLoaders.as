package com.simpleas3.plugins
{
	import com.simpleas3.core.IPlugin;
	import com.simpleas3.core.SimpleAS3;
	import com.simpleas3.utils.BrowserUtil;
	import com.simpleas3.utils.URLLoaderUtil;

	/**
	 * A SimpleAS3 plugin that defines several functions that load URLs in the
	 * browser or into Flash Player to be parsed.
	 * 
	 * @author Josh Tynjala
	 */
	public class QuickLoaders implements IPlugin
	{
		/**
		 * @inheritDoc
		 */
		public function initialize():void
		{
			SimpleAS3.quickScope.loadXML = URLLoaderUtil.loadXML;
			SimpleAS3.quickScope.loadPlainText = URLLoaderUtil.loadPlainText;
			SimpleAS3.quickScope.loadJSON = URLLoaderUtil.loadJSON;
			SimpleAS3.quickScope.getURL = BrowserUtil.getURL;
		}
	}
}