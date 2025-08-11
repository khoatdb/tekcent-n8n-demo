@echo off
REM Comprehensive build validation for TekcentDemo Sitecore solution
REM This script performs extensive validation of the solution build process

echo ===============================================
echo TekcentDemo Sitecore Solution Build Validation
echo ===============================================
echo.

setlocal enabledelayedexpansion
set SOLUTION_FILE=TekcentDemo.sln
set ERROR_COUNT=0

REM Check if solution file exists
if not exist "%SOLUTION_FILE%" (
    echo [ERROR] Solution file not found: %SOLUTION_FILE%
    set /a ERROR_COUNT+=1
    goto :end
)
echo [OK] Solution file found: %SOLUTION_FILE%

REM Find MSBuild
set MSBUILD_PATH=""
for %%p in (
    "C:\Program Files\Microsoft Visual Studio\2022\Professional\MSBuild\Current\Bin\MSBuild.exe"
    "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\MSBuild.exe"
    "C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe"
    "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\MSBuild\Current\Bin\MSBuild.exe"
    "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\MSBuild\Current\Bin\MSBuild.exe"
    "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\MSBuild.exe"
) do (
    if exist %%p (
        set MSBUILD_PATH=%%p
        goto :found_msbuild
    )
)

echo [ERROR] MSBuild not found. Please install Visual Studio 2019/2022
set /a ERROR_COUNT+=1
goto :end

:found_msbuild
echo [OK] MSBuild found: %MSBUILD_PATH%

REM Check .NET Framework 4.8
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" /v Release >nul 2>&1
if !errorlevel! equ 0 (
    echo [OK] .NET Framework is available
) else (
    echo [WARNING] .NET Framework 4.8 may not be available
)

REM Check NuGet
where nuget.exe >nul 2>&1
if !errorlevel! equ 0 (
    echo [OK] NuGet found in PATH
) else (
    echo [WARNING] NuGet.exe not found in PATH - package restore may fail
)

echo.
echo Project Structure Validation:
echo ------------------------------

REM Check all project files
set PROJECT_FILES[0]=src\Foundation\Serialization\code\Foundation.Serialization.csproj
set PROJECT_FILES[1]=src\Foundation\DependencyInjection\code\Foundation.DependencyInjection.csproj
set PROJECT_FILES[2]=src\Feature\Navigation\code\Feature.Navigation.csproj
set PROJECT_FILES[3]=src\Feature\Home\code\Feature.Home.csproj
set PROJECT_FILES[4]=src\Project\TekcentDemo\code\Project.TekcentDemo.Website.csproj

for /l %%i in (0,1,4) do (
    if exist "!PROJECT_FILES[%%i]!" (
        echo [OK] !PROJECT_FILES[%%i]!
    ) else (
        echo [ERROR] Missing: !PROJECT_FILES[%%i]!
        set /a ERROR_COUNT+=1
    )
)

REM Check packages.config files
echo.
echo NuGet Package Configuration:
echo ----------------------------
for /r "src" %%f in (packages.config) do (
    if exist "%%f" (
        echo [OK] %%f
    )
)

REM Check configuration files
echo.
echo Configuration Files:
echo --------------------

if exist "NuGet.config" (
    echo [OK] NuGet.config found
) else (
    echo [ERROR] NuGet.config missing
    set /a ERROR_COUNT+=1
)

if exist "sitecore.json" (
    echo [OK] sitecore.json found (SCS configuration)
) else (
    echo [WARNING] sitecore.json missing (SCS configuration)
)

if exist "src\Project\TekcentDemo\code\Web.config" (
    echo [OK] Web.config found
) else (
    echo [ERROR] Web.config missing
    set /a ERROR_COUNT+=1
)

if exist ".gitignore" (
    echo [OK] .gitignore found
) else (
    echo [WARNING] .gitignore missing
)

echo.
echo Testing Package Restore:
echo ------------------------

REM Try package restore
where nuget.exe >nul 2>&1
if !errorlevel! equ 0 (
    echo Attempting NuGet package restore...
    nuget restore %SOLUTION_FILE% -NonInteractive
    if !errorlevel! equ 0 (
        echo [OK] Package restore completed successfully
    ) else (
        echo [WARNING] Package restore failed - may need Sitecore NuGet credentials
    )
) else (
    echo [SKIP] NuGet not available - skipping package restore test
)

echo.
echo Testing MSBuild Compilation:
echo ----------------------------

echo Building solution in Debug configuration...
%MSBUILD_PATH% %SOLUTION_FILE% /p:Configuration=Debug /p:Platform="Any CPU" /t:Build /nologo /verbosity:minimal
if !errorlevel! equ 0 (
    echo [OK] Debug build successful
) else (
    echo [ERROR] Debug build failed
    set /a ERROR_COUNT+=1
)

echo Building solution in Release configuration...
%MSBUILD_PATH% %SOLUTION_FILE% /p:Configuration=Release /p:Platform="Any CPU" /t:Build /nologo /verbosity:minimal
if !errorlevel! equ 0 (
    echo [OK] Release build successful
) else (
    echo [ERROR] Release build failed
    set /a ERROR_COUNT+=1
)

:end
echo.
echo ===============================================
if !ERROR_COUNT! equ 0 (
    echo [SUCCESS] All validation tests passed!
    echo The solution is ready for Sitecore development.
    echo.
    echo Next steps:
    echo 1. Install Sitecore 10.4
    echo 2. Update connection strings in Web.config
    echo 3. Add license.xml to App_Data folder
    echo 4. Deploy to IIS and configure site bindings
) else (
    echo [FAILURE] !ERROR_COUNT! validation errors found
    echo Please resolve the issues above before proceeding.
)
echo ===============================================

if !ERROR_COUNT! gtr 0 exit /b 1
echo.
pause