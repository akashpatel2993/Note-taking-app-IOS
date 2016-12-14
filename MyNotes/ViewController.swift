//
//  ViewController.swift
//  MyNotes
//
//  Created by jay on 2016-11-21.
//  Copyright © 2016 jay. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var lblNoResult: UILabel!
    var managedObjectContext: NSManagedObjectContext!
    
    lazy var fetchedResultsController:NSFetchedResultsController<NSFetchRequestResult>={
        var fetchRequest=NSFetchRequest<NSFetchRequestResult>()
        let itemEntity=NSEntityDescription.entity(forEntityName: "Item", in: self.managedObjectContext)
        fetchRequest.entity=itemEntity
        
        let sortDescriptors=NSSortDescriptor(key: "createdAt", ascending: true)
        fetchRequest.sortDescriptors=[sortDescriptors]
        
        let fetchedResultsController=NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate=self
        return fetchedResultsController
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try self.fetchedResultsController.performFetch()
            self.checkNoResult()
        } catch {
            let error=error as NSError
            print(error.description)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- Table data source
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "ToDoCell",for:indexPath) as! ToDoCellTableViewCell
        configureCell(cell: cell, atIndexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            let object=self.fetchedResultsController.object(at: indexPath) as! NSManagedObject
            self.managedObjectContext.delete(object)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let oldRow=self.fetchedResultsController.object(at: sourceIndexPath) as! NSManagedObject
        self.managedObjectContext.insert(oldRow)
        let objects=self.fetchedResultsController.fetchedObjects
    }
    
    // MARK: -
    // MARK: Table View Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: -
    // MARK: Fetched Results Controller Delegate Methods
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tblList.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tblList.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tblList.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tblList.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            if let indexPath = indexPath {
                let cell = tblList.cellForRow(at: indexPath) as! ToDoCellTableViewCell
                configureCell(cell: cell, atIndexPath: indexPath)
            }
            break;
        case .move:
            if let indexPath = indexPath {
                tblList.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                tblList.insertRows(at: [newIndexPath], with: .fade)
            }
            break;
        }
        self.checkNoResult()
    }
    
    //MARK:-
    //MARK:- Custom methods
    func configureCell(cell: ToDoCellTableViewCell, atIndexPath indexPath:IndexPath) {
        // Fetch Record
        let record = fetchedResultsController.object(at: indexPath) as! Item
        
        let attributes = [
            NSStrikethroughStyleAttributeName: NSNumber(value: NSUnderlineStyle.styleThick.rawValue),
            NSStrikethroughColorAttributeName:UIColor.gray
            ] as [String : Any]
        
        // Update Cell
        
        if let name = record.name {
            cell.lblName.text = name
        }
        
        if record.done {
            cell.btnDone.isSelected = record.done
            var title = NSAttributedString(string:record.name!, attributes: attributes)
            cell.lblName.attributedText=title
        }
        else{
            cell.btnDone.isSelected=false
        }
        
        
        cell.didTapButtonHandler = {
            if record.done {
                record.done = !record.done
            }
            else
            {
                record.done=true
            }
        }
        
       
    }
    
    func checkNoResult()
    {
        if let sections=self.fetchedResultsController.sections
        {
            
            if sections[0].numberOfObjects>0 {
                self.tblList.isHidden=false
                self.tblList.delegate=self
                self.tblList.dataSource=self
                self.tblList.tableFooterView=UIView()
                self.lblNoResult.isHidden=true
            }
            else
            {
                self.tblList.delegate=nil
                self.tblList.dataSource=nil
                self.tblList.isHidden=true
                self.lblNoResult.isHidden=false
            }
        }
    }
    
    //MARK:-
    //MARK:- Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier=="SegueAdd" {
            let vcNav=segue.destination as! UINavigationController
            
            if let vcAdd=vcNav.topViewController as? AddToDoViewController
            {
                vcAdd.managedObjectContext=self.managedObjectContext
                vcAdd.actionType=ActionType.ADD
            }
        }
        else if segue.identifier=="SegueUpdate"
        {
            let vcNav=segue.destination as! UINavigationController
            
            if let vcAdd=vcNav.topViewController as? AddToDoViewController
            {
                vcAdd.managedObjectContext=self.managedObjectContext
                vcAdd.actionType=ActionType.UPDATE
                if let index=self.tblList.indexPathForSelectedRow
                {
                    vcAdd.record=self.fetchedResultsController.object(at: index) as? Item
                }
            }
            
        }
    }
    
    //MARK:-
    //MARK:- Actions
    @IBAction func onEditClick(_ sender: UIBarButtonItem) {
        if self.tblList.isEditing {
            self.tblList.isEditing=false
            self.navigationItem.leftBarButtonItem?.title="Edit"
            self.navigationItem.leftBarButtonItem=UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(onEditClick(_:)))
        }
        else
        {
            self.tblList.isEditing=true
            self.navigationItem.leftBarButtonItem=UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onEditClick(_:)))
            
        }
    }
    
}

