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
import Photos

class RoomDetailViewController: JSQMessagesViewController {
  
  // MARK: Properties
  var messages = [JSQMessage]()
  var roomRef: DatabaseReference?
  lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingMessage()
  lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingMessage()
  private lazy var messageRef: DatabaseReference = self.roomRef!.child("messages")
  private var newMessageRefHandle: DatabaseHandle?
  
  var room: Room? {
    didSet {
      title = room?.title
    }
  }
  
  private lazy var userIsTypingRef: DatabaseReference =
    self.roomRef!.child("typingIndicator").child(self.senderId)
  private var localTyping = false
  var isTyping: Bool {
    get {
      return localTyping
    }
    set {
      localTyping = newValue
      userIsTypingRef.setValue(newValue)
    }
  }
  
  private lazy var userTypingQuery: DatabaseQuery =
    self.roomRef!.child("typingIndicator").queryOrderedByValue().queryEqual(toValue: true)
  
  lazy var storageRef: StorageReference = Storage.storage().reference(forURL: "gs://mate-6402d.appspot.com/")
  private let imageURL = "EMPTY"
  
  private var photoItems = [String: JSQPhotoMediaItem]()
  
  private var updateMessageRef: DatabaseHandle?
  
  deinit {
    if let refHandle = newMessageRefHandle {
      messageRef.removeObserver(withHandle: refHandle)
    }
    
    if let refHandle = updateMessageRef {
      messageRef.removeObserver(withHandle: refHandle)
    }
  }
  
  // MARK: UIViewController Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.senderId = Auth.auth().currentUser?.uid
    
    collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
    collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
    
    observeMessages()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    observeTyping()
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
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
    let message = messages[indexPath.item]
    if message.senderId == senderId {
      return outgoingBubbleImageView
    } else {
      return incomingBubbleImageView
    }
  }
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
    return nil
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
    let message = messages[indexPath.item]
    
    if message.senderId == senderId {
      cell.textView?.textColor = UIColor.white
    } else {
      cell.textView?.textColor = UIColor.black
    }
    return cell
  }
  
  // MARK: message UI & related functions
  private func setupOutgoingMessage() -> JSQMessagesBubbleImage {
    let bubbleImage = JSQMessagesBubbleImageFactory()
    return bubbleImage!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
  }
  
  private func setupIncomingMessage() -> JSQMessagesBubbleImage {
    let bubbleImage = JSQMessagesBubbleImageFactory()
    return bubbleImage!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
  }
  
  // MARK: Actions
  private func addMessage(withId id: String, name: String, text: String) {
    if let message = JSQMessage(senderId: id, displayName: name, text: text) {
      messages.append(message)
    }
  }
  
  private func addPhoto(withId id: String, key: String, mediaItem: JSQPhotoMediaItem) {
    if let message = JSQMessage(senderId: id, displayName: "", media: mediaItem) {
      messages.append(message)
      
      if mediaItem.image == nil {
        photoItems[key] = mediaItem
      }
      
      collectionView.reloadData()
    }
  }
  
  private func fetchImageDataByURL(_ photoURL: String, forMediaItem mediaItem: JSQPhotoMediaItem, clearsPhotoMessageMapOnSuccessForKey key: String?) {
    let storageRef = Storage.storage().reference(forURL: photoURL)
    storageRef.getData(maxSize: INT64_MAX) { (data, error) in
      if let error = error {
        print("Error: download iamge data: \(error)")
        return
      }
      
      storageRef.getMetadata(completion: { (metaData, error) in
        if let error = error {
          print("Error: download iamge metaData: \(error)")
          return
        }
        
        if (metaData?.contentType == "image/gif") {
          mediaItem.image = UIImage.init(data: data!)
        } else {
          mediaItem.image = UIImage.init(data: data!)
        }
        
        self.collectionView.reloadData()
        
        guard key != nil else {
          return
        }
        
        self.photoItems.removeValue(forKey: key!)
      })
    }
  }
  
  override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
    let itemRef = messageRef.childByAutoId()
    let messageItem = [
      "senderId": senderId!,
      "senderEmail": senderDisplayName!,
      "content": text!
    ]
    
    itemRef.setValue(messageItem)
    JSQSystemSoundPlayer.jsq_playMessageSentSound()
    finishSendingMessage()
    
    isTyping = false
  }
  
  override func didPressAccessoryButton(_ sender: UIButton!) {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
      imagePicker.sourceType = UIImagePickerControllerSourceType.camera
    } else {
      imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
    }
    
    present(imagePicker, animated: true, completion: nil)
  }
  
  func sendPhoto() -> String? {
    let itemRef = messageRef.childByAutoId()
    let messageItem = [
      "photoURL": imageURL,
      "senderId": senderId!
    ]
    
    itemRef.setValue(messageItem)
    JSQSystemSoundPlayer.jsq_playMessageSentSound()
    finishSendingMessage()
    
    return itemRef.key
  }
  
  func setImageURL(_ url: String, forPhotoMessageWithKey key: String) {
    let itemRef = roomRef?.child(key)
    itemRef?.updateChildValues(["photoURL": url])
  }
  
  // MARK: Observe functions
  private func observeMessages() {
    messageRef = roomRef!.child("messages")
    
    let messageQuery = messageRef.queryLimited(toLast:25)
    
    newMessageRefHandle = messageQuery.observe(.childAdded, with: { (snapshot) -> Void in
      let messageData = snapshot.value as! Dictionary<String, String>
      
      if let id = messageData["senderId"] as String!, let name = messageData["senderEmail"] as String!, let text = messageData["content"] as String!, text.characters.count > 0 {
        self.addMessage(withId: id, name: name, text: text)
        self.finishReceivingMessage()
      } else if let id = messageData["senderId"] as String!,
        let photoURL = messageData["photoURL"] as String! {
        if let mediaItem = JSQPhotoMediaItem(maskAsOutgoing: id == self.senderId) {
          // 3
          self.addPhoto(withId: id, key: snapshot.key, mediaItem: mediaItem)
          
          if photoURL.hasPrefix("gs://") {
            self.fetchImageDataByURL(photoURL, forMediaItem: mediaItem, clearsPhotoMessageMapOnSuccessForKey: nil)
          }
        }
      } else {
        print("Error!")
      }
    })
    
    updateMessageRef = messageRef.observe(.childChanged, with: { (snapshot) in
      let key = snapshot.key
      let messageData = snapshot.value as! Dictionary<String, String>
      
      if let photoURL = messageData["photoURL"] as String! {
        if let mediaItem = self.photoItems[key] {
          self.fetchImageDataByURL(photoURL, forMediaItem: mediaItem, clearsPhotoMessageMapOnSuccessForKey: key)
        }
      }
    })
  }
  
  private func observeTyping() {
    let typingRef = roomRef!.child("typingIndicator")
    userIsTypingRef = typingRef.child(senderId)
    userIsTypingRef.onDisconnectRemoveValue()
    
    userTypingQuery.observe(.value) { (data: DataSnapshot) in
      if data.childrenCount == 1 && self.isTyping {
        return
      }
      
      self.showTypingIndicator = data.childrenCount > 0
      self.scrollToBottom(animated: true)
    }
  }
  
  override func textViewDidChange(_ textView: UITextView) {
    super.textViewDidChange(textView)
    isTyping = textView.text != ""
  }
}


// MARK: Image Picker Delegate
extension RoomDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [String : Any]) {
    
    picker.dismiss(animated: true, completion:nil)
    
    if let photoReferenceUrl = info[UIImagePickerControllerReferenceURL] as? URL {
      let assets = PHAsset.fetchAssets(withALAssetURLs: [photoReferenceUrl], options: nil)
      let asset = assets.firstObject
      
      if let key = sendPhoto() {
        asset?.requestContentEditingInput(with: nil, completionHandler: { (contentEditingInput, info) in
          let imageFileURL = contentEditingInput?.fullSizeImageURL
          let path = "\(String(describing: Auth.auth().currentUser?.uid))/\(Int(Date.timeIntervalSinceReferenceDate * 1000))/\(photoReferenceUrl.lastPathComponent)"
          
          self.storageRef.child(path).putFile(from: imageFileURL!, metadata: nil) { (metadata, error) in
            if let error = error {
              print("Error: uploading photo: \(error.localizedDescription)")
              return
            }
            
            self.setImageURL(self.storageRef.child((metadata?.path)!).description, forPhotoMessageWithKey: key)
          }
        })
      }
    } else {
      let image = info[UIImagePickerControllerOriginalImage] as! UIImage
      if let key = sendPhoto() {
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        let imagePath = Auth.auth().currentUser!.uid + "/\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        storageRef.child(imagePath).putData(imageData!, metadata: metadata) { (metadata, error) in
          if let error = error {
            print("Error: uploading photo: \(error)")
            return
          }
  
          self.setImageURL(self.storageRef.child((metadata?.path)!).description, forPhotoMessageWithKey: key)
        }
      }
    }
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion:nil)
  }
}




