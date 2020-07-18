//
//  ExploreController.swift
//  TwitterClone
//
//  Created by Andrey Novikov on 7/10/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class ExploreViewController: UITableViewController {
    
    // MARK: - Private properties
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var users = [User]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var filtredUsers = [User]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var inSearchMode: Bool {
        return searchController.isActive && !(searchController.searchBar.text!.isEmpty)
    }
    
    
    // MARK: - Live cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
        configureUI()
        setupTable()
        configureSearchController()
        
        print(inSearchMode)
        
    }
    
    // MARK: - API
    
    func fetchUsers() {
        UserService.shared.fetchUsers { users in
            self.users = users
        }
    }
    
    // MARK: - Private methods
    
    private func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Explore"
    }
    
    private func setupTable() {
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.reuseId)
        tableView.showsVerticalScrollIndicator = false
    }
    
    private func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search user"
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
}


// MARK: - UITableViewDataSource
extension ExploreViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filtredUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reuseId, for: indexPath) as? UserCell else  { return UITableViewCell() }
        
        let user = inSearchMode ? filtredUsers[indexPath.row] : users[indexPath.row]
        cell.user = user
        return cell
    }
}


// MARK: - UITableViewDelegate
extension ExploreViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = inSearchMode ? filtredUsers[indexPath.row] : users[indexPath.row]
        navigationController?.pushViewController(ProfileController(user: user), animated: true)
    }
}


// MARK: - UISearchResultsUpdating
extension ExploreViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        filtredUsers = users.filter { $0.userName.contains(searchText) }
    }
}
