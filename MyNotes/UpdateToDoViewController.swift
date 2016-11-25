//
//  UpdateToDoViewController.swift
//  MyNotes
//
//  Created by jay on 2016-11-22.
//  Copyright © 2016 jay. All rights reserved.
//

import UIKit
import CoreData

class UpdateToDoViewController: UIViewController {
    
    @IBOutlet weak var txtFieldNotes: UITextField!
    
    @IBOutlet weak var imgViewTag: UIImageView!
    var managedObjectContext:NSManagedObjectContext!
    var record:NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtFieldNotes.text=self.record.value(forKey: "name") as? String
        
        if let imageData=self.record.value(forKey: "image") as? Data {
            self.imgViewTag.image=UIImage(data:imageData)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -
    // MARK: Actions
    @IBAction func onSave(_ sender: UIBarButtonItem) {
        if (self.txtFieldNotes.text?.isEmpty)!{
            self.showAlertWithTitle(title: "Warning!!", message: "Enter some text", cancelButtonTitle: "OK")
        }
        else
        {
            self.record.setValue(self.txtFieldNotes.text, forKey: "name")
            
            do {
                try self.managedObjectContext.save()
                if let vc=self.navigationController {
                    vc.popViewController(animated: true)
                }
            } catch  {
                let error=error as NSError
                print(error.description)
                self.showAlertWithTitle(title: "Warning", message: "Your to-do could not be saved.", cancelButtonTitle: "OK")
            }
        }
    }
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        if let vc=self.navigationController {
            vc.popViewController(animated: true)
        }
    }
}
