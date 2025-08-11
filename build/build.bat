@echo off
REM Build script for TekcentDemo Sitecore solution
REM This script builds the entire solution using MSBuild

echo ===============================================
echo Building TekcentDemo Sitecore Solution
echo ===============================================

REM Set solution file path
set SOLUTION_FILE=TekcentDemo.sln

REM Set MSBuild path (adjust if needed)
set MSBUILD_PATH="C:\Program Files\Microsoft Visual Studio\2022\Professional\MSBuild\Current\Bin\MSBuild.exe"

REM Check if MSBuild exists
if not exist %MSBUILD_PATH% (
    echo MSBuild not found at expected location: %MSBUILD_PATH%
    echo Please update the MSBUILD_PATH variable in this script
    goto :error
)

echo Restoring NuGet packages...
nuget restore %SOLUTION_FILE%
if errorlevel 1 goto :error

echo Building solution in Debug configuration...
%MSBUILD_PATH% %SOLUTION_FILE% /p:Configuration=Debug /p:Platform="Any CPU" /m
if errorlevel 1 goto :error

echo Building solution in Release configuration...
%MSBUILD_PATH% %SOLUTION_FILE% /p:Configuration=Release /p:Platform="Any CPU" /m
if errorlevel 1 goto :error

echo ===============================================
echo Build completed successfully!
echo ===============================================
goto :success

:error
echo ===============================================
echo Build failed!
echo ===============================================
exit /b 1

:success
echo Solution built successfully.
pause