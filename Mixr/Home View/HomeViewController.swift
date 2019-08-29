//
//  ViewController.swift
//  Mixr
//
//  Created by Tevin Scott on 8/10/19.
//  Copyright © 2019 Tevin Scott. All rights reserved.
//

import UIKit
import ReSwift

protocol ViewHandler {
    func initiateSearch()
}

class HomeViewController: UIViewController, StoreSubscriber, UITextFieldDelegate {
    
    var viewDelegate: ViewHandler!
    
    @IBOutlet weak var searchField: UITextField!
    
    @IBOutlet weak var result: UILabel!
    
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
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        viewDelegate.initiateSearch()
    }
    
    func newState(state: AppState) {
        
        if let currentSong = state.currentSong?.songName {
            result.text = currentSong
        }
    }
}
