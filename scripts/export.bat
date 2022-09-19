@echo off
setlocal

set "script_root=%~dp0"

set "DISTRO=Ubuntu-K8s"
set /p "DISTRO=Enter distribution name [%DISTRO%]: "

echo.
set /p VER=< "%script_root%\_current_version"
echo Current version is: v%VER%
set /a VER=VER+1
set /p "VER=Enter next version [v%VER%]: v"

echo %VER%> "%script_root%\_current_version"

set "FILE=%DISTRO%-v%VER%.tar"
set /p SRC=< "%script_root%\_archive_path"
set "DST=%SRC%\%FILE%.gz"

echo.
echo Exporting...

wsl --export %DISTRO% "%TEMP%\%FILE%"
7z a -tgzip -mx9 "%DST%" -sdel "%TEMP%\%FILE%"

echo.
set /p "RESPONSE=Commit new version back to Git? (Y/[N]): "
if /i "%RESPONSE%" == "Y" (
    git add "%script_root%\_current_version" CHANGELOG.md
    git commit -m "updated distro to v%VER%"
    git push
)

:END
endlocal
