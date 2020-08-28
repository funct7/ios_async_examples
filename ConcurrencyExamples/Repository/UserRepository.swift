//
//  UserRepository.swift
//  ConcurrencyExamples
//
//  Created by Joshua Park on 2020/08/28.
//  Copyright © 2020 Knowre. All rights reserved.
//

import Foundation

final class UserRepository {
    
    // MARK: Interface
    
    private(set) var user: UserModel?
    
    func signIn(completion: @escaping (UserModel?, Error?) -> Void) {
        
    }
    
    func fetchUser(id: String, completion: @escaping (UserModel?, Error?) -> Void) {
        
    }
    
    // MARK: Private
    
    /**
     `$userID : UserModel` 매핑.
     */
    private var userTable: [String : UserModel] = [:]
    
    private init() { }
    
}

extension UserRepository {
    
    static let shared = UserRepository()
    
}
