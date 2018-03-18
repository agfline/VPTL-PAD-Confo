@echo off



SET DEBUG=false
SET VERBOSE=false



:: Allows to set !variables! inside for loops
:::::::::::::::::::::::::::::::::::::::::::::

SETLOCAL enabledelayedexpansion



:: Clears MS noises when runing from a network drive
::::::::::::::::::::::::::::::::::::::::::::::::::::

CLS



echo.
echo *******************************************************************************
echo ***                             VPTL PAD Confo                              ***
echo *******************************************************************************
echo.
echo    VPTL PAD Confo  permet de preparer des  fichiers  .mov  a  destination du
echo    melangeur  du  VPTL,  en  ne  conservant  que  les  pistes audio  1 et 2.
echo.
echo.
echo    Utilisation :
echo      - Deposer les fichiers a convertir dans le dossier "input"
echo      - Lancer VPTL_PAD_Confo.bat
echo      - Recuperer les fichiers dans le dossier "output"
echo.
echo.
echo *******************************************************************************
echo.



:: Sets the current path
::::::::::::::::::::::::

SET localPath=%~dp0
SET localPath=%localPath:~0,-1%

:: If ran from a network drive, converts from standard path to UNC
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

call:resolveUNCPath "%localPath%"

if %DEBUG%==true echo  Localpath : %localPath%



:: Sets and creates input/output dir, if needed
:::::::::::::::::::::::::::::::::::::::::::::::

SET inputPath=%localPath%\input
SET outputPath=%localPath%\output

if %DEBUG%==true echo  Input     : %inputPath%
if %DEBUG%==true echo  Output    : %outputPath%

if not exist "%inputPath%"  mkdir ""%inputPath%""
if not exist "%outputPath%" mkdir ""%outputPath%""



if %DEBUG%==true echo



:: Sets the correct ffmpeg version depending on the system
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT || set OS=64BIT

if exist "%localPath%\ffmpeg.exe" (

  SET ffmpeg=%localPath%\ffmpeg.exe

) else (

  if %OS%==32BIT SET ffmpeg=%localPath%\ffmpeg-x86.exe
  if %OS%==64BIT SET ffmpeg=%localPath%\ffmpeg-x64.exe

)

if %DEBUG%==true echo  ffmpeg    : %ffmpeg%



:loop

if %DEBUG%==true echo :loop

if exist "%inputPath%\*.mov" (

  if %DEBUG%==true echo if exist "%inputPath%\*.mov"

  for %%a in ("%inputPath%\*.mov") do (

    if %DEBUG%==true echo for %%a in ^("%inputPath%\*.mov"^)

    set filename=%%~na
    set fileextension=%%~xa


    echo  [^>] processing : !filename!!fileextension!


    if %DEBUG%==true echo "%ffmpeg%" -i "%inputPath%\!filename!!fileextension!" ^-map 0:v ^-map 0:a:0 ^-map 0:a:1 ^-c copy "%outputPath%\!filename!!fileextension!"

    if %VERBOSE%==true (

      "%ffmpeg%" -i "%inputPath%\!filename!!fileextension!" -map 0:v -map 0:a:0 -map 0:a:1 -c copy "%outputPath%\!filename!!fileextension!"

    ) else (

      "%ffmpeg%" -loglevel panic -i "%inputPath%\!filename!!fileextension!" -map 0:v -map 0:a:0 -map 0:a:1 -c copy "%outputPath%\!filename!!fileextension!"

    )

  )

) else (

  echo  [^!] Le repertoire "input" est vide.

)



:: Sets script as a watch-folder deamon
:::::::::::::::::::::::::::::::::::::::

REM ping -n 10 localhost >nul
REM goto :loop



echo.

pause



:: Converts a standard path to UNC, if it is a network drive.
:: The function updates the argument global variable
:: %localPath% with the new path.
::
:: E.g "S:\" becomes "\\10.87.127.70\"
::
::
:: Thank to Stephen Knight:
:: http://scripts.dragon-it.co.uk/scripts.nsf/docs/batch-get-unc-path-from-name!OpenDocument&ExpandSection=2&BaseTarget=East&AutoFramed

:resolveUNCPath

  set pnx=%~pnx1%
  set unc=

  for /f "tokens=* delims= " %%U in ('net use %~d1 2^> nul ^| find /i "\\"') do set unc=%%U

  if "%unc%" == "" (
    set uncname=%~d1!pnx!
  ) else (
    set uncname=%unc:*\\=\\%!pnx!
  )

  set "localPath=%uncname%"

goto:eof
