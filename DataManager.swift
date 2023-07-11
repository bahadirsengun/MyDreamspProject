//
//  DataManager.swift
//  myDream
//
//  Created by Bahadır Sengun on 6.07.2023.
//

import Foundation

// Sembollerin Hangi Dilde Gösterileceğinin Yönetimini Yaptığımız Yer.

class DataManager {

    func fetchSemboller(from url: URL, completion: @escaping (Result<Symbols, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"]) as Error
                completion(.failure(error))
                return
            }

            let decoder = JSONDecoder()
            do {
                let symbols = try decoder.decode(Symbols.self, from: data)
                completion(.success(symbols))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
