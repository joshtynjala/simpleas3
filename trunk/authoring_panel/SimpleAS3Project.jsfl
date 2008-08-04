/**
 * Allows the user to select a folder into which a SimpleAS3 project will be
 * created.
 */
function getProjectFolderPath()
{
	return fl.browseForFolderURL("Select a folder for a new SimpleAS3 Project");
}

/**
 * Checks for the SimpleAS3 framework in a directory. If it exists, returns the
 * version. If it doesn't exist, returns 0.
 */
function getFrameworkVersion(projectPath)
{
	var simplePath = projectPath + "/simple/simple.as";
	if(!FLfile.exists(simplePath))
	{
		return 0;
	}
	
	var simpleCode = FLfile.read(simplePath);
	
	var versionDecl = "SIMPLEAS3_VERSION = \"";
	var versionDeclStart = simpleCode.indexOf(versionDecl);
	var versionStart = versionDeclStart + versionDecl.length;
	var versionLength = simpleCode.indexOf("\"", versionStart) - versionStart;
	
	return simpleCode.substr(versionStart, versionLength);
}

/**
 * Checks to see if there already exists a FLA file or a class with the desired
 * project name.
 */
function projectFilesExist(projectPath, projectName)
{
	var projectFiles = [projectName + ".fla", projectName + ".as"];
	for(var i = 0; i < projectFiles.length; i++)
	{
		var filePath = projectPath + "/" + projectFiles[i];
		if(FLfile.exists(filePath))
		{
			return true;
		}
	}
	return false;
}

//-- Project Creation Function

/**
 * Creates a new FLA file and document class in the specified directory, and
 * copies the SimpleAS3 framework to that directory.
 */
function createNewSimpleAS3Project(projectPath, projectName, frameworkPath)
{	
	//create the FLA file
	var newFLA = fl.createDocument()
	newFLA.as3StrictMode = false;
	
	var newFLAPath = projectPath + "/" + projectName + ".fla";
	if(FLfile.exists(newFLAPath))
	{
		//if the FLA already exists, remove it.
		FLfile.remove(newFLAPath);
	}
	
	fl.saveDocument(newFLA, newFLAPath);
	
	addSimpleAS3ToExistingFLA(frameworkPath);
}


/**
 * Using an existing FLA file, creates 
 */
function addSimpleAS3ToExistingFLA(frameworkPath)
{
	var fla = fl.getDocumentDOM();
	if(!fla)
	{
		fl.trace("No FLA file is open. Please create a new FLA file.");
		return;
	}
	
	//make sure the FLA is actually saved somewhere!
	if(fla.path == undefined)
	{
		fl.trace("You must first save this FLA file. Please select a location.");
		fla.save();
	}
	
	//if a document class already exists, ask the user if it is okay to replace it
	if(fla.docClass)
	{
		var result = confirm("This FLA file already has a document class. Do you want to replace it? The original document class will be lost.");
		if(!result)
		{
			fl.trace("You chose not to replace the document class. Project creation canceled.");
			return;
		}
	}
	
	//extract the FLA file's name and set that as the name of the document class
	var flaPath = "file:///" + fla.path;
	var flaName = fla.name.substr(0, fla.name.length - 4);
	fla.docClass = flaName;
	fla.save();
	
	//determine the project location from the FLA location
	var projectPath = flaPath.substr(0,  flaPath.indexOf(flaName) - 1);
	
	//copy the SimpleAS3 framework
	copyFramework(frameworkPath, projectPath);
	
	var templateDocClassPath = projectPath + "/DocClass.as";
	var newDocClassPath = projectPath + "/" + flaName + ".as";
	if(FLfile.exists(newDocClassPath))
	{
		FLfile.remove(newDocClassPath);
	}
	
	var docClassCode = FLfile.read(templateDocClassPath);
	FLfile.remove(templateDocClassPath);
	docClassCode = docClassCode.split("${CLASSNAME}").join(flaName);
	FLfile.write(newDocClassPath, docClassCode);
}

function copyFramework(frameworkPath, projectPath)
{
	//remove the old framework if needed
	var simplePath = projectPath + "/simple";
	if(FLfile.exists(simplePath))
	{
		var result = FLfile.remove(simplePath); //remove the framework if it already exists
		if(!result)
		{
			throw "Framework already exists at this location and it cannot be deleted. Make sure files aren't read-only!"
			return;
		}
	}
	
	var fileList = FLfile.listFolder(frameworkPath, "files");
	copyFiles(frameworkPath, projectPath, fileList);
	var folderList = FLfile.listFolder(frameworkPath, "directories");
	copyFolders(frameworkPath, projectPath, folderList);
}

//--- HELPER FUNCTIONS

//copyFolders() from the Gaia Framework by Steven Sacks
function copyFolders(sourcePath, targetPath, folderList)
{
	var i = folderList.length;
	while (i--)
	{
		FLfile.createFolder(targetPath + "/" + folderList[i]);
		copyFiles(sourcePath + "/" + folderList[i], targetPath + "/" + folderList[i], FLfile.listFolder(sourcePath + "/" + folderList[i], "files"));
		copyFolders(sourcePath + "/" + folderList[i], targetPath + "/" + folderList[i], FLfile.listFolder(sourcePath + "/" + folderList[i], "directories"));
	}
}

//copyFiles() from the Gaia Framework by Steven Sacks
function copyFiles(sourcePath, targetPath, fileList)
{
	var i = fileList.length;
	while (i--)
	{
		FLfile.copy(sourcePath + "/" + fileList[i], targetPath + "/" + fileList[i]);
	}
}
