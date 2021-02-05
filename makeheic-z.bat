@echo off
set /p q=target quality? (crf): 
set /p delsrc=delete source file? (confirm=y/else=n): 
if not defined delsrc set delsrc=no
for %%x in (%*) do (
    ffmpeg -hide_banner -r 1 -i "%%~dpnxx" -vf zscale=m=170m:r=pc:f=bicubic:d=error_diffusion,format=yuv444p10le -frames 1 -c:v libx265 -preset 6 -crf %q% -x265-params no-sao=1:selective-sao=0:ref=1:bframes=0:aq-mode=1:psy-rd=2:psy-rdoq=8:cbqpoffs=1:crqpoffs=1:range=full:colormatrix=smpte170m:transfer=iec61966-2-1:no-info=1 "%temp%\%%~nxx.heic.hevc" -y
    ffmpeg -hide_banner -r 1 -i "%%~dpnxx" -vf extractplanes=a,zscale=r=pc:f=bicubic:d=error_diffusion,format=gray10le -frames 1 -c:v libx265 -preset 6 -crf %q% -x265-params no-sao=1:selective-sao=0:ref=1:bframes=0:aq-mode=1:psy-rd=2:psy-rdoq=8:cbqpoffs=1:crqpoffs=1:range=full:colormatrix=smpte170m:transfer=iec61966-2-1:no-info=1 "%temp%\%%~nxx.alpha.hevc" -y
    mp4box -add-image "%temp%\%%~nxx.heic.hevc":primary -brand heic -new "%%~dpnx.heic"
    mp4box -add-image "%temp%\%%~nxx.alpha.hevc":ref=auxl,1:alpha -brand heic "%%~dpnx.heic"
    del "%temp%\%%~nxx.heic.hevc"
    del "%temp%\%%~nxx.alpha.hevc"
    if %delsrc%==confirm del "%%~dpnxx" 
)
pause
