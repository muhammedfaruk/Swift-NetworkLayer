//
//  ContentView.swift
//  NetworkLayer
//
//  Created by Muhammed Faruk Söğüt on 7.04.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            getComments(id: 1)
            post(title: "DENEMEEE", body: "BODYDENEME", id: 10)
        }
    }
    
    private func getComments(id: Int) {
        NetworkManager.shared.getComments(postID: String(id)) { result in
            switch result {
            case .success(let success):
                success.forEach { comment in
                    print(comment.postID ?? "")
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    private func post(title:String, body:String, id:Int){
        NetworkManager.shared.posts(title: title, body: body, userID: id) { result in
            switch result {
            case .success(let post):
                print(post.body)
                print(post.title)
                print(post.id)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
