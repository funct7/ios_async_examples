//
//  ViewModel.swift
//  Callback
//
//  Created by Joshua Park on 2020/09/04.
//  Copyright © 2020 Knowre. All rights reserved.
//

import UIKit

class ViewModel : ObservableObject {

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

    @objc dynamic var isSignInButtonVisible: Bool = true
    
    @objc dynamic var isUserViewVisible: Bool = false
    
    @objc dynamic var user: User? = nil {
        didSet {
            isSignInButtonVisible = user == nil
            isUserViewVisible = user != nil
        }
    }
    
    @objc dynamic var feed: [Post] = []
    
    @objc dynamic var signInMessage: String? = nil
    
    @objc dynamic var alertMessage: String? = nil
    
    @objc dynamic var isLoading: Bool = false
    
    func tapButton() { fatalError("implement in subclass") }
    
    func signIn() { fatalError("implement in subclass") }
    
    func signOut() { fatalError("implement in subclass") }
    
    // MARK: Interface
    
    func setAlertMessage(_ message: String) {
        alertMessage = message
        DispatchQueue.main.async { self.alertMessage = nil }
    }
    
    private(set) var loadingCount: Int = 0 {
        didSet { isLoading = loadingCount > 0 }
    }
    
    func incrementLoading() { loadingCount += 1 }
    
    func decrementLoading() { loadingCount -= 1 }
    
}
