//
//  APIService.swift
//  PingLatency
//
//  Created by Javid Sheikh on 11/04/2018.
//  Copyright © 2018 Javid Sheikh. All rights reserved.
//

import Foundation
import UIKit

enum APIError: Error {
    case jsonDecodingError
    case apiResponseError(String)
    case dataResponseNil
}

class APIService {

    typealias JSONTaskCompletionHandler = (Result<Any, APIError>) -> Void
    typealias UIImageFetchCompletionHandler = (UIImage) -> Void

    private let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    func fetchHostList(withURL urlString: String, completion: @escaping JSONTaskCompletionHandler) {
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        let session = URLSession.shared
        DispatchQueue.global(qos: .utility).async {
            session.dataTask(with: request) { data, response, error in
                if let data = data {
                    do {
                        let hostList = try JSONDecoder().decode([Host].self, from: data)
                        completion(Result.success(hostList))
                    } catch {
                        completion(Result.failure(APIError.jsonDecodingError))
                    }
                } else if let err = error {
                    completion(Result.failure(APIError.apiResponseError(err.localizedDescription)))
                } else {
                    completion(Result.failure(APIError.dataResponseNil))
                }
            }
            .resume()
        }
    }

    func fetchImage(fromURL urlString: String, completion: @escaping UIImageFetchCompletionHandler) {
        if let url = URL(string: urlString) {
            do {
                let data = try Data(contentsOf: url)
                guard let image = UIImage(data: data) else { return }
                completion(image)
            } catch {
                // TODO - handle error
                print("Error retrieving icon image")
                completion(UIImage())
            }
        }
    }
}
