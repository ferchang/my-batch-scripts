@echo off
%~d1
cd "%~dp1"

rem for %%v in (%*) do echo %%~nv

rem goto skip

for %%v in (%*) do magick convert -crop 50%%x100%% +repage %%v "split-%%~nv.png"
title finished
echo finished

:skip
pause
