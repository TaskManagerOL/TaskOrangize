#Persistent ; 保持脚本不退出
MsgBox TaskOrangize已运行

; 读取文件内容
FileRead, fileContent, AutoOrganize.txt
configContent := StrReplace(fileContent, "`r`n", "`n")
configLines := StrSplit(configContent, "`n")
OS := Trim(configLines[1])
Time := Trim(configLines[2]) ;
Folder := Trim(configLines[3])

;获取信息
username := A_UserName
FormatTime, CurrentTime, , yyyyMMdd
StringSplit, timeParts, Time, `:  
targetHour := timeParts1
targetMinute := timeParts2
currentHour := A_Hour
currentMinute := A_Min
timeDifference := (targetHour * 60 + targetMinute) - (currentHour * 60 + currentMinute)
if (timeDifference < 0) {
    timeDifference += 24 * 60
}
timeDifferenceMilliseconds := timeDifference * 60 * 1000
MsgBox 下次执行时间 %timeDifferenceMilliseconds% ms
Sleep, %timeDifferenceMilliseconds%

ExecuteAtTargetTime:
    MsgBox 即将对桌面进行整理
    if(OS == "Windows"){
        FileCreateDir, %Folder%\%CurrentTime%
        sourceFolder := "C:\Users\" username "\Desktop"
        targetFolder := Folder "\" CurrentTime

        if !FileExist(sourceFolder) {
            MsgBox, 源文件夹不存在: %sourceFolder%
            ExitApp
        }
        if !FileExist(targetFolder) {
            MsgBox, 目标文件夹不存在: %targetFolder%
            ExitApp
        }
        FileMove, %sourceFolder%\*.*, %targetFolder%
        Loop, Files, %sourceFolder%\*, D
        {
            sourcePath := A_LoopFileFullPath
            targetPath := targetFolder "\" A_LoopFileName
            FileMoveDir, %sourcePath%, %targetPath%, 1
        }    
        FileAppend, %CurrentTime% 整理完成，感谢使用 ,%Folder%\%CurrentTime%\log.txt
        MsgBox, 操作完成！
    }else{
        MsgBox OS
    }
    ExitApp

return