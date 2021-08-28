//
//  ViewController.swift
//  TestImageLoader
//
//  Created by Артем Хребтов on 28.08.2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var results: [Result] = []
    let network = NetworkManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        network.getPost { [weak self] results, error in
            if let error = error {
                print ("error", error)
                return
            }
            guard let results = results else { return }
            self?.results = results
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
    }

   
    // MARK: - Table view data source

    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return results.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell() }
        let result = results[indexPath.row]
        let desc = result.description == nil ? "Without description" : result.description
        
        func image(data: Data?) -> UIImage? {
          if let data = data {
            return UIImage(data: data)
          }
          return UIImage(systemName: "picture")
        }
        
        network.getImage(result: result) { data, error in
            if let error = error {
                print ("error", error)
                return
            }
            guard let data = data else { return }
            let image = image(data: data)
            DispatchQueue.main.async {
                cell.image = image
                cell.desc = desc
                
                
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let identifire = segue.identifier else { return }
//        if identifire == "detail" {
//            //guard let indexPath = tableView.indexPathForSelectedRow else {return}
//            if let dvc = segue.destination as? DetailViewController {
//                let calendar = Calendar.current
//                let day = calendar.component(.day, from: date)
//                //dvc.imageDescription = results[indexPath.row].description
//                dvc.imageDescription = day
//            }
//        }
//    }
    //TODO list
    //Cash or CoreData
    //Network status
    //Qty of loading images
    //NetworkManager??
}


