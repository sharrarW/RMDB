//
//  NetworkController.swift
//  RMDB
//
//  Created by Sharrar Wasit on 12/22/21.
//

import Foundation

var array: [CharacterModel] = []

struct NetworkManager {
    
     
    static let shared = NetworkManager()
    
    
    private var url = URL(string: "https://rickandmortyapi.com/api/character")!
    
    enum Endpoint : String {
        case characters = "character"
        case location = "location"
    }
    
    func getCharacters(_ completionHandler: @escaping ([CharacterModel]) -> Void ) {
        print("Downloading initiated ... ")
        downloadData { (returnedData) in
            if let data = returnedData {
                guard let characters = try? JSONDecoder().decode(Results.self, from: data) else { print("download failed")
                    return }
                
                print("Parsed JSON data")
                // print each character
                for character in characters.results {
                    array.append(character)
                    
                }
                
                completionHandler(characters.results)
                print(array.count)
  
            }
        }
    }
    
    
    func downloadData(completionHandler: @escaping (_ data: Data?) -> ()) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            print ("Downloaded as JSON data")
            completionHandler(data)
        }
        task.resume()
    }
    
    func getAndParseAPI() {
        
    }
}
