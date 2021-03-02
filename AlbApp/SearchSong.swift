//
//  SearchSong.swift
//  AlbApp
//
//  Created by Никита on 24.02.2021.
//

import Foundation


struct SearchSong: Decodable {
    var resultCount: Int
    var results: [Songs]
}

struct Songs: Decodable {
    var trackName: String?
   
}
