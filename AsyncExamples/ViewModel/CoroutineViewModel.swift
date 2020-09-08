//
//  CoroutineViewModel.swift
//  AsyncExamples
//
//  Created by Joshua Park on 2020/09/07.
//  Copyright © 2020 Knowre. All rights reserved.
//

import UIKit
import SwiftCoroutine

final class CoroutineViewModel : BaseViewModel {
    
    override
    func tapButton() {
        DispatchQueue.main.startCoroutine {
            self._setAlertMessage("로그인 하시겠습니까?")
        }
    }
    
    override
    func signIn() {
        DispatchQueue.main.startCoroutine { self._signIn() }
    }
    
    override
    func signOut() {
        user = nil
        feed = []
    }
    
    // MARK: Private
    
    private let model = CoroutineModel()
    
    private func _setAlertMessage(_ message: String) {
        signInMessage = message
        try! Coroutine.delay(.never)
        signInMessage = nil
    }
    
    private func _signIn() {
        incrementLoading()
        
        do {
            let userModel = try model.signIn().await()
            user = User(id: userModel.id)
            user!.username = userModel.username
            user!.userImage = try model.resolveImage(url: userModel.pictureURL).await()
            
            let postList = try model.fetchPost(userID: userModel.id).await()
            feed = postList.map { Post(id: $0.id, userID: $0.userID, content: $0.content) }
            
            try postList
                .reduce(into: Set<String>()) { $0.insert($1.userID) }
                .map { model.fetchUser(id: $0) }
                .map {
                    let userModel = try $0.await()
                    
                    feed
                        .filter { $0.userID == userModel.id }
                        .forEach { $0.username = userModel.username }
                    
                    return (userModel.id, model.resolveImage(url: userModel.pictureURL))
                }
                .forEach{ (id: String, image: CoPromise<UIImage>) in
                    try feed
                        .filter { $0.userID == id }
                        .forEach { $0.userImage = try image.await() }
                }
        } catch {
            _setAlertMessage(error.localizedDescription)
        }
        
        decrementLoading()
    }
    
}

private let mainQueue = DispatchQueue.main

final class CoroutineModel {
    
    private var userRepo: UserRepository { UserRepository.shared }
    private var imageRepo: ImageRepository { ImageRepository.shared }
    private var postRepo: PostRepository { PostRepository.shared }
    
    func signIn() -> CoPromise<UserModel> {
        CoPromise<UserModel> { (result) in
            userRepo.signIn { (user, error) in
                if let user = user {
                    result(.success(user))
                } else {
                    result(.failure(error!))
                }
            }
        }
    }
    
    func fetchUser(id: String) -> CoPromise<UserModel> {
        CoPromise<UserModel> { (result) in
            userRepo.fetchUser(id: id) { (user, error) in
                if let user = user {
                    result(.success(user))
                } else {
                    result(.failure(error!))
                }
            }
        }
    }
    
    func resolveImage(url: URL) -> CoPromise<UIImage> {
        CoPromise<UIImage> { (result) in
            imageRepo.resolveImage(url: url) { (image, error) in
                if let image = image {
                    result(.success(image))
                } else {
                    result(.failure(error!))
                }
            }
        }
    }
    
    func fetchPost(userID: String) -> CoPromise<[PostModel]> {
        CoPromise<[PostModel]> { (result) in
            postRepo.fetchPost(userID: userID) { (posts, error) in
                if let posts = posts {
                    result(.success(posts))
                } else {
                    result(.failure(error!))
                }
            }
        }
    }
    
}
