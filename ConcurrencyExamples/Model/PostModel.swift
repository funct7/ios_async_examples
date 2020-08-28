//
//  PostModel.swift
//  ConcurrencyExamples
//
//  Created by Joshua Park on 2020/08/28.
//  Copyright © 2020 Knowre. All rights reserved.
//

import Foundation

protocol PostModel {
    var id: String { get }
    var name: String { get }
    var userImage: UIImage? { get }
    var content: String { get }
}

protocol NSObjectPostModel : NSObjectProtocol, PostModel { }
