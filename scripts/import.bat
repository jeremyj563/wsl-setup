@echo off
setlocal

set "script_root=%~dp0"

set "SRC_DISTRO=Ubuntu-K8s"
set "DST_DISTRO=%SRC_DISTRO%"
set /p "SRC_DISTRO=Enter source distribution name [%SRC_DISTRO%]: "
set /p "DST_DISTRO=Enter destination distribution name [%DST_DISTRO%]: "

echo.
set /p VER=< "%script_root%\_current_version"
set /p "VER=Enter version to import [v%VER%]: v"

set "FILE=%SRC_DISTRO%-v%VER%.tar.gz"
set /p SRC=< "%script_root%\_archive_path"
set "SRC_PATH=%SRC%\%FILE%"
set "DST_PATH=%USERPROFILE%\wsl\%DST_DISTRO%"

if not exist %DST_PATH% mkdir %DST_PATH%

echo.
wsl --unregister %DST_DISTRO%
echo.

echo Importing...
echo.
echo Source: '%SRC_PATH%'
echo Destination: '%DST_PATH%'
wsl --import %DST_DISTRO% "%DST_PATH%" "%SRC_PATH%"

echo.
set /p "RESPONSE=Set '%DST_DISTRO%' as default distribution? (Y/[N]): "
if /i "%RESPONSE%" == "Y" (
    echo.
    echo Setting default distribution: '%DST_DISTRO%'
    wsl --set-default %DST_DISTRO%
)

echo.
wsl -l -v

:END
endlocal
