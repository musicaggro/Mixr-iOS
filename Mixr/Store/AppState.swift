//
//  AppState.swift
//  Mixr
//
//  Created by Tevin Scott on 8/10/19.
//  Copyright © 2019 Tevin Scott. All rights reserved.
//

import Foundation
import ReSwift
import AVKit

public struct AppState: StateType {
    var currentSong: SongState?
    var listOfSongs: LoadingState<[SongState]>?
}

public struct SongState: Equatable, Hashable {
    public var songName: String?
    public var artist: String?
    public var songImage: UIImage?
    public var songDuration: String?
    public var songURL: URL?
    
    init(trackResponse: TrackResponse?) {
        guard let trackResponse = trackResponse else {
            return
        }
        
        self.songName = trackResponse.title
        self.artist = trackResponse.publisher_metadata?.artist
        self.songDuration = trackResponse.media.transcodings.first?.duration
    }
}

public struct ActionCollection: Action {
    let actions: [Action]
}

extension Store {
    func dispatchCollection(_ actions: [Action]) {
        self.dispatch(ActionCollection(actions: actions))
    }
}

var allReducers: [AnySubstateReducer] = [
    AppReducer()
]

func appReducer(action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState()
    
    if let collectionOfActions = action as? ActionCollection {
        var modifiableState = state
        for action in collectionOfActions.actions {
            modifiableState = reduceForAction(action: action, state: state)
        }
        
        return modifiableState
    } else {
        return reduceForAction(action: action, state: state)
    }
}

func reduceForAction(action: Action, state: AppState) -> AppState {
    for r in allReducers {
        if let subState = r.associatedState(action: action, state: state) {
            return r.reduce(state: state, action: action, subState: subState)
        }
    }
    return state
}

//MARK: - Generic State Helpers

enum LoadingState<T> {
    case failed
    case initialized
    case loading
    case loaded(T)
    
    func value() -> T? {
        switch self {
        case .failed, .initialized, .loading:
           return nil
        case .loaded(let value):
            return value
        }
    }
}
