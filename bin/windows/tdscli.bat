:: script chamada TDS CLi
@echo off

SETLOCAL

SET DEBUG=
SET DEBUG_LOG=
IF "%DEBUG%"=="1" SET DEBUG_LOG="--log-file=cli-debug.log"

SET LS_DIR=.
SET LS_EXE=advpls.exe
SET LS=%LS_DIR%\%LS_EXE%

SET ARGS=%*
IF DEFINED ARGS SET ARGS=%ARGS:"=\"%

CALL %LS% %DEBUG_LOG% --tdsCliArguments="%ARGS%"

IF "%DEBUG%"=="1" IF %ERRORLEVEL% NEQ 0 echo TDS CLi errorcode [%ERRORLEVEL%]

exit %ERRORLEVEL%

ENDLOCAL
