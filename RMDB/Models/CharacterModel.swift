//
//  RMCharacter.swift
//  RMDB
//
//  Created by Sharrar Wasit on 12/21/21.
//

import Foundation

struct Results: Decodable {
    let results: [CharacterModel]
}

struct CharacterModel: Decodable  {
    
    let name: String
    let status: String
    let species: String
    
    let location: LocationURL
    
    let image: String
    
    init(name: String, status: String, species: String, location: LocationURL, image: String) {
        self.name = name
        self.status = status
        self.species = species
        self.location = location
        self.image = image
    }
}

// INTERNAL LOCATION
struct LocationURL: Decodable{
    let url: String
}
