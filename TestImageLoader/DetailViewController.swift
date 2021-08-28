//
//  DetailViewController.swift
//  TestImageLoader
//
//  Created by Артем Хребтов on 28.08.2021.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var label:UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    
    let network = NetworkManagerPixabay()
    
    //var result: Result?
    var image: UIImage?
    var imageDescription: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = imageDescription
        detailImage.image = image
//        guard let result = result else { return }
//        network.getImage(result: result) { data, time, error in
//            if let error = error {
//                print ("error", error)
//                return
//            }
//            guard let data = data else { return }
//            DispatchQueue.main.async {
//                self.detailImage.image = UIImage(data: data)
//                self.label.text = time
//            }
//
        }
    
        
        // Do any additional setup after loading the view.
    }
    
   
    

