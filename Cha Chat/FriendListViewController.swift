//
//  FriendListViewController.swift
//  Cha Chat
//
//  Created by 송용규 on 22/02/2020.
//  Copyright © 2020 송용규. All rights reserved.
//

import UIKit
import FirebaseUI
import Firebase
import SnapKit
import Kingfisher



class FriendListViewController: UIViewController {
    

    @IBOutlet weak var tableView: UITableView!
    let currentUser = Auth.auth().currentUser
    var FriendList: [Friend] = []
    var friendUID = ""
    var senderName = ""
    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "FriendList"
        sendFriendList()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        
    }
    
    
    @IBAction func LogOutButtonClicked(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            guard let vc = self.storyboard?.instantiateViewController(identifier: "authViewController") else {return}
            self.dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    
    
    
    func sendFriendList() {
        Database.database().reference().child("users").observe(DataEventType.value, with: { (snapshot) in
            self.FriendList.removeAll()
            for child in snapshot.children {
                let fchild = child as! DataSnapshot
                let friend = Friend()
                let currentUserEmail = Auth.auth().currentUser?.email
                friend.setValuesForKeys(fchild.value as! [String : Any])
                if (!friend.email.elementsEqual(currentUserEmail!)){
                    self.FriendList.append(friend)
                }else {
                    self.senderName = friend.name
                }
                print("FriendList : \(self.FriendList)")
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData();
            }
        })
    }
    
    func moveChat() {
        
            var chatRoomUID = ""
            let chatRoomUID_first = Auth.auth().currentUser!.uid + self.friendUID
            let chatRoomUID_second = self.friendUID + Auth.auth().currentUser!.uid
            var createChatRoomFlag = false
            
             if chatRoomUID_first > chatRoomUID_second {
               chatRoomUID = chatRoomUID_first
            }else if chatRoomUID_first < chatRoomUID_second {
               chatRoomUID = chatRoomUID_second
            }
        
        if  Database.database().reference().child("chatRooms").child(chatRoomUID).description() == nil {
            Database.database().reference().child("chatRooms").child(chatRoomUID).setValue(["chats" : []])
            createChatRoomFlag = true

        }
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatView") as? ChatViewController else { return }
            vc.chatRoomUID = chatRoomUID
            vc.createChatRoomFlag = createChatRoomFlag
            vc.title = "친구이름"
        vc.senderName = self.senderName
            self.navigationController?.pushViewController(vc, animated: true)
            //self.present(vc, animated: true, completion: nil)
    }
    
}

extension FriendListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FriendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let label = UILabel()
        let imageView = UIImageView()
        let imageURL = URL(string: FriendList[indexPath.row].profileImageUrl)
        
        cell.addSubview(label)
        cell.addSubview(imageView)
        
        label.text = FriendList[indexPath.row].name
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "profileImage"),options: [.transition(.flipFromLeft(0.1))])
        
        imageView.snp.makeConstraints{(make) in
            make.centerY.equalTo(cell)
            make.left.equalTo(cell).offset(10)
            make.height.width.equalTo(40)
        }
        
        label.snp.makeConstraints{ (make) in
            make.centerY.equalTo(cell)
            make.left.equalTo(imageView.snp.right).offset(20)
        }
        imageView.layer.borderWidth = 1
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.friendUID = FriendList[indexPath.row].userUid
        moveChat()
        
    }
}



