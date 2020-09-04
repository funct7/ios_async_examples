//
//  Transform.swift
//  ConcurrencyExamples
//
//  Created by Joshua Park on 2020/08/28.
//  Copyright © 2020 Knowre. All rights reserved.
//

import Foundation

/**
 타입을 변환 시켜주는 함수 namespace.
 */
enum Transform { }

extension Transform {
    
    static func identity<T, U>(_ input: T) -> U { input as! U }
    
}
