#include <InetConstants.au3>
#include <WinAPIFiles.au3>
#include <MsgBoxConstants.au3>
#include <File.au3>
#include <WinNet.au3>


#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <TreeViewConstants.au3>
#include <WindowsConstants.au3>
Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=c:\scripts\autoit\distroboot.kxf
$Form1_1 = GUICreate("Form1", 498, 436, 192, 124)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1_1Close")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "Form1_1Minimize")
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "Form1_1Maximize")
GUISetOnEvent($GUI_EVENT_RESTORE, "Form1_1Restore")
$AddDistro = GUICtrlCreateButton("&Add ISO Image", 0, 8, 83, 89)
GUICtrlSetOnEvent(-1, "AddDistroClick")
$RemoveDistro = GUICtrlCreateButton("&Remove ISO Image", 88, 8, 107, 89)
GUICtrlSetOnEvent(-1, "RemoveDistroClick")
$ScanISOs = GUICtrlCreateButton("&Scan ISO folder", 200, 8, 91, 89)
GUICtrlSetOnEvent(-1, "ScanISOsClick")
$gRamdiskSize = GUICtrlCreateGroup("Ramdisk Size", 296, 3, 89, 94)
$r4Gb = GUICtrlCreateRadio("4Gb", 304, 19, 49, 17)
GUICtrlSetOnEvent(-1, "r4GbClick")
$r10Gb = GUICtrlCreateRadio("10Gb", 304, 35, 49, 17)
GUICtrlSetOnEvent(-1, "r10GbClick")
$Checkbox1 = GUICtrlCreateCheckbox("Terminal", 304, 67, 97, 17)
GUICtrlSetOnEvent(-1, "Checkbox1Click")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Download = GUICtrlCreateButton("&Download", 392, 8, 91, 17)
GUICtrlSetTip(-1, "download selected distro")
GUICtrlSetOnEvent(-1, "DownloadClick")
$Progress = GUICtrlCreateGroup("Details", 8, 328, 481, 89)
$Label1 = GUICtrlCreateLabel("Speed: ", 341, 357, 51, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetOnEvent(-1, "Label1Click")
$Label2 = GUICtrlCreateLabel(".", 396, 336, 88, 36)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlSetBkColor(-1, 0x0000FF)
GUICtrlSetOnEvent(-1, "Label2Click")
$Progress1 = GUICtrlCreateProgress(10, 341, 294, 73)
$Label3 = GUICtrlCreateLabel("Downloaded:", 307, 397, 84, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetOnEvent(-1, "Label3Click")
$Label4 = GUICtrlCreateLabel(".", 396, 376, 88, 36)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlSetBkColor(-1, 0x0000FF)
GUICtrlSetOnEvent(-1, "Label4Click")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$TreeView1 = GUICtrlCreateTreeView(8, 104, 481, 217, BitOR($GUI_SS_DEFAULT_TREEVIEW,$TVS_CHECKBOXES,$TVS_TRACKSELECT,$TVS_INFOTIP,$WS_VSCROLL,$WS_BORDER), BitOR($WS_EX_CLIENTEDGE,$WS_EX_STATICEDGE))
GUICtrlSetTip(-1, "Distrolist")
GUICtrlSetOnEvent(-1, "TreeView1Click")
$Update_distrolist = GUICtrlCreateButton("&Update distrolist", 392, 80, 91, 17)
GUICtrlSetOnEvent(-1, "Update_distrolistClick")
$QemuRun = GUICtrlCreateButton("run in &Qemu VM", 392, 32, 91, 41)
GUICtrlSetOnEvent(-1, "QemuRunClick")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Global $Url, $Start, $Name, $iFileSize, $iBytesSize, $fDiff, $Download
$sFilePath = _WinAPI_GetTempFileName(@TempDir)
Update_distrolistClick()

While 1
	Sleep(100)
WEnd

Func AddDistroClick()

EndFunc
Func Checkbox1Click()

EndFunc
Func CheckSize()

#cs
	$iFileSize = totale grootte (  in MB )
	$iBytesSize = downloaded    (  in MB )
	$fDiff = tijd 		        ( in sec )

	Download time (in seconds) = (File size in megabytes)
								 ----------------------------
								 (Internet speed in Mbps / 8)

	speed in Mbps / 8 = (File size in megabytes)
						----------------------------
						Download time (in seconds)

#ce
	if not InetGetInfo($Download, $INET_DOWNLOADCOMPLETE) Then
		$iBytesSize = round(InetGetInfo($Download, $INET_DOWNLOADREAD)/1024/2024,1)
		If $iBytesSize < $iFileSize Then
			$fDiff = TimerDiff($Start)/1000
			;local $speed = $iBytesSize / $fDiff
			;ProgressOn("Progress Meter", "Increments every second" & @CRLF & "..." , "0%", -1, -1, BitOR($DLG_NOTONTOP, $DLG_MOVEABLE))
			;ProgressSet(round($iBytesSize / $iFileSize*100), ($iBytesSize / $iFileSize * 100) & "%")
			GUICtrlSetData($Progress1, round($iBytesSize / $iFileSize*100)+1)
			GUICtrlSetData($Label4, $iBytesSize & "/" & $iFileSize)
			GUICtrlSetData($Label2, round($iBytesSize+1 / $iFileSize*100))
		Else
			FileMove($sFilePath, @ScriptDir & "\" & $Name & ".iso", $FC_OVERWRITE + $FC_CREATEPATH)
			AdlibUnRegister("CheckSize")
		EndIf
	EndIf
EndFunc
Func DownloadClick()
	$Start = TimerInit()
	local $tmp = GUICtrlRead($TreeView1, 1)
	$lines = _FileCountLines ( @ScriptDir & "\distrolist.csv" )
	For $i = 1 To $lines Step 1
		$line = FileReadLine(@ScriptDir & "\distrolist.csv", $i)
		$arrLineSplit = StringSplit($line, ",", 2)
		$Name = $arrLineSplit[0]
		If $Name=$tmp Then
			$sFilePath = _WinAPI_GetTempFileName(@TempDir)
			$Url = $arrLineSplit[1]
			$iFileSize = round($arrLineSplit[2]/1024/2024,1)
			$Download = InetGet($Url, $sFilePath, $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND)
			AdlibRegister("CheckSize")
		EndIf
	Next
EndFunc
Func Form1_1Close()
	Exit
EndFunc
Func Form1_1Maximize()

EndFunc
Func Form1_1Minimize()

EndFunc
Func Form1_1Restore()

EndFunc
Func Label1Click()

EndFunc
Func Label2Click()

EndFunc
Func Label3Click()

EndFunc
Func Label4Click()

EndFunc
Func r10GbClick()

EndFunc
Func r4GbClick()

EndFunc
Func RemoveDistroClick()

EndFunc
Func ScanISOsClick()

EndFunc
Func TreeView1Click()

EndFunc
Func Update_distrolistClick()
	$aInfo = _WinNet_GetConnectionPerformance("Netwtw06", "Netwtw06")
	ConsoleWrite($aInfo[1] & @CRLF)
	If FileExists(@ScriptDir & "\distrolist1.csv") Then FileDelete(@ScriptDir & "\distrolist1.csv")
	InetGet("https://raw.githubusercontent.com/DimBertolami/Distroboot/refs/heads/main/distrolist.csv", @ScriptDir & "\distrolist.csv")
	$lines = _FileCountLines ( @ScriptDir & "\distrolist.csv" )
	For $i = 1 To $lines Step 1
		$line = FileReadLine(@ScriptDir & "\distrolist.csv", $i)
		$arrLineSplit = StringSplit($line, ",")
		If $arrLineSplit[0] <> 0 Then
			$Name = $arrLineSplit[1]
			GUICtrlCreateTreeViewItem($Name, $TreeView1)
			$Url = $arrLineSplit[2]
 			$Size = Round($arrLineSplit[3]/1024/1024, 1)
		EndIf
	Next
EndFunc
Func QemuRunClick()
EndFunc

