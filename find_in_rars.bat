@echo off

rem got UnRAR.exe from installing WinRAR

set pass=

:loop1
set /p "str=enter search string (excluding any file extension): "
if "%str%"=="" goto loop1

echo.

if "%pass%"=="" (
	set /p "pass=enter rar files password (if any): "
	echo.
)

cls

if not "%pass%"=="" set pass=-p"%pass%"

setlocal ENABLEDELAYEDEXPANSION

echo ===================================
echo.

FOR %%f IN (*.rar) DO (

	unrar lb %pass% "%%f" | find "%str%"
	
	if !errorlevel!==0 (
		echo in file: %%f
		echo.
	)

)

echo.
echo ===================================

echo.
pause
exit