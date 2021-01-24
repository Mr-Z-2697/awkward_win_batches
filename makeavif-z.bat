@echo off
set /p q=target quality? (ffmpeg call it crf but it's cq): 
set /p u=speed/quality trade off? (cpu-used, default 4): 
set /p delsrc=delete source file? (confirm=y/else=n): 
if not defined delsrc set delsrc=no
if not defined u set u=4
for %%x in (%*) do (
    ffmpeg -hide_banner -r 1 -i "%%~dpnxx" -vf zscale=m=470bg:r=pc:f=lanczos:d=error_diffusion,format=yuv444p10le -frames 1 -c:v libaom-av1 -cpu-used %u% -crf %q% -color_range pc "%temp%\%%~nxx.avif.ivf" -y
    ffmpeg -hide_banner -r 1 -i "%%~dpnxx" -vf extractplanes=a,scale=out_range=pc,format=yuv444p10le -frames 1 -c:v libaom-av1 -cpu-used %u% -crf %q% -color_range pc "%temp%\%%~nxx.alpha.ivf" -y
    mp4box -add-image "%temp%\%%~nxx.avif.ivf":primary -brand avif -new "%%~dpnx.avif"
    mp4box -add-image "%temp%\%%~nxx.alpha.ivf":ref=auxl,1:alpha -brand avif "%%~dpnx.avif"
    del "%temp%\%%~nxx.avif.ivf"
    del "%temp%\%%~nxx.alpha.ivf"
    if %delsrc%==confirm del "%%~dpnxx" 
)
pause
