//
//  UserModel.swift
//  ConcurrencyExamples
//
//  Created by Joshua Park on 2020/08/28.
//  Copyright © 2020 Knowre. All rights reserved.
//

import Foundation

protocol UserModel {
    var id: String { get }
    var username: String { get }
    var pictureURL: URL { get }
}
