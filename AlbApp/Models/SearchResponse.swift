//
//  SearchResponse.swift
//  AlbApp
//
//  Created by Никита on 24.02.2021.
//

import Foundation

struct SearchResponse: Decodable {
    var resultCount: Int
    var results: [Track]
}

struct Track: Decodable {
    var trackName: String?
    var collectionName: String?
    var collectionId: Int?
    var artistName: String?
    var artworkUrl100: String?
    var artworkUrl60: String?
}
