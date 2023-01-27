//
//  PersonsViewController.swift
//  StarWarsTestTask
//
//  Created by Артем Соколовский on 15.12.2022.
//

import UIKit

class PersonsViewController: UIViewController {
    
    var navTitle: String!
    var numberOfMovie: Int!
    var viewModel: PersonsViewModelProtocol!
    var personsApiStrings: [String]!
    let spinner = UIActivityIndicatorView(style: .large)
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = navTitle
        viewModel = PersonsViewModel()
        tableView.backgroundView = spinner
        spinner.startAnimating()
        sendRequest()
        tableView.register(PersonTableViewCell.self, forCellReuseIdentifier: PersonTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func sendRequest() {
        viewModel.downloadingPersons(numberOfMovie: numberOfMovie, apiStrings: personsApiStrings) { [weak self] result in
            self?.spinner.stopAnimating()
            switch result {
            case .success(()):
                self?.tableView.reloadData()
            case .failure(let error):
                self?.showAlert(title: "Error", message: "Failed loading")
                print(error.localizedDescription)
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let action = UIAlertAction(title: "Try again", style: .default) { _ in
            self.sendRequest()
        }
        let back = UIAlertAction(title: "Back", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
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
    
    override func viewDidLayoutSubviews() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraintsForTableView = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraintsForTableView)
    }
}

// MARK: - Pass data to the next ViewController

extension PersonsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showPlanet", sender: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destanation = segue.destination as? PlanetViewController else { return }
        guard let index = sender as? Int else { return }
        destanation.apiString = viewModel.tableViewPersons[index].homeworld
    }
}

// MARK: - Configuring Table View cell

extension PersonsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PersonTableViewCell.identifier, for: indexPath) as? PersonTableViewCell else { return UITableViewCell() }
        cell.configureCell(data: viewModel.tableViewPersons[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.tableViewPersons.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.heightOfTableViewCell
    }
}
