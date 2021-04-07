//  ResultDrivenOperation.swift
//  Created by Dmitry Samartcev on 20.11.2020.

import Foundation

#if canImport(UIKit)
/// Asynchronous result-oriented operation
open class ResultDrivenOperation<Success, Failure> : AsynchronousOperation where Failure: Error {
    
    private(set) var result : Result<Success,Failure>? {
        didSet {
            guard let result = result else { return }
            onResult?(result)
        }
    }
    
    open var onResult: ((_ result:  Result<Success,Failure>) -> Void)?
    
    open override func finish() {
        fatalError("You should use finish(with:) to ensure a result.")
    }
    
    open func finish(with result: Result<Success,Failure>) {
        self.result = result
        super.finish()
    }
    
    open override func cancel() {
        fatalError("You should use cancel(with:) to ensure a result.")
    }
    
    open func cancel(with error: Failure) {
        result = .failure(error)
        super.cancel()
    }
}
#endif
