//
//  SoundCloudAPI.swift
//  Mixr
//
//  Created by Tevin Scott on 8/29/19.
//  Copyright © 2019 Tevin Scott. All rights reserved.
//

import Foundation
import PromiseKit

public enum SearchType: String {
    case everything = ""
    case premiumTracks = "go"
    case tracks = "sounds"
    case users = "people"
    case albums
    case playlists = "sets"
}

public struct SoundCloudResponse: Codable {
    var collection: [TrackResponse?]
}

public struct TrackResponse: Codable {
    public var title: String?
    public var publisher_metadata: publisherMetadata?
    public var artwork_url: String?
    public var media: MediaResponse
}

public struct TrackStreamingResponse: Codable {
    var url: String?
}

public struct publisherMetadata: Codable {
    public var artist: String?
}



public struct MediaResponse: Codable {
    public var transcodings: [TranscodingsResponse]
}

public struct TranscodingsResponse: Codable {
    public var url: String
    public var duration: String
    public var format: AudioCodecTypeResponse
    public var quality: String

}

public struct AudioCodecTypeResponse: Codable {
    public var `protocol` : String
    public var mime_type: String
}

class SoundCloudAPI {
    
    let searchURL = "https://api-v2.soundcloud.com/search"
    
    let genericError = NSError( domain: "Endpoint Error",
                                code: 0,
                                userInfo: [NSLocalizedDescriptionKey: "Unknown error"])
    
    func loadSongImage(artworkURL: String) -> Promise<UIImage?> {
        return Promise { seal in
            guard let url = URL(string: artworkURL) else {
                return
            }
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard
                    let data = data,
                    let loadedImage = UIImage(data: data),
                    error == nil else {
                        seal .reject(error ?? self.genericError)
                        return
                }
                seal.fulfill(loadedImage)
            }.resume()
        }
            
    }
    
    func performSearch(for text: String, searchType: SearchType) -> Promise<SoundCloudResponse?> {
        return Promise { seal in
            var baseURL = URLComponents(string: "\(searchURL)")!
            let queryItems = [URLQueryItem(name: "q", value: text),
                              URLQueryItem(name: "client_id", value: clientID),
                              URLQueryItem(name: "limit", value: "10"),
                              URLQueryItem(name: "offset", value: "0"),
                              URLQueryItem(name: "linked_partitioning", value: "1"),
                              URLQueryItem(name: "app_version", value: "1567082993"),
                              URLQueryItem(name: "app_locale", value: "en")]
            
            baseURL.queryItems = queryItems
            guard let url = baseURL.url else {
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard
                    let data = data,
                    let result = try? JSONDecoder().decode(SoundCloudResponse.self, from: data) else {
                    
                    seal.reject(error ?? self.genericError)
                    return
                }
                seal.fulfill(result)
            }.resume()
        }
    }
    
    
    //MARK:- Client ID
    let clientID = "8PezNQVfAnCr9g8hsjVOaGqXDc1rtk8R"
}
