@ECHO off

REM : Clear screen
cls

REM : Load config
call config.bat
ECHO startmake

if "%1"=="debug" (
	set MAKE_DEBUG=1
	set MAKE_RUN=
	set MAKE_BUILD=
) else if "%1"=="run" (
	set MAKE_DEBUG=
	set MAKE_RUN=1
	set MAKE_BUILD=
) else if "%1"=="build" (
	set MAKE_DEBUG=
	set MAKE_RUN=
	set MAKE_BUILD=1
)


if "%MAKE_DEBUG%"=="1" (	
	echo ...make debug
	%FLEX_DIR%\bin\fdb %OUTPUT_SWF%
) else if "%MAKE_RUN%"=="1" (
	echo ...make run
	%FLASH_DEBUG% %OUTPUT_SWF%
) else if "%MAKE_BUILD%"=="1" (
	echo ...make build
	%FLEX_DIR%\bin\mxmlc.exe -compiler.include-libraries=%STARLING_LIB% -output=%OUTPUT_SWF% -debug=true -static-link-runtime-shared-libraries=true %MAIN_DIR%
)

