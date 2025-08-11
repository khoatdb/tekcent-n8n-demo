#!/bin/bash
# Validation script to verify Sitecore solution structure
echo "==============================================="
echo "Validating TekcentDemo Sitecore Solution"
echo "==============================================="

# Check solution file
if [ -f "TekcentDemo.sln" ]; then
    echo "✓ Solution file exists: TekcentDemo.sln"
else
    echo "✗ Solution file missing: TekcentDemo.sln"
    exit 1
fi

# Check Helix structure
echo ""
echo "Checking Helix architecture structure..."

# Foundation layer
if [ -d "src/Foundation" ]; then
    echo "✓ Foundation layer exists"
    
    if [ -f "src/Foundation/Serialization/code/Foundation.Serialization.csproj" ]; then
        echo "  ✓ Foundation.Serialization project"
    else
        echo "  ✗ Foundation.Serialization project missing"
    fi
    
    if [ -f "src/Foundation/DependencyInjection/code/Foundation.DependencyInjection.csproj" ]; then
        echo "  ✓ Foundation.DependencyInjection project"
    else
        echo "  ✗ Foundation.DependencyInjection project missing"
    fi
else
    echo "✗ Foundation layer missing"
    exit 1
fi

# Feature layer
if [ -d "src/Feature" ]; then
    echo "✓ Feature layer exists"
    
    if [ -f "src/Feature/Navigation/code/Feature.Navigation.csproj" ]; then
        echo "  ✓ Feature.Navigation project"
    else
        echo "  ✗ Feature.Navigation project missing"
    fi
    
    if [ -f "src/Feature/Home/code/Feature.Home.csproj" ]; then
        echo "  ✓ Feature.Home project"
    else
        echo "  ✗ Feature.Home project missing"
    fi
else
    echo "✗ Feature layer missing"
    exit 1
fi

# Project layer
if [ -d "src/Project" ]; then
    echo "✓ Project layer exists"
    
    if [ -f "src/Project/TekcentDemo/code/Project.TekcentDemo.Website.csproj" ]; then
        echo "  ✓ Project.TekcentDemo.Website project"
    else
        echo "  ✗ Project.TekcentDemo.Website project missing"
    fi
else
    echo "✗ Project layer missing"
    exit 1
fi

# Check configuration files
echo ""
echo "Checking configuration files..."

if [ -f "NuGet.config" ]; then
    echo "✓ NuGet.config exists"
else
    echo "✗ NuGet.config missing"
fi

if [ -f "sitecore.json" ]; then
    echo "✓ sitecore.json exists (SCS configuration)"
else
    echo "✗ sitecore.json missing"
fi

if [ -f ".gitignore" ]; then
    echo "✓ .gitignore exists"
else
    echo "✗ .gitignore missing"
fi

# Check web.config
if [ -f "src/Project/TekcentDemo/code/Web.config" ]; then
    echo "✓ Web.config exists"
else
    echo "✗ Web.config missing"
fi

# Check build scripts
if [ -f "build/build.bat" ] && [ -f "build/build.sh" ]; then
    echo "✓ Build scripts exist"
else
    echo "✗ Build scripts missing"
fi

echo ""
echo "==============================================="
echo "Solution validation completed!"
echo "==============================================="
echo ""
echo "Next steps:"
echo "1. Install Sitecore 10.4"
echo "2. Update connection strings in Web.config"
echo "3. Add license.xml to App_Data folder"
echo "4. Build solution: ./build/build.sh"
echo "5. Deploy to IIS and configure site"