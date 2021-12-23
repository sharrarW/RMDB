//
//  CharacterDetailCell.swift
//  RMDB
//
//  Created by Sharrar Wasit on 12/22/21.
//

import UIKit

class CharacterDetailCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    var character: CharacterModel? {
        didSet {
            guard let character = character else { return }
            
            nameLabel.text = character.name
            speciesLabel.text = character.species
            statusLabel.text = character.status
            
        }
    }
}
