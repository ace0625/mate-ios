//
//  RoomDetailViewController.swift
//  Mate
//
//  Created by Dan Hyunchan Kim on 6/29/17.
//  Copyright © 2017 Dan Kim. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

class RoomDetailViewController: JSQMessagesViewController {
    
    // MARK: Properties
    var messages = [JSQMessage]()
    var roomRef: FIRDatabaseReference?
    var room: Room? {
        didSet {
            title = room?.title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.senderId = FIRAuth.auth()?.currentUser?.uid
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Collection view data source methods
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    // MARK message UI
    
    
}
