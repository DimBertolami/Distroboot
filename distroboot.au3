#include <InetConstants.au3>
#include <WinAPIFiles.au3>
#include <MsgBoxConstants.au3>
#include <File.au3>

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
$Download = GUICtrlCreateButton("&Download", 392, 8, 91, 41)
GUICtrlSetTip(-1, "download selected distro")
GUICtrlSetOnEvent(-1, "DownloadClick")
$Progress = GUICtrlCreateGroup("Result", 8, 328, 481, 97)
$Label1 = GUICtrlCreateLabel("Speed: ", 320, 344, 88, 33)
GUICtrlSetFont(-1, 18, 400, 0, "MS Sans Serif")
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetOnEvent(-1, "Label1Click")
$Label2 = GUICtrlCreateLabel(". Kbps", 400, 344, 78, 33)
GUICtrlSetFont(-1, 18, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlSetBkColor(-1, 0x0000FF)
GUICtrlSetOnEvent(-1, "Label2Click")
$Progress1 = GUICtrlCreateProgress(16, 344, 294, 65)
$Label3 = GUICtrlCreateLabel("Size:", 344, 376, 57, 33)
GUICtrlSetFont(-1, 18, 400, 0, "MS Sans Serif")
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetOnEvent(-1, "Label3Click")
$Label4 = GUICtrlCreateLabel("0Mb", 400, 376, 54, 33)
GUICtrlSetFont(-1, 18, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlSetBkColor(-1, 0x0000FF)
GUICtrlSetOnEvent(-1, "Label4Click")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$TreeView1 = GUICtrlCreateTreeView(8, 104, 481, 217, BitOR($GUI_SS_DEFAULT_TREEVIEW,$TVS_CHECKBOXES,$TVS_TRACKSELECT,$TVS_INFOTIP,$WS_VSCROLL,$WS_BORDER), BitOR($WS_EX_CLIENTEDGE,$WS_EX_STATICEDGE))
$TreeView1_0 = GUICtrlCreateTreeViewItem("Ubuntu", $TreeView1)
$TreeView1_1 = GUICtrlCreateTreeViewItem("Kodachi", $TreeView1)
$TreeView1_2 = GUICtrlCreateTreeViewItem("Kali", $TreeView1)
$TreeView1_3 = GUICtrlCreateTreeViewItem("Android", $TreeView1)
GUICtrlSetTip(-1, "Distrolist")
GUICtrlSetOnEvent(-1, "TreeView1Click")
$Update_distrolist = GUICtrlCreateButton("&Update distrolist", 392, 56, 91, 41)
GUICtrlSetOnEvent(-1, "Update_distrolistClick")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	Sleep(100)
WEnd

Func AddDistroClick()

EndFunc
Func Checkbox1Click()

EndFunc
Func DownloadClick()
	local $tmp = GUICtrlRead($TreeView1, 1)
	ConsoleWrite($tmp & @CRLF)
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
	If FileExists(@ScriptDir & "\distrolist1.csv") Then FileDelete(@ScriptDir & "\distrolist1.csv")
	InetGet("https://raw.githubusercontent.com/DimBertolami/Distroboot/refs/heads/main/distrolist.csv", @ScriptDir & "\distrolist.csv")
EndFunc
