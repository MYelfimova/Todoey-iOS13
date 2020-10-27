//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

//Users/mariayelfimova/Library/Developer/Xcode/DerivedData/Todoey-ggmnwvjmcohyivbemzwcltawsudl/Build/Intermediates.noindex/Todoey.build/Debug-iphonesimulator/Todoey.build/DerivedSources/CoreDataGenerated/DataModel/Item+CoreDataProperties.swift

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var items = [Item]()
    
    //creating context - the context (similar principle to git) is tracking all my changes
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // create a variable for user defaul settings - takes only standars data types, doesnt take custom classes
    //var defaults = UserDefaults.standard
    // INSTEAD OF USING THE DEFAULT FOLDER I'M USING MY OWN FOLDER FOR SAVING THE DATA
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         
        // printing the location of my db storage
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist"))
        loadItems()
    }
    
    //MARK:  - TableView Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
        let item = items[indexPath.row]
        
        cell.textLabel?.text = items[indexPath.row].title
        cell.accessoryType = item.done == true ? .checkmark : .none

        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        items[indexPath.row].done = !items[indexPath.row].done
        
        self.saveItems()
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            context.delete(items[indexPath.row])
            items.remove(at:indexPath.row)
            self.saveItems()
        }

    }

    
    //MARK:  - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //creating a local variable, so that to store here the refference to the alertText field
        var textField = UITextField()
        
        // Here I define a VC that will execute my alert.
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        // Here I define my alert action - this is what should happend once the user clicks
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // what will happen once the user clicks on that button
            let newItem = Item(context: self.context)
            newItem.title = textField.text ?? "New Item"
            newItem.done = false
            self.items.append(newItem)
            
            self.saveItems()
            //print("action")
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
 
        //Here I call the action
        alert.addAction(action)
        alert.addAction(actionCancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model manupulating methods
    
    //used for Update Create Delete
    func saveItems() {
        //Saving the changes to the user defaults

        do {
            try context.save()
        }
        catch {
            print("Error saving context:\(error)")
        }
        
        self.tableView.reloadData()
    }
    //used for Read
    func loadItems() {
        //here i read my data frorm the database
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            items = try context.fetch(request)
        }
        catch {
            print("Error fetching context:\(error)")
        }
    }
}

