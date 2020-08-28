//
//  ObservableObject.swift
//  ConcurrencyExamples
//
//  Created by Joshua Park on 2020/08/28.
//  Copyright © 2020 Knowre. All rights reserved.
//

import Foundation

class ObservableObject : NSObject, ObservedObject {
    
    var queue: DispatchQueue? = nil
    
}

protocol ObservedObject { }

extension ObservedObject where Self : ObservableObject {
    
    func bind<T>(_ keyPath: KeyPath<Self, T>, _ binder: @escaping (T) -> Void) -> NSKeyValueObservation {
        return observe(keyPath) { [weak queue] (observable, _) in
            (queue ?? .main).async { binder(observable[keyPath: keyPath]) }
        }
    }
    
    func bind<Object, T, U>(
        _ keyPath: KeyPath<Self, T>,
        _ object: Object,
        _ targetPath: ReferenceWritableKeyPath<Object, U>)
        -> NSKeyValueObservation
        where Object: AnyObject
    {
        return bind(keyPath, object, Transform.identity(_:), targetPath)
    }
    
    func bind<Object, T, U>(
        _ keyPath: KeyPath<Self, T>,
        _ object: Object,
        _ transform: @escaping (T) -> U = Transform.identity(_:),
        _ targetPath: ReferenceWritableKeyPath<Object, U>)
        -> NSKeyValueObservation
        where Object: AnyObject
    {
        return observe(keyPath) { [weak object, weak queue] (observable, _) in
            guard let object = object else { return }
            let result = transform(observable[keyPath: keyPath])
            (queue ?? .main).async { object[keyPath: targetPath] = result }
        }
    }
    
    func bind<Object, T, U>(
        _ keyPath: KeyPath<Self, T>,
        _ object: Object,
        _ transformPath: KeyPath<Object, (T) -> U>,
        _ targetPath: ReferenceWritableKeyPath<Object, U>)
        -> NSKeyValueObservation
        where Object: AnyObject
    {
        return observe(keyPath) { [weak object, weak queue] (observable, _) in
            guard let object = object else { return }
            let result = object[keyPath: transformPath](observable[keyPath: keyPath])
            (queue ?? .main).async { object[keyPath: targetPath] = result }
        }
    }
    
}
