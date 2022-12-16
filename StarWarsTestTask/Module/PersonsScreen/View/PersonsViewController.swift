//
//  PersonsViewController.swift
//  StarWarsTestTask
//
//  Created by Артем Соколовский on 15.12.2022.
//

import UIKit

class PersonsViewController: UIViewController {
    
    var navTitle: String!
    
    var viewModel: PersonsViewModelProtocol!
    var personsApiStrings: [String]!
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = navTitle
        viewModel = PersonsViewModel()
        viewModel.downloadingPersons(apiStrings: personsApiStrings) { [weak self] result in
            switch result {
            case .success(()):
                self?.tableView.reloadData()
            case .failure(let error):
                print("\(error.localizedDescription)")
            }
        }
        tableView.register(PersonTableViewCell.self, forCellReuseIdentifier: PersonTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
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
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destanation = segue.destination as? PlanetViewController else { return }
        guard let index = sender as? Int else { return }
        destanation.apiString = viewModel.tableViewPersons[index].homeworld
    }
    
}

extension PersonsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showPlanet", sender: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

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
        300.0
    }
    
}
