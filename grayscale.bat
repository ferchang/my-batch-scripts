@echo off
%~d1
cd "%~dp1"

for %%v in (%*) do magick convert %%v -set colorspace Gray -separate -average "gray-%%~nv%%~xv"

title finished
echo finished

:skip
pause
