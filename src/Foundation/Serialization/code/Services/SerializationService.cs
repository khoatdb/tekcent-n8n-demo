using System;
using Newtonsoft.Json;
using Sitecore.Data.Items;
using Foundation.Serialization.Services;

namespace Foundation.Serialization.Services
{
    /// <summary>
    /// Default implementation of Sitecore item serialization service
    /// </summary>
    public class SerializationService : ISerializationService
    {
        /// <summary>
        /// Serializes a Sitecore item to JSON format
        /// </summary>
        /// <param name="item">The Sitecore item to serialize</param>
        /// <returns>JSON representation of the item</returns>
        public string SerializeItem(Item item)
        {
            if (item == null)
                throw new ArgumentNullException(nameof(item));

            var itemData = new
            {
                Id = item.ID.ToString(),
                Name = item.Name,
                DisplayName = item.DisplayName,
                TemplateName = item.TemplateName,
                Path = item.Paths.FullPath,
                Language = item.Language.Name,
                Version = item.Version.Number,
                Fields = GetFieldValues(item)
            };

            return JsonConvert.SerializeObject(itemData, Formatting.Indented);
        }

        /// <summary>
        /// Deserializes JSON data back to specified type
        /// </summary>
        /// <typeparam name="T">The type to deserialize to</typeparam>
        /// <param name="json">The JSON data</param>
        /// <returns>Deserialized object</returns>
        public T DeserializeItem<T>(string json) where T : class
        {
            if (string.IsNullOrWhiteSpace(json))
                throw new ArgumentException("JSON cannot be null or empty", nameof(json));

            return JsonConvert.DeserializeObject<T>(json);
        }

        /// <summary>
        /// Extracts field values from a Sitecore item
        /// </summary>
        /// <param name="item">The Sitecore item</param>
        /// <returns>Dictionary of field names and values</returns>
        private object GetFieldValues(Item item)
        {
            var fields = new System.Collections.Generic.Dictionary<string, object>();
            
            foreach (Sitecore.Data.Fields.Field field in item.Fields)
            {
                if (field != null && !string.IsNullOrEmpty(field.Name) && !field.Name.StartsWith("__"))
                {
                    fields[field.Name] = field.Value;
                }
            }
            
            return fields;
        }
    }
}