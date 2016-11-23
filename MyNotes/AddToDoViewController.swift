//
//  AddToDoViewController.swift
//  MyNotes
//
//  Created by jay on 2016-11-21.
//  Copyright © 2016 jay. All rights reserved.
//

import UIKit
import CoreData

class AddToDoViewController: UIViewController,UITextFieldDelegate {

    var managedObjectContext: NSManagedObjectContext!
    
    @IBOutlet weak var txtFieldNotes: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onCancelClick(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func onSaveClick(_ sender: UIBarButtonItem) {
        
        if !(self.txtFieldNotes.text?.isEmpty)! {
            
            let notes=self.txtFieldNotes.text
            
            let notesEntity=NSEntityDescription.entity(forEntityName: "Item", in: self.managedObjectContext)
            
            let modelObject=NSManagedObject(entity: notesEntity!, insertInto: self.managedObjectContext)
            
            modelObject.setValue(notes, forKey: "name")
            modelObject.setValue(NSDate(), forKey: "createdAt")
            
            do {
                try self.managedObjectContext.save()
                dismiss(animated: true, completion: nil)

            } catch  {
                let error=error as NSError
                print(error.description)
                self.showAlertWithTitle(title: "Warning", message: "Your to-do could not be saved.", cancelButtonTitle: "OK")
            }
            
        }
        else
        {
            self.showAlertWithTitle(title: "Warning!!", message: "Pleaser enter the notes", cancelButtonTitle: "Ok")
        }
        

    }
}
