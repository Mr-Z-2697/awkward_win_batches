@echo off
set /p q=target quality? (crf): 
set /p delsrc=delete source file? (confirm=y/else=n): 
if not defined delsrc set delsrc=no
for %%x in (%*) do (
    ffmpeg -loglevel 0 -r 1 -i "%%~dpnxx" -vf scale=out_color_matrix=470bg:out_range=pc:flags=lanczos:sws_dither=ed,format=yuv444p10le -frames 1 -f yuv4mpegpipe -strict -1 -|x265 --input - --y4m --preset 6 --crf %q% --no-sao --selective-sao 0 --ref 1 --bframes 0 --aq-mode 1 --psy-rd 2 --psy-rdoq 8 --cbqpoffs 1 --crqpoffs 1 --range full --colormatrix bt470bg --no-info -D 10 -o "%temp%\%%~nxx.heic.hevc"
    ffmpeg -loglevel 0 -r 1 -i "%%~dpnxx" -vf extractplanes=a,scale=out_range=pc,format=yuv444p10le -frames 1 -f yuv4mpegpipe -strict -1 -|x265 --input - --y4m --preset 6 --crf %q% --no-sao --selective-sao 0 --ref 1 --bframes 0 --aq-mode 1 --psy-rd 2 --psy-rdoq 8 --cbqpoffs 1 --crqpoffs 1 --range full --colormatrix bt470bg --no-info -D 10 -o "%temp%\%%~nxx.alpha.hevc"
    if exist "%temp%\%%~nxx.alpha.hevc" (
        mp4box -add-image "%temp%\%%~nxx.heic.hevc":primary -add-image "%temp%\%%~nxx.alpha.hevc":ref=auxl,1:alpha -brand heic -new "%%~dpnx.heic"
        del "%temp%\%%~nxx.heic.hevc"
        del "%temp%\%%~nxx.alpha.hevc"
    )else (
        mp4box -add-image "%temp%\%%~nxx.heic.hevc":primary -brand heic -new "%%~dpnx.heic"
        del "%temp%\%%~nxx.heic.hevc"
    )
    if %delsrc%==confirm del "%%~dpnxx" 
)
pause
