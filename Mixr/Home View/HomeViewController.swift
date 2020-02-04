//
//  HomeViewController.swift
//  Mixr
//
//  Created by Tevin Scott on 8/10/19.
//  Copyright © 2019 Tevin Scott. All rights reserved.
//

import UIKit
import ReSwift
import AVKit

protocol ViewHandler {
    func initiateSearch(for text: String)
}

class HomeViewController: UIViewController, StoreSubscriber, UITextFieldDelegate {
    
    var viewDelegate: ViewHandler!
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var SongImage: UIImageView!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var pauseAndPlayButton: UIButton!
    var avPlayer: AVPlayer?
    
    init(delegate: ViewHandler) {
        self.viewDelegate = delegate
        super.init(nibName: "HomeView", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        store.subscribe(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        store.unsubscribe(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func newState(state: AppState) {
        
        if let songName = state.currentSong?.songName,
            let artist = state.currentSong?.artist {
            result.text = "\(songName) - \(artist)"
        }
        
        if let artwork = state.currentSong?.songImage {
            SongImage.image = artwork
        }
        
    }
    
    // Button Actions
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        guard
            let searchText = searchField.text,
            !searchText.isEmpty else {
                return
        }

        viewDelegate.initiateSearch(for: searchText)
        if let streamURL = URL(string: "") {
        
            avPlayer = AVPlayer(url: streamURL)
        }
        
    }
    
    private func isPlaying() -> Bool {
        return avPlayer?.rate != nil && avPlayer?.rate != 0
    }
    
    @IBAction func playToggleTapped(_ sender: Any) {
        if isPlaying() {
            avPlayer?.pause()
        } else {
            avPlayer?.play()
        }
    }
    
    
    
}
