//
//  PostRepository.swift
//  ConcurrencyExamples
//
//  Created by Joshua Park on 2020/08/28.
//  Copyright © 2020 Knowre. All rights reserved.
//

import Foundation

final class PostRepository : BaseRepository {
    
    // MARK: Interface
    
    func fetchPost(userID: String, completion: @escaping ([PostModel]?, Error?) -> Void) {
        switch returnTable[#function] {
        
        case let postList as [PostModel]:
            performAfterDelay { completion(postList, nil) }
        
        case let error as Error:
            performAfterDelay { completion(nil, error) }
        
        default:
            print("\(#function) completion is never called")
            
        }
    }
    
    // MARK: Private
    
    override
    private init() { }
    
}

extension PostRepository {
    
    static let shared = PostRepository()
    
}
