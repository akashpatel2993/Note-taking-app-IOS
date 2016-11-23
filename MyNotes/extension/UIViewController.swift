//
//  UIViewController.swift
//  MyNotes
//
//  Created by jay on 2016-11-22.
//  Copyright © 2016 jay. All rights reserved.
//

import UIKit

extension UIViewController
{
    open func showAlertWithTitle(title: String, message: String, cancelButtonTitle: String) {
        // Initialize Alert Controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Configure Alert Controller
        alertController.addAction(UIAlertAction(title: cancelButtonTitle, style: .default, handler: nil))
        
        // Present Alert Controller
        present(alertController, animated: true, completion: nil)
    }
}
