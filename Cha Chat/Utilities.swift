//
//  Utilities.swift
//  Cha Chat
//
//  Created by 송용규 on 16/02/2020.
//  Copyright © 2020 송용규. All rights reserved.
//

import Foundation
import UIKit

class Utilites {
    func showAlert(title: String, message: String, vc: UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
}
