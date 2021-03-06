//
// DefaultAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

open class DefaultAPI {
    /**
     Returns the result of a search query by name of movie/tvshow.
     
     - parameter s: (query) Movie title to search for. 
     - parameter apikey: (query) API key for using the service. 
     - parameter page: (query) Рage number of the selection of results (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func rootGet(s: String, apikey: String, page: Int? = nil, apiResponseQueue: DispatchQueue = OmdbAPIAPI.apiResponseQueue, completion: @escaping ((_ data: InlineResponse200?, _ error: Error?) -> Void)) {
        rootGetWithRequestBuilder(s: s, apikey: apikey, page: page).execute(apiResponseQueue) { result -> Void in
            switch result {
            case let .success(response):
                completion(response.body, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }

    /**
     Returns the result of a search query by name of movie/tvshow.
     - GET /
     - parameter s: (query) Movie title to search for. 
     - parameter apikey: (query) API key for using the service. 
     - parameter page: (query) Рage number of the selection of results (optional)
     - returns: RequestBuilder<InlineResponse200> 
     */
    open class func rootGetWithRequestBuilder(s: String, apikey: String, page: Int? = nil) -> RequestBuilder<InlineResponse200> {
        let path = "/"
        let URLString = OmdbAPIAPI.basePath + path
        let parameters: [String: Any]? = nil

        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems([
            "s": s.encodeToJSON(),
            "apikey": apikey.encodeToJSON(),
            "page": page?.encodeToJSON(),
        ])

        let nillableHeaders: [String: Any?] = [
            :
        ]

        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<InlineResponse200>.Type = OmdbAPIAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, headers: headerParameters)
    }

}
