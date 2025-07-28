@echo off

set default_percent=50

%~d1
cd "%~dp1"

rem ======================================
:loop
set /p percent="percent? or just press Enter for %default_percent%: "
if "%percent%"=="" set percent=%default_percent%
SET "var="&for /f "delims=0123456789" %%i in ("%percent%") do set var=%%i
if defined var goto num_err
if %percent% LEQ 0 goto num_err
goto after_num_err
:num_err
	echo.
	echo please enter only a number and greater than zero!
	set percent=
	echo.
	goto loop
:after_num_err
rem ======================================

echo.
set /p q="quality? (1-100) or just press Enter for default: "
if [%q%]==[] (
	set extra=
	set quality=def
) else (
	set extra=-quality %q%
	set quality=%q%
)

rem magick %extra% %* -set filename:name %%t "png2jpg-%%[filename:name].jpg"
rem for %%v in (%*) do magick %%v -resize %percent%%% "scale-%percent%-%%~nv%%~xv"

for %%v in (%*) do magick %%v -resize %percent%%% "scale8jpg-%percent%-%quality%-%%~nv.jpg"

title finished
echo.
echo finished

:skip
pause
