//
//  AppDelegate.swift
//  ConcurrencyExamples
//
//  Created by Joshua Park on 2020/08/21.
//  Copyright © 2020 Knowre. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        mockSuccess()
        return true
    }

}

func mockSuccess() {
    struct AnyUser : UserModel {
        var id: String
        var pictureURL: URL
        var username: String
    }
    
    let user = AnyUser(
        id: UUID().uuidString,
        pictureURL: .userImageURL,
        username: "Jim Halpert")
    
    let otherUser = AnyUser(
        id: UUID().uuidString,
        pictureURL: .otherUserImageURL,
        username: "Dwight Schrute")
    
    struct AnyPost : PostModel {
        var id: String
        var userID: String
        var content: String
    }
    
    UserRepository.shared.returnTable["signIn(completion:)"] = user
    UserRepository.shared.returnTable["fetchUser(id:completion:)"] = [
        user.id: user,
        otherUser.id: otherUser,]
    ImageRepository.shared.returnTable["resolveImage(url:completion:)"] = [
        user.pictureURL: #imageLiteral(resourceName: "jim.jpg"),
        otherUser.pictureURL: #imageLiteral(resourceName: "dwight.jpg"),]
    PostRepository.shared.returnTable["fetchPost(userID:completion:)"] = [
        AnyPost(id: UUID().uuidString, userID: otherUser.id, content: "random stuff"),
        AnyPost(id: UUID().uuidString, userID: user.id, content: "anything"),
        AnyPost(id: UUID().uuidString, userID: otherUser.id, content: "foo bar baz"),
        AnyPost(id: UUID().uuidString, userID: otherUser.id, content: "yucky"),]
}

func mockFailure() {
    UserRepository.shared.returnTable["signIn(completion:)"] = TestError.expected
}
