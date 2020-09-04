//
//  ViewModel.swift
//  Callback
//
//  Created by Joshua Park on 2020/09/04.
//  Copyright © 2020 Knowre. All rights reserved.
//

import UIKit

@objc protocol ViewModel : NSObjectProtocol, ObservedObject {
    
    @objc dynamic var isSignInButtonVisible: Bool { get }
    @objc dynamic var isUserViewVisible: Bool { get }
    @objc dynamic var user: User? { get }
    @objc dynamic var feed: [Post] { get }
    @objc dynamic var signInMessage: String? { get }
    @objc dynamic var alertMessage: String? { get }
    @objc dynamic var isLoading: Bool { get }
    
    func tapButton()
    func signIn()
    
}

final class User : NSObject {
    let id: String
    @objc dynamic var username: String! = nil
    @objc dynamic var userImage: UIImage? = nil
    
    init(id: String) {
        self.id = id
        super.init()
    }
}

final class Post : ObservableObject {
    let id: String
    @objc dynamic var userID: String
    @objc dynamic var username: String! = nil
    @objc dynamic var userImage: UIImage? = nil
    @objc dynamic var content: String
    
    init(id: String, userID: String, content: String) {
        self.id = id
        self.userID = userID
        self.content = content
        super.init()
    }
}
