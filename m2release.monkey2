' Monkey2 Make release
' By @Hezkore 2018
' https://github.com/Hezkore/m2release

#Import "<std>"
Using std..

#Import "config.txt@/.."

Global M2Path:String
Global ZipPath:String
Global Type:String
Global Config:String
Global Target:String
Global Source:String
Global Output:String
Global DoneCmd:String

Function Main()
	If CurrentDir()=AppDir() Then
		Print "Please make a shortcut and set the ~qStart in~q path"
		Sleep(60)
		Return 
	Endif
	
	'Read config file
	Print "Applying settings from ~qconfig.txt~q"
	Local stream:=Stream.Open( AppDir()+"config.txt", "r" )
	Local line:String
	While Not stream.Eof
		line=stream.ReadLine()
		ProcessCfgLine( line )
	Wend
	Print ""
	
	'Read AppArgs
	If AppArgs().Length>1 Then
		Print "Applying settings from AppArgs"
		For Local s:=Eachin AppArgs()
			ProcessCfgLine( s )
		Next
	Else
		Print "No settings from AppArgs"
	Endif
	Print ""
	
	'Check if M2Path is set
	If Not M2Path Then
		Print "Monkey 2 path is not set"
		Sleep(1)
		Print "ERROR"
		Sleep(1)
		Print ""
		Print "Please set your Monkey2 path in ~qconfig.txt~q"
		Print "Example: m2=c:\m2_path\bin\mx2cc_windows.exe"
		Sleep(60*60)
	Endif
	
	'Check if 7-Zip path is set
	If ZipPath.Length<=1 Then
		Print "7-Zip path not set"
		Print "Attempting to run 7-Zip anyways..."
		If libc.system( "7z" ) Then
			Sleep(1)
			Print "ERROR"
			Sleep(1)
			Print ""
			Print "Please set your 7-Zip path in ~qconfig.txt~q or AppArgs"
			Print "Example: 7z=c:\7-zip_path\7z.exe"
			Sleep(60*60)
			Return
		Else
			Print ""
			ZipPath="7z"
		Endif
	Endif
	
	'Check if Type is set
	If Type.Length<=1 Then
		Print "Type not set"
		Type="gui"
		
		Print "Using ~q"+Type+"~q as Type"
		Print ""
	Endif
	
	'Check if Config is set
	If Config.Length<=1 Then
		Print "Config not set"
		Config="release"
		
		Print "Using ~q"+Config+"~q as Config"
		Print ""
	Endif
	
	'Check if Config is set
	If Target.Length<=1 Then
		Print "Config not set"
		Target="desktop"
		
		Print "Using ~q"+Target+"~q as Target"
		Print ""
	Endif
	
	'Check if Source is set
	If Source.Length<=1 Then
		Print "Source not set"
		
		Source=CurrentDir()+"main.monkey2"
		If GetFileType( Source )=FileType.File Then
			Print "Guessing Source: "+Source
		Else
			Source=Null
		Endif
		
		If Not Source Then 
			'Try to get from current dir
			Local dirName:String
			dirName=CurrentDir().ToLower()
			
			'Is the dir just the SRC dir?
			If dirName.EndsWith("src/") Or dirName.EndsWith("source/") Then
				dirName=dirName.Slice( 0, -4 )
			Endif
			
			If dirName.EndsWith("/") Then
				dirName=dirName.Slice( 0, -1 )
			Endif
			
			'Strip out everything but the final name
			dirName=StripDir(dirName)
			
			Source=CurrentDir()+dirName+".monkey2"
			If GetFileType( Source )=FileType.File Then
				Print "Guessing Source: "+Source
			Else
				Print "No source found!"
				Sleep(1)
				Print "ERROR"
				Sleep(1)
				Print ""
				Print "Couldn't find ~qmain.monkey2~q nor ~q"+dirName+".monkey2~q"
				Print "Or set your source file path in ~qconfig.txt~q or AppArgs"
				Print "Example: source=c:\project_path\source.monkey2"
				Sleep(60*60)
				Return
			Endif
			
			Print ""
		Endif
		
	Endif
	
	'Check if Output is set
	If Output.Length<=1 Then
		Print "Output not set"
		
		'Try to get from current dir
		Output=CurrentDir().ToLower()
		
		'Is the dir just the SRC dir?
		If Output.EndsWith("src/") Then
			Output=Output.Slice( 0, -4 )
		Endif
		
		If Output.EndsWith("/") Then
			Output=Output.Slice( 0, -1 )
		Endif
		
		Output+="/"+Config+"/"
		
		'Guess filename
		Local dirName:String
		dirName=CurrentDir().ToLower()
		
		'Is the dir just the SRC dir?
		If dirName.EndsWith("src/") Or dirName.EndsWith("source/") Then
			dirName=dirName.Slice( 0, -4 )
		Endif
		
		If dirName.EndsWith("/") Then
			dirName=dirName.Slice( 0, -1 )
		Endif
		
		dirName=StripDir( dirName )
		
		Output+=dirName
		
		Print "Guessing Output: "+Output
		Print ""
	Endif
	
	Local projectName:String=StripDir( Output )
	
	Local tmpDir:String=CurrentDir()+"m2release_tmp"+Now()+"/"
	CreateDir( tmpDir, True, True )
	
	'DO STUFF!
	Print "Ready to start"
	Sleep(0.25)
	Print "=MONKEY2="
	Print "Working in: ~q"+tmpDir+StripDir( Output )+"~q"
	Sleep(0.25)
	If libc.system( "~q"+M2Path+"~q makeapp -clean -apptype="+Type+" -build -config="+Config+" -product=~q"+tmpDir+StripDir(Output)+"~q ~q"+Source+"~q" )
		Sleep(1)
		Print "ERROR"
		Sleep(60*60)
	Endif
	
	'Make output
	Print ""
	' Name
	Local filename:=StripDir( Output ).ToLower().Replace( " ", "_" )+"-"
	
	'Target
	If Target="desktop" Then
		#If __HOSTOS__="macos"
			filename+="mac"
		#ElseIf __HOSTOS__="windows"
			filename+="win"
		#Else
			filename+="lin"
		#Endif
	Else
		filename+=Target.Left(3)
	Endif
	
	'Arch
	#If __ARCH__="x64"
		filename+="64"
	#Elseif
		filename+="86"
	#Endif
	
	filename+="-" 'Date
	filename+=Time.Now().Year+"-"
	filename+=DatePad(Time.Now().Month+1)+"-"
	filename+=DatePad(Time.Now().Day)
	filename+="-" 'Time
	filename+=DatePad(Time.Now().Hours)+"."
	filename+=DatePad(Time.Now().Minutes)
	filename+=".7z" 'Extension
	
	Sleep(0.25)
	Print "=7-ZIP="
	Sleep(0.25)
	If libc.system( "~q"+ZipPath+"~q a -r ~q"+ExtractDir( Output )+filename+"~q ~q"+tmpDir+"~q/*.* -sdel -y" )
		Sleep(1)
		Print "ERROR"
		Sleep(60*60)
	Endif
	
	'Ending command
	If DoneCmd Then
		Sleep(0.25)
		Print ""
		Print "=CMD="
		Sleep(0.25)
		DoneCmd=DoneCmd.Replace( "%output%", (ExtractDir( Output )+filename).Replace("/","\") ).Replace( "%name%", projectName )
		Print "Executing: "+DoneCmd
		Local exitCode:=libc.system( DoneCmd )
		If exitCode Then
			Sleep(1)
			Print "Error "+exitCode
			Sleep(1)
		Else
			Print "CMD complete"
		Endif
	End
	
	'Cleanup
	Sleep(0.25)
	Print ""
	Print "=CLEANUP="
	Sleep(0.25)
	While GetFileType( tmpDir )=FileType.Directory
		DeleteDir( tmpDir, True )
		If GetFileType( tmpDir )=FileType.Directory Then
			Print "Retrying..."
			Sleep(1)
		Else
			Print "Clean complete"
		Endif
	Wend
	
	'Done :)
	Print ""
	Print "All done!"
	Sleep(60*60)
End

Function ProcessCfgLine( line:String )
	
	If line.ToLower().StartsWith("m2=") Then
		M2Path=line.Slice(3)
		Print "MONKEY2="+M2Path
		Return
	Endif
	
	If line.ToLower().StartsWith("7z=") Then
		ZipPath=line.Slice(3)
		Print "7-Zip="+ZipPath
		Return
	Endif
	
	If line.ToLower().StartsWith("type=") Then
		Type=line.Slice(5)
		Print "TYPE="+Type.ToLower()
		Return
	Endif
	
	If line.ToLower().StartsWith("done=") Then
		DoneCmd=line.Slice(5)
		Print "DONE="+DoneCmd.ToLower()
		Return
	Endif
	
	If line.ToLower().StartsWith("config=") Then
		Config=line.Slice(7)
		Print "CONFIG="+Config.ToLower()
		Return
	Endif
	
	If line.ToLower().StartsWith("target=") Then
		Target=line.Slice(7)
		Print "TARGET="+Target.ToLower()
		Return
	Endif
	
	If line.ToLower().StartsWith("source=") Then
		Source=line.Slice(7)
		Print "SOURCE="+Source
		Return
	Endif
	
	If line.ToLower().StartsWith("output=") Then
		Output=line.Slice(7)
		Print "OUTPUT="+Output
		Return
	Endif
	
End

Function DatePad:String( str:String, len:Int=2 )
	While str.Length<len
		str="0"+str
	Wend
	Return str
End