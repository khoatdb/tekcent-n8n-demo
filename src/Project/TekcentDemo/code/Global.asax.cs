using System;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using Microsoft.Extensions.DependencyInjection;
using Foundation.DependencyInjection.Services;

namespace Project.TekcentDemo.Website
{
    /// <summary>
    /// Global application class for Sitecore website
    /// </summary>
    public class Global : HttpApplication
    {
        /// <summary>
        /// Application start event handler
        /// </summary>
        protected void Application_Start()
        {
            // Configure dependency injection
            ConfigureServices();
            
            // Initialize MVC areas
            AreaRegistration.RegisterAllAreas();
            
            // Configure routes
            RegisterRoutes(RouteTable.Routes);
        }

        /// <summary>
        /// Configures dependency injection services
        /// </summary>
        private void ConfigureServices()
        {
            var services = new ServiceCollection();
            var serviceConfigurationService = new ServiceConfigurationService();
            serviceConfigurationService.ConfigureServices(services);
            
            // Build service provider
            var serviceProvider = services.BuildServiceProvider();
            
            // Store service provider for later use
            Application["ServiceProvider"] = serviceProvider;
        }

        /// <summary>
        /// Registers MVC routes
        /// </summary>
        /// <param name="routes">Route collection</param>
        protected void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");
            
            // Default route for Sitecore
            routes.MapRoute(
                name: "Default",
                url: "{controller}/{action}/{id}",
                defaults: new { controller = "Home", action = "Index", id = UrlParameter.Optional }
            );
        }

        /// <summary>
        /// Application error handler
        /// </summary>
        /// <param name="sender">Event sender</param>
        /// <param name="e">Event arguments</param>
        protected void Application_Error(object sender, EventArgs e)
        {
            // Log errors here
            Exception exception = Server.GetLastError();
            // TODO: Add logging implementation
        }
    }
}