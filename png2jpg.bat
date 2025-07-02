@echo off
%~d1
cd "%~dp1"
set /p q="quality? (1-100) or just press Enter for default: "
if [%q%]==[] (set extra=) else (set extra=-quality %q%)
magick %extra% %* -set filename:name %%t "png2jpg-%%[filename:name].jpg"
title finished
echo finished
pause
