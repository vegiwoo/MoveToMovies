# DefaultAPI

All URIs are relative to *http://www.omdbapi.com*

Method | HTTP request | Description
------------- | ------------- | -------------
[**rootGet**](DefaultAPI.md#rootget) | **GET** / | Returns the result of a search query by name of movie/tvshow.


# **rootGet**
```swift
    open class func rootGet(s: String, apikey: String, completion: @escaping (_ data: InlineResponse200?, _ error: Error?) -> Void)
```

Returns the result of a search query by name of movie/tvshow.

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OmdbAPI

let s = "s_example" // String | Movie title to search for.
let apikey = "apikey_example" // String | API key for using the service.

// Returns the result of a search query by name of movie/tvshow.
DefaultAPI.rootGet(s: s, apikey: apikey) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **s** | **String** | Movie title to search for. | 
 **apikey** | **String** | API key for using the service. | 

### Return type

[**InlineResponse200**](InlineResponse200.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

