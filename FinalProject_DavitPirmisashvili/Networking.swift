//
//  Networking.swift
//  FinalProject_DavitPirmisashvili
//
//  Created by Davit Pirmisashvili on 26.03.23.
//

import Foundation


enum NetworkError: Error {
    case wrongResponse
    case wrongStatusCode(code: Int)
}

class NetworkService {
    static var shared = NetworkService()
    
    var session = URLSession()
    
    init() {
        let urlSessionConfiguration = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: urlSessionConfiguration)
        self.session = urlSession
    }
    
    
    func getData<T: Codable>(urlString: String, completion: @escaping (T) ->(Void)) {
        let url = URL(string: urlString)!

        session.dataTask(with: URLRequest(url: url)) { data, response, error in
            
            if let error = error {
                print(error)
            }

            guard let response = response as? HTTPURLResponse else {
                return
            }
            
            guard (200...299).contains(response.statusCode) else {
                print("wrong response")
                return
            }
            
            guard let data = data else {
                return
            }

            do {
                let decoder = JSONDecoder()
                let object = try decoder.decode(T.self, from: data)
                
                DispatchQueue.main.async {
                    completion(object)
                }
            } catch {
                print(error)
            }
        }.resume()
    }
}
