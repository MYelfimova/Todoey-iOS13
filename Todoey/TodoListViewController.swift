//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var items = ["Smile at Denis","Find a perfect screen","Buy carrot"]
    
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let itemsArray = defaults.array(forKey: "TodoListArray") as? [String] {
            items = itemsArray
        }
    }
    
    //MARK - TableView Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
        } else { cell?.accessoryType = .checkmark }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    //MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //creating a local variable, so that to store here the refference to the alertText field
        var textField = UITextField()
        
        // Here I define a VC that will execute my alert.
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        // Here I define my alert action - this is what should happend once the user clicks
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // what will happen once the user clicks on that button
            self.items.append(textField.text ?? "New Item")
            
            //Saving the changes to the user defaults
            self.defaults.setValue(self.items, forKey: "TodoListArray")
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            //print(alertTextField)
            textField = alertTextField
            //print(alertTextField.text)
            //print("Now")
        }
        //Here I call the action
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}

