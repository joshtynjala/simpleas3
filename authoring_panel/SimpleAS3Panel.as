package
{
	import adobe.utils.MMExecute;
	
	import fl.controls.Button;
	import fl.controls.TextInput;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextFormat;

	public class SimpleAS3Panel extends Sprite
	{
		private static const REPLACE_PROJECT_MESSAGE:String = "A .FLA or .AS file with this name may already exist in the selected folder. If you continue, the existing files will be deleted. Do you want to delete these files and generate new ones?";
		
		public function SimpleAS3Panel()
		{
			super();
			
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			this._simpleAS3Root = this.loaderInfo.url.substr(0, this.loaderInfo.url.lastIndexOf("/")) + "/../SimpleAS3";
			this._jsflPath = this._simpleAS3Root + "/SimpleAS3Project.jsfl";
			this._frameworkPath = this._simpleAS3Root + "/framework";

			this.headerText.buttonMode = true;
			this.headerText.addEventListener(MouseEvent.CLICK, headerTextClickHandler);

			this.createProjectButton.addEventListener(MouseEvent.CLICK, createProjectClickHandler);
			this.createProjectButton.setStyle("upSkin", "yellowButtonUpSkin");
			this.createProjectButton.setStyle("overSkin", "yellowButtonOverSkin");
			this.createProjectButton.setStyle("downSkin", "yellowButtonDownSkin");
			this.createProjectButton.setStyle("textFormat", new TextFormat("Helvetica Neue,Helvetica,Arial", 14, 0x000000, true));
			
			this.projectNameInput.setStyle("focusRectSkin", "yellowFocusRect");
			this.projectNameInput.setStyle("textFormat", new TextFormat("Helvetica Neue,Helvetica,Arial", 12, 0x000000, true));
		}
		
		public var projectNameInput:TextInput;
		public var createProjectButton:Button;
		public var headerText:MovieClip;
		
		private var _simpleAS3Root:String;
		private var _frameworkPath:String;
		private var _jsflPath:String;
		
		private function runScript(...args:Array):String
		{
			return MMExecute('fl.runScript("' + args.join('","') + '");');
		}
		
		private function output(message:String):void
		{
			MMExecute('fl.trace("' + message + '");');
		}
		
		private function confirm(message:String):Boolean
		{
			return MMExecute('confirm("' + message + '");') == "true";
		}
		
		private function alert(message:String):void
		{
			MMExecute('alert("' + message + '");');
		}
		
		private function createProjectClickHandler(event:MouseEvent):void
		{
			var projectName:String = this.projectNameInput.text.replace("\s*", "");
			if(!this.isProjectNameValid(projectName))
			{
				this.alert("Invalid Project Name. It must contain only letters and numbers, and it cannot start with a number.");
				return;
			}
			
			var projectPath:String = this.runScript(this._jsflPath, "getProjectFolderPath") as String;
			if(projectPath == "null")
			{
				this.output("No folder chosen. Project creation cancelled.");
				return;
			}
			
			this.output("Checking if simpleas3 framework is present.");
			var frameworkVersion:String = this.runScript(this._jsflPath, "getFrameworkVersion", projectPath);
			if(frameworkVersion != "0")
			{
				this.output("INFO: The SimpleAS3 framework already exists at this location. Found version " + frameworkVersion + ".");
			}
			else
			{
				this.output("INFO: The SimpleAS3 framework does not yet exist at this location.");
			}
			
			var projectFilesExist:Boolean = this.runScript(this._jsflPath, "projectFilesExist", projectPath, projectName) == "true";
			if(!projectFilesExist || this.confirm(REPLACE_PROJECT_MESSAGE))
			{
				this.runScript(this._jsflPath, "createNewSimpleAS3Project", projectPath, projectName, this._frameworkPath);
				this.output("Project FLA and Document Class created.");
			}
			else
			{
				this.output("You chose not to replace the existing files. Project creation cancelled.");
			}
			
		}
		
		private function isProjectNameValid(projectName:String):Boolean
		{
			if(projectName.length == 0)
			{
				return false;
			}
			
			return /^[a-z$_][\w$]*$/i.test(projectName);
		}
		
		private function headerTextClickHandler(event:MouseEvent):void
		{
			navigateToURL(new URLRequest("http://www.simpleas3.com/"));
		}
	}
}
