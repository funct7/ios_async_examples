//
//  BaseRepository.swift
//  ConcurrencyExamples
//
//  Created by Joshua Park on 2020/08/31.
//  Copyright © 2020 Knowre. All rights reserved.
//

import Foundation

/**
 모든 콜백은 background thread에서 실행.
 */
class BaseRepository {
    
    // MARK: Interface
    
    var delay: TimeInterval = 1.0
    
    /**
     `$METHOD_NAME : $RETURN_VALUE` 테이블.
     */
    var returnTable: [String : Any] = [:]
    
    let dispatchQueue: DispatchQueue = .global()
    
    func performAfterDelay(_ block: @escaping () -> Void) {
        dispatchQueue.asyncAfter(deadline: .now() + delay, execute: block)
    }
    
}
