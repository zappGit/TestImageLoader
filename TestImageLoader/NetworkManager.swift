//
//  NetworkManager.swift
//  TestImageLoader
//
//  Created by Артем Хребтов on 28.08.2021.
//

import Foundation

enum NetworkManagerError: Error {
    case invalidUrl
    case badData
}

class NetworkManager {
    
    
    var results: [Result] = []
    
    var imageCash = NSCache<NSString, NSData>()
    
    //Func to get data from Unsplash API
    func getPost(complition: @escaping([Result]?, Error?) -> Void) {
        let urlString = "https://api.unsplash.com/search/photos?page=1&per_page=50&query=office&client_id=0z68AXZNy9C0k39_N65GJuZawnDmo7dFsROQw7NZPt0"
        
        guard let url = URL(string: urlString) else {
            complition(nil, NetworkManagerError.invalidUrl)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _ , error in
            //Handle error
            if let error = error {
                complition(nil, error)
                return
            }
            //Handle data
            guard let data = data else {
                complition(nil, NetworkManagerError.badData)
                return
            }
            //Decode JSON
            do {
                let jsonResult = try JSONDecoder().decode(ImageReguest.self, from: data)
                print("get data")
                complition(jsonResult.results,nil)
            }
            catch let error {
                complition(nil, error)
            }
        }
        task.resume()
    }
    
    // Func to download data from URL
    private func download(imageURL: URL, completion: @escaping (Data?, Error?) -> (Void)) {

        let task = URLSession.shared.downloadTask(with: imageURL) { localUrl, _, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let localUrl = localUrl else {
                completion(nil, NetworkManagerError.invalidUrl)
                return
            }
            do {
                let data = try Data(contentsOf: localUrl)
               
                completion(data, nil)
            }
            catch let error {
                completion(nil, error)
                return
            }
            
        }
        task.resume()
    }
    //Func to get image data
    func getImage(result: Result, completion: @escaping(Data?, Error?) -> Void){
        guard let imageUrl = URL(string: result.urls.small) else {
            completion(nil, NetworkManagerError.invalidUrl)
            return
        }
        download(imageURL: imageUrl, completion: completion)
    }
}
