//
//  NetworkService.swift
//  AlbApp
//
//  Created by Никита on 24.02.2021.
//

import Foundation
import UIKit


class NetworkService {
    
    func fetchTracks(searchText: String, competion: @escaping (SearchResponse?) -> Void)  {
        
        let urlString = "https://itunes.apple.com/search?term=\(searchText)&entity=album&limit=10"
        
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                
                let decoder = JSONDecoder()
                do {
                    let objects = try decoder.decode(SearchResponse.self, from: data)
                    print("objects: ", objects)
                    competion(objects)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                
            }
            
            
        }
        task.resume()
    }
    
    func fetchSing(searchText: Int, competion: @escaping (SearchSong?) -> Void)  {
        
        let urlString = "https://itunes.apple.com/lookup?id=\(searchText)&entity=song" 
        
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                
                let decoder = JSONDecoder()
                do {
                    let objects = try decoder.decode(SearchSong.self, from: data)
                    print("!!!!!!!!")
                    print("objects: ", objects)
                   
                    competion(objects)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                
            }
            
            
        }
        task.resume()
    }
    
}
