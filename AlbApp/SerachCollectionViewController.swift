//
//  SerachCollectionViewController.swift
//  AlbApp
//
//  Created by Никита on 24.02.2021.
//

import UIKit

class SerachCollectionViewController: UICollectionViewController {
    
    let searhController = UISearchController(searchResultsController: nil)
    var networkService = NetworkService()
    private var timer: Timer?
    
    var tracks = [Track]()
    
    let album = ["1","2","3","4","5","6","7","8","9","10"]
    
    let itemsPerRow: CGFloat = 2
    let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        
        

    }

    private func setupSearchBar(){
        navigationItem.searchController = searhController
        searhController.searchBar.delegate = self
    }
  

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return tracks.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as! SearchCell
        
        let track = tracks[indexPath.row]
        
        
//
//        let imageName = album[indexPath.item]
//        let image = UIImage(named: imageName)
//
//        cell.albumImageView.image = image
        cell.nameAlbum.text = track.trackName
        //cell.backgroundColor = .black
        
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

extension  SerachCollectionViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
      
       // guard let cityName = textField?.text else { return }
//        if searchText != "" {
////                self.networkWeatherManager.fetchCurrentWeather(forCity: cityName)
//            let searchTexts = searchText.split(separator: " ").joined(separator: "%20")
        
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkService.fetchTracks(searchText: searchText) { [weak self] (searchResults) in
                DispatchQueue.main.async {
                self?.tracks = searchResults?.results ?? []
                self?.collectionView.reloadData()
                }
            }
        })
        
}
}
