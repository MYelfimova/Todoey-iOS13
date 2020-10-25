//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var items = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    // create a variable for user defaul settings - takes only standars data types, doesnt take custom classes
    var defaults = UserDefaults.standard
    // INSTEAD OF USING THE DEFAULT FOLDER I'M USING MY OWN FOLDER FOR SAVING THE DATA
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         
        print(dataFilePath)
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
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: false)
        self.saveItems()
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
            let item = Item()
            item.title = textField.text ?? "New Item"
            self.items.append(item)
            
            self.saveItems()
            //print("action")
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            //print("canceled")
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            //print("Now")
        }
 
        //Here I call the action
        alert.addAction(action)
        alert.addAction(actionCancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        //Saving the changes to the user defaults
        //self.defaults.setValue(self.items, forKey: "TodoListArray")
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(self.items)
            try data.write(to: self.dataFilePath!)
        }
        catch {
            print("Error:\(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            
            do {
            items = try decoder.decode([Item].self, from: data)
            }
            catch {
                print("Error occured: \(error)")
            }
        }
    }
}

