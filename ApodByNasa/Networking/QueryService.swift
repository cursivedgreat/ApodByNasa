//
//  QueryService.swift
//  ApodByNasa
//
//  Created by Avinash Kumar on 23/07/22.
//

import Foundation

///Class performs data task in default URLSession configuration
class QueryService {
    //
    //MARK: - Constants
    //
    let defaultSession = URLSession(configuration: .default)
    
    //
    //MARK: - Variables
    var apodInfo: ApodInfo?
    var errorMessage = ""
    var dataTask: URLSessionDataTask?
    typealias QueryResult = (Result<ApodInfo, Error>) -> Void
    
    func getApodInfo(forDate date: String, completion: @escaping QueryResult) {
        dataTask?.cancel()
        if var urlComponent = URLComponents(string: "https://api.nasa.gov/planetary/apod") {
            urlComponent.query = "api_key=1d88NWCQ1f4m4ajlOKEHIIczXMdnnde7s8ZaYr0p&date=\(date)"
            guard let url = urlComponent.url else { return }
            
            dataTask = defaultSession.dataTask(with: url, completionHandler: {[weak self] data, response, error in
                
                defer {
                    self?.dataTask = nil
                }
                
                if let error = error {
                    completion(.failure(error))
                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    do {
                        let apodInfo = try JSONDecoder().decode(ApodInfo.self, from: data)
                        completion(.success(apodInfo))
                    } catch let error {
                        completion(.failure(error))
                    }
                }
            })
            self.dataTask?.resume()
        }
    }
    
}
