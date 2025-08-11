# Windows Build Validation Guide

This guide provides comprehensive instructions for validating the TekcentDemo Sitecore 10.4 solution build process on Windows environments.

## Prerequisites

### Required Software
- **Visual Studio 2019 or 2022** (Professional, Enterprise, or Community)
- **.NET Framework 4.8 SDK**
- **NuGet CLI** (optional, for package restore testing)

### Environment Setup
1. Ensure Visual Studio is properly installed with .NET Framework 4.8 support
2. Verify MSBuild is available (typically installed with Visual Studio)
3. Download NuGet CLI if needed: https://www.nuget.org/downloads

## Validation Methods

### Method 1: PowerShell Comprehensive Validation (Recommended)

The PowerShell script provides the most comprehensive validation:

```powershell
# Navigate to solution directory
cd path\to\tekcent-n8n-demo

# Run full validation (includes package restore and build test)
.\build\validate-build.ps1

# Skip package restore if already done
.\build\validate-build.ps1 -SkipRestore

# Test specific configuration
.\build\validate-build.ps1 -Configuration Release
```

**What it validates:**
- ✅ Solution file existence
- ✅ .NET Framework 4.8 availability (registry check)
- ✅ MSBuild location detection (VS 2019/2022)
- ✅ NuGet CLI availability
- ✅ Project file structure and target frameworks
- ✅ NuGet package configuration validation
- ✅ Package restore testing
- ✅ MSBuild compilation testing (Debug/Release)

### Method 2: Batch File Validation

For environments where PowerShell is restricted:

```cmd
# Run comprehensive batch validation
.\build\validate-build.bat
```

**Features:**
- ✅ All validation checks from PowerShell version
- ✅ Command prompt compatible
- ✅ Detailed error reporting
- ✅ Automatic MSBuild detection

### Method 3: Direct MSBuild Testing

For quick build verification:

```cmd
# Use the provided build script
.\build\build.bat
```

**Process:**
1. Locates MSBuild (VS 2022/2019)
2. Restores NuGet packages
3. Builds Debug configuration
4. Builds Release configuration
5. Reports success/failure

### Method 4: Manual Visual Studio Testing

1. Open `TekcentDemo.sln` in Visual Studio
2. Restore NuGet packages: `Tools` → `NuGet Package Manager` → `Package Manager Console`
   ```
   Update-Package -Reinstall
   ```
3. Build solution: `Build` → `Build Solution` (Ctrl+Shift+B)
4. Verify all projects compile successfully

## Expected Build Output

### Successful Build Artifacts

After successful build, expect these assemblies:

```
src\Foundation\Serialization\code\bin\Debug\Foundation.Serialization.dll
src\Foundation\DependencyInjection\code\bin\Debug\Foundation.DependencyInjection.dll
src\Feature\Navigation\code\bin\Debug\Feature.Navigation.dll  
src\Feature\Home\code\bin\Debug\Feature.Home.dll
src\Project\TekcentDemo\code\bin\Debug\Project.TekcentDemo.Website.dll
```

### Build Configuration

All projects target:
- **Target Framework**: .NET Framework 4.8
- **Platform**: Any CPU
- **Configurations**: Debug, Release

## Common Issues and Solutions

### Issue 1: MSBuild Not Found
**Error**: MSBuild not found at expected location

**Solution**: 
- Install Visual Studio 2019/2022
- Update script paths if custom VS installation location
- Use Developer Command Prompt

### Issue 2: .NET Framework 4.8 Missing
**Error**: TargetFrameworkVersion 'v4.8' not supported

**Solution**:
- Install .NET Framework 4.8 SDK
- Verify installation: `reg query "HKLM\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" /v Release`

### Issue 3: Package Restore Failures
**Error**: Unable to resolve Sitecore packages

**Solution**:
- Configure Sitecore NuGet credentials
- Add Sitecore MyGet feed authentication
- Use company's internal NuGet proxy if available

### Issue 4: Assembly Loading Issues
**Error**: Could not load file or assembly

**Solution**:
- Check assembly binding redirects in web.config
- Verify package versions match across projects
- Clean and rebuild solution

## Sitecore-Specific Considerations

### License Requirements
- Solution builds without Sitecore license
- Runtime requires valid license.xml in App_Data folder

### Database Dependencies  
- Build process doesn't require Sitecore databases
- Runtime requires properly configured connection strings

### Deployment Notes
- Solution builds assemblies suitable for Sitecore 10.4
- Requires Sitecore 10.4 runtime environment for execution
- Compatible with standard on-premise Sitecore installations

## Automated CI/CD Integration

### Azure DevOps
```yaml
- task: MSBuild@1
  inputs:
    solution: 'TekcentDemo.sln'
    msbuildArguments: '/p:Configuration=Release'
    platform: 'Any CPU'
```

### GitHub Actions
```yaml
- name: Build Solution
  run: |
    MSBuild.exe TekcentDemo.sln /p:Configuration=Release /p:Platform="Any CPU"
```

## Verification Checklist

Before considering the build successful, verify:

- [ ] All 5 projects compile without errors
- [ ] All assemblies are generated in bin folders
- [ ] No missing dependency warnings
- [ ] Web.config is valid XML
- [ ] Package restore completed successfully
- [ ] Both Debug and Release configurations build
- [ ] Assembly versions are set correctly
- [ ] All project references resolve properly

## Support

For build issues:
1. Run validation scripts first
2. Check Visual Studio Error List
3. Verify prerequisites are installed
4. Review MSBuild output for specific error details

The solution is designed to build cleanly on any Windows machine with Visual Studio and .NET Framework 4.8, without requiring Sitecore installation for compilation.