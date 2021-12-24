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
    
    private var charactersUrl = URL(string: "https://rickandmortyapi.com/api/character")!
    
    //character.location.url
    
    enum Endpoint : String {
        case characters = "character"
        case location = "location"
    }
    
    func getCharacters(_ completionHandler: @escaping ([CharacterModel]) -> Void ) {
        print("Downloading initiated ... ")
        downloadData(url: charactersUrl) { (returnedData) in
            if let data = returnedData {
                guard let characters = try? JSONDecoder().decode(Results.self, from: data) else { print("download failed")
                    return }
                
                print("Parsed Character(s) List JSON data")
                // print each character
                for character in characters.results {
                    array.append(character)
                    
                }
                
                completionHandler(characters.results)
                print(array.count)
  
            }
        }
    }
    
    func getCharacterLocation(character: CharacterModel, _ completionHandler: @escaping (RMLocation) -> Void ) {
        print("Retrieving character location")
        guard let locationUrl = URL(string: character.location.url) else { return }
        downloadData(url: locationUrl) { (returnedData) in
            if let data = returnedData {
                guard let location = try? JSONDecoder().decode(RMLocation.self, from: data) else { print("download failed")
                    return }
                
                print("Parsed Location JSON data")
                // print each character
                print("\(location.name): \(location.residents.count)")
                completionHandler(location)
            }
        }
    }
    
    func downloadData(url: URL, completionHandler: @escaping (_ data: Data?) -> ()) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            print ("Downloaded as JSON data")
            completionHandler(data)
        }
        task.resume()
    }
}
