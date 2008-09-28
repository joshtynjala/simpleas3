package
{
	import com.simpleas3.core.SimpleAS3;
	import com.simpleas3.plugins.*;
	
	import flash.display.MovieClip;
	
	/**
	 * Document class for a SimpleAS3 project.
	 */
	public dynamic class ${CLASSNAME} extends MovieClip
	{
		public function ${CLASSNAME}()
		{
			super();
			SimpleAS3.registerPlugin(new Events());
			SimpleAS3.registerPlugin(new OnEventName());
			SimpleAS3.registerPlugin(new PlayerGlobalEventNames());
			SimpleAS3.registerPlugin(new DisplayList(this));
			SimpleAS3.registerPlugin(new QuickLoaders());
			SimpleAS3.initialize();
		}
	}
}