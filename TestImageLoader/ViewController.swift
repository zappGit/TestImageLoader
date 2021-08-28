//
//  ViewController.swift
//  TestImageLoader
//
//  Created by Артем Хребтов on 28.08.2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var results: [Hit] = []
    let network = NetworkManagerPixabay()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        network.getPost(text: "cat") { [weak self] results, error in
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

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text {
//            results = []
//            self.tableView.reloadData()
            network.getPost(text: text) { [weak self] results, error in
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
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return results.count
    }

    func image(data: Data?) -> UIImage? {
      if let data = data {
        return UIImage(data: data)
      }
      return UIImage(systemName: "picture")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell() }
        DispatchQueue.main.async {
        cell.image = UIImage(systemName: "photo")
        }
        let result = results[indexPath.row]
        let desc = result.tags == nil ? "Without description" : result.tags
        
        let id = result.id
        cell.cellID = id
        
        network.getImage(result: result) { data, time, error in
            if let error = error {
                print ("error", error)
                return
            }
            guard let data = data else { return }
            let image = self.image(data: data)
            DispatchQueue.main.async {
                if cell.cellID == id {
                cell.image = image
                cell.desc = desc
                }
                
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifire = segue.identifier else { return }
        if identifire == "detail" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            if let dvc = segue.destination as? DetailViewController {
            let result = results[indexPath.row]

                    network.getImage(result: result) { data, time, error in
                        if let error = error {
                            print ("error", error)
                            return
                        }
                        guard let data = data else { return }
                        dvc.image = self.image(data: data)
                        dvc.imageDescription = time
                        //dvc.result = result
                }
            }
        }
    }
    //TODO list
    //Cash or CoreData
    //Network status
    //Qty of loading images
    //NetworkManager??
}


