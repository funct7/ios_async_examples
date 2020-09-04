//
//  RxViewModel.swift
//  AsyncExamples
//
//  Created by Joshua Park on 2020/09/04.
//  Copyright © 2020 Knowre. All rights reserved.
//

import UIKit
import RxSwift

final class RxViewModel : ViewModel {
    
    // MARK: Implement - ViewModel
    
    override
    func signIn() {
        let signInObservable = model.signIn()
            .asObservable()
            .share()
            
        signInObservable
            .do(onSubscribed: { [unowned self] in
                self.incrementLoading()
            })
            .subscribe(
                onNext: { [unowned self] in
                    self.user = User(id: $0.id)
                    self.user!.username = $0.username
                },
                onError: { [unowned self] in
                    self.alertMessage = $0.localizedDescription
                },
                onDisposed: { [unowned self] in
                    self.alertMessage = nil
                    self.decrementLoading()
                })
            .disposed(by: disposeBag)
        
        signInObservable
            .flatMapLatest { [unowned self] in
                self.model.resolveImage(url: $0.pictureURL)
            }
            .do(onSubscribed: { [unowned self] in
                self.incrementLoading()
            })
            .subscribe(
                onNext: { [unowned self] in
                    self.user?.userImage = $0
                },
                onError: { [unowned self] in
                    self.alertMessage = $0.localizedDescription
                },
                onDisposed: {
                    self.alertMessage = nil
                    self.decrementLoading()
                })
            .disposed(by: disposeBag)

        signInObservable
            .flatMapLatest { [unowned self] in
                self.model.fetchPost(userID: $0.id)
            }
            .do(onSubscribed: { [unowned self] in
                self.incrementLoading()
            })
            .flatMapLatest { [unowned self] (postList) -> Observable<UserModel> in
                self.feed = postList.map {
                    Post(id: $0.id, userID: $0.userID, content: $0.content)
                }

                let batch = postList
                    .reduce(into: Set<String>()) { $0.insert($1.userID) }
                    .map { self.model.fetchUser(id: $0).asObservable() }

                return Observable<UserModel>.merge(batch)
            }
            .flatMap { [unowned self] (user) -> Single<(String, UIImage)> in
                self.feed
                    .filter { $0.userID == user.id }
                    .forEach { $0.username = user.username }

                return self.model
                    .resolveImage(url: user.pictureURL)
                    .map { (user.id, $0) }
            }
            .subscribe(
                onNext: { [unowned self] (userID, image) in
                    self.feed
                        .filter { $0.userID == userID }
                        .forEach { $0.userImage = image }
                },
                onError: { [unowned self] in
                    self.alertMessage = $0.localizedDescription
                },
                onDisposed: { [unowned self] in
                    self.alertMessage = nil
                    self.decrementLoading()
                })
            .disposed(by: disposeBag)
    }
    
    // MARK: Private
    
    private let model: RxModel = .init()
    
    private let disposeBag: DisposeBag = .init()
    
}

private class RxModel {
    
    private var userRepository: UserRepository { .shared }
    private var imageRepository: ImageRepository { .shared }
    private var postRepository: PostRepository { .shared }
    
    private var signInSubject: PublishSubject<UserModel>!
    
    func signIn() -> Single<UserModel> {
        signInSubject = .init()
        userRepository.signIn { [weak self] in
            if let user = $0 {
                self?.signInSubject.onNext(user)
            } else {
                self?.signInSubject.onError($1!)
            }
        }
        
        return Single.create { [unowned self] (cont) in
            self.signInSubject.subscribe(
                onNext: {
                    cont(.success($0))
                },
                onError: {
                    cont(.error($0))
                })
        }
    }
    
    private var fetchUserSubject: PublishSubject<UserModel>!
    
    func fetchUser(id: String) -> Single<UserModel> {
        fetchUserSubject = .init()
        userRepository.fetchUser(id: id) { [weak self] in
            if let user = $0 {
                self?.fetchUserSubject.onNext(user)
            } else {
                self?.fetchUserSubject.onError($1!)
            }
        }
        
        return Single.create { [unowned self] (cont) in
            self.fetchUserSubject.subscribe(
                onNext: {
                    cont(.success($0))
                },
                onError: {
                    cont(.error($0))
                })
        }
    }
    
    private var resolveImageSubject: PublishSubject<UIImage>!
    
    func resolveImage(url: URL) -> Single<UIImage> {
        resolveImageSubject = .init()
        imageRepository.resolveImage(url: url) { [weak self] in
            if let image = $0 {
                self?.resolveImageSubject.onNext(image)
            } else {
                self?.resolveImageSubject.onError($1!)
            }
        }
        
        return Single.create { [unowned self] (cont) in
            self.resolveImageSubject.subscribe(
                onNext: {
                    cont(.success($0))
                },
                onError: {
                    cont(.error($0))
                })
        }
    }
    
    private var postListSubject: PublishSubject<[PostModel]>!
    
    func fetchPost(userID: String) -> Single<[PostModel]> {
        postListSubject = .init()
        postRepository.fetchPost(userID: userID) { [weak self] in
            if let postList = $0 {
                self?.postListSubject.onNext(postList)
            } else {
                self?.postListSubject.onError($1!)
            }
        }
        
        return Single.create { [unowned self] (cont) in
            self.postListSubject.subscribe(
                onNext: {
                    cont(.success($0))
                },
                onError: {
                    cont(.error($0))
                })
        }
    }
    
}
