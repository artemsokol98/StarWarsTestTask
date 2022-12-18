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
    var person: String!
    
    // MARK: - UI elements
    
    let spinner = UIActivityIndicatorView(style: .large)
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.backgroundColor = UIColor(red: 0.5, green: 0.7, blue: 0.5, alpha: 1)
        stackView.layer.cornerRadius = 10
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
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var population: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = person
        viewModel = PlanetViewModel()
        sendRequest()
    }
    
    // MARK: - Layout UI elements
    
    override func viewDidLayoutSubviews() {
        view.addSubview(verticalStackView)
        view.addSubview(spinner)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        let constraintsForStackView = [
            verticalStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.1),
            verticalStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.bounds.height * 0.1),
            verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.1),
            verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.1)
        ]
        
        let constraintsForActivityIndicator = [
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraintsForStackView)
        NSLayoutConstraint.activate(constraintsForActivityIndicator)
    }
    
    func sendRequest() {
        spinner.startAnimating()
        guard let apiString = apiString else { return }
        viewModel.downloadingPlanet(apiString: apiString) { [weak self] result in
            self?.spinner.stopAnimating()
            switch result {
            case .success(()):
                guard let planetInfo = self?.viewModel.planetModelForView else { return }
                self?.namePlanet.text = "Planet: \(planetInfo.planetName)"
                self?.diameter.text = "Diameter: \(planetInfo.diameter)"
                self?.climate.text = "Climate: \(planetInfo.climate)"
                self?.gravitation.text = "Gravitation: \(planetInfo.gravitation)"
                self?.terrainType.text = "TerrainType: \(planetInfo.terrainType)"
                self?.population.text = "Population: \(planetInfo.population)"
                self?.verticalStackView.reloadInputViews()
            case .failure(let error):
                print(error.localizedDescription)
                self?.showAlert(title: "Error", message: "Failed loading")
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let action = UIAlertAction(title: "Try again", style: .default) { _ in
            self.sendRequest()
        }
        let back = UIAlertAction(title: "Back", style: .default) { _ in
            self.dismiss(animated: true)
        }
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(action)
        alert.addAction(back)
        present(alert, animated: true)
    }
}
