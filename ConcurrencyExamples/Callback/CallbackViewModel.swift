//
//  CallbackViewModel.swift
//  ConcurrencyExamples
//
//  Created by Joshua Park on 2020/08/28.
//  Copyright © 2020 Knowre. All rights reserved.
//

import UIKit

protocol CallbackViewModel : NSObjectProtocol {
    
    dynamic var user: NSObjectUserModel? { get }
    dynamic var userImage: UIImage? { get }
    dynamic var feed: [PostModel] { get }
    
    dynamic var alertMessage: String? { get }
    
    func tapButton()
    func signIn()
    
}
