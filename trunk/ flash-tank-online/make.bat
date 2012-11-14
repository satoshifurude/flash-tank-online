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
	REM %FLEX_DIR%\bin\fdb %OUTPUT_SWF%
	D:\Work\flex_sdk_4.6.0.23201\bin\fdb D:\D1\client\_release\DragonIsland_ZINGME_1_0.3.0.swf
) else if "%MAKE_RUN%"=="1" (
	echo ...make run
	REM %FLASH_DEBUG% %OUTPUT_SWF%
	call D:\D1\client\FlashPlayerDebugger.exe D:\D1\client\_release\DragonIsland_ZINGME_1_0.3.0.swf
) else if "%MAKE_BUILD%"=="1" (
	echo ...make build
	%FLEX_DIR%\bin\mxmlc.exe -target-player %TARGET_FLASH_PLAYER% -compiler.library-path %FLEX3_LIB% -debug=true main.as -static-link-runtime-shared-libraries=true
)

