//
//  CallbackViewModel.swift
//  ConcurrencyExamples
//
//  Created by Joshua Park on 2020/08/28.
//  Copyright © 2020 Knowre. All rights reserved.
//

import UIKit

final class CallbackViewModel : ObservableObject {
    
    // MARK: Interface
    
    @objc
    private(set) dynamic var isSignInButtonVisible: Bool = true
    
    @objc
    private(set) dynamic var isUserViewVisible: Bool = false
    
    @objc
    private(set) dynamic var user: User? = nil {
        didSet {
            isSignInButtonVisible = user == nil
            isUserViewVisible = user != nil
        }
    }
    
    @objc
    private(set) dynamic var feed: [Post] = []
    
    @objc
    private(set) dynamic var signInMessage: String? = nil
    
    @objc
    private(set) dynamic var alertMessage: String? = nil
    
    func tapButton() {
        signInMessage = "로그인 하시겠습니까?"
        DispatchQueue.main.async { self.signInMessage = nil }
    }
    
    func signIn() {
        UserRepository.shared.signIn { [weak self] (user, error) in
            if let user = user {
                self?.user = User(id: user.id)
                self?.user?.username = user.username
                
                ImageRepository.shared.resolveImage(url: user.pictureURL) { [weak self] (image, error) in
                    if let image = image {
                        self?.user?.userImage = image
                    } else {
                        self?.setAlertMessage(error!.localizedDescription)
                    }
                }
                
                PostRepository.shared.fetchPost(userID: user.id) { [weak self] (postList, error) in
                    if let postList = postList {
                        self?.feed = postList.map {
                            Post(id: $0.id, userID: $0.userID, content: $0.content)
                        }
                        
                        postList
                            .reduce(into: Set<String>()) { $0.insert($1.id) }
                            .forEach {
                                UserRepository.shared.fetchUser(id: $0) { [weak self] (user, error) in
                                    if let user = user {
                                        self?.feed
                                            .filter { $0.userID == user.id }
                                            .forEach { $0.username = user.username }
                                        
                                        ImageRepository.shared.resolveImage(url: user.pictureURL) { (image, error) in
                                            if let image = image {
                                                self?.feed
                                                    .filter { $0.userID == user.id }
                                                    .forEach { $0.userImage = image }
                                            } else {
                                                self?.setAlertMessage(error!.localizedDescription)
                                            }
                                        }
                                    } else {
                                        self?.setAlertMessage(error!.localizedDescription)
                                    }
                                }
                            }
                    } else {
                        self?.setAlertMessage(error!.localizedDescription)
                    }
                }
            } else {
                self?.setAlertMessage(error!.localizedDescription)
            }
        }
    }
    
    // MARK: Private
    
    private func setAlertMessage(_ message: String) {
        alertMessage = message
        DispatchQueue.main.async { self.alertMessage = nil }
    }
    
}

extension CallbackViewModel {
    
    final class User : NSObject {
        let id: String
        var username: String! = nil
        var userImage: UIImage? = nil
        
        init(id: String) {
            self.id = id
            super.init()
        }
    }
    
    final class Post : NSObject {
        let id: String
        var userID: String
        var username: String! = nil
        var userImage: UIImage? = nil
        var content: String
        
        init(id: String, userID: String, content: String) {
            self.id = id
            self.userID = userID
            self.content = content
            super.init()
        }
    }
    
}
