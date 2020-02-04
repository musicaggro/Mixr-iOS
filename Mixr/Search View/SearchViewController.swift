//
//  SearchViewController.swift
//  Mixr
//
//  Created by Tevin Scott on 9/21/19.
//  Copyright © 2019 Tevin Scott. All rights reserved.
//

import UIKit
import ReSwift

protocol SearchHandler {
    func initiateSearch(for text: String)
}

class SearchViewController: UIViewController, StoreSubscriber, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var searchDelegate: SearchHandler!
    var results: [SongState] = []
    init(delegate: SearchHandler) {
        self.searchDelegate = delegate
        super.init(nibName: "SearchView", bundle: nil)
    }
    
    func newState(state: AppState) {
        if
            let loadedSongs = state.listOfSongs?.value(),
            loadedSongs != results {
            
            loadedSongs = 
        }
    }
    
    func registerCells() {
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
        let nib = UINib.init(nibName: "SearchResultCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "SearchResultCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! SearchResultCell
        
        let aSong = results[indexPath.row]
        
        cell.songNameLabel.text = aSong.songName
        cell.artistLabel.text = aSong.artist
        cell.durationLabel.text = aSong.songDuration
        return cell
    }
}
