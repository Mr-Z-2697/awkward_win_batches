@echo off
set /p sz=target image width? (int): 
set /p cs=palette colors? (int):
echo ---///palettegen///---
ffmpeg -hide_banner -i "%~dpnx1" -vf scale=%sz%:%sz%/dar,palettegen=%cs%:0 "%~dpn1.palette.png"
echo ---///paletteuse///---
ffmpeg -hide_banner -i "%~dpnx1" -i "%~dpn1.palette.png" -filter_complex "[0:v]scale=%sz%:%sz%/dar[v];[v][1:v]paletteuse=dither=1" "%~dpn1.palette.gif"
pause