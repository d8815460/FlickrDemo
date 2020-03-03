//
//  Error+FlickrError.swift
//  FlickrDemo
//
//  Created by 陳駿逸 on 2020/3/3.
//  Copyright © 2020 陳駿逸. All rights reserved.
//

import UIKit

// MARK: - FlickrError

struct FlickrError: Error, Decodable {
    let code: Int
    let msg: String
}

extension FlickrError: CustomStringConvertible { var description: String { return localizedDescription } }
