//
//  AddToDoViewController.swift
//  MyNotes
//
//  Created by jay on 2016-11-21.
//  Copyright © 2016 jay. All rights reserved.
//

import UIKit
import CoreData

class AddToDoViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate {
    
    @IBOutlet weak var txtFieldNotes: UITextField!
    @IBOutlet weak var collectionViewImageList: UICollectionView!
    
    var managedObjectContext: NSManagedObjectContext!
    var arrayOfImages=[Data]()
    let imagePickerTag=UIImagePickerController()
    var pageCount=0
    var actionType:ActionType!
    var record:Item!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePickerTag.delegate=self
        self.automaticallyAdjustsScrollViewInsets=false
        switch actionType! {
        case ActionType.ADD:
            self.title=kTxtADD
        case ActionType.UPDATE:
            self.title=kTxtUpdate
            self.txtFieldNotes.text=self.record.name
            self.arrayOfImages=self.record.image!
            
        }
    }
    
//   override func viewWillLayoutSubviews() {
//        self.collectionViewImageList.collectionViewLayout.invalidateLayout()
//    }
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
            
            
            switch actionType! {
            case ActionType.ADD:
                let notes=self.txtFieldNotes.text
                
                let notesEntity=NSEntityDescription.entity(forEntityName: "Item", in: self.managedObjectContext)
                let modelObject=Item(entity: notesEntity!, insertInto: self.managedObjectContext)
                
                modelObject.name=notes!
                modelObject.createdAt=Date()
                modelObject.image=self.arrayOfImages
                
            case ActionType.UPDATE:
                self.record.name=self.txtFieldNotes.text
                self.record.image=self.arrayOfImages
            }
            
            do {
                try self.managedObjectContext.save()
                dismiss(animated: true, completion: nil)
                
            } catch  {
                let error=error as NSError
                print(error.description)
                self.showAlertWithTitle(title: kTxtWarning, message: kTxtNotSaved, cancelButtonTitle: "OK")
            }
            
        }
        else
        {
            self.showAlertWithTitle(title:kTxtWarning, message: kTxtNotSaved, cancelButtonTitle: "OK")
        }
    }
    
    @IBAction func onCameraClick(_ sender: UIBarButtonItem) {
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
    
    // MARK: - Image picker delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.arrayOfImages.append(UIImageJPEGRepresentation(pickedImage,0.5)! as Data)
            dismiss(animated: true, completion: {
               // self.collectionViewImageList.reloadData()
                let indexPath=IndexPath(row: self.arrayOfImages.count-1, section: 0)
//                self.collectionViewImageList.scrollToItem(at: indexPath , at: UICollectionViewScrollPosition.right, animated: true)
                self.collectionViewImageList.insertItems(at: [indexPath])
                self.collectionViewImageList.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.right, animated: true)

            })
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Collection view delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayOfImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CustomCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellImage", for: indexPath) as! CustomCollectionViewCell
        
        cell.imgViewNote.image=UIImage(data: self.arrayOfImages[indexPath.row])
        
        return cell
    }
    
    //    private func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    //
    //    return self.collectionViewImageList.frame.size
    //
    //    }
    
    
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        self.pageCount += 1
    //
    //    }
    //    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    //
    //
    //
    //    }
    //
    //    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    //        let pageWidth=self.collectionViewImageList.frame.size.width
    //
    //        let point=CGPoint(x: pageWidth*CGFloat(self.pageCount), y: self.collectionViewImageList.contentOffset.y)
    //
    //        self.collectionViewImageList.setContentOffset(point, animated: true)
    //    }
    
    
    
}
