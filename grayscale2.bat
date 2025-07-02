@echo off

rem needs ImageMagick

rem ========================

set default_method=old
set num_methods=8
set methods=old:Rec601Luma:Rec601Luminance:Rec709Luma:Rec709Luminance:Brightness:Lightness:all

rem ========================

cls

%~d1
cd "%~dp1"

echo.
echo methods:
echo.
for /f "tokens=1-%num_methods% delims=:" %%a in ("%methods%") do (
  echo 1. %%a
  echo 2. %%b
  echo 3. %%c
  echo 4. %%d
  echo 5. %%e
  echo 6. %%f
  echo 7. %%g
  echo 8. %%h
)

:loop
echo.
set /p method="method? / press enter for '%default_method%': "
if "%method%"=="" (
	set method=%default_method%
	goto jmp_method
)
SET "var="&for /f "delims=0123456789" %%i in ("%method%") do set var=%%i
if defined var goto num_err
if %method% GTR %num_methods% goto num_err
if %method% LSS 1 goto num_err

goto after_num_err
:num_err
	echo.
	echo please enter only a number between 1 and %num_methods%!
	set method=
	goto loop
:after_num_err

for /f "tokens=%method% delims=:" %%a in ("%methods%") do set method=%%a
:jmp_method
rem =======================

echo.

if not %method%==old goto jmp
	for %%v in (%*) do magick convert %%v -set colorspace Gray -separate -average "gray-%%~nv%%~xv"
	goto end
:jmp

rem ===========================================

if not %method%==all goto jmp
	set i=1
	:loop_all
		
		for /f "tokens=%i% delims=:" %%a in ("%methods%") do set method=%%a
		if %method%==all goto skip
		
		echo ============ %i%. %method% ================
		
		if not %method%==old goto jmp2
			for %%v in (%*) do magick convert %%v -set colorspace Gray -separate -average "gray-%%~nv%%~xv"
			goto jmp3
		:jmp2
		
		for %%v in (%*) do magick %%v -grayscale %method% "gray-%method%-%%~nv%%~xv"
		
		:jmp3
		echo =======================================
		echo.
		
		:skip
		set /a i=%i%+1
		if %i% GTR %num_methods% goto end
		goto loop_all
	goto end
:jmp

rem ===========================================

for %%v in (%*) do magick %%v -grayscale %method% "gray-%method%-%%~nv%%~xv"

:end
title finished
echo finished
pause
