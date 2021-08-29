//
//  ViewController.swift
//  TestImageLoader
//
//  Created by Артем Хребтов on 28.08.2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var results: [Hit] = []
    let network = NetworkManagerPixabay()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//Получаем данные с Pixabay
        network.getPost() { [weak self] results, error in
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
//Задаем кол-во ячеек таблицы, на основе полученных данных
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
// Преобразовываем Data в UIImage
    func image(data: Data?) -> UIImage? {
      if let data = data {
        return UIImage(data: data)
      }
      return UIImage(systemName: "picture")
    }
//Заполняем Table View полученной информацией.
//Кастим ячейку таблицы как кастомную.
//Присваиваем изображение и теги, используя методы NetworkManager
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell() }
        DispatchQueue.main.async {
        cell.image = UIImage(systemName: "photo")
        }
        let result = results[indexPath.row]
        let desc = result.tags == nil ? "Without tags" : result.tags
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
//   Убираем выделение ячеки при тапе на нее
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
//  Подготавливаем информацию для передачи на другой экран через segue
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
                }
            }
        }
    }
}


