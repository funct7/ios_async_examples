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
    
    @objc
    private(set) dynamic var isLoading: Bool = false
    
    func tapButton() {
        signInMessage = "로그인 하시겠습니까?"
        DispatchQueue.main.async { self.signInMessage = nil }
    }
    
    func signIn() {
        incrementLoading()
        
        UserRepository.shared.signIn { [weak self] (user, error) in
            guard let self = self else { return }
            
            if let user = user {
                self.user = User(id: user.id)
                self.user?.username = user.username
                
                self.incrementLoading()
                
                ImageRepository.shared.resolveImage(url: user.pictureURL) { [weak self] (image, error) in
                    guard let self = self else { return }
                    
                    if let image = image {
                        self.user?.userImage = image
                    } else {
                        self.setAlertMessage(error!.localizedDescription)
                    }
                    
                    self.decrementLoading()
                }
                
                self.incrementLoading()
                
                PostRepository.shared.fetchPost(userID: user.id) { [weak self] (postList, error) in
                    guard let self = self else { return }
                    
                    if let postList = postList {
                        self.feed = postList.map {
                            Post(id: $0.id, userID: $0.userID, content: $0.content)
                        }
                        
                        postList
                            .reduce(into: Set<String>()) { $0.insert($1.userID) }
                            .forEach {
                                self.incrementLoading()
                                
                                UserRepository.shared.fetchUser(id: $0) { [weak self] (user, error) in
                                    guard let self = self else { return }
                                    
                                    if let user = user {
                                        self.feed
                                            .filter { $0.userID == user.id }
                                            .forEach { $0.username = user.username }
                                        
                                        self.incrementLoading()
                                        
                                        ImageRepository.shared.resolveImage(url: user.pictureURL) { [weak self] (image, error) in
                                            guard let self = self else { return }
                                            
                                            if let image = image {
                                                self.feed
                                                    .filter { $0.userID == user.id }
                                                    .forEach { $0.userImage = image }
                                            } else {
                                                self.setAlertMessage(error!.localizedDescription)
                                            }
                                            
                                            self.decrementLoading()
                                        }
                                    } else {
                                        self.setAlertMessage(error!.localizedDescription)
                                    }
                                    
                                    self.decrementLoading()
                                }
                            }
                    } else {
                        self.setAlertMessage(error!.localizedDescription)
                    }
                    
                    self.decrementLoading()
                }
            } else {
                self.setAlertMessage(error!.localizedDescription)
            }
            
            self.decrementLoading()
        }
    }
    
    func signOut() {
        user = nil
        feed = []
    }
    
    // MARK: Private
    
    private func setAlertMessage(_ message: String) {
        alertMessage = message
        DispatchQueue.main.async { self.alertMessage = nil }
    }
    
    private var loadingCount: Int = 0 {
        didSet { isLoading = loadingCount > 0 }
    }
    
    private func incrementLoading() {
        loadingCount += 1
    }
    
    private func decrementLoading() {
        loadingCount -= 1
    }
    
}

extension CallbackViewModel {
    
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
    
}
