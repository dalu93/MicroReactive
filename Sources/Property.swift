//
//  Property.swift
//  MicroReactive
//
//  Created by D'Alberti, Luca on 6/18/17.
//  Copyright © 2017 dalu93. All rights reserved.
//

import Foundation

// MARK: - Public typealiases
public typealias Closure<ParamType, ReturnType> = (ParamType) -> ReturnType
public typealias PropertyBindClosure<T> = Closure<T, ()>

/// The `Property` generic class describes a property which can change its
/// value in the future and can be observed.
public class Property<Value> {
    
    // MARK: - Public properties
    /// The current value.
    var value: Value {
        didSet {
            _disposables.forEach {
                $0.execute(with: value)
            }
        }
    }
    
    // MARK: - Private properties
    private var _disposables: [PropertyDisposable<Value>] = []
    
    // MARK: - Object lifecycle
    /// Initialize the object with an initial value.
    ///
    /// - Parameter value: The initial value.
    init(_ value: Value) {
        self.value = value
    }
}

// MARK: - Public methods
extension Property {
    
    /// Bind new changes to the property.
    ///
    /// Assign the function result to a `DisposableCollection` to
    /// make sure that the operation will be canceled when needed.
    ///
    /// - Parameter listener: The listener which will be called.
    /// - Returns: The `Disposable` operation to assign to a `DisposableCollection`
    /// instance.
    func bind(_ listener: @escaping PropertyBindClosure<Value>) -> Disposable {
        let bindDisposable = PropertyDisposable(listener)
        _disposables.append(bindDisposable)
        
        return bindDisposable
    }
}

// MARK: - PropertyDisposable declaration
/// Concrete `Disposable` type used to describe a `Property` disposable operation.
private class PropertyDisposable<Value>: Disposable {
    
    // MARK: - Private properties
    private var closure: [PropertyBindClosure<Value>] = []
    
    // MARK: - Object lifecycle
    init(_ listener: @escaping PropertyBindClosure<Value>) {
        self.closure = [listener]
    }
    
    // MARK: - Methods
    // MARK: Public methods
    func dispose() {
        closure.removeAll()
    }
    
    // MARK: Private methods
    fileprivate func execute(with value: Value) {
        closure.first?(value)
    }
}
