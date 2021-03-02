//
//  AlbumViewController.swift
//  AlbApp
//
//  Created by Никита on 24.02.2021.
//

import UIKit

class AlbumViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var networkService = NetworkService()
    var image: UIImage?
    var album : Int = 0
    var albumName: String?
    var song = [Songs]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductTableViewCell")
        tableView.rowHeight = 70
        tableView.layer.cornerRadius = 10
        tableView.layer.borderWidth = 2
        albumImageView.image = image
        albumNameLabel.text = albumName
        
        networkService.fetchSing(searchText:album) { [weak self] (searchResults) in
            DispatchQueue.main.async {
                self?.song = searchResults?.results ?? []
                self?.tableView.reloadData()
                self?.song.remove(at: 0)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return song.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        let songs = song[indexPath.row]
        let lol = songs.trackName
        if lol != ""{
            cell.textLabel?.text = songs.trackName
            cell.imageView?.image = image
        }
        return cell
    }
}
