using Microsoft.Extensions.DependencyInjection;
using Foundation.DependencyInjection.Services;

namespace Foundation.DependencyInjection.Services
{
    /// <summary>
    /// Default implementation for configuring dependency injection services
    /// </summary>
    public class ServiceConfigurationService : IServiceConfigurationService
    {
        /// <summary>
        /// Configures services for dependency injection
        /// </summary>
        /// <param name="services">The service collection to configure</param>
        public void ConfigureServices(IServiceCollection services)
        {
            RegisterFoundationServices(services);
            RegisterFeatureServices(services);
            RegisterProjectServices(services);
        }

        /// <summary>
        /// Registers foundation layer services
        /// </summary>
        /// <param name="services">The service collection</param>
        public void RegisterFoundationServices(IServiceCollection services)
        {
            // Register foundation layer services here
            // Example: services.AddTransient<ISerializationService, SerializationService>();
        }

        /// <summary>
        /// Registers feature layer services
        /// </summary>
        /// <param name="services">The service collection</param>
        private void RegisterFeatureServices(IServiceCollection services)
        {
            // Register feature layer services here
            // Example: services.AddTransient<INavigationService, NavigationService>();
        }

        /// <summary>
        /// Registers project layer services
        /// </summary>
        /// <param name="services">The service collection</param>
        private void RegisterProjectServices(IServiceCollection services)
        {
            // Register project-specific services here
            // Example: services.AddTransient<IHomeService, HomeService>();
        }
    }
}