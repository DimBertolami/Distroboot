#include <InetConstants.au3>
#include <WinAPIFiles.au3>
#include <MsgBoxConstants.au3>
#include <File.au3>
#include <WinNet.au3>
#include <ColorConstants.au3>


#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <TreeViewConstants.au3>
#include <WindowsConstants.au3>
Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=c:\scripts\autoit\distroboot.kxf
$Form1_1 = GUICreate("", 490, 323, 192, 124)
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
;GUICtrlSetOnEvent(-1, "r4GbClick")
$r10Gb = GUICtrlCreateRadio("10Gb", 304, 35, 49, 17)
;GUICtrlSetOnEvent(-1, "r10GbClick")
$Checkbox1 = GUICtrlCreateCheckbox("Terminal", 304, 67, 97, 17)
;GUICtrlSetOnEvent(-1, "Checkbox1Click")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Download = GUICtrlCreateButton("&Download", 392, 8, 91, 25)
GUICtrlSetTip(-1, "download selected distro")
GUICtrlSetOnEvent(-1, "DownloadClick")
$TreeView1 = GUICtrlCreateTreeView(0, 99, 113, 217, BitOR($GUI_SS_DEFAULT_TREEVIEW,$TVS_CHECKBOXES,$TVS_TRACKSELECT,$TVS_INFOTIP,$WS_VSCROLL,$WS_BORDER), BitOR($WS_EX_CLIENTEDGE,$WS_EX_STATICEDGE))
GUICtrlSetTip(-1, "Distrolist")
;GUICtrlSetOnEvent(-1, "TreeView1Click")
$Update_distrolist = GUICtrlCreateButton("&Update distrolist", 392, 72, 91, 25)
GUICtrlSetOnEvent(-1, "Update_distrolistClick")
$QemuRun = GUICtrlCreateButton("run in &Qemu VM", 392, 32, 91, 41)
GUICtrlSetOnEvent(-1, "QemuRunClick")
$Progress1 = GUICtrlCreateProgress(136, 110, 150, 12)
;GUICtrlSetState(-1, $GUI_HIDE)
$Progress2 = GUICtrlCreateProgress(136, 125, 150, 12)
;GUICtrlSetState(-1, $GUI_HIDE)
$Progress3 = GUICtrlCreateProgress(136, 141, 150, 12)
;GUICtrlSetState(-1, $GUI_HIDE)
$Progress4 = GUICtrlCreateProgress(136, 156, 158, 12)
;GUICtrlSetState(-1, $GUI_HIDE)
$Group1 = GUICtrlCreateGroup("", 118, 93, 361, 225)
$Label1 = GUICtrlCreateLabel(".", 358, 109, 80, 12)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlSetBkColor(-1, 0x0000FF)
;GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlSetTip(-1, "Mb's downloaded")
;GUICtrlSetOnEvent(-1, "Label1Click")
$Label2 = GUICtrlCreateLabel(".", 286, 109, 64, 12)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlSetBkColor(-1, 0x0000FF)
;GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlSetTip(-1, "Percentage downloaded")
;GUICtrlSetOnEvent(-1, "Label2Click")
$Label3 = GUICtrlCreateLabel(".", 358, 122, 80, 12)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlSetBkColor(-1, 0x0000FF)
;GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlSetTip(-1, "Mb's downloaded")
;GUICtrlSetOnEvent(-1, "Label3Click")
$Label4 = GUICtrlCreateLabel(".", 286, 122, 64, 12)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlSetBkColor(-1, 0x0000FF)
;GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlSetTip(-1, "Percentage downloaded")
;GUICtrlSetOnEvent(-1, "Label4Click")
$Label5 = GUICtrlCreateLabel(".", 286, 135, 64, 12)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlSetBkColor(-1, 0x0000FF)
;GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlSetTip(-1, "Percentage downloaded")
;GUICtrlSetOnEvent(-1, "Label5Click")
$Label6 = GUICtrlCreateLabel(".", 358, 135, 80, 12)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlSetBkColor(-1, 0x0000FF)
;GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlSetTip(-1, "Mb's downloaded")
;GUICtrlSetOnEvent(-1, "Label6Click")
$Label7 = GUICtrlCreateLabel(".", 286, 148, 64, 12)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlSetBkColor(-1, 0x0000FF)
;GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlSetTip(-1, "Percentage downloaded")
;GUICtrlSetOnEvent(-1, "Label7Click")
$Label8 = GUICtrlCreateLabel(".", 358, 148, 80, 12)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlSetBkColor(-1, 0x0000FF)
;GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlSetTip(-1, "Mb's downloaded")
;GUICtrlSetOnEvent(-1, "Label8Click")
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUIStartGroup()
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
Global $bIsRunning = False
Global $Url, $Start, $Name, $iFileSize, $iBytesSize, $fDiff, $Download
$sFilePath = _WinAPI_GetTempFileName(@TempDir)
Update_distrolistClick()
Global $sSize
While 1
;	Local $sMsg = 0
;	$sMsg = GUIGetMsg()
	Sleep(1000)
;	Select
;		Case $sMsg = $GUI_EVENT_CLOSE
;			ExitLoop
#cs
		Case $sMsg = $Download
			;			$bIsRunning = True
			DownloadClick()
			$sSize = round($iBytesSize / $iFileSize * 100)
			Do
				$iBytesSize = round(InetGetInfo($Download, $INET_DOWNLOADREAD)/1024/2024,1)
				ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $iBytesSize = ' & $iBytesSize & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
				If $iBytesSize+7 < $iFileSize Then
					$fDiff = round(TimerDiff($Start)/1000)
					GUICtrlSetData($Progress1, round($sSize)+7)
					GUICtrlSetData($Label1, $iBytesSize & "Mb")
					GUICtrlSetData($Label2, $sSize & "% in " & $fDiff & " seconds")
				EndIf
				Switch $sSize
					Case 0 To 14
						GUICtrlSetBkColor($Form1_1, $COLOR_RED)
					Case 15 To 29
						GUICtrlSetBkColor($Form1_1, $COLOR_ORANGE)
					Case 30 To 44
						GUICtrlSetBkColor($Form1_1, $COLOR_YELLOW)
					Case 45 To 59
						GUICtrlSetBkColor($Form1_1, $COLOR_GREEN)
					Case 60 To 74
						GUICtrlSetBkColor($Form1_1, $COLOR_BLUE)
					Case 75 To 89
						GUICtrlSetBkColor($Form1_1, $COLOR_INDIGO)
					Case 90 To 100
						GUICtrlSetBkColor($Form1_1, $COLOR_VIOLET)
				EndSwitch
			Until InetGetInfo($Download, $INET_DOWNLOADCOMPLETE)
			#ce

;			If $sSize>=99 Then
;				FileMove($sFilePath, @ScriptDir & "\" & $Name & ".iso", $FC_OVERWRITE + $FC_CREATEPATH)
;			EndIf
;		EndSelect

;	GUICtrlSetState($Progress1, $GUI_SHOW)
;	GUICtrlSetState($Label4, $GUI_SHOW)
;	GUICtrlSetState($Label2, $GUI_SHOW)
;	GUICtrlSetState($Progress2, $GUI_SHOW)
;	GUICtrlSetState($Label3, $GUI_SHOW)
;	GUICtrlSetState($Label4, $GUI_SHOW)
;	GUICtrlSetState($Progress3, $GUI_SHOW)
;	GUICtrlSetState($Label5, $GUI_SHOW)
;	GUICtrlSetState($Label6, $GUI_SHOW)
;	GUICtrlSetState($Progress4, $GUI_SHOW)
;	GUICtrlSetState($Label7, $GUI_SHOW)
;	GUICtrlSetState($Label8, $GUI_SHOW)
;	Select
;		Case $bIsRunning
;		Case Else
;	EndSelect
WEnd

Func AddDistroClick()

EndFunc
Func Checkbox1Click()

EndFunc
Func CheckSize($i, $Name, $sFilePath, $Url, $iFileSize, $Download)
	$bIsRunning = True
	if not InetGetInfo($Download, $INET_DOWNLOADCOMPLETE) Then
		$iBytesSize = round(InetGetInfo($Download, $INET_DOWNLOADREAD)/1024/2024,1)
		$sSize = round($iBytesSize / $iFileSize * 100)
		If $iBytesSize+7 < $iFileSize Then
			$fDiff = round(TimerDiff($Start)/1000)
			GUICtrlSetData($Progress1, round($sSize)+7)
			GUICtrlSetData($Label1, $iBytesSize & "Mb")
			GUICtrlSetData($Label2, $sSize & "%")
		EndIf
		If $sSize>=99 Then
			FileMove($sFilePath, @ScriptDir & "\" & $Name & ".iso", $FC_OVERWRITE + $FC_CREATEPATH)
		EndIf
	EndIf

$bIsRunning = False
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
			CheckSize($i, $Name, $sFilePath, $Url, $iFileSize, $Download)
		EndIf
		InetClose($Download)
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
#cs
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
#ce
Func RemoveDistroClick()

EndFunc
Func ScanISOsClick()

EndFunc
Func TreeView1Click()

EndFunc
Func Update_distrolistClick()
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

