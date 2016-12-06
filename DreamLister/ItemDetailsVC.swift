//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Jovy Ong on 12/2/16.
//  Copyright © 2016 DIGIGAMES INTERACTIVE. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var itemTitle: CustomTextField!
    @IBOutlet weak var price: CustomTextField!
    @IBOutlet weak var details: CustomTextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var thumbImage: UIImageView!
    
    // array that will hold our Store entities
    var stores = [Store]()
    
    // array that will hold our ItemType entities
    var itemTypes = [ItemType]()
    
    // this will help us determine if we're in add or edit mode
    var itemToEdit: Item?
    
    
    // declare an image picker VC
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self
        pickerView.dataSource = self
        
        // create the image picker
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if UserDefaults.standard.string(forKey: "firstTime") != nil
        {
            print("Not user first time")
        }
        else
        {
            print("User first time")
            generateTestStores()
            generateTestItemTypes()
            UserDefaults.standard.set("no", forKey: "firstTime")
        }
        print("PREFS: \(UserDefaults.standard.string(forKey: "firstTime"))")

        
        
        getStores()
        getItemTypes()
        
        
        // figure out if we're adding or editing
        if itemToEdit != nil
        {
            loadItemData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - BUTTON FUNCTIONS
    @IBAction func imagePressed(_ sender: AnyObject) {
        
        // present the image picker VC when the user presses the image button
        present(imagePicker, animated: true, completion: nil)
        
        
    }
 
    @IBAction func savePressed(_ sender: AnyObject) {
        
        
        // create a new item based on user input
        //let item = Item(context: context)
        
        var item: Item!
        var picture: Image!
        var itemType: ItemType!
        
        if itemToEdit == nil
        {
            item = Item(context: context)
            picture = Image(context: context)
            itemType = ItemType(context: context)
        }
        else
        {
            // set the item to the passed item via segue
            item = itemToEdit
            // core data will behind the scenes automatically know that we're editing an existing item and will overwrite the item when we save, instead of creating a duplicate which is awesome.
            
            if item.toImage == nil
            {
                picture = Image(context: context)
            }
            else
            {
                picture = item.toImage
            }
            
            if item.toItemType == nil
            {
                itemType = ItemType(context: context)
            }
            else
            {
                itemType = item.toItemType
            }
        }
        
        if let thumbPic = thumbImage.image{
            picture.image = thumbPic
            item.toImage = picture
        }
        
        itemType = itemTypes[pickerView.selectedRow(inComponent: 1)]
        item.toItemType = itemType
        
        if let title = itemTitle.text{
            item.title = title
        }
        
        if let price = price.text{
            item.price = Double(price)!
        }
        
        if let details = details.text{
        
            item.details = details
        }
        
        item.toStore = stores[pickerView.selectedRow(inComponent: 0)]
        
        // save it to coredata
        ad.saveContext()
        
        // once saved, go back to the MainVC
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deletePressed(_ sender: AnyObject) {
        
        // check first if we're editing an existing Item
        if itemToEdit != nil
        {
            // this is how easy it is to delete an existing item in core data
            context.delete(itemToEdit!)
            // save the changes
            ad.saveContext()
            
        }
        
        // go back to MainVC regardless of editing or just adding a new Item
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    
    // MARK: - GENERATION TEST FUNCTIONS
    func generateTestStores()
    {
        // create some store entities
        let store = Store(context: context)
        store.name = "Best Buy"
        let store2 = Store(context: context)
        store2.name = "Tesla Dealership"
        let store3 = Store(context: context)
        store3.name = "Fry's Electronics"
        let store4 = Store(context: context)
        store4.name = "Target"
        let store5 = Store(context: context)
        store5.name = "Amazon"
        let store6 = Store(context: context)
        store6.name = "K Mart"
        
        ad.saveContext()
    }
    
    func getStores()
    {
        // this func will fetch the Stores saved in core data
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        do{
            self.stores = try context.fetch(fetchRequest)
            self.pickerView.reloadAllComponents() // similar to tableview.reloadData
        } catch{
            // handle the error here if any
            
        }
    }
    
    func generateTestItemTypes()
    {
        let itemType = ItemType(context: context)
        itemType.type = "Furniture"
        let itemType2 = ItemType(context: context)
        itemType2.type = "Electronics"
        let itemType3 = ItemType(context: context)
        itemType3.type = "Toys"
        let itemType4 = ItemType(context: context)
        itemType4.type = "Music"
        let itemType5 = ItemType(context: context)
        itemType5.type = "Jewelry"
        
        
        ad.saveContext()
    }
    
    func getItemTypes()
    {
        // this func will fetch the Stores saved in core data
        let fetchRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        do{
            self.itemTypes = try context.fetch(fetchRequest)
            self.pickerView.reloadAllComponents() // similar to tableview.reloadData
        } catch{
            // handle the error here if any
            
        }
    }
    
    
    // MARK: - PICKERVIEW DELEGATE METHODS
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var string: String!
        
        switch component
        {
        case 0:
            let store = stores[row]
            string = store.name
        case 1:
            let itemType = itemTypes[row]
            string = itemType.type
        default:
            string = "FAIL"
        }
        
        return string
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var count:Int
        
        switch component
        {
        case 0:
            count =  stores.count
        case 1:
            count =  itemTypes.count
        default:
            count =  0
        }
        
        return count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // this is the number of columns
        return 2
    }
    
    // MARK: - IMAGE PICKER DELEGATE FUNCTIONS
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // this is called when the user has chosen an image from the image picker already
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            thumbImage.image = image
        }
        
        // dismiss the pickerview afterwards
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - MY FUNCTIONS
    func loadItemData()
    {
        if let item = itemToEdit{
            itemTitle.text = item.title
            price.text = "\(item.price)"
            details.text = item.details
            
            // load the image attribute of the Item
            thumbImage.image = item.toImage?.image as? UIImage
            
            // assign the picker view store
            if let store = item.toStore{
                
                for i in 0..<stores.count
                {
                    let s = stores[i]
                    if s.name == store.name
                    {
                        pickerView.selectRow(i, inComponent: 0, animated: true)
                        break
                    }
                }
            }
            
            // assign the picker view item type
            if let itemType = item.toItemType
            {
                for i in 0..<itemTypes.count
                {
                    let t = itemTypes[i]
                    if t.type == itemType.type
                    {
                        pickerView.selectRow(i, inComponent: 1, animated: true)
                        break
                    }
                }
            }
        }
    }
    
    deinit {
        print("DELETING ITEMDETAILSVC")
    }

}
