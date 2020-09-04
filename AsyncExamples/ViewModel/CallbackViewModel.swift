//
//  CallbackViewModel.swift
//  ConcurrencyExamples
//
//  Created by Joshua Park on 2020/08/28.
//  Copyright © 2020 Knowre. All rights reserved.
//

import UIKit

final class CallbackViewModel : ViewModel {
    
    // MARK: Implement - BaseViewModel
    
    override
    func tapButton() {
        signInMessage = "로그인 하시겠습니까?"
        DispatchQueue.main.async { self.signInMessage = nil }
    }
    
    override
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
    
    override
    func signOut() {
        user = nil
        feed = []
    }
        
}
