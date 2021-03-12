//
//  SerachCollectionViewController.swift
//  AlbApp
//
//  Created by Никита on 24.02.2021.
//

import UIKit
import CoreData

class SerachCollectionViewController: UICollectionViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let searhController = UISearchController(searchResultsController: nil)
    var networkService = NetworkService()
    private var timer: Timer?
    
    var tracks = [Track]()
    var search = [Search]()
    var tagUrl : String = ""
    let itemsPerRow: CGFloat = 2
    let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        collectionView.reloadData()

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let photoVC = segue.destination as! AlbumViewController
        let collectionNameId = segue.destination as! AlbumViewController
        let collectionName = segue.destination as! AlbumViewController
        let cell = sender as! SearchCell
        photoVC.image = cell.albumImageView.image
        collectionNameId.album = cell.albumId ?? 0
        collectionName.albumName = cell.nameAlbum.text
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.becomeFirstResponder()
        
        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            let photoVC = segue.destination as! AlbumViewController
            let collectionNameId = segue.destination as! AlbumViewController
            let collectionName = segue.destination as! AlbumViewController
            let cell = sender as! SearchCell
            photoVC.image = cell.albumImageView.image
            collectionNameId.album = cell.albumId ?? 0
            collectionName.albumName = cell.nameAlbum.text
        }
    }

    private func parseJson (whiteTitle title: String){
        self.networkService.fetchAlbum(forRequestType: .albumName(album: title))
        self.networkService.onResult = { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let album):
                    self?.tracks = album.results
                    self?.collectionView.reloadData()
                    self?.activityIndicator.stopAnimating()
                case.failure:
                    self?.presentSearchAlertController()
                }
            }
        }
    }
    
    private func saveSearch (whiteTitle title: String){
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            guard let entity = NSEntityDescription.entity(forEntityName: "Search", in: context) else { return }
            
            let taskObject = Search(entity: entity, insertInto: context)
            taskObject.title = title
            taskObject.data = Date()
            
            do {
                try context.save()
                self.search.insert(taskObject, at: 0)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupSearchBar(){
        navigationItem.searchController = searhController
        searhController.searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Search> = Search.fetchRequest()
        
        do {
            search = try context.fetch(fetchRequest)
            guard let tag = search.last?.title else {return}
         
            if search.last?.title != nil {
                parseJson(whiteTitle: tag)
            } else {return}
            collectionView.reloadData()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    //MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tracks.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as! SearchCell
        
        let track = tracks[indexPath.row]
        cell.nameAlbum.text = track.collectionName
        cell.albumId = track.collectionId
        
        DispatchQueue.global().async {
            guard let imageUrl = URL(string: track.artworkUrl100 ?? "") else { return }
            guard let imageData = try? Data(contentsOf: imageUrl) else { return }
            
            DispatchQueue.main.async {
                cell.albumImageView.image = UIImage(data: imageData)
            }
        }
        
        return cell
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension SerachCollectionViewController : UICollectionViewDelegateFlowLayout {
    
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     
        let paddingWidth = sectionInserts.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = availableWidth / itemsPerRow + 20
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
    
}

//MARK: UISearchBarDelegate
extension  SerachCollectionViewController: UISearchBarDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
  
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        func searchBarFieldShouldReturn (_ searchBar: UISearchBar){
            performSegue(withIdentifier: searchText, sender: nil)
        }
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.parseJson(whiteTitle: searchText)
        })
        
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (_) in
            
            DispatchQueue.global().async {
                self.saveSearch(whiteTitle: searchText)
            }
            
        })
    }
}
