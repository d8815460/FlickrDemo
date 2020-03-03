//
//  AIConstants.swift
//  FlickrDemo
//
//  Created by 陳駿逸 on 2020/3/3.
//  Copyright © 2020 陳駿逸. All rights reserved.
//

import UIKit

struct AIConstants {
    struct FlickrURLParams {
        static let APIScheme = "https"
        static let APIHost = "api.flickr.com"
        static let APIPath = "/services/rest"
    }
    
    struct FlickrAPIKeys {
        static let SearchMethod = "method"
        static let APIKey = "api_key"
        static let Extras = "extras"
        static let PerPage = "per_page"
        static let Page = "page"
        static let ResponseFormat = "format"
        static let DisableJSONCallback = "nojsoncallback"
        static let SafeSearch = "safe_search"
        static let Text = "text"
    }
    
    struct FlickrAPIValues {
        static let SearchMethod = "flickr.photos.search"
        static let APIKey = "c91566370ee553deb75e142ff13dee57"
        static let ResponseFormat = "json"
        static let DisableJSONCallback = "1"
        static let MediumURL = "url_m"
        static let SafeSearch = "1"
    }
    
    
}
