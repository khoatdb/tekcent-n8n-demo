using Microsoft.Extensions.DependencyInjection;

namespace Foundation.DependencyInjection.Services
{
    /// <summary>
    /// Interface for configuring dependency injection services
    /// </summary>
    public interface IServiceConfigurationService
    {
        /// <summary>
        /// Configures services for dependency injection
        /// </summary>
        /// <param name="services">The service collection to configure</param>
        void ConfigureServices(IServiceCollection services);

        /// <summary>
        /// Registers foundation layer services
        /// </summary>
        /// <param name="services">The service collection</param>
        void RegisterFoundationServices(IServiceCollection services);
    }
}