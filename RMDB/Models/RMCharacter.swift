//
//  RMCharacter.swift
//  RMDB
//
//  Created by Sharrar Wasit on 12/21/21.
//

import Foundation

/*
 Requirements
 - cell displays character NAME, STATUS, SPECIES
 - expanded cell displays IMAGE, LOCATION's (TYPE, DIMENSION, #_OF_RESIDENTS)
 
 */


struct Results: Decodable {
    let results: [CharacterModel]
}

    struct CharacterModel: Decodable  {
        
        
        let name: String
        let status: String
        let species: String

        let location: Location
        
        let image: String
        
        init(name: String, status: String, species: String, location: Location, image: String) {
          self.name = name
          self.status = status
          self.species = species
          self.location = location
          self.image = image
        }
    }
    // INTERNAL LOCATION
    struct Location: Decodable{
        let name: String
        let url: String
    }


