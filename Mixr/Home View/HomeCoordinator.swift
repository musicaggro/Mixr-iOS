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
        store.dispatch(AppAction.setListOfSongs(newListOfSongs: .loading))
        soundCloudAPI.performSearch(for: text, searchType: .everything)
        .then { listOfSongs -> Promise<Void> in
            guard let songCollection = listOfSongs?.collection else {
                store.dispatch(AppAction.setListOfSongs(newListOfSongs: .failed))
                return Promise()
            }
            
            let arrayOfSongStates = songCollection.compactMap { SongState(trackResponse: $0)}
            
            var exampleArrayOfSongStates: [SongState] = []
            for song in songCollection {
                exampleArrayOfSongStates.append(SongState(trackResponse: song))
            }
            store.dispatch(AppAction.setListOfSongs(newListOfSongs: .loaded(arrayOfSongStates)))
            
        }
    }
}
