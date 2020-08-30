//
//  ImageRepository.swift
//  ConcurrencyExamples
//
//  Created by Joshua Park on 2020/08/28.
//  Copyright © 2020 Knowre. All rights reserved.
//

import UIKit

final class ImageRepository : BaseRepository {
    
    func resolveImage(url: URL, completion: @escaping (UIImage?, Error?) -> Void) {
        
    }
    
    // MARK: Private
    
    override
    private init() { }
    
}

extension ImageRepository {
    
    static let shared = ImageRepository()
    
}
