//
//  ViewController.swift
//  DreamLister
//
//  Created by MacTesterSierra on 12/1/16.
//  Copyright © 2016 DIGIGAMES INTERACTIVE. All rights reserved.
//

import UIKit
import CoreData // need this to be able to work with CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!

    // this is how to declare an FRC that fetches entities of type Item
    var controller: NSFetchedResultsController<Item>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        //generateTestData()
        attemptFetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func generateTestData()
    {
        // this is a test function to demonstrate how to insert data into CoreData
        
        // create an Item entity
        let item = Item(context: context)
        // set the attributes
        item.title = "Macbook Pro"
        item.price = 1800
        item.details = "Overpriced laptop"
        
        // create an Item entity
        let item2 = Item(context: context)
        // set the attributes
        item2.title = "Bose Headphones"
        item2.price = 300
        item2.details = "Noise cancelling, ear destroying"
        
        // create an Item entity
        let item3 = Item(context: context)
        // set the attributes
        item3.title = "Tesla Model S"
        item3.price = 110000
        item3.details = "Because gas is too mainstream"
        
        // don't forget to actually save the items. otherwise they will just stay in memory and then the next time you open the app, you won't see the actual items as they are deleted already from memory.
        ad.saveContext()
        
    }
    
    func attemptFetch()
    {
        // this is how to create a fetch request of type Item
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        // here we create a sort descriptor to sort the results according to the created attribute
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        
        // create the sorts for the price and title as well
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        // take note that this sorts capitalized letters first THEN sorts lowercase letters. For instance, C will go ahead of b
        //let titleSort = NSSortDescriptor(key: "title", ascending: true)
        // if you don't want this behavior, use the code below
        let titleSort = NSSortDescriptor(key: "title", ascending: true, selector:#selector(NSString.localizedCaseInsensitiveCompare(_:)) )
        
        // sort the data according to what the user set in the segmented controller
        if segment.selectedSegmentIndex == 0
        {
            // here we 'attach' the sort-by-date we created. notice that it accepts an array. this is because you can have more than 1 sort descriptors in a fetch request.
            fetchRequest.sortDescriptors = [dateSort]
        }
        else if segment.selectedSegmentIndex == 1
        {
            fetchRequest.sortDescriptors = [priceSort]
        }
        else
        {
            fetchRequest.sortDescriptors = [titleSort]
        }
        
        
        // instantiate the FRC: 2nd param is the context we exposed in our app delegate
        // 3rd param = we pass nil because we just want to return all of the results
        // 4th param = we don't need so pass nil
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        // DON'T FORGET TO SET THE DELEGATE OF THE FRC!
        controller.delegate = self
        /////////////////////////////////////////////
        
        self.controller = controller
        
        // a fetch request can fail, so we need a do-catch statement
        do{
            try controller.performFetch()
        } catch{
            let error = error as NSError
            print("\(error)")
        }
    }
    
    
    // MARK: - TABLEVIEW METHODS
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: ItemCell, indexPath: IndexPath)
    {
        // we will call the ItemCell's configure cell because remember MVC. We don't want to manipulate our views in a controller object. A view should manipulate itself. So we implement a primary configureCell in our ItemCell class. 
        
        let item = controller.object(at: indexPath)
        cell.configureCell(item: item)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = controller.sections{ // try to grab the sections out of the controller. it returns an array
            
            let sectionInfo = sections[section] // pass the section param from the tableview delegate func to the sections array
            return sectionInfo.numberOfObjects // then return the number of objects in that section
        }
        // if the above fails, return 0. this way we know it will return 0 if there's an error with the controller
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // first check if the FRC has fetched the Item objects successfully and it's not empty
        if let objs = controller.fetchedObjects, objs.count > 0{
            let item = objs[indexPath.row]
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections{
            return sections.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    
    
    
    @IBAction func segmentChanged(_ sender: AnyObject) {
        
        attemptFetch()
        
        // need to reload the tableview afterwards
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetailsVC"
        {
            if let destination = segue.destination as? ItemDetailsVC
            {
                if let item = sender as? Item
                {
                    destination.itemToEdit = item
                }
            }
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate  methods
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        // whenever the tableview is about to update. this will start to listen for changes and will handle that for us.
        // basically this method is called before the contents of the FRC changes. so this is a good place to update the tableview contents
        
        // this is an alternative to tableview.reloadData()
        tableView.beginUpdates() // call this metod if you want subsequent insertions, deletion, and selections operations to be animated simultaneously
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        // once the FRC changed its contents, end the tableview updates
        tableView.endUpdates()
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        // this is going to be listening for when we're gonna be making a change. whether it's an insertion,deletion,modification
        switch(type)
        {
        case .insert:
            // called when we create a new Item in the app
            if let indexPath = newIndexPath // we use newIndex because we're adding/inserting a new row for a new Item
            {
                // we insert a row into our tableview given the newIndexPath (last param)
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            // called when we delete an existing Item in the app
            if let indexPath = indexPath // we choose the existing index because we're deleting an existing Item
            {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .move:
            // called when we have implemented the ability for the user to move cells around. we delete the old cell row. then we insert a new cell row to wherever the user moved the Item to
            if let indexPath = indexPath
            {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath
            {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        case .update:
            // called when we update an existing item with new values/attributes
            if let indexPath = indexPath // we choose the existing index because we're updating an existing Item
            {
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                // TODO: Update the cell data. we'll come back to this later
                configureCell(cell: cell, indexPath: indexPath)
            }
        }
    }
    
    
}

