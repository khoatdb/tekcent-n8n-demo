# TekcentDemo - Sitecore 10.4 Solution

This is a Sitecore 10.4 solution built following Helix architectural principles. The solution uses .NET Framework 4.8 and is configured for standard on-premise Sitecore deployment.

## Architecture Overview

The solution follows the **Helix** architecture pattern with three main layers:

### Foundation Layer
- **Foundation.Serialization**: Core serialization services for Sitecore items
- **Foundation.DependencyInjection**: Dependency injection configuration and services

### Feature Layer  
- **Feature.Navigation**: Site navigation functionality (main nav, breadcrumbs, footer nav)
- **Feature.Home**: Home page specific features and components

### Project Layer
- **Project.TekcentDemo.Website**: Main website project containing web configuration and global application settings

## Technology Stack

- **Framework**: .NET Framework 4.8
- **CMS**: Sitecore 10.4
- **Architecture**: Helix principles
- **Dependency Injection**: Microsoft.Extensions.DependencyInjection
- **JSON**: Newtonsoft.Json 13.0.3
- **MVC**: ASP.NET MVC 5.2.9

## Prerequisites

Before running this solution, ensure you have:

- Visual Studio 2019/2022
- .NET Framework 4.8 SDK
- Sitecore 10.4 license file
- SQL Server (2019 or later recommended)
- IIS with ASP.NET 4.8 support

## Getting Started

### 1. Clone the Repository

```bash
git clone <repository-url>
cd tekcent-n8n-demo
```

### 2. Validate Solution Structure

First, validate that the solution is properly structured:

```bash
# On Linux/Mac
bash scripts/validate.sh

# On Windows
scripts\validate.sh
```

### 3. Windows Build Validation

For comprehensive build validation on Windows, use the provided validation scripts:

#### Option 1: PowerShell Validation (Recommended)
```powershell
# Run comprehensive build validation
.\build\validate-build.ps1

# Skip package restore (if packages already restored)  
.\build\validate-build.ps1 -SkipRestore

# Test Release configuration
.\build\validate-build.ps1 -Configuration Release
```

#### Option 2: Batch File Validation
```cmd
# Run complete build validation
.\build\validate-build.bat
```

#### Option 3: MSBuild Direct Testing
```cmd
# Find MSBuild and test compilation
.\build\build.bat
```

The validation scripts will:
- ✅ Verify .NET Framework 4.8 availability
- ✅ Locate MSBuild (VS 2019/2022)
- ✅ Validate project structure and target frameworks
- ✅ Check NuGet package configurations  
- ✅ Test package restore process
- ✅ Attempt compilation in Debug/Release modes
- ✅ Verify assembly output and dependencies

### 4. Restore NuGet Packages

```bash
nuget restore TekcentDemo.sln
```

### 3. Build the Solution

Using the build scripts:

**Windows:**
```cmd
build\build.bat
```

**Linux/macOS:**
```bash
./build/build.sh
```

**Or manually with MSBuild:**
```cmd
msbuild TekcentDemo.sln /p:Configuration=Debug /p:Platform="Any CPU"
```

### 4. Sitecore Setup

1. Install Sitecore 10.4 using Sitecore Installation Assistant (SIA)
2. Place your license file at: `src/Project/TekcentDemo/code/App_Data/license.xml`
3. Update connection strings in `Web.config` to match your SQL Server instance
4. Configure your IIS site to point to: `src/Project/TekcentDemo/code/`
5. Set up the hostname `tekcentdemo.local` in your hosts file

### 5. Item Serialization

The solution uses Sitecore Content Serialization (SCS). To sync items:

```bash
dotnet sitecore ser pull
```

## Solution Structure

```
TekcentDemo/
├── src/
│   ├── Foundation/
│   │   ├── DependencyInjection/
│   │   └── Serialization/
│   ├── Feature/
│   │   ├── Home/
│   │   └── Navigation/
│   └── Project/
│       └── TekcentDemo/
│           └── code/              # Main website project
├── build/
│   ├── build.bat                  # Windows build script
│   └── build.sh                   # Linux/macOS build script  
├── serialization/                 # Sitecore item serialization
├── NuGet.config                   # NuGet package sources
├── sitecore.json                  # SCS configuration
└── TekcentDemo.sln               # Visual Studio solution
```

## Configuration

### Database Connections

Update the connection strings in `Web.config` for your environment:

- `core`: Sitecore Core database
- `master`: Sitecore Master database  
- `web`: Sitecore Web database
- Additional databases as needed

### Site Configuration

The main site is configured in `App_Config/Sitecore.config`:

- **Site name**: tekcentdemo
- **Hostname**: tekcentdemo.local
- **Root path**: /sitecore/content/TekcentDemo
- **Database**: web

## Development Guidelines

### Helix Principles

1. **Foundation Layer**: Contains only base functionality that other layers depend on
2. **Feature Layer**: Contains business features that can reference Foundation but not other Features
3. **Project Layer**: Contains site-specific implementations and can reference both Foundation and Feature layers

### Dependencies

- Foundation projects should not reference Feature or Project layers
- Feature projects can reference Foundation projects but not other Feature projects
- Project layer can reference both Foundation and Feature projects

### Naming Conventions

- Assemblies: `Layer.Module` (e.g., `Feature.Navigation`)
- Namespaces: Match assembly names
- Templates: `/sitecore/templates/Layer/Module/`
- Renderings: `/sitecore/layout/Renderings/Layer/Module/`

## Building and Deployment

### Local Development

1. Build the solution in Visual Studio or using build scripts
2. Copy assemblies to your Sitecore `bin` folder
3. Publish website files to your Sitecore website root
4. Sync serialized items using SCS

### CI/CD

The build scripts can be integrated into your CI/CD pipeline:

- Use `build/build.bat` for Windows agents
- Use `build/build.sh` for Linux agents
- Artifacts are generated in each project's `bin` folder

## Troubleshooting

### Common Issues

1. **License Error**: Ensure `license.xml` is in `App_Data` folder
2. **Database Connection**: Verify connection strings in `Web.config`
3. **Build Errors**: Ensure all NuGet packages are restored
4. **IIS Issues**: Check .NET Framework 4.8 is installed and enabled

### Support

For questions and support, please refer to:

- Sitecore documentation: https://doc.sitecore.com/
- Helix documentation: https://helix.sitecore.net/
- Project issues: Create an issue in this repository

## License

This project is licensed under the MIT License - see the LICENSE file for details.