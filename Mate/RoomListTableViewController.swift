//
//  RoomListTableViewController.swift
//  Mate
//
//  Created by Dan Kim on 6/27/17.
//  Copyright © 2017 Dan Kim. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RoomListTableViewController: UITableViewController {
  
  // MARK: Constants
  let listToRoom = "ListToRoom"
  
  // MARK: Properties
  let roomRef = FIRDatabase.database().reference().child("room")
  let usersRef = FIRDatabase.database().reference().child("online")
  var rooms: [Room] = []
  var user: User!
  var userCountBarButtonItem: UIBarButtonItem!
  var senderDisplayName: String?
  
  // MARK: UIViewController Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tableView.allowsMultipleSelectionDuringEditing = false
    
    userCountBarButtonItem = UIBarButtonItem(title: "1", style: .plain, target: self, action: #selector(onlineUserCountButtonAction))
    userCountBarButtonItem.tintColor = UIColor.white
    navigationItem.leftBarButtonItem = userCountBarButtonItem
    
    usersRef.observe(FIRDataEventType.value, with: { snapshot in
      if snapshot.exists() {
        self.userCountBarButtonItem?.title = snapshot.childrenCount.description
      } else {
        self.userCountBarButtonItem?.title = "0"
      }
    })
    
    roomRef.queryOrdered(byChild: "completed").observe(FIRDataEventType.value, with: { snapshot in
      var newRooms: [Room] = []
      
      for room in snapshot.children {
        let newRoom = Room(snapshot: room as! FIRDataSnapshot)
        newRooms.append(newRoom)
      }
      
      self.rooms = newRooms
      self.tableView.reloadData()
    })
    
    FIRAuth.auth()!.addStateDidChangeListener { auth, user in
      guard let user = user else { return }
      self.user = User(authData: user)
      let currentUserRef = self.usersRef.child(self.user.uid)
      currentUserRef.setValue(self.user.email)
      currentUserRef.onDisconnectRemoveValue()
    }
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    
    if let room = sender as? Room {
      let roomDetailVc = segue.destination as! RoomDetailViewController
      
      roomDetailVc.senderDisplayName = senderDisplayName
      roomDetailVc.room = room
      roomDetailVc.roomRef = roomRef.child(room.title)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: UITableView Delegate methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return rooms.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath)
    let room = rooms[indexPath.row]
    
    cell.textLabel?.text = room.title
    cell.detailTextLabel?.text = room.userEmail
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let room = rooms[indexPath.row]
      room.ref?.removeValue()
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let room = rooms[indexPath.row]
    self.performSegue(withIdentifier: self.listToRoom, sender: room)
  }
  
  // MARK: Actions
  
  @IBAction func AddRoomAction(_ sender: Any) {
    let alert = UIAlertController(title: "New room",
                                  message: "Enter title",
                                  preferredStyle: .alert)
    
    let saveAction = UIAlertAction(title: "Save",
                                   style: .default) { _ in
                                    // 1
                                    guard let textField = alert.textFields?.first,
                                      let text = textField.text else { return }
                                    
                                    // 2
                                    let room = Room(title: text, userEmail: self.user.email, completed: false)
                                    
                                    // 3
                                    let roomRef = self.roomRef.child(text.lowercased())
                                    
                                    // 4
                                    roomRef.setValue(room.toAnyObject())
    }
    
    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .default)
    
    alert.addTextField()
    
    alert.addAction(cancelAction)
    alert.addAction(saveAction)
    
    present(alert, animated: true, completion: nil)
  }
  
  func onlineUserCountButtonAction() {
    print("onlineUserCountButtonAction")
  }
}
