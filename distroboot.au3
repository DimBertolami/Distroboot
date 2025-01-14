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
Global $PctDl = 0
Global $AddDistro, $RemoveDistro, $r4Gb, $r10Gb, $Update_distrolist, $QemuRun, $gRamdiskSize
Global $Progress1, $Label1, $Label2, $Url, $Start, $Name, $iFileSize, $iBytesSize, $fDiff, $Download, $sFilePath = "", $sSize = 0, $counter = 0
Global $arrColors = [$COLOR_ALICEBLUE, $COLOR_ANTIQUEWHITE, $COLOR_AQUA, $COLOR_AQUAMARINE, $COLOR_AZURE, $COLOR_BEIGE, $COLOR_BISQUE, $COLOR_BLACK, $COLOR_BLANCHEDALMOND, $COLOR_BLUE, $COLOR_BLUEVIOLET, $COLOR_BROWN, $COLOR_BURLYWOOD, $COLOR_CADETBLUE, $COLOR_CHARTREUSE, $COLOR_CHOCOLATE, $COLOR_CORAL, $COLOR_CORNFLOWERBLUE, $COLOR_CORNSILK, $COLOR_CRIMSON, $COLOR_CYAN, $COLOR_DARKBLUE, $COLOR_DARKCYAN, $COLOR_DARKGOLDENROD, $COLOR_DARKGRAY, $COLOR_DARKGREEN, $COLOR_DARKKHAKI, $COLOR_DARKMAGENTA, $COLOR_DARKOLIVEGREEN, $COLOR_DARKORANGE, $COLOR_DARKORCHID, $COLOR_DARKRED, $COLOR_DARKSALMON, $COLOR_DARKSEAGREEN, $COLOR_DARKSLATEBLUE, $COLOR_DARKSLATEGRAY, $COLOR_DARKTURQUOISE, $COLOR_DARKVIOLET, $COLOR_DEEPPINK, $COLOR_DEEPSKYBLUE, $COLOR_DIMGRAY, $COLOR_DODGERBLUE, $COLOR_FIREBRICK, $COLOR_FLORALWHITE, $COLOR_FORESTGREEN, $COLOR_FUCHSIA, $COLOR_GAINSBORO, $COLOR_GHOSTWHITE, $COLOR_GOLD, $COLOR_GOLDENROD, $COLOR_GRAY, $COLOR_GREEN, $COLOR_GREENYELLOW, $COLOR_HONEYDEW, $COLOR_HOTPINK, $COLOR_INDIANRED, $COLOR_INDIGO, $COLOR_IVORY, $COLOR_KHAKI, $COLOR_LAVENDER, $COLOR_LAVENDERBLUSH, $COLOR_LAWNGREEN]
Opt("GUIOnEventMode", 1)
Opt("TrayIconHide", 1)

If Not IsAdmin() Then
	MsgBox(790592, "access denied", "Admin rights required." & @CRLF & "This popup will self destruct", 5)
	Exit
EndIf
ConsoleWriter("Launching distroboot")

Global $Form1_1 = GUICreate("Distr0 Select0r", 490, 323, 192, 124)

GUISetOnEvent($GUI_EVENT_CLOSE, "Form1_1Close")
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
		BitOR($GUI_SS_DEFAULT_TREEVIEW, $TVS_TRACKSELECT, $TVS_INFOTIP, _
		$WS_VSCROLL, $WS_BORDER), BitOR($WS_EX_CLIENTEDGE, $WS_EX_STATICEDGE, $WS_EX_TRANSPARENT))
GUICtrlSetBkColor($TreeView1, $COLOR_AQUA) ;_GUICtrlTreeView_SetBkColor($TreeView1, $COLOR_AQUA)
GUICtrlSetColor($TreeView1, $COLOR_DEEPPINK)
GUICtrlSetFont($TreeView1, 12, $FW_HEAVY)
$Update_distrolist = GUICtrlCreateButton("&Update distrolist", 392, 72, 91, 25)
GUICtrlSetOnEvent($Update_distrolist, "Update_distrolist")
$QemuRun = GUICtrlCreateButton("run in &Qemu VM", 392, 32, 91, 41)
GUICtrlSetOnEvent($QemuRun, "QemuRunClick")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###


ConsoleWriter("default components loaded")


Update_distrolist()

GUICtrlSetBkColor($QemuRun, $COLOR_LIGHTGOLDENRODYELLOW)
GUICtrlSetColor($QemuRun, $COLOR_BLUEVIOLET)
GUICtrlSetFont($QemuRun, 8, $FW_BOLD)
GUICtrlSetBkColor($Update_distrolist, $COLOR_LIGHTGOLDENRODYELLOW)
GUICtrlSetColor($Update_distrolist, $COLOR_BLUEVIOLET)
GUICtrlSetFont($Update_distrolist, 8, $FW_BOLD)
GUICtrlSetBkColor($Download, $COLOR_LIGHTGOLDENRODYELLOW)
GUICtrlSetColor($Download, $COLOR_BLUEVIOLET)
GUICtrlSetFont($Download, 8, $FW_BOLD)
GUICtrlSetBkColor($r10Gb, $COLOR_LIGHTGOLDENRODYELLOW)
GUICtrlSetColor($r10Gb, $COLOR_BLUEVIOLET)
GUICtrlSetFont($r10Gb, 8, $FW_BOLD)
GUICtrlSetBkColor($r4Gb, $COLOR_LIGHTGOLDENRODYELLOW)
GUICtrlSetColor($r4Gb, $COLOR_BLUEVIOLET)
GUICtrlSetFont($r4Gb, 8, $FW_BOLD)
GUICtrlSetBkColor($ScanISOs, $COLOR_LIGHTGOLDENRODYELLOW)
GUICtrlSetColor($ScanISOs, $COLOR_BLUEVIOLET)
GUICtrlSetFont($ScanISOs, 8, $FW_BOLD)
GUICtrlSetBkColor($RemoveDistro, $COLOR_LIGHTGOLDENRODYELLOW)
GUICtrlSetColor($RemoveDistro, $COLOR_BLUEVIOLET)
GUICtrlSetFont($RemoveDistro, 8, $FW_BOLD)
GUICtrlSetBkColor($AddDistro, $COLOR_LIGHTGOLDENRODYELLOW)
GUICtrlSetColor($AddDistro, $COLOR_BLUEVIOLET)
GUICtrlSetFont($AddDistro, 8, $FW_BOLD)
ConsoleWriter("Making adjustments to the defaults")



; WM_NOTIFY message handler
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

While 1
	Sleep(100)
WEnd

Func AddDistroClick()
	;ConsoleWrite(@ScriptDir & @CRLF)
EndFunc   ;==>AddDistroClick

Func RemoveDistroClick()
EndFunc   ;==>RemoveDistroClick

Func showColor($nr = 1)
	If $nr = 0 Then
		For $i = 1 To $arrColors[0] Step 1
			ConsoleWrite("color: " & $arrColors[$nr] & @CRLF)
		Next
	Else
		ConsoleWrite("color: " & $arrColors[$nr] & @CRLF)
	EndIf
EndFunc   ;==>showColor


Func GetISOFolder()
	If Not FileExists(@ScriptDir & "\config.ini") Then
		IniWrite(@ScriptDir & "\config.ini", "", "ISO", "e:\ISO\")
	EndIf
	Return StringStripWS(IniRead(@ScriptDir & "\config.ini", "", "ISO", "e:\ISO\"), $STR_STRIPLEADING + $STR_STRIPTRAILING)
EndFunc   ;==>GetISOFolder
#cs
Func FindFiles($sSearchStr)
	Local 		 $aDistros
	$fISO = GetISOFolder()
	local $hSearch = FileFindFirstFile($fISO & "*" & $sSearchStr)
	$lines = _FileCountLines ( @ScriptDir & "\distrolist.csv" )
	While 1
        $sFileName = FileFindNextFile($hSearch)
		If @error Then ExitLoop
		ConsoleWriter(_Now & ": iso image found " & $sFileName & $sSearchStr)
		For $i = 1 To $lines Step 1
			If not FileExists($fISO & $sFileName & $sSearchStr) Then
				GUICtrlCreateTreeViewItem($i & ") " & $sFileName, $TreeView1)
			Else
				ConsoleWrite($fISO & $sFileName & $sSearchStr & @CRLF)
				GUICtrlSetState(GUICtrlCreateTreeViewItem($i & ") " & $sFileName, $TreeView1), $GUI_DEFBUTTON)
				;_GUICtrlTreeView_SetBold($TreeView1, -1)
			EndIf
		Next
	WEnd
EndFunc
#ce
Func ScanISOsClick()
	;	$fISO = GetISOFolder()
	DeleteAllTVItems()
	Update_distrolist()
EndFunc   ;==>ScanISOsClick

Func DownloadClick()
	HotKeySet("{ESC}", "AbortDownload")
	;	Local $ii = 0
	$fISO = GetISOFolder()
	Local $sFilePath = _WinAPI_GetTempFileName(@TempDir)
	$linesLst = _FileCountLines(@ScriptDir & "\distrolist.csv")
	$linesTV = _GUICtrlTreeView_GetCount($TreeView1)
	Local $tselected = GUICtrlRead($TreeView1, 1)
	;	For $i = 1 To $linesTV Step 1
	If $tselected <> 0 Then
		$aSelected = StringSplit($tselected, ")")
		$Name = StringStripWS($aSelected[2], $STR_STRIPLEADING + $STR_STRIPTRAILING)
		For $j = 1 To $linesLst Step 1
			$line = FileReadLine(@ScriptDir & "\distrolist.csv", $j)
			$arrLineSplit = StringSplit($line, ",", 2)
			$lstName = $arrLineSplit[0] & ".iso"
			If $Name == $lstName Then
				$Url = $arrLineSplit[1]
				$sSize = Round($arrLineSplit[2] / 1024 / 1024)
			EndIf
		Next
	EndIf

	$Download = InetGet($Url, $sFilePath, $INET_BINARYTRANSFER, $INET_DOWNLOADBACKGROUND)
	ConsoleWriter("downloading " & $Name)
	ProgressOn("Downloading " & $Name & ".iso", "0%", "", -1, -1, BitOR($DLG_NOTONTOP, $DLG_MOVEABLE))
	Do
		$PctDl = (Round(InetGetInfo($Download, $INET_DOWNLOADREAD) / 1024 / 1024) / $sSize) * 100
		$PctDl = Round($PctDl)
		$currentdownloadsize = Round(InetGetInfo($Download, $INET_DOWNLOADREAD) / 1024 / 1024)
		ProgressSet($PctDl, "(" & $currentdownloadsize & " / " & $sSize & ")Mb", $PctDl & "%")
		ConsoleWriter("Downloaded (  " & $currentdownloadsize & "Mb / " & $sSize & "Mb  )")
		Sleep(100)
	Until InetGetInfo($Download, $INET_DOWNLOADCOMPLETE)
	InetClose($Download)
	ProgressSet(100, "Done", "Complete")
	Sleep(2000)
	FileMove($sFilePath, $fISO & $Name & ".iso", $FC_OVERWRITE + $FC_CREATEPATH)
	ProgressOff()

	ConsoleWriter("Done")
	;	Next
	;	AbortDownload($PctDl)
EndFunc   ;==>DownloadClick

Func AbortDownload($PctDl = 0)
	InetClose($Download)
	ConsoleWriter(_Now & ": download aborted at " & $PctDl & "%")
	Exit
EndFunc   ;==>AbortDownload

Func Form1_1Close()
	ConsoleWriter("thank you for using this application")
	Exit
EndFunc   ;==>Form1_1Close

Func Update_distrolist()
	$fISO = GetISOFolder()
	GUICtrlSetState($r4Gb, $GUI_CHECKED)
	GUISetBkColor($COLOR_LIGHTSTEELBLUE, $Form1_1)
	GUICtrlSetColor($TreeView1, $COLOR_PURPLE)
	If Not FileExists(@ScriptDir & "\distrolist1.csv") Then
		InetGet("https://raw.githubusercontent.com/DimBertolami/Distroboot/refs/heads/main/distrolist.csv", @ScriptDir & "\distrolist.csv")
	Else
		$linesLst = _FileCountLines(@ScriptDir & "\distrolist.csv")
	EndIf
	_GUICtrlTreeView_BeginUpdate($TreeView1)
	_GUICtrlTreeView_SetTextColor($TreeView1, $COLOR_HOTPINK)
	_GUICtrlTreeView_SetLineColor($TreeView1, $COLOR_GREENYELLOW) ;$arrColors[$ColNr]
	DeleteAllTVItems()
	ListFiles_ToTreeView($fISO, 0)
	_GUICtrlTreeView_EndUpdate($TreeView1)
EndFunc   ;==>Update_distrolist

Func QemuRunClick()
	$fISO = GetISOFolder()
	If Not FileExists("C:\Progra~1\qemu\qemu-system-x86_64.exe") Then execCommand('powershell -command "winget install qemu"')
	$qemu = "C:\Progra~1\qemu\qemu-system-x86_64.exe"
	Local $tselected = GUICtrlRead($TreeView1, 1)
	If $tselected = 0 Then
		ConsoleWriter("nothing selected")
	Else
		$aSelected = StringSplit($tselected, ")")
		$tselected = StringStripWS($aSelected[2], $STR_STRIPLEADING + $STR_STRIPTRAILING)
		Select
			Case StringInStr($tselected, ".iso") <> 0
				execCommand('"' & $qemu & '"' & ' -cdrom "' & $fISO & $tselected & '" -m 4G -full-screen')
			Case StringInStr($tselected, ".img") <> 0
				execCommand('"' & $qemu & '"' & ' -m 4G -drive file="' & $fISO & $tselected & '",format=raw,index=0,media=disk -vga virtio -no-reboot -full-screen')
			Case StringInStr($tselected, ".zip") <> 0
				execCommand('PowerShell -Command "Expand-Archive -Path "' & $fISO & $tselected & '.zip" -DestinationPath ' & $fISO & ' -Force"')
				FileDelete($fISO & $tselected & ".zip")
		EndSelect
	EndIf
EndFunc   ;==>QemuRunClick

Func getMemStats($iPid)
	Local $aMemory = ProcessGetStats($iPid, 0)
	If IsArray($aMemory) Then
		Local $output = @TAB & @TAB & @TAB & "WorkingSetSize	  : " & $aMemory[0] & @CRLF & _
				@TAB & @TAB & @TAB & "PeakWorkingSetSize: " & $aMemory[1]
		Return $output
	EndIf
EndFunc   ;==>getMemStats

Func getIOStats($iPid)
	Local $aIO = ProcessGetStats($iPid, 1)
	If IsArray($aIO) Then
		Local $output = @TAB & @TAB & @TAB & $aIO[0] & @TAB & ":r(x)" & @CRLF & _
				@TAB & @TAB & @TAB & $aIO[1] & @TAB & ":t(x)" & @CRLF & _
				@TAB & @TAB & @TAB & $aIO[2] & @TAB & ":I/O (-) r/w" & @CRLF & _
				@TAB & @TAB & @TAB & $aIO[3] & @TAB & ":bytes r(x)" & @CRLF & _
				@TAB & @TAB & @TAB & $aIO[4] & @TAB & ":bytes t(x)" & @CRLF & _
				@TAB & @TAB & @TAB & $aIO[5] & @TAB & ":bytes t(x)" & @CRLF
		Return $output
	EndIf
EndFunc   ;==>getIOStats

Func execCommand($cmd)
	$fISO = GetISOFolder()
	ConsoleWriter($cmd)
	RunWait(@ComSpec & ' /k color 9e & ' & $cmd, $fISO, @SW_HIDE)
EndFunc   ;==>execCommand

Func ConsoleWriter($cmd)
	Local $lineLenght = StringLen($cmd)
	Local $stringline = "------"
	For $i = 1 To $lineLenght Step 1
		$stringline &= "-"
	Next
	ConsoleWrite(">" & @CRLF)
	ConsoleWrite("-" & @TAB & @TAB & "Written by Dim Bertolami" & @CRLF)
	ConsoleWrite(">" & _Now() & @CRLF)
	ConsoleWrite("!" & @CRLF)
	ConsoleWrite("!   " & $stringline & @CRLF)
	ConsoleWrite("!   || " & $cmd & " ||" & @CRLF)
	ConsoleWrite("!   " & $stringline & @CRLF)
	ConsoleWrite("+" & "Autoit ftw" & @CRLF)
	LogLine($cmd)
EndFunc   ;==>ConsoleWriter

Func DeleteAllTVItems()
	_GUICtrlTreeView_BeginUpdate($TreeView1)
	Local $hParentItem = _GUICtrlTreeView_GetFirstItem($TreeView1), $hChildItem, $deleteTreelist, $iCnt, $Selected = 0
	Do
		$deleteTreelist = _GUICtrlTreeView_GetItemParam($TreeView1, $hParentItem)
		$hParentItem = _GUICtrlTreeView_GetNextSibling($TreeView1, $hParentItem)
	Until $hParentItem = 0
	GUICtrlSendMsg($TreeView1, $TVM_DELETEITEM, $TVI_ROOT, 0)
	_GUICtrlTreeView_EndUpdate($TreeView1)
	ConsoleWriter("Rebuilding Distro list..")
EndFunc   ;==>DeleteAllTVItems

Func LogLine($sLine)
	If $sLine <> "" Then
		Local $log = FileOpen(@ScriptDir & "\activity.log", $FO_APPEND)
		FileWriteLine($log, _Now() & ": " & $sLine)
		FileClose($log)
	EndIf
EndFunc   ;==>LogLine

Func WM_NOTIFY($hWnd, $iMsg, $wParam, $lParam)
	Local $tNMHDR = DllStructCreate($tagNMHDR, $lParam)
	Local $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	Local $iCode = DllStructGetData($tNMHDR, "Code")

	Switch $hWndFrom
		Case $TreeView1
			Switch $iCode
				Case $NM_CUSTOMDRAW
					Local $tNMTVCUSTOMDRAW = DllStructCreate($tagNMTVCUSTOMDRAW, $lParam)
					Local $dwDrawStage = DllStructGetData($tNMTVCUSTOMDRAW, "DrawStage")
					Switch $dwDrawStage                            ; Specifies the drawing stage
						Case $CDDS_PREPAINT           ; Before the paint cycle begins
							Return $CDRF_NOTIFYITEMDRAW ; Item-related drawing operations
						Case $CDDS_ITEMPREPAINT              ; Before painting an item
							Local $iItemParam = DllStructGetData($tNMTVCUSTOMDRAW, "ItemParam")
							If $iItemParam Then
								DllStructSetData($tNMTVCUSTOMDRAW, "ClrTextBk", 0xCCCCFF)      ; Red, BGR
							Else
								DllStructSetData($tNMTVCUSTOMDRAW, "ClrTextBk", 0xCCFFCC)      ; Green
							EndIf
							Return $CDRF_NEWFONT        ; Return $CDRF_NEWFONT after changing colors
					EndSwitch
			EndSwitch
	EndSwitch

	Return $GUI_RUNDEFMSG
	#forceref $hWnd, $iMsg, $wParam
EndFunc   ;==>WM_NOTIFY

Func ListFiles_ToTreeView($sSourceFolder, $hItem)
	Local $i = 1
	;	$fISO = GetISOFolder()
	If StringRight($sSourceFolder, 1) <> "\" Then $sSourceFolder &= "\"
	$linesLst = _FileCountLines(@ScriptDir & "\distrolist.csv")
	Local $hImage = _GUIImageList_Create(25, 25, 5, 5)
	_GUIImageList_AddIcon($hImage, "shell32.dll", 110)
	_GUIImageList_AddIcon($hImage, "shell32.dll", 131)
	_GUIImageList_AddIcon($hImage, "shell32.dll", 165)
	_GUIImageList_AddIcon($hImage, "shell32.dll", 168)
	_GUIImageList_AddIcon($hImage, "shell32.dll", 137)
	_GUIImageList_AddIcon($hImage, "shell32.dll", 146)
	_GUICtrlTreeView_SetNormalImageList($TreeView1, $hImage)
	_GUICtrlTreeView_BeginUpdate($TreeView1)
	Local $sFile, $hFile
	Local $oDict = ObjCreate("Scripting.Dictionary")
	Local $hSearch = FileFindFirstFile($sSourceFolder & "*.iso")
	If $hSearch = -1 Then Return
	For $x = 0 To $linesLst
		$sFile = FileFindNextFile($hSearch)
		If @error Then ExitLoop
		$oDict.Add ($x, $sFile)
		$iImage = 3
		$hItem = _GUICtrlTreeView_Add($TreeView1, $hItem, $i & ") " & $sFile, $iImage, $iImage)
		$i += 1
		If $oDict.Exists($sFile) Then
			While $hFile
				_GUICtrlTreeView_SetItemParam($TreeView1, $hFile, 1)       ; Red
				$hFile = _GUICtrlTreeView_GetParentHandle($TreeView1, $hFile)
			WEnd
			If $oDict($sFile) Then
				$hFile = $oDict($sFile)
				While $hFile
					_GUICtrlTreeView_SetItemParam($TreeView1, $hFile, 1)       ; Red
					$hFile = _GUICtrlTreeView_GetParentHandle($TreeView1, $hFile)
				WEnd
				$oDict($sFile) = 0       ; Set first file red only once
			EndIf
		Else
			$oDict($sFile) = $hFile
		EndIf
	Next
	FileClose($hSearch)
EndFunc   ;==>ListFiles_ToTreeView
