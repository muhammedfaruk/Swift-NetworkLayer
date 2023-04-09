//
//  Post.swift
//  NetworkLayer
//
//  Created by Muhammed Faruk Söğüt on 9.04.2023.
//

import Foundation

struct Post: Codable {
  let id:Int?
  let title:String?
  let body:String?
  let userId:Int?
}
