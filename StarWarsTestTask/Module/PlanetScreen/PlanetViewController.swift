//
//  PlanetViewController.swift
//  StarWarsTestTask
//
//  Created by Артем Соколовский on 16.12.2022.
//

import UIKit

class PlanetViewController: UIViewController {
    
    var viewModel: PlanetViewModelProtocol!
    var apiString: String?
    
    private lazy var card: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor(red: 0.5, green: 0.7, blue: 0.5, alpha: 1)
        return view
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.addArrangedSubview(namePlanet)
        stackView.addArrangedSubview(diameter)
        stackView.addArrangedSubview(climate)
        stackView.addArrangedSubview(gravitation)
        stackView.addArrangedSubview(terrainType)
        stackView.addArrangedSubview(population)
        return stackView
    }()
    
    private lazy var namePlanet: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var diameter: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var climate: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var gravitation: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var terrainType: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var population: UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = PlanetViewModel()
        guard let apiString = apiString else {
            return //show error and try again.
        }

        viewModel.downloadingPlanet(apiString: apiString) { [weak self] result in
            switch result {
            case .success(()):
                self?.namePlanet.text = self?.viewModel.planetModelForView.planetName
                self?.diameter.text = self?.viewModel.planetModelForView.diameter
                self?.climate.text = self?.viewModel.planetModelForView.climate
                self?.gravitation.text = self?.viewModel.planetModelForView.gravitation
                self?.terrainType.text = self?.viewModel.planetModelForView.terrainType
                self?.population.text = self?.viewModel.planetModelForView.population
                self?.verticalStackView.reloadInputViews()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        view.addSubview(verticalStackView)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraintsForStackView = [
            verticalStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.1),
            verticalStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.bounds.height * 0.1),
            verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraintsForStackView)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
