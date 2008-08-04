package
{
	import flash.display.MovieClip
	
	/**
	 * Document class for a SimpleAS3 project.
	 */
	public dynamic class ${CLASSNAME} extends MovieClip
	{
		public function ${CLASSNAME}()
		{
			super();
			
			//set up the root and stage global shortcuts
			simpleas3.root = this.root;
			simpleas3.stage = this.stage;
		}
	}
}

//don't remove this line. it initializes the SimpleAS3 framework.
include "simple/simple.as";