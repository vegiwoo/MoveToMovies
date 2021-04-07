//  FileDownloadOperation.swift
//  Created by Dmitry Samartcev on 06.04.2021.

import Foundation

public enum FileDownloadOperationError: Swift.Error {
    case canceled
    case urlError(error: Swift.Error)
}

public class FileDownloadOperation: ResultDrivenOperation<Data, FileDownloadOperationError> {

    public var tag: String
    public var urlString: String
    
    public init(tag: String, urlString: String) {
        self.tag = tag
        self.urlString = urlString
    }

    public override func main() {
        guard let url = URL(string: urlString) else { return }

        loadData(from: url) { (data, response, error) in
            if let error = error {
                self.finish(with: .failure(.urlError(error: error)))
            }
            if let data = data {
                self.finish(with: .success(data))
            }
        }
    }
    
    public override func cancel() {
        cancel(with: .canceled)
    }

    private func loadData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    
}
