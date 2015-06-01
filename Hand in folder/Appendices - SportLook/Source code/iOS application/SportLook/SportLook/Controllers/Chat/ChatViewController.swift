//
//  ChatViewController.swift
//  SportLook
//
//  Created by Terminator on 22/04/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import UIKit

//Sources used
//https://github.com/huyouare/SwiftParseChat
//https://github.com/relatedcode/NotificationChat
//https://www.parse.com/questions/setchannel-and-setchannels-are-not-working-at-all-sends-it-to-every-installation
//https://parse.com/docs/ios/api/Classes/PFPush.html

class ChatViewController: JSQMessagesViewController {
    
    var outgoingBubbleImageData : JSQMessagesBubbleImage?
    var incomingBubbleImageData : JSQMessagesBubbleImage?
    var messages = [JSQMessage]()
    
    var timer: NSTimer?
    var isLoading: Bool = false
    
    var eventId: String?
    var eventName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupChat()
    
        isLoading = false
        self.loadMessages()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        timer = NSTimer()
        timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "loadMessages", userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    
    //MARK: Configure chat
    
    func setupChatLayout(){
        //No accessory left button, next to the 'Send' button
        self.inputToolbar.contentView.leftBarButtonItem = nil
        
        //Prevent the avatars from taking size
        self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
        
        //Create outgoing and incoming message bubbles
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImageData = bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
        incomingBubbleImageData = bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    }
    
    func setupChat(){
        
        setupChatLayout()
        
        //Mandatory setting senderId and displayName
        self.senderId = KeychainHandler.getUserLoggedId()
        self.senderDisplayName = KeychainHandler.getUserLoggedName()
    }
    
    //MARK: Setup navigation bar
    
    func setupNavBar(){
        self.title = "Event Chat"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: Selector("leftNavBarButtonTapped"))
        
        //Same as in 'BaseViewController'
        self.edgesForExtendedLayout = UIRectEdge.None
        self.navigationController?.navigationBar.translucent = false
    }
    
    func leftNavBarButtonTapped(){
        //Hide keyboard
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: JSQMessagesViewController method overrides
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        
        self.sendMessage(text)
    }
    
    //MARK: JSQMessagesViewController protocol required methods
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        
        return self.messages[indexPath.item]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        var message = self.messages[indexPath.item]
        if message.senderId == self.senderId {
            return outgoingBubbleImageData
        }
        return incomingBubbleImageData
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    //Display the name of the sender over each message
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        
        //Changes in this method, must be consistent with 'heightForMessageBubbleTopLabelAtIndexPath'

        let currentMessage = self.messages[indexPath.item]
        
        //If sender = self, don't show the sender label
        if (currentMessage.senderId == self.senderId) {
            return nil
        }
        
        //If sender is the same, for 2 messages in a row, don't show the sender label
        if(indexPath.item - 1 >= 0){
            let previousMessage = self.messages[indexPath.item - 1]
            if(previousMessage.senderId == currentMessage.senderId){
                return nil
            }
        }
        return NSAttributedString(string: currentMessage.senderDisplayName)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        
        //Changes in this method, must be consistent with 'attributedTextForMessageBubbleTopLabelAtIndexPath'

        let currentMessage = self.messages[indexPath.item]
        
        //If sender = self, don't show the sender label
        if(currentMessage.senderId == self.senderId){
            return 0.0
        }
        
        //If sender is the same, for 2 messages in a row, don't show the sender label
        if(indexPath.item - 1 >= 0){
            let previousMessage = self.messages[indexPath.item - 1]
            if(previousMessage.senderId == currentMessage.senderId){
                return 0.0
            }
        }
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    //MARK: UICollectionView DataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = self.messages[indexPath.item]
        if(message.isMediaMessage == false){
            if(message.senderId == self.senderId){
                cell.textView.textColor = UIColor.whiteColor()
            } else {
                cell.textView.textColor = UIColor.blackColor()
            }
        }
        
        let linkTextAttributes = [NSForegroundColorAttributeName: cell.textView.textColor, NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
        cell.textView.linkTextAttributes = linkTextAttributes
        
        return cell
    }
    
    //MARK: UICollectionView tap events
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapCellAtIndexPath indexPath: NSIndexPath!, touchLocation: CGPoint) {
        //Tapping outside any element should close the keyboard
        self.view.endEditing(true)
    }
    
    //MARK: Parse methods
    
    func loadMessages() {
        
        if self.isLoading == false {
            self.isLoading = true
            var lastMessage = messages.last
            
            var query = PFQuery(className: Constants.Parse.PF_CHAT_CLASS_NAME)
            query.whereKey(Constants.Parse.PF_CHAT_EVENT_ID, equalTo: eventId!)
            if lastMessage != nil {
                query.whereKey(Constants.Parse.PF_CHAT_CREATED_AT, greaterThan: lastMessage!.date!)
            }
            query.orderByDescending(Constants.Parse.PF_CHAT_CREATED_AT)
            query.limit = 50
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if error == nil {
                    self.automaticallyScrollsToMostRecentMessage = false
                    for object in (objects as! [PFObject]!).reverse() {
                        self.addMessage(object)
                    }
                    if objects!.count > 0 {
                        self.finishReceivingMessageAnimated(true)
                        self.scrollToBottomAnimated(false)
                    }
                    self.automaticallyScrollsToMostRecentMessage = true
                } else {
                    let alert = SCLAlertView()
                    alert.showError("Oups!", subTitle: "Couldn't load messages! Please check your internet connection and try again!", closeButtonTitle: "Ok")
                }
                self.isLoading = false
            })
        }
    }
    
    func addMessage(object: PFObject) {
        
        var message: JSQMessage!
        
        var userId = object[Constants.Parse.PF_CHAT_USER_ID] as! String
        var userName = object[Constants.Parse.PF_CHAT_USER_NAME] as! String
        
        message = JSQMessage(senderId: userId, senderDisplayName: userName, date: object.createdAt, text: (object[Constants.Parse.PF_CHAT_MESSAGE] as? String))
        messages.append(message)
    }
    
    func sendMessage(var text: String) {
        
        var object = PFObject(className: Constants.Parse.PF_CHAT_CLASS_NAME)
        object[Constants.Parse.PF_CHAT_USER_ID] = KeychainHandler.getUserLoggedId()
        object[Constants.Parse.PF_CHAT_USER_NAME] = KeychainHandler.getUserLoggedName()
        object[Constants.Parse.PF_CHAT_EVENT_ID] = self.eventId
        object[Constants.Parse.PF_CHAT_MESSAGE] = text

        object.saveInBackgroundWithBlock { (succeeded, error) -> Void in
            if error == nil {
                JSQSystemSoundPlayer.jsq_playMessageSentSound()
                self.loadMessages()
            } else {
                let alert = SCLAlertView()
                alert.showError("Oups!", subTitle: "Message couldn't be sent! Please check your internet connection and try again!", closeButtonTitle: "Ok")
            }
        }
        
        sendPushNotification(eventId!, text: text)
        self.finishSendingMessageAnimated(true)
    }
    
    //MARK: Push notification
    
    func sendPushNotification(groupId: String, text: String) {
        
        //Sending to everyone except myself
        let installationQuery = PFInstallation.query()
        let currentUserId = KeychainHandler.getUserLoggedId()
        installationQuery!.whereKey(Constants.Parse.PF_INSTALLATION_CURRENT_USER_ID, notEqualTo: currentUserId!)
        
        //Who is subscribed to the event channel
        let eventId = Constants.Parse.CHANNEL_EVENT + self.eventId!
        installationQuery!.whereKey(Constants.Parse.CHANNELS, containedIn: [eventId])
        
        var push = PFPush()
        push.setQuery(installationQuery)
        
        //Message format: User_name to event_name : Message
        //The push notification data should be consistent with the one sent for inviting to event
        var completeMessage = self.senderDisplayName + " to " + self.eventName! + " : " + text
        let data : [NSObject : AnyObject] = [
            "title" : "New chat message received!",
            "alert" : completeMessage,
            "badge" : "Increment",
            "eventId" : self.eventId!,
            "isForInvite": 0,
            "isForChat": 1
        ]
        push.setData(data)
        push.sendPushInBackgroundWithBlock { (succeeded, error) -> Void in
            if error != nil {
                println("sendPushNotification error")
            }
        }
    }
}
