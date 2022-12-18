//
//  FilmsScreenViewController.swift
//  StarWarsTestTask
//
//  Created by Артем Соколовский on 14.12.2022.
//

import UIKit
import CoreData

class FilmsScreenViewController: UIViewController {
    
    var viewModel: FilmsScreenViewModelProtocol!

    private let searchController = UISearchController()
    private var filterActive = false
    private let spinner = UIActivityIndicatorView(style: .large)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Search bar configuration
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Clear Cache", style: .done, target: self, action: #selector(clearCache))
        navigationController?.navigationBar.tintColor = .label
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        
        // MARK: - TableView configuration
        
        tableView.register(FilmsTableViewCell.self, forCellReuseIdentifier: FilmsTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        // MARK: - Spinner configuration
        
        spinner.hidesWhenStopped = true
        tableView.backgroundView = spinner
        
        viewModel = FilmsScreenViewModel()
        sendRequest()
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
    
    @objc private func clearCache() {
        DataManager.shared.clearCache()
    }
    
    private func sendRequest() {
        spinner.startAnimating()
        viewModel.downloadingFilms { [weak self] result in
            self?.spinner.stopAnimating()
            switch result {
            case .success(()):
                self?.tableView.reloadData()
            case .failure(let error):
                print("error in ViewController: \(error)")
                self?.showAlert(title: "Error", message: "Failed loading")
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let action = UIAlertAction(title: "Try again", style: .default) { _ in
            self.sendRequest()
        }
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(action)
        present(alert, animated: true)
    }
}

// MARK: - Pass data to the next ViewController

extension FilmsScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showPersons", sender: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destanation = segue.destination as? PersonsViewController else { return }
        guard let index = sender as? Int else { return }
        destanation.personsApiStrings = viewModel.charecters[index]
        destanation.navTitle = filterActive ? viewModel.parsedFilmsSearched[index].FilmName : viewModel.parsedFilms[index].FilmName
        destanation.numberOfMovie = index
    }
}

// MARK: - Configuring table view cells

extension FilmsScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filterActive ? viewModel.parsedFilmsSearched.count : viewModel.parsedFilms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilmsTableViewCell.identifier, for: indexPath) as? FilmsTableViewCell else { return UITableViewCell() }
        cell.configureCell(data: filterActive ? viewModel.parsedFilmsSearched[indexPath.row] : viewModel.parsedFilms[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        300.0
    }
}

// MARK: - Configuring search settings

extension FilmsScreenViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        filterItems(text: searchBar.text)
        tableView.reloadData()
    }
    
    func filterItems(text: String?) {
        guard let text = text else {
            filterActive = false
            self.tableView.reloadData()
            return
        }
        viewModel.parsedFilmsSearched = viewModel.parsedFilms.filter({ (item) -> Bool in
            return item.FilmName.lowercased().contains(text.lowercased())
            })
            filterActive = true
            self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        filterActive = false
        self.tableView.reloadData()
    }
}
