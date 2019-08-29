//
//  SongState.swift
//  Mixr
//
//  Created by Tevin Scott on 8/10/19.
//  Copyright © 2019 Tevin Scott. All rights reserved.
//

import Foundation
import ReSwift

class AppReducer: SubStateReducer {
    

    func reduce(action: AppAction, subState: AppState) -> AppState {
        
        var newState = subState
        switch action {
        case .setCurrentSong(let newSong):
            newState.currentSong = newSong
        case .setListOfSongs(let newListOfSongs):
            newState.listOfSongs = newListOfSongs
        }
        
        return newState
    }
    
    func unwrap(state: AppState) -> AppState? {
        return state
    }
    
    func wrap(state: AppState, subState: AppState) -> AppState {
        return subState
    }
    
    
    
}

enum AppAction: Action {
    case setCurrentSong(newSong: SongState)
    case setListOfSongs(newListOfSongs: LoadingState<[SongState]>)
}

// Reducer Helpers
protocol AnySubstateReducer {
    func associatedState(action: Action, state: AppState) -> Any?
    func reduce(state: AppState, action: Action, subState: Any) -> AppState
}

protocol SubStateReducer: AnySubstateReducer {
    associatedtype SubStateType
    associatedtype ActionType
    
    func unwrap(state: AppState) -> SubStateType?
    func wrap(state: AppState, subState: SubStateType) -> AppState
    func reduce(action: ActionType, subState: SubStateType) -> SubStateType
}

extension SubStateReducer {
    func associatedState(action: Action, state: AppState) -> Any? {
        if let _ = action as? ActionType {
            return unwrap(state: state)
        } else {
            return nil
        }
    }
    
    func reduce(state: AppState, action: Action, subState: Any) -> AppState {
        return wrap(state: state,
                    subState: reduce(action: action as! ActionType,
                                     subState: subState as! SubStateType))
    }
}
