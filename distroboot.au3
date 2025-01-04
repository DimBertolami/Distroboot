#include <InetConstants.au3>
#include <WinAPIFiles.au3>
#include <MsgBoxConstants.au3>
#include <File.au3>
#include <WinNet.au3>
#include <ColorConstants.au3>

#RequireAdmin
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <TreeViewConstants.au3>
#include <WindowsConstants.au3>
Opt("GUIOnEventMode", 1)
If not IsAdmin() Then
	#Region --- CodeWizard generated code Start ---
	;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=Info, Modality=System Modal, Timeout=5 ss, Miscellaneous=Top-most attribute and Title/text right-justified
	MsgBox(790592,"access denied","Admin rights required." & @CRLF & "This program will now close",5)
	#EndRegion --- CodeWizard generated code End ---
	Exit
EndIf
#Region ### START Koda GUI section ### Form=c:\scripts\autoit\distroboot.kxf
Global $Form1_1 = GUICreate("", 490, 323, 192, 124)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1_1Close")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "Form1_1Minimize")
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "Form1_1Maximize")
GUISetOnEvent($GUI_EVENT_RESTORE, "Form1_1Restore")
Global $AddDistro = GUICtrlCreateButton("&Add ISO Image", 0, 8, 83, 89)
GUICtrlSetOnEvent($AddDistro, "AddDistroClick")
Global $RemoveDistro = GUICtrlCreateButton("&Remove ISO Image", 88, 8, 107, 81)
GUICtrlSetOnEvent($RemoveDistro, "RemoveDistroClick")
Global $ScanISOs = GUICtrlCreateButton("&Scan ISO folder", 200, 8, 91, 81)
GUICtrlSetOnEvent($ScanISOs, "ScanISOsClick")
Global $gRamdiskSize = GUICtrlCreateGroup("Ramdisk Size", 296, 3, 89, 86)
Global $r4Gb = GUICtrlCreateRadio("4Gb", 304, 19, 49, 17)


; -----------------------------------------------------------------------------------
Global $r10Gb = GUICtrlCreateRadio("10Gb", 304, 35, 49, 17)
Global $Checkbox1 = GUICtrlCreateCheckbox("Terminal", 304, 67, 97, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $Download = GUICtrlCreateButton("&Download", 392, 8, 91, 25)
GUICtrlSetTip($Download, "download selected distro")
GUICtrlSetOnEvent($Download, "DownloadClick")
Global $TreeView1 = GUICtrlCreateTreeView(0, 99, 193, 217, BitOR($GUI_SS_DEFAULT_TREEVIEW,$TVS_TRACKSELECT,$TVS_INFOTIP,$WS_VSCROLL,$WS_BORDER), BitOR($WS_EX_CLIENTEDGE,$WS_EX_STATICEDGE))

GUICtrlSetTip(-1, "Distrolist")
Global $Update_distrolist = GUICtrlCreateButton("&Update distrolist", 392, 72, 91, 25)
GUICtrlSetOnEvent($Update_distrolist, "Update_distrolist")
Global $QemuRun = GUICtrlCreateButton("run in &Qemu VM", 392, 32, 91, 41)
GUICtrlSetOnEvent($QemuRun, "QemuRunClick")
Global $Progress1, $Progress2, $Progress3, $Progress4, $Label1, $Label2, $Label3, $Label4, $Label5, $Label6, $Label7, $Label8
Global $lProg, $pleft, $ptop, $pwidth, $pheight, $lblA, $ltxtA, $lleftA, $ltopA, $lwidthA, $lheightA, $lblB, $ltxtB, $lleftB, $ltopB, $lwidthB, $lheightB
Global $bIsRunning = False
Global $Url, $Start, $Name, $iFileSize, $iBytesSize, $fDiff, $Download
Global $sFilePath  = ""
Global $sSize = 0
$Progress1 = GUICtrlCreateProgress (199, 105, 150, 22)
GUIctrlSetState(-1, @SW_UNLOCK)
$Label1 = GUICtrlCreateLabel(".", 365, 105, 50, 22)
GUICtrlSetFont($lblA, 10, 800, 0, "MS Sans Serif")
GUICtrlSetColor($lblA, 0xFFFF00)
GUICtrlSetBkColor($lblA, 0x0000FF)
GUICtrlSetTip($lblA, "Mb's downloaded")

$Label2 = GUICtrlCreateLabel(".", 420, 105, 50, 22)
GUICtrlSetFont($lblB, 10, 800, 0, "MS Sans Serif")
GUICtrlSetColor($lblB, 0xFFFF00)
GUICtrlSetBkColor($lblB, 0x0000FF)
GUICtrlSetTip($lblB, "Percentage downloaded")

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Global $iPid = run(@ComSpec & " /k color 9e & title output & cd " & @ScriptDir, @ScriptDir, @SW_MINIMIZE, $STDIN_CHILD + $STDOUT_CHILD)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $iPid = ' & $iPid & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

Update_distrolist()
While 1
	Sleep(1000)
WEnd

Func AddDistroClick()
EndFunc
Func Checkbox1Click()
EndFunc
Func Form1_1Maximize()
	GUISetState(@SW_SHOWMAXIMIZED)
EndFunc
Func Form1_1Minimize()
EndFunc
Func Form1_1Restore()
EndFunc
Func RemoveDistroClick()
EndFunc
Func ScanISOsClick()
	local $hSearch = FileFindFirstFile("*.iso")
	While 1
        local $sFileName = FileFindNextFile($hSearch)
		If @error Then ExitLoop
		ConsoleWrite("File: " & $sFileName & @CRLF)
		StdinWrite($iPid, "echo yolo mofos")
		;StdinWrite($iPid)
		Local $sOutput = ""
		$sOutput &= StdoutRead($iPID) ; Read the Stdout stream of the PID returned by Run.
		If @error Then ; Exit the loop if the process closes or StdoutRead returns an error.
			ExitLoop
		EndIf
		MsgBox($MB_SYSTEMMODAL, "", "The sorted string is: " & @CRLF & $sOutput)
	WEnd
	local $hSearch2 = FileFindFirstFile("*.img")
	While 1
        local $sFileName = FileFindNextFile($hSearch2)
		If @error Then ExitLoop
		ConsoleWrite("File: " & $sFileName & @CRLF)
		StdinWrite($iPid, "echo yolo mofos")
		;StdinWrite($iPid)
		GUICtrlSetData($TreeView1, "")
		GUICtrlSetData($TreeView1, $sFileName)
	WEnd
EndFunc


Func DownloadClick()
	$sFilePath = _WinAPI_GetTempFileName(@TempDir)
	local $tmp = GUICtrlRead($TreeView1, 1)
	$lines = _FileCountLines ( @ScriptDir & "\distrolist.csv" )
	For $i = 1 To $lines Step 1
		$line = FileReadLine(@ScriptDir & "\distrolist.csv", $i)
		$arrLineSplit = StringSplit($line, ",", 2)
		$Name = $arrLineSplit[0]
		If $Name=$tmp Then
			$Url = $arrLineSplit[1]
			$iFileSize = round($arrLineSplit[2]/1024/2024) & "Mb"
			$Download = InetGet($Url, $sFilePath, $INET_BINARYTRANSFER, $INET_DOWNLOADBACKGROUND)
			Do
				$iBytesSize = round(InetGetInfo($Download, $INET_DOWNLOADREAD)/1024/2024)
				ConsoleWrite(round($iBytesSize/$iFileSize*100) & "Yolo Mofo" & @CRLF)
				GUICtrlSetData($Progress1, $iBytesSize / $iFileSize * 100)
				GUICtrlSetData($Label1, $iBytesSize & "Mb")
				GUICtrlSetData($Label2, $sSize & "%")
				Sleep(500)
			Until InetGetInfo($Download, $INET_DOWNLOADCOMPLETE)
			InetClose($Download)
			FileMove($sFilePath, @ScriptDir & "\" & $Name & ".iso", $FC_OVERWRITE + $FC_CREATEPATH)
		EndIf
	Next
EndFunc
Func Form1_1Close()
	Exit
EndFunc

Func Update_distrolist()
	If FileExists(@ScriptDir & "\distrolist1.csv") Then FileDelete(@ScriptDir & "\distrolist1.csv")
	InetGet("https://raw.githubusercontent.com/DimBertolami/Distroboot/refs/heads/main/distrolist.csv", @ScriptDir & "\distrolist.csv")
	$lines = _FileCountLines ( @ScriptDir & "\distrolist.csv" )
	GUICtrlSetData($TreeView1, "")
	For $i = 1 To $lines Step 1
		$line = FileReadLine(@ScriptDir & "\distrolist.csv", $i)
		$arrLineSplit = StringSplit($line, ",")
;		If $arrLineSplit[0] <> 0 Then
			$Name = $arrLineSplit[1]
			GUICtrlCreateTreeViewItem($Name, $TreeView1)
			$Url = $arrLineSplit[2]
 			$Size = Round($arrLineSplit[3]/1024/1024, 1)
;		EndIf
	Next
EndFunc
Func QemuRunClick()
	If Not FileExists("C:\Program Files\qemu\qemu-system-x86_64.exe") Then
		RunWait('powershell -command "winget install qemu"', @ScriptDir, @SW_SHOW)
	EndIf
	Local $tselected = GUICtrlRead($TreeView1, 1)
	if FileExists(@ScriptDir & "\" & $tselected & ".iso") <> 0 Then																; ISO
		$strCmd  = 'cd \progra~1\qemu & "qemu-system-x86_64.exe" -cdrom "' & _
							 @ScriptDir & "\" & $tselected & '.iso" -m 4G'
		execCommand($strCmd)
	EndIf
	if FileExists(@ScriptDir & "\" & $tselected& ".img") <> 0 Then																; IMG
		$strCmd = '"C:\Program Files\qemu\qemu-system-x86_64.exe" -m 4G -drive file="' & _
							@ScriptDir & "\" & $tselected & '.img",format=raw,index=0,media=disk -vga virtio -no-reboot'
		execCommand($strCmd)
	EndIf
	If FileExists(@ScriptDir & "\" & $tselected& ".zip") <> 0 Then															; ZIP FILE
		$strCmd = 'PowerShell -Command "Expand-Archive -Path "' & $tselected & '.zip" -DestinationPath ' & @ScriptDir & ' -Force"'
		;GUICtrlSetData($TreeView1, StringReplace($tselected, StringRight($tselected, 4), ".iso"))
		execCommand($strCmd)
		;FileDelete(@ScriptDir & "\" & $tselected & ".zip")
	EndIf
EndFunc
Func execCommand($cmd)
	RunWait(@comspec & " /c color 9e & " & $cmd, @ScriptDir, @SW_SHOW)
	ConsoleWrite("command executed: " & @CRLF & @TAB & @comspec & " / c color 9e & " & $cmd & @CRLF)
EndFunc

