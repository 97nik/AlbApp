//
//  NetworkService.swift
//  AlbApp
//
//  Created by Никита on 24.02.2021.
//

import Foundation
import UIKit

enum ApiError : Error {
    case noData
}
//let check = Reachability()
var alert = SerachCollectionViewController()

class NetworkService {
    
    enum RequestType {
        case albumName(album: String)
        case aboutTheAlbum(album: String)
    }
    var onResult: ((Result<SearchResponse, Error>) -> Void)?
    
    func fetchAlbum (forRequestType requestType: RequestType) {
        var urlString = ""
        switch requestType {
        case .albumName(let album):
            urlString = "https://itunes.apple.com/search?term=\(album)&entity=album&limit=10"
            
        case .aboutTheAlbum(let album):
            urlString = "https://itunes.apple.com/lookup?id=\(album)&entity=song"
        }
        performRequest(withURLString: urlString)
    }
    
    
    fileprivate func performRequest(withURLString urlString: String) {
        
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if Reachability.isConnectedToNetwork(){
                if let httpResponse = response as? HTTPURLResponse {
                    print(httpResponse.statusCode)
                    if httpResponse.statusCode == 404 {
                        self.onResult?(.failure(ApiError.noData))
                        return
                    } else if httpResponse.statusCode != 200 {
                        self.onResult?(.failure(ApiError.noData))
                        return
                    }
                }
                
                if let data = data {
                    
                    let decoder = JSONDecoder()
                    do {
                        let objects = try decoder.decode(SearchResponse.self, from: data)
                        self.onResult?(.success(objects))
                    } catch let error as NSError {
                        self.onResult?(.failure(error))
                        print(error.localizedDescription)
                    }
                }else {
                    self.onResult?(.failure(ApiError.noData))
                    print("xxxxxxx")
                    return
                }
            } else{
                print("Internet Connection not Available!")
                self.onResult?(.failure(ApiError.noData))
                return
            }
        }
        task.resume()
    }
}

