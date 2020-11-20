@echo off
set pt=D:\Softwares\waifu2x-ncnn-vulkan
cd /d %pt%
set /p dn=denoise level? (-1,0,1,2,3): 
set /p sc=scale factor? (1,2): 
set /p od=output to .\output? (1,0): 
if %od%==0 (
for %%x in (%*) do %pt%\waifu2x-ncnn-vulkan.exe -i "%%~dpnxx" -o "%%~dpnx_w2xn%dn%s%sc%.png" -n %dn% -s %sc%
)else (
if not exist "%~dp1output" md "%~dp1output"
for %%x in (%*) do %pt%\waifu2x-ncnn-vulkan.exe -i "%%~dpnxx" -o "%~dp1output\%%~nx_w2xn%dn%s%sc%.png" -n %dn% -s %sc%
)
pause