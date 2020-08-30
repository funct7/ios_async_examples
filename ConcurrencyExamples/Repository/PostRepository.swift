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
    
    func fetchPost(userID: String, completion: @escaping ([Any]?, Error?) -> Void) {
        
    }
    
    // MARK: Private
    
    override
    private init() { }
    
}

extension PostRepository {
    
    static let shared = PostRepository()
    
}
