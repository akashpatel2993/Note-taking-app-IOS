//
//  AddToDoViewController.swift
//  MyNotes
//
//  Created by jay on 2016-11-21.
//  Copyright © 2016 jay. All rights reserved.
//

import UIKit
import CoreData

class AddToDoViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var managedObjectContext: NSManagedObjectContext!
    
    @IBOutlet weak var imgViewTags: UIImageView!
    @IBOutlet weak var txtFieldNotes: UITextField!
    let imagePickerTag=UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePickerTag.delegate=self
        
        let tapGesture=UITapGestureRecognizer(target: self, action: #selector(handleImageTap(sender:)))
        self.imgViewTags.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Actions Methods
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
            
            let imageData=UIImageJPEGRepresentation(self.imgViewTags.image!,0.5)! as Data
            
            modelObject.setValue(imageData, forKey: "image")
            
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
    
    // MARK: - Image picker delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imgViewTags.contentMode = .scaleAspectFit
            self.imgViewTags.image = pickedImage
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Custom Methods
    
    func handleImageTap(sender:UITapGestureRecognizer)
    {
        let alert = UIAlertController(title:"Choose an option", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title:"Camera", style: .default, handler: {
            action in
            self.imagePickerTag.allowsEditing = true
            self.imagePickerTag.sourceType = .camera
            self.present(self.imagePickerTag, animated: true, completion: nil)
            
        }))
        alert.addAction(UIAlertAction(title:"Gallery", style: .default, handler: {
            action in
            self.imagePickerTag.allowsEditing = true
            self.imagePickerTag.sourceType = .photoLibrary
            self.present(self.imagePickerTag, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title:"Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
}
