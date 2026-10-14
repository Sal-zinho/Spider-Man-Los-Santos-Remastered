@echo off
setlocal
set "ROOT=%~dp0"
set "SDK=%ROOT%vendor\ScriptHookV_SDK"
set "VCROOT=C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools"
set "SRC=%ROOT%src\SpiderSwingASI.cpp"
set "OUT=%ROOT%build\SpiderSwingASI.asi"
if not exist "%SDK%\inc\main.h" (
  echo [ERROR] ScriptHookV headers are missing.
  exit /b 2
)
if not exist "%SDK%\lib\ScriptHookV.lib" (
  echo [ERROR] ScriptHookV import library is missing.
  exit /b 3
)
if not exist "%ROOT%build" mkdir "%ROOT%build"
call "%VCROOT%\Common7\Tools\VsDevCmd.bat" -arch=x64 -host_arch=x86
if errorlevel 1 exit /b 4
cl /nologo /LD /O2 /EHsc /std:c++17 /MT /W3 /wd4505 /wd4324 /DWIN32_LEAN_AND_MEAN /DNOMINMAX /I "%SDK%\inc" "%SRC%" /Fo"%ROOT%build\obj_" /link /OUT:"%OUT%" "%SDK%\lib\ScriptHookV.lib" user32.lib
if errorlevel 1 exit /b 5
echo [OK] Built "%OUT%"
