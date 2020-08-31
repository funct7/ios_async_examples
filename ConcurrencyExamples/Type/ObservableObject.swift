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
        observe(keyPath) { [weak queue] (observable, _) in
            (queue ?? .main).async { binder(observable[keyPath: keyPath]) }
        }
    }
    
    /**
     - Parameters:
        - keyPath: The source key path.
        - object: The object to bind to.
        - targetKeyPath: The target key path of the `object`.
     */
    func bind<Object, T, U>(
        _ keyPath: KeyPath<Self, T>,
        _ object: Object,
        _ targetKeyPath: ReferenceWritableKeyPath<Object, U>)
        -> NSKeyValueObservation
        where Object: AnyObject
    {
        bind(keyPath, object, Transform.identity(_:), targetKeyPath)
    }
    
    /**
     - Parameters:
        - keyPath: The source key path.
        - object: The object to bind to.
        - transform: The function that transforms the source type to the target type.
        - source: The source object to transform.
        - targetKeyPath: The target key path of the `object`.
     */
    func bind<Object, T, U>(
        _ keyPath: KeyPath<Self, T>,
        _ object: Object,
        _ transform: @escaping (_ source: T) -> U = Transform.identity(_:),
        _ targetKeyPath: ReferenceWritableKeyPath<Object, U>)
        -> NSKeyValueObservation
        where Object: AnyObject
    {
        observe(keyPath) { [weak object, weak queue] (observable, _) in
            guard let object = object else { return }
            let result = transform(observable[keyPath: keyPath])
            (queue ?? .main).async { object[keyPath: targetKeyPath] = result }
        }
    }
    
    /**
     - Parameters:
        - keyPath: The source key path.
        - object: The object to bind to.
        - transformPath: The key path to the method that transforms the source type to the target type.
        - source: The source object to transform.
        - targetKeyPath: The target key path of the `object`.
    */
    func bind<Object, T, U>(
        _ keyPath: KeyPath<Self, T>,
        _ object: Object,
        _ transformPath: KeyPath<Object, (_ source: T) -> U>,
        _ targetKeyPath: ReferenceWritableKeyPath<Object, U>)
        -> NSKeyValueObservation
        where Object: AnyObject
    {
        return observe(keyPath) { [weak object, weak queue] (observable, _) in
            guard let object = object else { return }
            let result = object[keyPath: transformPath](observable[keyPath: keyPath])
            (queue ?? .main).async { object[keyPath: targetKeyPath] = result }
        }
    }
    
}
