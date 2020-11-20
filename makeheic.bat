@echo off
set /p q=target quality? (crf): 
set /p delsrc=delete source file? (confirm=y/else=n): 
if not defined delsrc set delsrc=no
for %%x in (%*) do ffmpeg -i "%%~dpnxx"     -lavfi color=white:r=1,format=rgb24[c];[c][0:v]scale2ref,overlay,format=rgb24[p];[p]zscale=m=470bg:r=pc:f=5:d=error_diffusion,format=yuv444p10le     -frames 1 -c:v libx265 -preset 6 -crf %q%     -x265-params sao=0:selective-sao=0:ref=1:bframes=0:aq-mode=1:psy-rd=2:psy-rdoq=8:cbqpoffs=1:crqpoffs=1:range=full:info=0     "%temp%\%%~nxx.mp4"     && mp4box -add-image "%temp%\%%~nxx.mp4":primary -brand heic -new "%%~dpnx.heic"     && del "%temp%\%%~nxx.mp4"     && if %delsrc%==confirm del "%%~dpnxx" 
pause
