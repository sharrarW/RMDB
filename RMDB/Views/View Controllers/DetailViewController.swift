//
//  DetailViewController.swift
//  RMDB
//
//  Created by Sharrar Wasit on 12/22/21.
//  NOTE: Keeping the ViewModel in the controller file for the team's convenience to look at! @Clover

import UIKit
import Kingfisher

//Dictionary to hold character locations, keyed by its URL. Acts as local cache
private var locationDict: Dictionary<String, LocationModel> = [:]

struct DetailViewModel {
    
    var character: CharacterModel
    
    func getCharacterLocation(_ completionHandler: @escaping () -> Void) {
        
        // Check if location's stored in cache, keyed by URL (was already downloaded)
        if !(locationDict[self.character.location.url] == nil) {
            print("Found location in cache!")
            completionHandler()
        }
        
        // Otherwise download and store in cache
        else {
            NetworkManager.shared.getCharacterLocation(character: character) { (location) in
                locationDict[self.character.location.url] = location
                print("Downloading location ...")
                completionHandler()
            }
        }
    }
}

class DetailViewController: UIViewController {
    
    private var image : UIImageView!
    private var name : UILabel!
    private var dimension : UILabel!
    private var type : UILabel!
    private var resdidentCount : UILabel!
    private var locationStackView: UIStackView!
    
    var vm: DetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Programatically draw UI
        setupUI()
        
        // Download/Cache image using Kingfisher
        let url = URL(string: vm.character.image)
        image.kf.setImage(with: url)
        
        vm.getCharacterLocation {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.name.text = locationDict[self.vm.character.location.url]?.name
                self.dimension.text = "\(locationDict[self.vm.character.location.url]!.dimension)"
                self.type.text = locationDict[self.vm.character.location.url]?.type
                self.resdidentCount.text = "Resident Count: \(locationDict[self.vm.character.location.url]!.residents.count)"
            }
        }
    }
    
    
    
    // MARK: UI Configurations
    
    private func setupUI() {
        image = UIImageView()
        name = UILabel()
        dimension = UILabel()
        type = UILabel()
        resdidentCount = UILabel()
        locationStackView = UIStackView()
        
        locationStackView.axis = .horizontal
        locationStackView.distribution = .fillEqually
        locationStackView.alignment = .center
        locationStackView.spacing = 10
        locationStackView.addArrangedSubview(dimension)
        locationStackView.addArrangedSubview(type)
        locationStackView.addArrangedSubview(resdidentCount)
        
        view.addSubview(image)
        view.addSubview(name)
        view.addSubview(locationStackView)
        
        styleUI()
        configureAutoLayout()
    }
    
    private func configureAutoLayout() {
        image.translatesAutoresizingMaskIntoConstraints = false
        name.translatesAutoresizingMaskIntoConstraints = false
        dimension.translatesAutoresizingMaskIntoConstraints = false
        resdidentCount.translatesAutoresizingMaskIntoConstraints = false
        locationStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            image.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            image.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            image.heightAnchor.constraint(equalToConstant: 250),
            image.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            name.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            name.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 10),
            name.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 25),
            name.centerXAnchor.constraint(equalTo: image.centerXAnchor),
            
            resdidentCount.rightAnchor.constraint(equalTo: locationStackView.rightAnchor),
            
            locationStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 5),
            locationStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            locationStackView.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 30),
            locationStackView.centerXAnchor.constraint(equalTo: name.centerXAnchor),
        ])
    }
    
    private func styleUI() {
        name.font = UIFont.boldSystemFont(ofSize: 25)
        name.adjustsFontSizeToFitWidth = true
        name.minimumScaleFactor = 0.5
        name.textAlignment = .center
        name.numberOfLines = 1
        
        dimension.numberOfLines = 2
        dimension.adjustsFontSizeToFitWidth = true
        dimension.minimumScaleFactor = 0.5
        
        resdidentCount.numberOfLines = 0
    }
}
