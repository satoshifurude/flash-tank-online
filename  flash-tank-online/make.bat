@ECHO off

REM : Clear screen
cls

REM : Load config
call config.bat

if "%1"=="debug" (
	set MAKE_DEBUG = 1
)

)

%FLEX_DIR%\bin\mxmlc.exe -compiler.include-libraries=%STARLING_LIB% -static-link-runtime-shared-libraries=true %MAIN_DIR%