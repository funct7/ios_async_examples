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
        let urlTable = returnTable[#function] as! [URL : Any]
        
        switch urlTable[url] {
        
        case let image as UIImage:
            performAfterDelay { completion(image, nil) }
            
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

extension ImageRepository {
    
    static let shared = ImageRepository()
    
}
