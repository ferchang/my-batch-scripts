@echo off

rem got gswin64c.exe from installing Ghostscript10040w64.exe

rem ========================
set default_res=200
set default_format=jpeg
set min_quality=1
set max_quality=100
set default_quality=70
set num_formats=14

set formats=display:jpeg:jpeggray:jpegcmyk:png16m:png16:png48:png256:pnggray:pngmono:pngmonod:pngalpha:png16malpha:txtwrite
rem ========================
:again
%~d1
cd "%~dp1"
cls
rem ========================
set /p pages="pages? / press enter for 'all pages': "
if "%pages%"=="" set pages=1-
rem ========================
echo.
echo formats:
echo.
for /f "tokens=1-%num_formats% delims=:" %%a in ("%formats%") do (
  echo 1. %%a
  echo 2. %%b
  echo 3. %%c
  echo 4. %%d
  echo 5. %%e
  echo 6. %%f
  echo 7. %%g
  echo 8. %%h
  echo 9. %%i
  echo 10. %%j
  echo 11. %%k
  echo 12. %%l
  echo 13. %%m
  echo 14. %%n
)

:loop
echo.
set /p format="format? / press enter for '%default_format%': "
if "%format%"=="" (
	set format=%default_format%
	goto jmp_format
)
SET "var="&for /f "delims=0123456789" %%i in ("%format%") do set var=%%i
if defined var goto num_err
if %format% GTR %num_formats% goto num_err
if %format% LSS 1 goto num_err

goto after_num_err
:num_err
	echo.
	echo please enter only a number between 1 and %num_formats%!
	set format=
	goto loop
:after_num_err

for /f "tokens=%format% delims=:" %%a in ("%formats%") do set format=%%a
:jmp_format
rem =======================
if %format%==txtwrite goto txtwrite
rem =========================
:loop0
	echo.
	set /p res="resolution(DPI)? / press enter for '%default_res%': "
	if "%res%"=="" (
		set res=%default_res%
		goto jmp_res
	)

	SET "var="&for /f "delims=0123456789" %%i in ("%res%") do set var=%%i
	if defined var (
		echo.
		echo please enter only a positive number!
		set res=
		goto loop0
	)
:jmp_res
rem =========================
rem if /i "%format:~0,4%"=="jpeg" ( set is_jpg=1 ) else set is_jpg=0
rem if %is_jpg%==0 goto jmp
if /i not "%format:~0,4%"=="jpeg" goto jmp_quality
:loop2
	echo.
	set /p quality="quality? / press enter for '%default_quality%': "
	if "%quality%"=="" (
		set quality=%default_quality%
		goto jmp_quality
	)
	
	SET "var="&for /f "delims=0123456789" %%i in ("%quality%") do set var=%%i
	if defined var goto num_err
	if %quality% GTR %max_quality% goto num_err
	if %quality% LSS %min_quality% goto num_err

	goto after_num_err
	:num_err
		echo.
		echo please enter only a number between %min_quality% and %max_quality%!
		set quality=
		goto loop2
	:after_num_err
:jmp_quality

rem =============================

if %format%==display goto display

:txtwrite

echo.
echo output directory:
echo.
echo 1. same/current dir
echo 2. create a dir from pdf filename
echo 3. custom dir name
echo.
CHOICE /C:123
IF ERRORLEVEL 3 (
	set dir=custom
	goto out
)
IF ERRORLEVEL 2 (
	set dir=filename
	goto out
)
IF ERRORLEVEL 1 (
	set dir=.
	goto out
)
:out

for %%a in (%1) do (
	set filename0=%%~na
)

if not "%dir%"=="filename" goto jmp
	set dir=%filename0%
:jmp

if not "%dir%"=="custom" goto jmp
	:loopx
	echo.
	set /p dir="dir name: "
	if "%dir%"=="" (
		set dir=
		goto loopx
	)
:jmp

cls

if "%dir%"=="." goto jmp
	mkdir "%dir%"
	if %ERRORLEVEL% NEQ 0 echo.
:jmp

rem =========================
if %format%==txtwrite goto txtwrite
rem =========================

echo pages: %pages%
echo res: %res%
echo format: %format%
echo quality: %quality%
echo dir: %dir%
echo.

pause
echo.

if not "%quality%"=="" set quality2=-dJPEGQ=%quality%
if /i "%format:~0,4%"=="jpeg" set ext=jpg
if /i "%format:~0,3%"=="png" set ext=png
if /i "%format:~0,3%"=="txt" set ext=txt

set filename=pdf2img-%filename0%-r%res%-%format%
if %ext%==jpg set filename=%filename%-q%quality%

rem ============================

set dest_files="%dir%\%filename%*"

cls

rem echo dest_files: %dest_files%

dir %dest_files% >nul 2>nul && (
   echo similar destination files exist:
   echo -------------------------------
   for %%a in (%dest_files%) do echo %%a
   echo -------------------------------
   
   set similar_dest_files_exist=1
   
)

if not "%similar_dest_files_exist%"=="1" goto jmp

	echo.
	CHOICE /m "overwrite of existing files possible. continue"
	IF ERRORLEVEL 2 exit
	echo.

:jmp

rem ===========================

set filename=%filename%-%%03d.%ext%

gswin64c.exe -sPageList=%pages% -sDEVICE=%format% -r%res% %quality2% -o "%dir%/%filename%" %1

goto jmp
:txtwrite
	gswin64c.exe -sPageList=%pages% -sDEVICE=%format% -o "%dir%/%%03d.txt" %1
:jmp

echo.
title finished 
echo finished
echo.
pause
exit

goto jmp
:display
	gswin64c.exe -dBATCH -sPageList=%pages% -sDEVICE=%format% -r%res% %quality2% %1
	set pages=
	set format=
	set res=
	goto again
:jmp

