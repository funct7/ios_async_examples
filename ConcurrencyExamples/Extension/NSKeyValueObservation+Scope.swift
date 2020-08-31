//
//  NSKeyValueObservation+Scope.swift
//  ConcurrencyExamples
//
//  Created by Joshua Park on 2020/08/31.
//  Copyright © 2020 Knowre. All rights reserved.
//

import Foundation

extension NSKeyValueObservation {
    
    func setScope(_ tokenList: inout [NSKeyValueObservation]) {
        tokenList.append(self)
    }
    
    func setScope<T>(
        object: T,
        keyPath: ReferenceWritableKeyPath<T, NSKeyValueObservation>)
        where T : AnyObject
    {
        object[keyPath: keyPath] = self
    }
    
}
