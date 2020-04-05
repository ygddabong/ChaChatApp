//
//  Friend.swift
//  Cha Chat
//
//  Created by 송용규 on 22/03/2020.
//  Copyright © 2020 송용규. All rights reserved.
//
import UIKit

class Friend : NSObject{
    @objc var email: String = ""
    @objc var password: String = ""
    @objc var name: String = ""
    @objc var profileImageUrl: String = ""
    @objc var userUid: String = ""
    @objc var chatRoomList: NSDictionary = [:]
}
