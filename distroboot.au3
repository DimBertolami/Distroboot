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
#include <Date.au3>
#include <WinNet.au3>
#include <Color.au3>
#include <ColorConstants.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <TreeViewConstants.au3>
#include <WindowsConstants.au3>
Global $AddDistro, $RemoveDistro, $r4Gb, $r10Gb, $Update_distrolist, $QemuRun, $gRamdiskSize
Global $Progress1, $Label1, $Label2, $Url, $Start, $Name, $iFileSize, $iBytesSize, $fDiff, $Download, $sFilePath  = "", $sSize = 0, $counter = 0

Opt("GUIOnEventMode", 1)
If not IsAdmin() Then
	MsgBox(790592,"access denied","Admin rights required." & @CRLF & "This popup will self destruct",5)
	Exit
EndIf

#Region ### START Koda GUI section ### Form=c:\scripts\autoit\distroboot.kxf
Global $Form1_1 = GUICreate("", 490, 323, 192, 124)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1_1Close")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "Form1_1Minimize")
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "Form1_1Maximize")
GUISetOnEvent($GUI_EVENT_RESTORE, "Form1_1Restore")
$AddDistro = GUICtrlCreateButton("&Add ISO Image", 0, 8, 83, 89)
GUICtrlSetOnEvent($AddDistro, "AddDistroClick")
$RemoveDistro = GUICtrlCreateButton("&Remove ISO Image", 88, 8, 107, 89)
GUICtrlSetOnEvent($RemoveDistro, "RemoveDistroClick")
$ScanISOs = GUICtrlCreateButton("&Scan ISO folder", 200, 8, 91, 89)
GUICtrlSetOnEvent($ScanISOs, "ScanISOsClick")
$gRamdiskSize = GUICtrlCreateGroup("Ramdisk Size", 296, 3, 89, 89)
$r4Gb = GUICtrlCreateRadio("4Gb", 304, 19, 49, 17)
$r10Gb = GUICtrlCreateRadio("10Gb", 304, 35, 49, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Download = GUICtrlCreateButton("&Download", 392, 8, 91, 25)
GUICtrlSetTip($Download, "download selected distro")
GUICtrlSetOnEvent($Download, "DownloadClick")
$TreeView1 = GUICtrlCreateTreeView(2, 99, 487, 225, _
						BitOR($GUI_SS_DEFAULT_TREEVIEW,$TVS_TRACKSELECT,$TVS_INFOTIP, _
						$WS_VSCROLL,$WS_BORDER), BitOR($WS_EX_CLIENTEDGE,$WS_EX_STATICEDGE))
GUICtrlSetBkColor($TreeView1, $COLOR_LIGHTSKYBLUE)
GUICtrlSetFont($TreeView1, 10, $FW_HEAVY)
$Update_distrolist = GUICtrlCreateButton("&Update distrolist", 392, 72, 91, 25)
GUICtrlSetOnEvent($Update_distrolist, "Update_distrolist")
$QemuRun = GUICtrlCreateButton("run in &Qemu VM", 392, 32, 91, 41)
GUICtrlSetOnEvent($QemuRun, "QemuRunClick")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###


Update_distrolist()
While 1
	Sleep(100)
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

Func GetISOFolder()
	If not FileExists(@ScriptDir & "\config.ini") Then
		IniWrite(@ScriptDir & "\config.ini", "", "ISO","e:\ISO\")
	EndIf
;	ConsoleWrite(IniRead(@ScriptDir & "\config.ini", "", "ISO", "e:\ISO\") & "!" & @CRLF)
	Return StringStripWS(IniRead(@ScriptDir & "\config.ini", "", "ISO", "e:\ISO\"),$STR_STRIPLEADING + $STR_STRIPTRAILING)
EndFunc

Func ScanISOsClick()
	$fISO = GetISOFolder()
	DeleteAllTVItems()

	local $hSearch = FileFindFirstFile($fISO & "*.iso")
	While 1
        $sFileName = FileFindNextFile($hSearch)
		If @error Then ExitLoop
;		 ConsoleWriter("!" & $sFileName & "!")
	WEnd
	local $hSearch2 = FileFindFirstFile($fISO & "*.img")
	While 1
        $sFileName = FileFindNextFile($hSearch2)
		If @error Then ExitLoop
;		ConsoleWriter("!" & $sFileName & "!")
	WEnd
	Local $hSearch3 = FileFindFirstFile($fISO & "*.zip")
	while 1
		$sFileName = FileFindNextFile($hSearch3)
		If @error Then ExitLoop
;		ConsoleWriter("!" & $sFileName & "!")
	WEnd
;	ConsoleWrite(@CRLF)
EndFunc

Func DownloadClick()
	$fISO = GetISOFolder()
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
;			ConsoleWriter("downloading " & $Name)
			ProgressOn(" Downloading " & $Name & ".iso", "0%", "", -1, -1, BitOR($DLG_NOTONTOP, $DLG_MOVEABLE))
			Do
				$i = round(InetGetInfo($Download, $INET_DOWNLOADREAD)/1024/2024) / round($arrLineSplit[2]/1024/2024) * 100
				$i = Round($i)
				ProgressSet($i, "Progress (" & round(InetGetInfo($Download, $INET_DOWNLOADREAD)/1024/2024)*2 & " / " & $sSize & "MB)", $i & "%")
;				ConsoleWriter("Downloaded (" & round(InetGetInfo($Download, $INET_DOWNLOADREAD)/1024/2024)*2 & " / " & $sSize & "MB)")
				Sleep(200)
			Until InetGetInfo($Download, $INET_DOWNLOADCOMPLETE)
			InetClose($Download)
			FileMove($sFilePath, $fISO & $Name & ".iso", $FC_OVERWRITE + $FC_CREATEPATH)
			ProgressSet(100, "Done", "Complete")
			Sleep(2000)
			ProgressOff()
;			ConsoleWriter("Done")
		EndIf
	Next
EndFunc

Func Form1_1Close()
	Exit
EndFunc

Func Update_distrolist()
	GUICtrlSetState($r4Gb, $GUI_CHECKED)
	GUISetBkColor($COLOR_LIGHTSTEELBLUE, $Form1_1)
	GUICtrlSetColor($TreeView1, $COLOR_PURPLE)
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
		GUICtrlCreateTreeViewItem($i & ") " & $Name, $TreeView1)
	Next
EndFunc

Func QemuRunClick()
	$fISO = GetISOFolder()
	Local $tselected = GUICtrlRead($TreeView1, 1)	; ($i) "
	$aSelected = StringSplit($tselected, ")")
	$tselected = StringStripWS($aSelected[2],  $STR_STRIPLEADING + $STR_STRIPTRAILING)
;	ConsoleWrite($fISO & $tselected & ".iso!" & @CRLF)
	If Not FileExists("C:\Progra~1\qemu\qemu-system-x86_64.exe") Then execCommand('powershell -command "winget install qemu"')
	if FileExists($fISO & $tselected & ".iso") <> 0 Then execCommand('cd \progra~1\qemu & "qemu-system-x86_64.exe" -cdrom "' & $fISO & $tselected & '.iso" -m 4G -full-screen')
	if FileExists($fISO & $tselected & ".img") <> 0 Then execCommand('cd \progra~1\qemu & "qemu-system-x86_64.exe" -m 4G -drive file="' & $fISO & $tselected & _
																							'.img",format=raw,index=0,media=disk -vga virtio -no-reboot -full-screen') ;  -full-screen
	If FileExists($fISO & $tselected & ".zip") <> 0 Then
		execCommand('PowerShell -Command "Expand-Archive -Path "' & $fISO & $tselected & '.zip" -DestinationPath ' & $fISO & ' -Force"')
		FileDelete($fISO & $tselected & ".zip")
	EndIf
EndFunc

Func execCommand($cmd)
	RunWait(@comspec & " /c " & $cmd, @ScriptDir, @SW_SHOW)
;	ConsoleWriter($cmd)
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
	LogLine("Distro list purged")
EndFunc ;==>DeleteAll

func LogLine($sLine)
	local $log = FileOpen(@ScriptDir & "\activity.log", $FO_APPEND)
	FileWriteLine($log, _Now() & ": " & $sLine)
	FileClose($log)
EndFunc

