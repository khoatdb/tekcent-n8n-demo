using System;
using System.IO;
using System.Reflection;
using System.Diagnostics;

namespace BuildValidator
{
    /// <summary>
    /// Simple build validator to test if the solution can be compiled on Windows
    /// This utility loads the compiled assemblies to verify they were built correctly
    /// </summary>
    class Program
    {
        static int Main(string[] args)
        {
            Console.WriteLine("===============================================");
            Console.WriteLine("TekcentDemo Solution Build Validator");
            Console.WriteLine("===============================================");
            Console.WriteLine();

            bool success = true;
            string baseDir = AppDomain.CurrentDomain.BaseDirectory;
            string solutionDir = Directory.GetParent(baseDir).Parent.Parent.Parent.FullName;

            Console.WriteLine($"Solution directory: {solutionDir}");
            Console.WriteLine();

            // Expected assemblies after successful build
            string[] expectedAssemblies = {
                @"src\Foundation\Serialization\code\bin\Debug\Foundation.Serialization.dll",
                @"src\Foundation\DependencyInjection\code\bin\Debug\Foundation.DependencyInjection.dll",
                @"src\Feature\Navigation\code\bin\Debug\Feature.Navigation.dll",
                @"src\Feature\Home\code\bin\Debug\Feature.Home.dll",
                @"src\Project\TekcentDemo\code\bin\Debug\Project.TekcentDemo.Website.dll"
            };

            Console.WriteLine("Checking for compiled assemblies:");
            Console.WriteLine("--------------------------------");

            foreach (string assemblyPath in expectedAssemblies)
            {
                string fullPath = Path.Combine(solutionDir, assemblyPath);
                if (File.Exists(fullPath))
                {
                    try
                    {
                        // Try to load the assembly to verify it was built correctly
                        Assembly assembly = Assembly.LoadFrom(fullPath);
                        FileVersionInfo versionInfo = FileVersionInfo.GetVersionInfo(fullPath);
                        
                        Console.WriteLine($"✓ {Path.GetFileName(fullPath)} - v{versionInfo.FileVersion}");
                        Console.WriteLine($"  Location: {assemblyPath}");
                        Console.WriteLine($"  Types: {assembly.GetTypes().Length}");
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($"✗ {Path.GetFileName(fullPath)} - Failed to load: {ex.Message}");
                        success = false;
                    }
                }
                else
                {
                    Console.WriteLine($"✗ {Path.GetFileName(fullPath)} - Not found");
                    Console.WriteLine($"  Expected: {assemblyPath}");
                    success = false;
                }
                Console.WriteLine();
            }

            // Check web.config exists
            string webConfigPath = Path.Combine(solutionDir, @"src\Project\TekcentDemo\code\Web.config");
            if (File.Exists(webConfigPath))
            {
                Console.WriteLine("✓ Web.config found and accessible");
            }
            else
            {
                Console.WriteLine("✗ Web.config not found");
                success = false;
            }

            Console.WriteLine();
            Console.WriteLine("===============================================");
            if (success)
            {
                Console.WriteLine("✓ BUILD VALIDATION SUCCESSFUL!");
                Console.WriteLine("All assemblies were built and can be loaded correctly.");
            }
            else
            {
                Console.WriteLine("✗ BUILD VALIDATION FAILED!");
                Console.WriteLine("Some assemblies are missing or corrupted.");
            }
            Console.WriteLine("===============================================");

            return success ? 0 : 1;
        }
    }
}