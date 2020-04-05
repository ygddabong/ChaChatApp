//
//  KeyboardLayOutConstraint.swift
//  Cha Chat
//
//  Created by 송용규 on 16/02/2020.
//  Copyright © 2020 송용규. All rights reserved.
//

import Foundation
import UIKit
public class KeyboardLayoutConstraint: NSLayoutConstraint {
    
    var offset: CGFloat = 0
    var keyboardVisibleHeight: CGFloat = 0
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        offset = constant
        
        NotificationCenter.default.addObserver(self, selector:#selector(KeyboardLayoutConstraint.keyboardWillShow), name: NSNotification.Name("UIKeyboardWillShow"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(KeyboardLayoutConstraint.keyboardWillHide), name: NSNotification.Name("UIKeyboardWillHide"), object: nil)
    }
    
    
    @objc func keyboardWillShow (_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let frameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let frame = frameValue.cgRectValue
                keyboardVisibleHeight = frame.size.height
            }
            self.updateConstant()
            switch (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber, userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber) {
            case let (.some(duration), .some(curve)):
                let options = UIView.AnimationOptions(rawValue: curve.uintValue)
                UIView.animate(withDuration: duration.doubleValue, delay: 0,options: options, animations: {
                    UIApplication.shared.keyWindow?.layoutIfNeeded()
                    return
                }, completion: {(finished) in
            })
            default:
                break
            }
            
        }
    }
    
    @objc func keyboardWillHide (_ notification: Notification) {
        
        keyboardVisibleHeight = 0
        self.updateConstant()
        
        if let userInfo = notification.userInfo {
            
            switch (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber, userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber) {
            case let (.some(duration), .some(curve)):
                let options = UIView.AnimationOptions(rawValue: curve.uintValue)
                UIView.animate(withDuration: duration.doubleValue, delay: 0,options: options, animations: {
                    UIApplication.shared.keyWindow?.layoutIfNeeded()
                    return
                }, completion: {(finished) in
            })
            default:
                break
            }
            
        }
    }
    
    
    func updateConstant() {
        self.constant = offset + keyboardVisibleHeight
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
