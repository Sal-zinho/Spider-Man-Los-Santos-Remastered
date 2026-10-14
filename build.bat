@echo off
setlocal
call "%~dp0build-melty.cmd"
exit /b %errorlevel%
