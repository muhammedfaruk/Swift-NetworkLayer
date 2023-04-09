//
//  NetworkManager.swift
//  NetworkLayer
//
//  Created by Muhammed Faruk Söğüt on 7.04.2023.
//

import Foundation

//https://jsonplaceholder.typicode.com/users

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    private func request<T: Decodable>(_ endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
                
        let task = URLSession.shared.dataTask(with: endpoint.request()) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse , response.statusCode >= 200 , response.statusCode <= 299 else {
                completion(.failure(NSError(domain: "Invalid Response", code: 0)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Invalid Response data", code: 0)))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            }catch let error {
                completion(.failure(error))
            }
                    
        }
            
        
        task.resume()
    }
    
    
    // Tum endpintler buradan kontrol ediyoruz.
    func getUser(completion: @escaping (Result<[User], Error>) -> Void) {
        let endpoint = Endpoint.getUsers
        request(endpoint, completion: completion)
    }
    
    func getComments(postID: String, completion: @escaping (Result<CommentArray, Error>) -> Void) {
        let endpoint = Endpoint.comments(postID: postID)
        request(endpoint, completion: completion)
    }
    
    func posts(title:String, body: String, userID:Int, completion: @escaping (Result<Post, Error>) -> Void) {
        let endpoint = Endpoint.posts(title: title, body: body, userID: userID)
        request(endpoint, completion: completion)
    }
}
