//
//  FlickrAPI.swift
//  FlickrDemo
//
//  Created by 陳駿逸 on 2020/3/3.
//  Copyright © 2020 陳駿逸. All rights reserved.
//

import UIKit
import Alamofire

class FlickrAPI {
    static let shared = FlickrAPI()
    fileprivate let alamoFireManager : Alamofire.SessionManager!
    
    init(){
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60 // seconds
        configuration.timeoutIntervalForResource = 60
        self.alamoFireManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    fileprivate func getStatusCodeFrom(_ response: DataResponse<Any>  ) -> Int {
        if let httpError = response.result.error?._code {
            return httpError
        } else {
            return (response.response?.statusCode)!
        }
    }
    
    fileprivate func validateResponseSuccess(_ response: DataResponse<Any>) -> Bool {
        print("Request: \(response.request!)")
        let success = response.result.isSuccess && (self.getStatusCodeFrom(response) == 200)
        print(success ? "SUCCESS" : "FAILURE")
        return success
    }
    
    // API Calls
    func flickrURLFromParameters(searchString: String, perPageCount: String, page: String) -> URL {
        
        // Build base URL
        var components = URLComponents()
        components.scheme = AIConstants.FlickrURLParams.APIScheme
        components.host = AIConstants.FlickrURLParams.APIHost
        components.path = AIConstants.FlickrURLParams.APIPath
        
        // Build query string
        components.queryItems = [URLQueryItem]()
        
        // Query components
        components.queryItems!.append(URLQueryItem(name: AIConstants.FlickrAPIKeys.APIKey, value: AIConstants.FlickrAPIValues.APIKey))
        components.queryItems!.append(URLQueryItem(name: AIConstants.FlickrAPIKeys.SearchMethod, value: AIConstants.FlickrAPIValues.SearchMethod))
        components.queryItems!.append(URLQueryItem(name: AIConstants.FlickrAPIKeys.ResponseFormat, value: AIConstants.FlickrAPIValues.ResponseFormat))
        components.queryItems!.append(URLQueryItem(name: AIConstants.FlickrAPIKeys.Extras, value: AIConstants.FlickrAPIValues.MediumURL))
        components.queryItems!.append(URLQueryItem(name: AIConstants.FlickrAPIKeys.SafeSearch, value: AIConstants.FlickrAPIValues.SafeSearch))
        components.queryItems!.append(URLQueryItem(name: AIConstants.FlickrAPIKeys.DisableJSONCallback, value: AIConstants.FlickrAPIValues.DisableJSONCallback))
        components.queryItems!.append(URLQueryItem(name: AIConstants.FlickrAPIKeys.Text, value: searchString))
        components.queryItems!.append(URLQueryItem(name: AIConstants.FlickrAPIKeys.PerPage, value: perPageCount))
        components.queryItems!.append(URLQueryItem(name: AIConstants.FlickrAPIKeys.Page, value: page))
        return components.url!
    }
    
    func getPhotos(searchURL: String,
                   handler: @escaping (_ depthJson: PhotoResults?, _ error: Error?) -> Void) {
        
        self.alamoFireManager.request(searchURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).validate(statusCode: 200..<600).validate(contentType: ["application/json"]).responseJSON { (response) in
            let success = self.validateResponseSuccess(response)
            
            if (success) {
                do {
                    let depthJson = try JSONDecoder().decode(PhotoResults.self, from: (response.data)!)
                    handler(depthJson, nil)
                } catch {
                    let error = NSError()
                    handler(nil, error)
                }
            } else {
                do {
                    let error = try JSONDecoder().decode(FlickrError.self, from: (response.data)!)
                    handler(nil, error)
                } catch {
                    print("get Depth API unknow error, please try again.")
                }
            }
        }
    }
}
