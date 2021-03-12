//
//  alert.swift
//  AlbApp
//
//  Created by Никита on 12.03.2021.
//

import Foundation
import UIKit

extension SerachCollectionViewController  {
    func presentSearchAlertController() {
        
    let alertController = UIAlertController(title: "Ошибка", message: "Нет интернета.", preferredStyle: .alert)
            
    let action1 = UIAlertAction(title: "Ок", style: .default) { (action:UIAlertAction) in
        print("You've pressed default");
    }
        alertController.addAction(action1)
        present(alertController, animated: true, completion: nil)
    }
}
