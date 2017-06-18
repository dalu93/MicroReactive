//
//  Disposable.swift
//  MicroReactive
//
//  Created by D'Alberti, Luca on 6/18/17.
//  Copyright © 2017 dalu93. All rights reserved.
//

import Foundation

// MARK: - Disposable declaration
/// `Disposable` indicates an operation object that can be `disposed`.
protocol Disposable {
    
    /// Dispose the operation.
    func dispose()
}

// MARK: - Disposable default disposedBy
extension Disposable {
    func disposed(by collection: DisposableCollection) {
        collection.add(self)
    }
}

// MARK: - DisposableCollection declaration
/// A `DisposableCollection` is a collection of `Disposable`s.
///
/// It's responsible for cancelling the `Disposable` operation when needed.
public class DisposableCollection {
    
    // MARK: - Private properties
    private var _disposables: [Disposable] = []
    
    // MARK: - Methods
    // MARK: Private methods
    /// Add a `Disposable` to the collection.
    ///
    /// Once the `Disposable` is added, it will be disposed depending on this
    /// collection lifetime.
    ///
    /// - Parameter disposable: The `Disposable` to add.
    fileprivate func add(_ disposable: Disposable) {
        _disposables.append(disposable)
    }
    
    // MARK: - Public methods
    /// It disposes all the `Disposable` assigned.
    ///
    /// This method is called when the object is deallocated automatically, but
    /// it can also be called manually by the user.
    func dispose() {
        _disposables.forEach {
            $0.dispose()
        }
        
        _disposables.removeAll()
    }
    
    // MARK: - Object lifecycle
    deinit {
        dispose()
    }
}
