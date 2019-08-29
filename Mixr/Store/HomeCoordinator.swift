//
//  Coordinator.swift
//  Mixr
//
//  Created by Tevin Scott on 8/10/19.
//  Copyright © 2019 Tevin Scott. All rights reserved.
//

import UIKit
import Foundation
import ReSwift

class HomeCoordinator: ViewHandler {
    
    var state: AppState
    
    init(state: AppState) {
        self.state = state
    }
    
    func initiateSearch() {
        let dummySong = SongState(songName: "Abbey Road")
        store.dispatch(AppAction.setCurrentSong(newSong: dummySong))
    }
}
