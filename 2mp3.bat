@echo off
%~d1
cd "%~dp1"
rem set /p q="quality? (1-100) or just press Enter for default: "
rem if [%q%]==[] (set extra=) else (set extra=-quality %q%)
for %%f in (%*) do (
	echo ================= "%%~nf%%~xf" ===================
	ffmpeg -i "%%~nf%%~xf" -filter:a "volume=2" -q 1 "%%~nf.mp3"
)
title finished
echo finished
pause
