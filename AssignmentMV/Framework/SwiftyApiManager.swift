//
//  SwiftyApiManager.swift
//  AssignmentMV
//
//  Created by Himanshu Saraswat on 20/08/19.
//  Copyright © 2019 Himanshu Saraswat. All rights reserved.
//

import Foundation
import UIKit

public class SwiftyApiManager: Swifty {
    
    // Properties
    let session: URLSession
   static var imageCache = NSCache<NSString , UIImage>()
    var imageURlString: String?
    
    public init(configuration: URLSessionConfiguration = .default) {
        self.session = URLSession(configuration: configuration)
    }
    
}

extension SwiftyApiManager {
   // Download Images Async
    public func download(formUrl urlString: String, withMethod httpMehthod: HttpMethod? = nil, completion: @escaping (DownloadResult<Data?, Failure?>) -> Void) {
        imageURlString = urlString
        guard let url = URL(string: urlString) else {
            return
        }
        
        // Caching logic
        if let imageFromCache = SwiftyApiManager.imageCache.object(forKey: urlString as NSString),
             let imageData = imageFromCache.pngData() {
            completion(.success(imageData))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMehthod?.rawValue ?? HttpMethod.get.rawValue
        let task =  createSessionTask(forURLRequest: request) { (data, failures) in
            if let response = data {
                if let imageToBeStoredInCache = UIImage(data: response){
                    if self.imageURlString == urlString {
                        SwiftyApiManager.imageCache.setObject(imageToBeStoredInCache, forKey: urlString as NSString)
                    }
                }
                completion(.success(response))
            }
            else{
                completion(.failure(failures))
            }
        }
        task.resume()
    }
    
    //Download Tasks
    public func connectApi<T>(withEndPoint endPoint: String?, withRequestType method:HttpMethod? = nil, withParameters parameters: [String: Any]? = nil, withHeader headers: HttpHeader? = nil, decode: T.Type, completion: @escaping (Result<T?, Failure?>) -> Void) where T : Codable {
        
        guard let urlString = endPoint else {
            completion(.failure(.inValidURL))
            return
        }
        if let endPointURL =  URL(string: urlString){
            var request = URLRequest(url: endPointURL)
            request.allHTTPHeaderFields = headers
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = method?.rawValue ?? HttpMethod.get.rawValue
            if let json = parameters {
                if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []) {
                    request.httpBody = jsonData
                }
            }
            
            self.createRequest(with: request, decode: T.self) { (response) in
                switch response {
                    case .success(let model):
                            completion(.success(model))
                case .failure(let failure):
                        completion(.failure(failure))
                }
            }
        } else {
           completion(.failure(.inValidURL))
        }
    }

    
    
    private func createRequest<T>(with request: URLRequest, decode:T.Type, completion: @escaping (Result<T, Failure?>) -> Void) where T : Codable {
       
        let task =  createSessionTask(forURLRequest: request) { (data, failures) in
            if let response = data {
                if let responseModel = try? JSONDecoder().decode(T.self, from: response){
                    completion(.success(responseModel))
                }
                else{
                    completion(.failure(.parsingFailure))
                }
            }
            else{
                completion(.failure(.serviceFailure))
            }
        }
            task.resume()
    }
}

