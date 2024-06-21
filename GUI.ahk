Gui, Add, Text, x20 y20, 操作系统:
Gui, Add, DropDownList, vOSChoice x100 y18 w250, Windows|Linux
Gui, Add, Text, x20 y60, 时间输入:
Gui, Add, Edit, vTimeInput x100 y58 w250
Gui, Add, Text, x20 y100, 文件夹路径:
Gui, Add, Edit, vFolderPath x100 y98 w250, %lastFolder%
Gui, Add, Button, x360 y96 gSelectFolder, 选择文件夹
Gui, Add, Button, x100 y140 w250 gOutputToFiles, 输出到文件
Gui, Show, w440 h180, 设置和文件选择
return

SelectFolder:
    FileSelectFolder, selectedFolder, , 3, 请选择一个文件夹:
    if (selectedFolder <> "") {
        GuiControl,, FolderPath, %selectedFolder%
        IniWrite, %selectedFolder%, %configFile%, %section%, %keyFolder%
    } else {
        MsgBox, 您取消了选择文件夹。
    }
return

OutputToFiles:
    Gui, Submit, NoHide
    if (!ValidateTime(TimeInput)) {
        MsgBox, 输入的时间格式不正确。请使用 HH:MM 格式，并确保时和分在有效范围内。
        return
    }
    osFile := A_ScriptDir "\AutoOrganize.txt"

    If FileExist(osFile)
    {
        FileDelete, %osFile%
    }

    FileAppend,%OSChoice%`n%TimeInput%`n%FolderPath%, %osFile%

    username := A_UserName
    FileCopy, TaskOrangize.ahk, C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup, 1
    FileCopy, AutoOrganize.txt, C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup, 1
    run C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
    MsgBox, 信息已保存
    ExitApp
return

ValidateTime(time) {
    if RegExMatch(time, "^\d{1,2}:\d{2}$") {
        StringSplit, parts, time, :
        hour := parts1
        minute := parts2
        if (hour >= 0 && hour <= 23 && minute >= 0 && minute <= 59) {
            return true
        }
    }
    return false
}



GuiClose:
    ExitApp