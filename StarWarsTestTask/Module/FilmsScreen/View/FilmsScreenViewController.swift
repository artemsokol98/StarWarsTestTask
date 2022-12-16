//
//  FilmsScreenViewController.swift
//  StarWarsTestTask
//
//  Created by Артем Соколовский on 14.12.2022.
//

import UIKit

class FilmsScreenViewController: UIViewController {
    
    var viewModel: FilmsScreenViewModelProtocol!
    
    private var loadingView = UIActivityIndicatorView()
    private let searchController = UISearchController()
    var filterActive = false
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationBarAppereance = UINavigationBarAppearance()
        navigationBarAppereance.configureWithDefaultBackground()
        navigationItem.standardAppearance = navigationBarAppereance
        navigationController?.navigationBar.tintColor = .label
        searchController.searchBar.delegate = self
        //searchController
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        tableView.register(FilmsTableViewCell.self, forCellReuseIdentifier: FilmsTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.startAnimating()
        tableView.backgroundView = spinner
        //loadingView = LoadingIndicator.shared.showLoading(in: tableView.backgroundView)
        viewModel = FilmsScreenViewModel()
        sendRequest()
        spinner.stopAnimating()
        
    }
    
    func sendRequest() {
        viewModel.downloadingFilms { [weak self] result in
            self?.loadingView.stopAnimating()
            switch result {
            case .success(()):
                self?.tableView.reloadData()
            case .failure(let error):
                print("error in ViewController: \(error)"); #warning("сделать алерт с показанием ошибки через 10 секунд")
            }
            
        }
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

extension FilmsScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showPersons", sender: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destanation = segue.destination as? PersonsViewController else { return }
        guard let index = sender as? Int else { return }
        destanation.personsApiStrings = viewModel.films.results?[index].characters
        destanation.navTitle = viewModel.films.results?[index].title
    }
}

extension FilmsScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filterActive ? viewModel.parsedFilmsSearched.count : viewModel.parsedFilms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilmsTableViewCell.identifier, for: indexPath) as? FilmsTableViewCell else { return UITableViewCell() }; #warning("Сделать нормальный возврат во всех guard")
        cell.configureCell(data: filterActive ? viewModel.parsedFilmsSearched[indexPath.row] : viewModel.parsedFilms[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        300.0
    }

}

extension FilmsScreenViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        filterItems(text: searchBar.text)
        //self.search = searchBar.text
        //DataManager.shared.starWarsPeople = []
        //DataManager.shared.lastSearches.insert(search, at: 0)
        //searchRequest(searchString: urlStarWars + search)
        //searchController.isActive = false
        tableView.reloadData()
    }
    
    func filterItems(text: String?) {
        
            guard let text = text else {
                filterActive = false
                self.tableView.reloadData()
                return
            }

        viewModel.parsedFilmsSearched = viewModel.parsedFilms.filter({ (item) -> Bool in
            return item.FilmName.lowercased().contains(text.lowercased()) //item.title.lowercased().contains(text.lowercased())
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
