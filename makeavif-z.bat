@echo off
set /p q=target quality? (crf): 
set /p delsrc=delete source file? (confirm=y/else=n): 
if not defined delsrc set delsrc=no
for %%x in (%*) do (
    ffmpeg -hide_banner -r 1 -i "%%~dpnxx" -vf zscale=m=470bg:r=pc:f=lanczos:d=error_diffusion,format=yuv444p10le -frames 1 -c:v libaom-av1 -cpu-used 3 -crf %q% -color_range pc "%temp%\%%~nxx.heic.ivf" -y
    ffmpeg -hide_banner -r 1 -i "%%~dpnxx" -vf extractplanes=a,scale=out_range=pc,format=yuv444p10le -frames 1 -c:v libaom-av1 -cpu-used 3 -crf %q% -color_range pc "%temp%\%%~nxx.alpha.ivf" -y
    mp4box -add-image "%temp%\%%~nxx.heic.ivf":primary -brand avif -new "%%~dpnx.avif"
    mp4box -add-image "%temp%\%%~nxx.alpha.ivf":ref=auxl,1:alpha -brand avif "%%~dpnx.avif"
    del "%temp%\%%~nxx.heic.ivf"
    del "%temp%\%%~nxx.alpha.ivf"
    if %delsrc%==confirm del "%%~dpnxx" 
)
pause
