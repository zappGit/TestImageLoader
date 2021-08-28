//
//  NetworkManagerPixabay.swift
//  TestImageLoader
//
//  Created by Артем Хребтов on 28.08.2021.
//

import Foundation

//enum NetworkManagerError: Error {
//    case invalidUrl
//    case badData
//}

class NetworkManagerPixabay {
    
    
    var results: [Hit] = []
    
    var imageCash = NSCache<NSString, NSData>()
    var dataCash = NSCache<NSString, NSString>()
    
    
    func getTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let hour = calendar.component(.hour, from: date)
        let year = calendar.component(.year, from: date)
        let min = calendar.component(.minute, from: date)
        let sec = calendar.component(.second, from: date)
        //var dataTime = Calendar.current.component(.hour, from: Date())
        return "Image load on \(day).\(month).\(year) at \(hour):\(min):\(sec)"
        
    }
    //Func to get data from Unsplash API
    func getPost(text: String, complition: @escaping([Hit]?, Error?) -> Void) {
        let urlString = "https://pixabay.com/api/?key=23132531-be670cb0483c06e26caee5441&q=\(text)&per_page=200&pretty=true"
        
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
                let jsonResult = try JSONDecoder().decode(Pixabay.self, from: data)
                print("get data")
                complition(jsonResult.hits,nil)
            }
            catch let error {
                complition(nil, error)
            }
        }
        task.resume()
    }
    
    // Func to download data from URL
    private func download(imageURL: URL, completion: @escaping (Data?, String, Error?) -> (Void)) {
        if let imageCash = imageCash.object(forKey: imageURL.absoluteString as NSString),
           let date = dataCash.object(forKey: imageURL.absoluteString as NSString)
            {
            completion(imageCash as Data, date as String, nil)
            print ("Use cash image")
            return
        }
        let task = URLSession.shared.downloadTask(with: imageURL) { localUrl, _, error in
            if let error = error {
                completion(nil, "", error)
                return
            }
            guard let localUrl = localUrl else {
                completion(nil, "", NetworkManagerError.invalidUrl)
                return
            }
            do {
                let data = try Data(contentsOf: localUrl)
                self.imageCash.setObject(data as NSData, forKey: imageURL.absoluteString as NSString)
                self.dataCash.setObject(self.getTime() as NSString, forKey: imageURL.absoluteString as NSString)
                completion(data, self.getTime(), nil)
            }
            catch let error {
                completion(nil, "", error)
                return
            }
            
        }
        task.resume()
    }
    //Func to get image data
    func getImage(result: Hit, completion: @escaping(Data?, String, Error?) -> Void){
        guard let imageUrl = URL(string: result.webformatURL) else {
            completion(nil, "",  NetworkManagerError.invalidUrl)
            return
        }
        download(imageURL: imageUrl, completion: completion)
    }
    
}