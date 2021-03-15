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
    @IBOutlet weak var artistNameLabel: UILabel!
    
    var networkService = NetworkService()
    var alert = SerachCollectionViewController()
    var image: UIImage?
    var album : Int = 0
    var albumName: String?
    var song = [Track]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        albumImageView.image = image
        albumNameLabel.text = albumName

        networkService.fetchAlbum(forRequestType: .aboutTheAlbum(album: String(album)))
        networkService.onResult = { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let album):
                    self?.song = album.results
                    self?.song.remove(at: 0)
                    self?.artistNameLabel.text = self?.song[0].artistName
                    self?.tableView.reloadData()
                case.failure:
                    print("lox")
                    //self?.alert.presentSearchAlertController()
                }
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
            cell.textLabel?.numberOfLines = 2
            cell.imageView?.image = UIImage(systemName: "music.note")
        }
        return cell
    }
}
