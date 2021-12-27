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

    private var locationName: UILabel = UILabel(text: "Unavailable")
    private var characterImage: UIImageView = UIImageView()
    
    // Dimension stack
    private var dimensionSymbol: UIImageView?
    private var title1: UILabel?
    private var dimensionName: UILabel = UILabel(text: "N/A")
    
    // Type stack
    private var typeSymbol: UIImageView?
    private var title2: UILabel?
    private var typeName: UILabel = UILabel(text: "N/A")
    
    // Population stack
    private var populationSymbol: UIImageView?
    private var title3: UILabel?
    private var populationCount: UILabel = UILabel(text: "N/A")
    
    
    var vm: DetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createElements()
        setData()
    }
    
    private func createElements() {
        
        dimensionSymbol = UIImageView(image: UIImage(systemName: "pyramid"))
        title1 = UILabel(text: "Dimension".uppercased())
        
        typeSymbol = UIImageView(image: UIImage(systemName: "moon.stars"))
        title2 = UILabel(text: "Type".uppercased())
        
        populationSymbol = UIImageView(image: UIImage(systemName: "person.3"))
        title3 = UILabel(text: "Population".uppercased())
        
        // Create 3 Vertical Stacks
        let dimensionVStack = UIStackView(axis: .vertical, views: [dimensionSymbol!, title1!, dimensionName],  alignment: .center, spacing: 5)
        let typeVStack = UIStackView(axis: .vertical, views: [typeSymbol!, title2!, typeName], alignment: .center, spacing: 5)
        let populationVStack = UIStackView(axis: .vertical, views: [populationSymbol!, title3!, populationCount], alignment: .center, spacing: 5)
        
        // Create parent Horizontal Stack for the VStacks
        let detailsContainerHStack = UIStackView(axis: .horizontal, views: [dimensionVStack, typeVStack, populationVStack], spacing: 0)
        
        // MARK: Add Subviews
        [characterImage, locationName, detailsContainerHStack].forEach{ view.addSubview($0) }
        view.addSubview(detailsContainerHStack)
        
        // MARK: Style Elements
        locationName.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        locationName.adjustsFontSizeToFitWidth = true
        locationName.numberOfLines = 1
        locationName.minimumScaleFactor = 0.5
        
        // Style titles above symbols
        [title1, title2, title3].forEach {$0?.font = UIFont.systemFont(ofSize: 15, weight: .semibold) }
        
        // Style SF symbols
        [dimensionSymbol, typeSymbol, populationSymbol].forEach {
            let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .light, scale: .medium)
            $0?.preferredSymbolConfiguration = config
            $0?.tintColor = .black
        }
        // Style location details
        [dimensionName, typeName, populationCount].forEach {
            $0.font = UIFont.systemFont(ofSize: 20, weight: .regular)
            $0.adjustsFontSizeToFitWidth = true
            $0.textAlignment = .center
            $0.minimumScaleFactor = 0.5
            $0.numberOfLines = 2        }
        
        
        // MARK: Configure Autolayout
        characterImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 5, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 250))

        locationName.anchor(top: characterImage.bottomAnchor, bottom: nil, leading: characterImage.leadingAnchor, trailing: characterImage.trailingAnchor, padding: .init(top: 15, left: 0, bottom: 0, right: 0))

        detailsContainerHStack.anchor(top: view.safeAreaLayoutGuide.centerYAnchor, bottom: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
    }
    
    private func setData() {
        
        // Download/Cache image using Kingfisher
        let url = URL(string: vm.character.image)
        characterImage.kf.setImage(with: url)
        
        vm.getCharacterLocation {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.locationName.text = locationDict[self.vm.character.location.url]?.name
                print("Set name!")
                self.dimensionName.text = "\(locationDict[self.vm.character.location.url]!.dimension)"
                self.typeName.text = locationDict[self.vm.character.location.url]?.type
                self.populationCount.text = "\(locationDict[self.vm.character.location.url]!.residents.count)"
            }
        }
    }
    
    }


