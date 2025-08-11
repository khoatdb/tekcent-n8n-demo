using Sitecore.Data.Items;

namespace Foundation.Serialization.Services
{
    /// <summary>
    /// Interface for Sitecore item serialization services
    /// </summary>
    public interface ISerializationService
    {
        /// <summary>
        /// Serializes a Sitecore item to JSON format
        /// </summary>
        /// <param name="item">The Sitecore item to serialize</param>
        /// <returns>JSON representation of the item</returns>
        string SerializeItem(Item item);

        /// <summary>
        /// Deserializes JSON data back to Sitecore item structure
        /// </summary>
        /// <param name="json">The JSON data</param>
        /// <returns>Item data structure</returns>
        T DeserializeItem<T>(string json) where T : class;
    }
}