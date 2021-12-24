//
//  DetailViewController.swift
//  RMDB
//
//  Created by Sharrar Wasit on 12/22/21.
//

import UIKit
import Kingfisher


//Dictionary to hold character locations, keyed by its URL. Acts as local cache
var locationDict: Dictionary<String, RMLocation> = [:]

struct DetailViewModel {
    
    var character: CharacterModel
    
    func getCharacterLocation(_ completionHandler: @escaping () -> Void) {
        NetworkManager.shared.getCharacterLocation(character: character) { (location) in
            locationDict[self.character.location.url] = location
            completionHandler()
        }
    }
}

class DetailViewController: UIViewController {
    

    
    private var image : UIImageView!
    private var name : UILabel!
    private var dimension : UILabel!
    private var resdidentCount : UILabel!
    private var actionStackView: UIStackView!
    
    var vm: DetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        let url = URL(string: vm.character.image)
        image.kf.setImage(with: url)
        
        vm.getCharacterLocation {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.name.text = locationDict[self.vm.character.location.url]?.name
                self.dimension.text = "\(locationDict[self.vm.character.location.url]!.dimension)"
                self.resdidentCount.text = "Resident Count: \(locationDict[self.vm.character.location.url]!.residents.count)"
                print(locationDict.count)
            }
        }
    }
    
    private func setupUI() {
        image = UIImageView()
        name = UILabel()
        dimension = UILabel()
        resdidentCount = UILabel()
        actionStackView = UIStackView()
        
        view.addSubview(image)
        view.addSubview(name)
        view.addSubview(actionStackView)
        
        actionStackView.axis = .horizontal
        actionStackView.distribution = .fillEqually
        actionStackView.spacing = 10
        
        
        actionStackView.addArrangedSubview(dimension)
        actionStackView.addArrangedSubview(resdidentCount)
        
        styleUI()
        configureAutoLayout()
    }
    
    private func configureAutoLayout() {
        image.translatesAutoresizingMaskIntoConstraints = false
        name.translatesAutoresizingMaskIntoConstraints = false
        dimension.translatesAutoresizingMaskIntoConstraints = false
        resdidentCount.translatesAutoresizingMaskIntoConstraints = false
        actionStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            image.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            image.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            image.heightAnchor.constraint(equalToConstant: 250),
            image.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            name.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 25),
            name.centerXAnchor.constraint(equalTo: image.centerXAnchor),
            
            actionStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 5),
            actionStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            
            resdidentCount.rightAnchor.constraint(equalTo: actionStackView.rightAnchor),
            
            actionStackView.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 30),
            actionStackView.centerXAnchor.constraint(equalTo: name.centerXAnchor),
            
            
            
        ])
    }
    
    private func styleUI() {
        name.font = UIFont.boldSystemFont(ofSize: 25)
        name.adjustsFontSizeToFitWidth = true
        name.minimumScaleFactor = 0.5
        name.textAlignment = .center
        name.numberOfLines = 10
        
        dimension.numberOfLines = 1
        dimension.adjustsFontSizeToFitWidth = true
        dimension.minimumScaleFactor = 0.5
        
        resdidentCount.numberOfLines = 0
    }
}
