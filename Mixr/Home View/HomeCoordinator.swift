//
//  HomeCoordinator.swift
//  Mixr
//
//  Created by Tevin Scott on 8/10/19.
//  Copyright © 2019 Tevin Scott. All rights reserved.
//

import PromiseKit
import Foundation
import ReSwift

class HomeCoordinator: ViewHandler {
    
    var state: AppState
    let soundCloudAPI = SoundCloudAPI()
    
    init(state: AppState) {
        self.state = state
    }
    
    func initiateSearch(for text: String) {
        
        soundCloudAPI.performSearch(for: text, searchType: .everything)
        .then { listOfSongs -> Promise<String?> in
            guard
                let firstSongInCollection = listOfSongs?.collection.first,
                let artworkURL = firstSongInCollection?.artwork_url else {
                return .value(nil)
            }
            let firstSong = SongState(trackResponse: firstSongInCollection!)
            store.dispatch(AppAction.setCurrentSong(newSong: firstSong))
            return .value(artworkURL)
        }
        .then { artworkURL -> Promise<UIImage?> in
            guard let url = artworkURL else {
                return .value(nil)
            }
            return self.soundCloudAPI.loadSongImage(artworkURL: url)
        }
        .then { currentSongImage -> Promise<Void> in
            if let image = currentSongImage {
                store.dispatch(AppAction.setCurrentSongImage(image: image))
            }
            return Promise()
        }
        
    }
}
