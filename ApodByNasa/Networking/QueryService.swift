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
    let baseUrl = "https://api.nasa.gov/planetary/apod"
    let apiKey = "1d88NWCQ1f4m4ajlOKEHIIczXMdnnde7s8ZaYr0p"
    
    //
    //MARK: - Variables
    var apodInfo: ApodInfo?
    var errorMessage = ""
    var dataTask: URLSessionDataTask?
    typealias QueryResult = (Result<ApodInfo, NetworkError>) -> Void
    
    func getApodInfo(forDate date: String, completion: @escaping QueryResult) {
        dataTask?.cancel()
        if var urlComponent = URLComponents(string: baseUrl) {
            urlComponent.query = "api_key=\(apiKey)&date=\(date)"
            guard let url = urlComponent.url else { return }
            
            dataTask = defaultSession.dataTask(with: url, completionHandler: {[weak self] data, response, error in
                
                defer {
                    self?.dataTask = nil
                }
                
                if let error = error {
                    completion(.failure(.http(error)))
                } else if let data = data, let response = response as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        do {
                            let apodInfo = try JSONDecoder().decode(ApodInfo.self, from: data)
                            completion(.success(apodInfo))
                        } catch let error {
                            completion(.failure(.unknown(error)))
                        }
                    } else {
                        do {
                            let errorObj = try JSONDecoder().decode(ResponseError.self, from: data)
                            completion(.failure(.invalidDate(errorObj.msg)))
                        } catch let error {
                            print("\(#function):: Error \(error.localizedDescription)")
                        }
                    }
                }
            })
            self.dataTask?.resume()
        }
    }
    
}
