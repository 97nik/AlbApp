//
//  HistoryTableViewController.swift
//  AlbApp
//
//  Created by Никита on 28.02.2021.
//

import UIKit
import CoreData

class HistoryTableViewController: UITableViewController {
    
    var search = [Search]()
    
    let sc = SerachCollectionViewController()
    
    @IBAction func trashHistoryBarButton(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Search> = Search.fetchRequest()
        if let objects = try? context.fetch(fetchRequest) {
            for object in objects {
                context.delete(object)
                search.removeAll()
            }
        }
        do {
            try context.save()
            tableView.reloadData()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Search> = Search.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "data", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            search = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return search.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchIdentifier", for: indexPath)
        
        let searchOne = self.search[indexPath.row]
        
        cell.textLabel?.text = searchOne.title
        cell.imageView?.image = UIImage(systemName: "return" )
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchOne = self.search[indexPath.row]
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SerachCollectionViewController") as? SerachCollectionViewController {
            viewController.tagUrl = searchOne.title ?? ""
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
}
