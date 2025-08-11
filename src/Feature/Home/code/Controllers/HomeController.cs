using System.Web.Mvc;
using Sitecore.Mvc.Controllers;

namespace Feature.Home.Controllers
{
    /// <summary>
    /// Controller for home page functionality
    /// </summary>
    public class HomeController : SitecoreController
    {
        /// <summary>
        /// Default action for the home page
        /// </summary>
        /// <returns>ActionResult for home page</returns>
        public ActionResult Index()
        {
            // Home page logic here
            return View();
        }

        /// <summary>
        /// Renders a hero banner component
        /// </summary>
        /// <returns>ActionResult for hero banner</returns>
        public ActionResult HeroBanner()
        {
            // Get hero banner data from current item
            return View();
        }

        /// <summary>
        /// Renders featured content section
        /// </summary>
        /// <returns>ActionResult for featured content</returns>
        public ActionResult FeaturedContent()
        {
            // Get featured content items
            return View();
        }
    }
}