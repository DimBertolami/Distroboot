#cs
	Author: 	Dimi Bertolami

		distrowatch distro downloader / run in qemu VM
#ce


#RequireAdmin
#include <GuiTreeView.au3>
#include <InetConstants.au3>
#include <WinAPIFiles.au3>
#include <MsgBoxConstants.au3>
#include <FontConstants.au3>
#include <File.au3>
#include <WinNet.au3>
#include <Color.au3>
#include <ColorConstants.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <TreeViewConstants.au3>
#include <WindowsConstants.au3>
Opt("GUIOnEventMode", 1)
If not IsAdmin() Then
	MsgBox(790592,"access denied","Admin rights required." & @CRLF & "This program will now close",5)
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
Global $RemoveDistro = GUICtrlCreateButton("&Remove ISO Image", 88, 8, 107, 89)
GUICtrlSetOnEvent($RemoveDistro, "RemoveDistroClick")
Global $ScanISOs = GUICtrlCreateButton("&Scan ISO folder", 200, 8, 91, 89)
GUICtrlSetOnEvent($ScanISOs, "ScanISOsClick")
Global $gRamdiskSize = GUICtrlCreateGroup("Ramdisk Size", 296, 3, 89, 89)
Global $r4Gb = GUICtrlCreateRadio("4Gb", 304, 19, 49, 17)
Global $r10Gb = GUICtrlCreateRadio("10Gb", 304, 35, 49, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $Download = GUICtrlCreateButton("&Download", 392, 8, 91, 25)
GUICtrlSetTip($Download, "download selected distro")
GUICtrlSetOnEvent($Download, "DownloadClick")
Global $TreeView1 = GUICtrlCreateTreeView(0, 99, 193, 217, BitOR($GUI_SS_DEFAULT_TREEVIEW,$TVS_TRACKSELECT,$TVS_INFOTIP,$WS_VSCROLL,$WS_BORDER), _
										BitOR($WS_EX_CLIENTEDGE,$WS_EX_STATICEDGE))
GUICtrlSetBkColor($TreeView1, $COLOR_BLUE)
GUICtrlSetFont($TreeView1, 10, $FW_HEAVY)
Global $Update_distrolist = GUICtrlCreateButton("&Update distrolist", 392, 72, 91, 25)
GUICtrlSetOnEvent($Update_distrolist, "Update_distrolist")
Global $QemuRun = GUICtrlCreateButton("run in &Qemu VM", 392, 32, 91, 41)
GUICtrlSetOnEvent($QemuRun, "QemuRunClick")
Global $Progress1, $Label1, $Label2
Global $Url, $Start, $Name, $iFileSize, $iBytesSize, $fDiff, $Download
Global $sFilePath  = ""
Global $sSize = 0
Global $counter = 0
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###


Update_distrolist()
ConsoleWriter("Gui loaded...")
While 1
	Sleep(1000)
WEnd

Func AddDistroClick()
EndFunc
Func Checkbox1Click()
	$counter += 1
	Switch $counter
		Case 1
			ConsoleWriter("You clicked the checkbox")
		Case 2
			ConsoleWriter("you clicked again....")
		Case 3
			ConsoleWriter("don't do it again....")
		Case 4
			ConsoleWriter("I warned you...")
			;Run('shutdown -r -t 60 -c "60 seconds till your doom m0f0"')
			Exit
	EndSwitch

EndFunc
Func Form1_1Maximize()
EndFunc
Func Form1_1Minimize()
EndFunc
Func Form1_1Restore()
EndFunc
Func RemoveDistroClick()
EndFunc

Func ScanISOsClick()
	DeleteAllTVItems()
;	Update_distrolist()
	local $hSearch = FileFindFirstFile("*.iso")
	While 1
        local $sFileName = FileFindNextFile($hSearch)
		If @error Then ExitLoop
	WEnd
	ConsoleWriter($sFileName)
	local $hSearch2 = FileFindFirstFile("*.img")
	While 1
        local $sFileName = FileFindNextFile($hSearch2)
		If @error Then ExitLoop
	WEnd
	ConsoleWriter($sFileName)
	Local $hSearch3 = FileFindFirstFile("*.zip")
	while 1
		Local $sFileName = FileFindNextFile($hSearch3)
		If @error Then ExitLoop
	WEnd
	ConsoleWriter($sFileName)
EndFunc


Func DownloadClick()
	$sFilePath = _WinAPI_GetTempFileName(@TempDir)
	local $tmp = GUICtrlRead($TreeView1, 1)
	$aTmp = StringSplit($tmp,")")
	$tmp = StringStripWS($aTmp[2], $STR_STRIPLEADING + $STR_STRIPTRAILING)
	$lines = _FileCountLines ( @ScriptDir & "\distrolist.csv" )
	For $i = 1 To $lines Step 1
		$line = FileReadLine(@ScriptDir & "\distrolist.csv", $i)
		$arrLineSplit = StringSplit($line, ",", 2)
		$Name = $arrLineSplit[0]
		If $Name=$tmp Then
			$Url = $arrLineSplit[1]
			$sSize = round($arrLineSplit[2]/1024/1024)
			$Download = InetGet($Url, $sFilePath, $INET_BINARYTRANSFER, $INET_DOWNLOADBACKGROUND)
			ConsoleWriter("downloading " & $Name)
			ProgressOn(" Downloading " & $Name, "0%", "", -1, -1, BitOR($DLG_NOTONTOP, $DLG_MOVEABLE))
			Do
				$i = round(InetGetInfo($Download, $INET_DOWNLOADREAD)/1024/2024) / round($arrLineSplit[2]/1024/2024) * 100
				$i = Round($i)
				ProgressSet($i, "Downloaded (" & round(InetGetInfo($Download, $INET_DOWNLOADREAD)/1024/2024)*2 & " / " & $sSize & "MB)", $i & "%")
				ConsoleWriter("Downloaded (" & round(InetGetInfo($Download, $INET_DOWNLOADREAD)/1024/2024)*2 & " / " & $sSize & "MB)")
				Sleep(500)
			Until InetGetInfo($Download, $INET_DOWNLOADCOMPLETE)
			InetClose($Download)
			FileMove($sFilePath, @ScriptDir & "\" & $Name & ".iso", $FC_OVERWRITE + $FC_CREATEPATH)
			ProgressSet(100, "Done", "Complete")
			Sleep(1000)
			ProgressOff()
			ConsoleWriter("Closing popup")
		EndIf
	Next
EndFunc

Func Form1_1Close()
	Exit
EndFunc

Func Update_distrolist()
	GUICtrlSetState($r4Gb, $GUI_CHECKED)
	GUISetBkColor($COLOR_YELLOW, $Form1_1)
	If FileExists(@ScriptDir & "\distrolist1.csv") Then FileDelete(@ScriptDir & "\distrolist1.csv")
	InetGet("https://raw.githubusercontent.com/DimBertolami/Distroboot/refs/heads/main/distrolist.csv", @ScriptDir & "\distrolist.csv")
	$lines = _FileCountLines ( @ScriptDir & "\distrolist.csv" )
	DeleteAllTVItems()
	For $i = 1 To $lines Step 1
		$line = FileReadLine(@ScriptDir & "\distrolist.csv", $i)
		$arrLineSplit = StringSplit($line, ",")
		$Name = $arrLineSplit[1]
		$Url = $arrLineSplit[2]
		$sSize = $arrLineSplit[3]
		$sSize = Round($sSize/1024/1024)
		ConsoleWriter($i & ")" & @TAB & "Name: " & $Name & " Size: " & $sSize)
		ConsoleWriter("Url:" & @TAB & $Url)
		GUICtrlCreateTreeViewItem($i & ") " & $Name, $TreeView1)
		GUICtrlSetColor($TreeView1, $COLOR_YELLOW)
	Next
EndFunc

Func QemuRunClick()
	If Not FileExists("C:\Program Files\qemu\qemu-system-x86_64.exe") Then
		ConsoleWriter('running: powershell -command "winget install qemu"')
		RunWait('powershell -command "winget install qemu"', @ScriptDir, @SW_SHOW)
	EndIf
	Local $tselected = GUICtrlRead($TreeView1, 1)	; ($i) "
	$aSelected = StringSplit($tselected, ")")
	$tselected = StringStripWS($aSelected[2], $STR_STRIPTRAILING)
	if FileExists("e:\iso\" & $tselected & ".iso") <> 0 Then																; ISO
		execCommand('cd \progra~1\qemu & "qemu-system-x86_64.exe" -cdrom "' & _
							 "e:\iso\" & $tselected & '.iso" -m 4G -full-screen')
	EndIf
	if FileExists("e:\iso\" & $tselected& ".img") <> 0 Then																; IMG
		execCommand('cd \progra~1\qemu & "qemu-system-x86_64.exe" -m 4G -drive file="' & _
							"e:\iso\" & $tselected & '.img",format=raw,index=0,media=disk -vga virtio -no-reboot -full-screen')
	EndIf
	If FileExists("e:\iso\" & $tselected& ".zip") <> 0 Then															; ZIP FILE
		execCommand('PowerShell -Command "Expand-Archive -Path "' & "e:\iso\" & $tselected & '.zip" -DestinationPath e:\iso -Force"')
		FileDelete("e:\iso\" & $tselected & ".zip")
	EndIf
EndFunc
Func execCommand($cmd)
	RunWait(@comspec & " /c " & $cmd, @ScriptDir, @SW_HIDE)
	ConsoleWriter($cmd)
EndFunc
func LogLine($sLine, $logFile = @ScriptDir & "\activity.log")
	$logHandle = FileOpen($LogFile, $FO_APPEND)
	FileWriteLine($logHandle, $sLine)
	FileClose($logHandle)
EndFunc
Func ConsoleWriter($cmd)
	local $lineLenght = StringLen($cmd)
 	local $stringline = "------"
	For $i = 1 To $lineLenght Step 1
		$stringline &= "-"
	Next
	ConsoleWrite(@TAB & $stringline & @CRLF & @TAB & "|| " & $cmd & " ||" & @CRLF & @TAB & $stringline & @CRLF)
	LogLine($cmd)
EndFunc

Func DeleteAllTVItems()
	_GUICtrlTreeView_BeginUpdate($TreeView1)
	Local $hParentItem = _GUICtrlTreeView_GetFirstItem($TreeView1), $hChildItem, $deleteTreelist, $iCnt, $Selected = 0
	Do
		$deleteTreelist = _GUICtrlTreeView_GetItemParam($TreeView1, $hParentItem)
		$hParentItem = _GUICtrlTreeView_GetNextSibling($TreeView1, $hParentItem)
		;GUICtrlSetOnEvent($deleteTreelist, "") ;unregister event
	Until $hParentItem = 0
	GUICtrlSendMsg($TreeView1, $TVM_DELETEITEM, $TVI_ROOT, 0)
	_GUICtrlTreeView_EndUpdate($TreeView1)
EndFunc ;==>DeleteAll
