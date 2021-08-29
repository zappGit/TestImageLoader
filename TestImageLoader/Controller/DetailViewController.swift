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
    
    var image: UIImage?
    var imageDescription: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        Отображаем полученную информацию с другого экрана
        label.text = imageDescription
        detailImage.image = image
        }
    }
