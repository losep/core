' *****************************************************************************
' VBMake.vbs
' Copyright © 2000 Kinook Software.  All rights reserved.
' http://www.kinook.com
' Be sure to visit www.kinook.com for more handy utilities and tools, 
' including Visual Build, the build management tool for Windows and web
' developers.
'
' VBMake is freeware.  You may freely distribute it, as long as you do not 
' sell it or make it part of another package or application.  If any 
' modifications are made to the script code, they must be clearly marked in 
' the code and documented in the Modifications section below, and these header 
' comments must not be changed or removed.
'
' VBMake provides critical functionality that is missing from the Visual
' Basic IDE/compiler.  It is a VBScript make utility for intelligently 
' building Microsoft Visual Basic projects, only building projects when the 
' target executable is older than the source files.  It works well in 
' conjunction with the Visual Build build management tool.
'
' This script parses an individual VBP file (or all VBP files in a VBG) for 
' its target and dependencies (the project file, all constituent source files 
' and their binary equivalents [i.e.: frx, etc.]), and invokes VB from the 
' command-line to build the project only if the target executable does not 
' exist or is older than any of the dependencies.  It does not consider 
' references as a dependency.  If the target is not specified in the VBP, 
' VBMake will fail with an error.
'
' Usage: cscript VBMake.vbs <VBP/VBG file> [/V <VB compiler path>] [/F] [/N] [/S]
'
' Any output is echoed to standard output; returns ERRORLEVEL of 0 if 
' successful or < 0 if any error occurs.
'
' The first parameter must be a valid VB project file (VBP) or group filename 
' (VBG) and the following optional flags are supported (non-case-sensitive):
'   /F => forces all targets to be rebuilt regardless of dependency dates.
'   /N => displays commands but does not execute.  Useful for debugging.
'   /S => Suppress default output (only displays error output)
'   /V => full path to VB compiler (looks for compiler if not passed)
'         Use to override for newer version of VB (/m and /out
'         flags must be supported by newer versions for calling from command-line)
'
' e.g.: cscript VBMake.vbs MyProjects.vbg /s
'
' Dependencies:
'   1) Microsoft Windows Scripting 5.0+ (comes with Win98 & Win2000, download 
'      for NT 4.0 and Win95 at http://msdn.microsoft.com/scripting)
'   2) Microsoft Visual Basic 5.0+.  If SourceSafe is also installed, is 
'      recommended that you disable SourceSafe integration in VB on the build 
'      machine to prevent the possibility of dialog boxes requiring user input 
'      when building.  This is done by selecting Add-ins|Add-In Manager,
'      selecting Source Code Control in the listbox and unchecking 'Load on
'      Startup'.
'
' Modifications:
' Jan 1, 2000 (1.0)   => initial version
' May 7, 2000 (1.1)   => changed algorithm to locate VB (works for VB5 and VB6)
' June 26, 2000 (1.2) => clear error after deleting output file in case
'												 it doesn't exist
' *****************************************************************************

Const SCRIPT_VERSION = "1.2"

' global settings
Dim g_blnAlwaysBuild, g_blnDisplayOnly, g_blnSuppress, g_strVBPath
Dim g_objFS, g_objShell

' *****************************************************************************
' script entry point; retrieve arguments and build

   Dim intBuilt, intCount, strProject, intIdx, strTemp

   WScript.Echo "VBMake Utility, Version " & SCRIPT_VERSION + vbCrLf + _
      "Copyright (C) 2000 Kinook Software. All rights reserved." + vbCrLf

   On Error Resume Next
   
   Set g_objFS = WScript.CreateObject("Scripting.FileSystemObject")
   If Err.Number <> 0 Then ExitWithError "Failed to create Scripting.FileSystemObject."

   ' create shell object
   Set g_objShell = WScript.CreateObject("WScript.Shell")
   If Err.Number <> 0 Then ExitWithError "Failed to create WScript.Shell object."

   intBuilt = 0
   intCount = 0

   ' process command-line arguments
   For intIdx = 0 To WScript.Arguments.Count - 1
      If Left(WScript.Arguments(intIdx), 1) = "/" Then
         Select Case (LCase(Mid(WScript.Arguments(intIdx), 2, 1)))
            Case "f"
               g_blnAlwaysBuild = True

            Case "n"
               g_blnDisplayOnly = True

            Case "s"
               g_blnSuppress = True

            Case "v"
               intIdx = intIdx + 1
               If intIdx < WScript.Arguments.Count Then 
                  g_strVBPath = WScript.Arguments(intIdx)
               End If
         End Select
      Else
         strProject = WScript.Arguments(intIdx)
      End If
   Next

   If Len(g_strVBPath) = 0 Then
      ' lookup VB path in registry and use if not provided
		strTemp = g_objShell.RegRead("HKCR\VisualBasic.Project\shell\Make\command\")
      If Err.Number <> 0 Then ExitWithError "Failed to read VB location from registry."
		g_strVBPath = Left(strTemp, InStr(LCase(strTemp), ".exe") + 3)
		If Left(g_strVBPath, 1) <> """" Then g_strVBPath = """" & g_strVBPath
		If Mid(g_strVBPath, Len(g_strVBPath), 1) <> """" Then g_strVBPath = g_strVBPath & """"
   Else    ' add double quotes around executable if not provided
      If Left(g_strVBPath, 1) <> """" Then g_strVBPath = """" + g_strVBPath + """"
   End If

   If Len(strProject) = 0 Then      ' too few parameters
      WScript.Echo "Usage: cscript " & WScript.ScriptName & " <VBP/VBG file> " & _
         "[/V <VB compiler path>] [/F] [/N] [/S]"
      WScript.Quit -1
   End If

   ' add current directory to project file if a relative path
   If RelativePath(strProject) Then 
      strProject = g_objFS.BuildPath(g_objFS.GetFolder(".").Path, strProject)
   End If

   If InStr(LCase(strProject), ".vbp") > 0 Then
      BuildProject strProject
   Else
      BuildGroup strProject, intBuilt, intCount
      If Not g_blnSuppress Then WScript.Echo vbCrLf & "Processed " & intBuilt & _
         " of " & intCount & " projects."
   End If

   WScript.Quit 0		' exit with success code if we got here

' *****************************************************************************
' BuildGroup
' Process the project group file, building all projects that need to
' be built; Returns the number of projects found and the number built

Sub BuildGroup(strFilename, intBuilt, intCount)

   Dim strBasePath, strFullFile, strLine, intPos, objFile

   On Error Resume Next

   ' remember base VBG path for relative VBP files
   strBasePath = g_objFS.GetParentFolderName(strFilename)
   
   Set objFile = g_objFS.OpenTextFile(strFilename)
   If Err.Number <> 0 Then ExitWithError "Failed to open project group file '" & strFilename & "'."
   
   ' process each line of the file
   Do While Not objFile.AtEndOfStream
      strLine = objFile.ReadLine
      If Err.Number <> 0 Then ExitWithError "Failed to read project group file '" & strFilename & "'."
      intPos = InStr(strLine, "=") + 1
      If intPos > 1 Then
         strFullFile = g_objFS.BuildPath(strBasePath, Mid(strLine, intPos))
         If BuildProject(strFullFile) Then intBuilt = intBuilt + 1   ' and process it
         intCount = intCount + 1
      End If
   Loop
   objFile.Close

End Sub

' *****************************************************************************
' BuildProject
' Process the project file, building if necessary
' Returns return True if it was built, False if it the target was
' up-to-date

Function BuildProject(strFilename)

   Dim strVBOut, strLine, objFile, strEXE, intReturn, blnNeed

   On Error Resume Next

   strVBOut = g_objFS.BuildPath(g_objShell.Environment("PROCESS").Item("TEMP"), "vb.err")

   ' determine if the project needs to be built
   blnNeed = g_blnAlwaysBuild
   If Not blnNeed Then blnNeed = TargetOutOfDate(strFilename)
   
   If blnNeed Then  ' write build step to output
      ' build VB command-line to build the project
      strExe = g_strVBPath & " /m """ & strFilename & """ /out """ & strVBOut & """"
      If Not g_blnSuppress Then WScript.Echo vbTab & strExe

      If Not g_blnDisplayOnly Then
         g_objFS.DeleteFile strVBOut, True
				 Err.Clear		' clear error in case file doesn't exist

         ' run VB, passing parameters to build from command-line; then read output from
         ' the file that VB wrote to if it fails
         intReturn = g_objShell.Run(strExe, 0, True)
         If Err.Number <> 0 Then ExitWithError "Failed to build project '" & strFilename & "'."
         If intReturn <> 0 Then   ' echo error file output as well
            WScript.Echo "Failed building project '" & strFilename & "'."
            Set objFile = g_objFS.OpenTextFile(strVBOut)
            If Err.Number = 0 Then
               ' process each line of the file
               Do While Not objFile.AtEndOfStream
                  strLine = objFile.ReadLine
                  If Err.Number <> 0 Then Exit Do
                  WScript.Echo strLine
              Loop
              objFile.Close
            End If 
            WScript.Quit -2
         End If
      End If
      BuildProject = True
   End If

End Function

' *****************************************************************************
' GetVBPTarget
' Parses the project file to determine the target filename and populates in strTarget
' and returns length of target filename if found or 0 if not found

Function GetVBPTarget(strFilename, strTarget)

   Dim strBasePath, strTemp, strLine, strEXE, objFile
   
   On Error Resume Next

   ' remember base VBP path and prepend to target if they are relative filenames
   strBasePath = g_objFS.GetParentFolderName(strFilename)
   
   Set objFile = g_objFS.OpenTextFile(strFilename)
   If Err.Number <> 0 Then ExitWithError "Failed to open project file '" & strFilename & "'."
   
   ' traverse project file to determine the target filename
   Do While Not objFile.AtEndOfStream
      strLine = objFile.ReadLine
      If Err.Number <> 0 Then ExitWithError "Failed reading project file '" & strFilename & "'."
      
      If Left(strLine, 7) = "Path32=" Then
         strTemp = Mid(strLine, 9, Len(strLine) - 9)  ' extract out the path
         If RelativePath(strTemp) Then strTarget = strBasePath  ' if relative, prepend VBP path
         strTarget = g_objFS.BuildPath(strTarget, strTemp)    ' now add target path
      ElseIf Left(strLine, 10) = "ExeName32=" Then		' extract out EXE name
         strEXE = Mid(strLine, 12, Len(strLine) - 12)  ' save EXE name temporarily
      End If
   Loop
   objFile.Close

   If Len(strEXE) > 0 Then                     ' now add ExeName to path
      ' if no explicit path, prepend VBP path for full target name
      If Len(strTarget) = 0 And RelativePath(strEXE) Then strTarget = strBasePath
      strTarget = g_objFS.BuildPath(strTarget, strEXE)
   End If

   GetVBPTarget = Len(strTarget) > 0
   
End Function

' *****************************************************************************
' TargetOutOfDate
' Determine if the target for the project file is out of date with
' respect to any dependencies

Function TargetOutOfDate(strFilename)

   Dim objVBPFile, objTempFile, strBasePath, strDep, strTarget
   Dim dteTarget, dteVBP, strTok, intPos, blnBinDep
   
   On Error Resume Next

   ' remember base VBP path and prepend to target if they are relative filenames
   strBasePath = g_objFS.GetParentFolderName(strFilename)
   
   If GetVBPTarget(strFilename, strTarget) = 0 Then
      ' can't process without knowing the target
      WScript.Echo "No target found in project '" & strFilename & "'."
      WScript.Quit -3
   End If

   ' retrieve and store the date/time of the target
   Set objTempFile = g_objFS.GetFile(strTarget)
   If Err.Number = 0 Then
      dteTarget = objTempFile.DateLastModified
   Else
      TargetOutOfDate = True	' if target does not exist, it must be rebuilt
      Exit Function
   End If

   ' retrieve the date/time of the project file and compare with the target
   Set objTempFile = g_objFS.GetFile(strFilename)
   If Err.Number = 0 Then
      ' if target is older than the dependency, need to rebuild this project
      If dteTarget < objTempFile.DateLastModified Then
         TargetOutOfDate = True
         Exit Function
       End If
   End If

   ' start over and process each line of the project file for all dependencies
   Set objVBPFile = g_objFS.OpenTextFile(strFilename)
   If Err.Number <> 0 Then ExitWithError "Failed to open project file '" & strFilename & "'."
   
   Do While Not objVBPFile.AtEndOfStream
      strLine = objVBPFile.ReadLine
      If Err.Number <> 0 Then ExitWithError "Failed reading project file '" & strFilename & "'."
      
      blnBinDep = False      ' some files never have a binary dependency
      strTok = ""
      intPos = InStr(strLine, "=") + 1
      If intPos > 1 Then              ' look for a dependency line
         If Left(strLine, 5) = "Class" Or Left(strLine, 6) = "Module" Then
            ' items that have format <objectname; filename>
            strTok = Mid(strLine, InStr(intPos, strLine, ";") + 2)
         ElseIf Left(strLine, 9) = "ResFile32" Then
           ' items that have format <"filename">
           strTok = Mid(strLine, intPos + 1, Len(strLine) - intPos - 1)
         ElseIf Left(strLine, 4) = "Form" Or Left(strLine, 11) = "UserControl" Or _
              Left(strLine, 12) = "PropertyPage" Or Left(strLine, 8) = "Designer" Or _
              Left(strLine, 12) = "UserDocument" Then
           ' items that have format <filename>
           strTok = Mid(strLine, intPos)
           blnBinDep = True                  ' these files may have binary dependencies as well
         End If

         If Len(strTok) > 0 Then
            strDep = ""              ' clear dependency filename
            If RelativePath(strTok) Then strDep = strBasePath   ' if relative path, prepend VBP path
            strDep = g_objFS.BuildPath(strDep, strTok)          ' now add the dependency filename

            ' retrieve the date/time of the target
            Set objTempFile = g_objFS.GetFile(strDep)
            If Err.Number = 0 Then
               dteDep = objTempFile.DateLastModified
               
               ' if target is older than the dependency, need to rebuild this project
               If dteTarget < dteDep Then
                  TargetOutOfDate = True
                  Exit Do			' done checking this target
               End If

               If blnBinDep Then        ' if it could have a binary dependency, check it as well
                  blnBinDep = False     ' turn flag back off

                  ' extract root filename of dependency and convert to binary filename
                  strBinDep = LCase(g_objFS.GetFilename(strDep))
                  strBinDep = Left(strBinDep, Len(strBinDep)-1) & "x"

                  ' search the target to see if it actually has a binary dependency
                  Set objTempFile = g_objFS.OpenTextFile(strDep)
                  If Err.Number <> 0 Then ExitWithError "Failed opening dependency file '" & strDep & "'."

                  Do While Not objTempFile.AtEndOfStream
                     strLine = objTempFile.ReadLine
                     If Err.Number <> 0 Then ExitWithError "Failed reading dependency file '" & strDep & "'."
                     
                     If InStr(LCase(strLine), strBinDep) > 0 Then
                        blnBinDep = True
                        Exit Do
                     End If
                  Loop
                  objTempFile.Close
                  
                  ' if it has a binary dependency, compare its date to the target as well
                  If blnBinDep Then
                     ' convert dependency into its full binary filename
                     strBinDep = Left(strDep, Len(strDep)-1) & "x"
                     Set objTempFile = g_objFS.GetFile(strBinDep)
                     If Err.Number = 0 Then
                        ' if target is older than the binary dependency, need to rebuild this project
                        If dteTarget < objTempFile.DateLastModified Then
                           TargetOutOfDate = True
                           Exit Do   ' done checking this target
                        End If
                     Else
                        WScript.Echo "Failed to open dependency file '" & strBinDep & _
                           "' for project '" & strFilename & "'."
                        WScript.Quit -6
                     End If
                  End If
               End If
            Else
               WScript.Echo "Unable to find dependency '" & strDep & "' for project '" & strFilename & "'."
               WScript.Quit -5
            End If
         End If
      End If
   Loop
   objVBPFile.Close

End Function

' *****************************************************************************
Function RelativePath(strFilename)
' given a filename, determines if it is a relative or absolute path name

    RelativePath = True
    If Len(strFilename) > 0 Then
        If Left(strFilename, 1) = "\" Or Mid(strFilename, 2, 2) = ":\" Then
            RelativePath = False
        End If
    End If

End Function

' *****************************************************************************
Sub ExitWithError(strExtraDescr)
' write the error description to standard output and exit with a failure exitcode

   If Len(strExtraDescr) > 0 Then 
      WScript.Echo strExtraDescr & vbCrlf & Err.Description
   Else
      WScript.Echo Err.Description
   End If
   WScript.Quit Err.Number

End Sub
