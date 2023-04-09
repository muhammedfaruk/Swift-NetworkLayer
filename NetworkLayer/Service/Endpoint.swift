//
//  Endpoint.swift
//  NetworkLayer
//
//  Created by Muhammed Faruk Söğüt on 7.04.2023.
//

import Foundation

//https://jsonplaceholder.typicode.com/users


protocol EndpointProtocol {
    var baseURL: String {get}
    var path: String {get}
    var method: HTTPMethod {get}
    var header: [String: String]? {get}
    var parameters: [String: Any]? {get}
    func request() -> URLRequest
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case patch = "PATCH"
}


 
//IMPORTANT
enum Endpoint {
    case getUsers
    case comments(postID: String)
    case posts(title: String, body: String, userID: Int)
}


extension Endpoint: EndpointProtocol {
   
    var baseURL: String {
        return "https://jsonplaceholder.typicode.com"
    }
    
    var path: String {
        switch self {
        case .getUsers: return "/users"
            
        case .comments: return "/comments"
            
        case .posts: return "/posts"
          
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUsers: return .get
            
        case .comments: return .get
            
        case .posts: return .post
            
        }
    }
    
    var header: [String : String]? {
        let header: [String: String] = ["Content-type": "application/json; charset=UTF-8"]
        return header
    }
    
    var parameters: [String : Any]? {
        if case .posts(let title, let body, let userId) = self {
            return ["title": title, "body": body, "userId": userId]
        }
        
        return nil
    }
    
    
    func request() -> URLRequest {
        guard var components = URLComponents(string: baseURL) else {
            fatalError("URL ERROR")
        }

        //Add QueryItem
        if case .comments(let id) = self {
            components.queryItems = [URLQueryItem(name: "postId", value: id)]
        }
        
        //Add Path
        components.path = path
        
        //Create request
        var request = URLRequest(url: components.url!)
        request.httpMethod = method.rawValue
        
        //Add Paramters
        if let parameters {
            do {
                let data = try JSONSerialization.data(withJSONObject: parameters)
                request.httpBody = data
            }catch {
                print(error.localizedDescription)
            }
        }
        
        
        //Add Header
        if let header = header {
            for (key, value) in header {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        return request
    }
}




