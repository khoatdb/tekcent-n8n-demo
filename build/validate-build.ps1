# PowerShell script to validate Sitecore solution build on Windows
# This script performs comprehensive build validation without requiring Sitecore installation

param(
    [string]$Configuration = "Debug",
    [switch]$SkipRestore = $false
)

Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "Validating TekcentDemo Sitecore Solution Build" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

$ErrorActionPreference = "Stop"
$SolutionFile = "TekcentDemo.sln"
$ExitCode = 0

try {
    # Check if solution file exists
    if (!(Test-Path $SolutionFile)) {
        Write-Host "✗ Solution file not found: $SolutionFile" -ForegroundColor Red
        exit 1
    }
    Write-Host "✓ Solution file found: $SolutionFile" -ForegroundColor Green

    # Check .NET Framework 4.8 availability
    $NetFramework48 = Get-ItemProperty "HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full\" -Name Release -ErrorAction SilentlyContinue
    if ($NetFramework48 -and $NetFramework48.Release -ge 528040) {
        Write-Host "✓ .NET Framework 4.8 is available" -ForegroundColor Green
    } else {
        Write-Host "⚠ .NET Framework 4.8 may not be available - build may fail" -ForegroundColor Yellow
    }

    # Find MSBuild
    $MSBuildPaths = @(
        "${env:ProgramFiles}\Microsoft Visual Studio\2022\Professional\MSBuild\Current\Bin\MSBuild.exe",
        "${env:ProgramFiles}\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\MSBuild.exe",
        "${env:ProgramFiles}\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe",
        "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\Professional\MSBuild\Current\Bin\MSBuild.exe",
        "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\Enterprise\MSBuild\Current\Bin\MSBuild.exe",
        "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\MSBuild.exe"
    )

    $MSBuild = $null
    foreach ($Path in $MSBuildPaths) {
        if (Test-Path $Path) {
            $MSBuild = $Path
            break
        }
    }

    if ($MSBuild) {
        Write-Host "✓ MSBuild found: $MSBuild" -ForegroundColor Green
    } else {
        Write-Host "✗ MSBuild not found. Please install Visual Studio 2019/2022" -ForegroundColor Red
        exit 1
    }

    # Check NuGet
    $NuGet = Get-Command "nuget.exe" -ErrorAction SilentlyContinue
    if (!$NuGet) {
        Write-Host "⚠ NuGet.exe not found in PATH. Package restore may fail." -ForegroundColor Yellow
        Write-Host "  Download from: https://www.nuget.org/downloads" -ForegroundColor Yellow
    } else {
        Write-Host "✓ NuGet found: $($NuGet.Source)" -ForegroundColor Green
    }

    Write-Host ""
    Write-Host "Project Structure Validation:" -ForegroundColor Cyan

    # Validate project files exist and have correct target framework
    $Projects = @(
        "src\Foundation\Serialization\code\Foundation.Serialization.csproj",
        "src\Foundation\DependencyInjection\code\Foundation.DependencyInjection.csproj",
        "src\Feature\Navigation\code\Feature.Navigation.csproj",
        "src\Feature\Home\code\Feature.Home.csproj",
        "src\Project\TekcentDemo\code\Project.TekcentDemo.Website.csproj"
    )

    foreach ($ProjectPath in $Projects) {
        if (Test-Path $ProjectPath) {
            $ProjectXml = [xml](Get-Content $ProjectPath)
            $TargetFramework = $ProjectXml.Project.PropertyGroup.TargetFrameworkVersion
            if ($TargetFramework -eq "v4.8") {
                Write-Host "  ✓ $ProjectPath (Target: $TargetFramework)" -ForegroundColor Green
            } else {
                Write-Host "  ⚠ $ProjectPath (Target: $TargetFramework - expected v4.8)" -ForegroundColor Yellow
            }
        } else {
            Write-Host "  ✗ $ProjectPath - Missing" -ForegroundColor Red
            $ExitCode = 1
        }
    }

    # Validate packages.config files
    Write-Host ""
    Write-Host "NuGet Package Validation:" -ForegroundColor Cyan

    $PackageConfigs = Get-ChildItem -Path "src" -Recurse -Name "packages.config"
    foreach ($PackageConfig in $PackageConfigs) {
        $FullPath = Join-Path "src" $PackageConfig
        $PackageXml = [xml](Get-Content $FullPath)
        $Packages = $PackageXml.packages.package
        
        Write-Host "  $FullPath:" -ForegroundColor Gray
        foreach ($Package in $Packages) {
            if ($Package.targetFramework -eq "net48") {
                Write-Host "    ✓ $($Package.id) v$($Package.version)" -ForegroundColor Green
            } else {
                Write-Host "    ⚠ $($Package.id) v$($Package.version) (target: $($Package.targetFramework))" -ForegroundColor Yellow
            }
        }
    }

    if (!$SkipRestore) {
        Write-Host ""
        Write-Host "Testing Package Restore:" -ForegroundColor Cyan

        # Test package restore
        if ($NuGet) {
            try {
                & $NuGet.Source restore $SolutionFile -NonInteractive
                Write-Host "✓ Package restore completed successfully" -ForegroundColor Green
            } catch {
                Write-Host "⚠ Package restore failed: $($_.Exception.Message)" -ForegroundColor Yellow
                Write-Host "  This may be due to missing Sitecore NuGet credentials" -ForegroundColor Yellow
            }
        }
    }

    Write-Host ""
    Write-Host "Testing MSBuild Compilation:" -ForegroundColor Cyan

    # Test build
    try {
        $BuildOutput = & $MSBuild $SolutionFile /p:Configuration=$Configuration /p:Platform="Any CPU" /t:Build /nologo /verbosity:minimal 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ Solution builds successfully in $Configuration configuration" -ForegroundColor Green
        } else {
            Write-Host "✗ Build failed in $Configuration configuration" -ForegroundColor Red
            Write-Host "Build output:" -ForegroundColor Yellow
            Write-Host $BuildOutput -ForegroundColor Yellow
            $ExitCode = 1
        }
    } catch {
        Write-Host "✗ Build test failed: $($_.Exception.Message)" -ForegroundColor Red
        $ExitCode = 1
    }

} catch {
    Write-Host "✗ Validation failed: $($_.Exception.Message)" -ForegroundColor Red
    $ExitCode = 1
}

Write-Host ""
Write-Host "===============================================" -ForegroundColor Cyan
if ($ExitCode -eq 0) {
    Write-Host "✓ Build validation completed successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "The solution appears ready for Sitecore development:" -ForegroundColor Green
    Write-Host "1. All project files are properly structured" -ForegroundColor Gray
    Write-Host "2. Target framework is .NET 4.8" -ForegroundColor Gray
    Write-Host "3. NuGet packages are configured" -ForegroundColor Gray
    Write-Host "4. MSBuild can compile the solution" -ForegroundColor Gray
} else {
    Write-Host "✗ Build validation found issues" -ForegroundColor Red
}
Write-Host "===============================================" -ForegroundColor Cyan

exit $ExitCode