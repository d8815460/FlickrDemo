//
//  Model.swift
//  FlickrDemo
//
//  Created by 陳駿逸 on 2020/3/3.
//  Copyright © 2020 陳駿逸. All rights reserved.
//

import UIKit

struct PhotoResults: Hashable, Codable {
    var stat: String
    var photos: Photos
}

struct Photos: Hashable, Codable {
    var page: Int
    var pages: Int
    var perpage: Int
    var total: String
    var photo: [Photo]
}

struct Photo: Hashable, Codable {
    var id: String
    var owner: String?
    var secret: String?
    var server: String?
    var farm: Int?
    var title: String?
    var ispublic: Int?
    var isfriend: Int?
    var isfamily: Int?
    var url_m: String?
    var height_m: Int?
    var width_m: Int?
    var islike: Bool?
}
