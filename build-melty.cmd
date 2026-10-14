@echo off
setlocal
set "ROOT=%~dp0"
set "RT=%ROOT%vendor\melty-native-runtime"
set "VCROOT=C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools"
set "OUT=%ROOT%build\SpiderSwingASI.asi"
if not exist "%RT%\src\native_runtime.cpp" (
  echo [ERROR] Melty native runtime source is missing.
  exit /b 2
)
if not exist "%RT%\third_party\minhook\include\MinHook.h" (
  echo [ERROR] MinHook source is missing.
  exit /b 3
)
call "%VCROOT%\Common7\Tools\VsDevCmd.bat" -arch=x64 -host_arch=x86
if errorlevel 1 exit /b 4
if not exist "%ROOT%build" mkdir "%ROOT%build"
if not exist "%ROOT%build\obj" mkdir "%ROOT%build\obj"
cl /nologo /LD /O2 /EHsc /std:c++20 /MT /W3 /DWIN32_LEAN_AND_MEAN /DNOMINMAX /I "%ROOT%src" /I "%RT%\src" /I "%RT%\third_party\minhook\include" "%ROOT%src\SpiderSwingASI.cpp" "%RT%\src\native_runtime.cpp" "%RT%\third_party\minhook\src\buffer.c" "%RT%\third_party\minhook\src\hook.c" "%RT%\third_party\minhook\src\trampoline.c" "%RT%\third_party\minhook\src\hde\hde64.c" /Fo"%ROOT%build\obj\\" /link /OUT:"%OUT%" user32.lib
if errorlevel 1 exit /b 5
echo [OK] Built Melty-native "%OUT%"
