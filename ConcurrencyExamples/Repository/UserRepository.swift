//
//  UserRepository.swift
//  ConcurrencyExamples
//
//  Created by Joshua Park on 2020/08/28.
//  Copyright © 2020 Knowre. All rights reserved.
//

import Foundation

final class UserRepository : BaseRepository {
    
    // MARK: Interface
    
    private(set) var user: UserModel?
  
    /**
     - Parameters:
        - completion: 로그인 후 콜백. `user != nil || error != nil`.
        - user:
        - error:
     */
    func signIn(completion: @escaping (_ user: UserModel?, _ error: Error?) -> Void) {
        switch returnTable[#function] {
            
        case let user as UserModel:
            dispatchQueue.asyncAfter(deadline: .now() + delay) {
                completion(user, nil)
            }
            
        case let error as Error:
            dispatchQueue.asyncAfter(deadline: .now() + delay) {
                completion(nil, error)
            }
            
        default:
            print("\(#function) completion is never called")
            
        }
    }
    
    func fetchUser(id: String, completion: @escaping (UserModel?, Error?) -> Void) {
        
    }
    
    // MARK: Private
    
    override
    private init() { }
    
}

extension UserRepository {
    
    static let shared = UserRepository()
    
}
