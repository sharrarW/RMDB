//
//  CharactersViewController.swift
//  RMDB
//
//  Created by Sharrar Wasit on 12/21/21.
//  NOTE: Keeping the ViewModel in the controller file for the team's convenience to look at! @Clover

import UIKit

class CharactersListViewModel {
    var characters: [CharacterModel] = []
    
    func fetchCharacters(_ completionHandler: @escaping () -> Void) {
        NetworkManager.shared.getCharacters { (characters) in
            self.characters = characters
            completionHandler()
        }
    }
}

class CharactersViewController: UITableViewController {

    private var vm = CharactersListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Gets data through View Model, then updates table view on main thread
        vm.fetchCharacters { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    // Loads detailViewController before switching to it
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showDetails") {
            guard let viewController = segue.destination as? DetailViewController, let character = sender as? CharacterModel else { return }
            viewController.vm = DetailViewModel(character: character)
        }
    }
}



// MARK: Tableview Datasource

extension CharactersViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.characters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CharacterDetailCell else {
            fatalError("Couldn't dequeue a cell")
        }
        cell.character = vm.characters[indexPath.row]
        return cell
    }
}



// MARK: Tableview Delegates

extension CharactersViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Switch to new controller, which loads image and gets location + location details
        performSegue(withIdentifier: "showDetails", sender: vm.characters[indexPath.row])
    }
}

