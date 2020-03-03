//
//  DBPhoto.swift
//  FlickrDemo
//
//  Created by 陳駿逸 on 2020/3/3.
//  Copyright © 2020 陳駿逸. All rights reserved.
//

import UIKit
import RealmSwift

@objc class DBPhoto: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var owner: String = ""
    @objc dynamic var secret: String = ""
    @objc dynamic var server: String = ""
    @objc dynamic var farm: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var ispublic: Int = 0
    @objc dynamic var isfriend: Int = 0
    @objc dynamic var isfamily: Int = 0
    @objc dynamic var url_m: String = ""
    @objc dynamic var height_m: Int = 0
    @objc dynamic var width_m: Int = 0
    @objc dynamic var islike: Bool = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
