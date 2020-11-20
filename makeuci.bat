@echo off
set /p q=target quality? (crf): 
set /p delsrc=delete source file? (confirm=y/else=n): 
if not defined delsrc set delsrc=no
for %%x in (%*) do cd /d "D:\Softwares\UCI\" & imgdec "%%~dpnxx" - | ucienc - -o "%%~dpnx.uci" -s -hevc -x "--crf %q% -p placebo --ref 1 --bframes 0 --aq-mode 1 --psy-rd 2 --psy-rdoq 8 --cbqpoffs -2 --crqpoffs -2 -F 1 --no-sao --output-depth 10" && if %delsrc%==confirm del "%%~dpnxx"
pause
