@echo off
md "%~dp0\..\.vscode"
md "%~dp0\..\.log"
xcopy /Y /E "%~dp0��ʾ\��Ŀ����\*" "%~dp0.."
pause
