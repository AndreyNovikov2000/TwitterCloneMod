//
//  ActionSheetLauncher.swift
//  TwitterClone
//
//  Created by Andrey Novikov on 7/23/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit


struct TableActionSheetConstants {
    static let heightForCell: CGFloat = 60
    static let heightForTableFooterView: CGFloat = 60
}

protocol ActionSheetLauncherDelegate: class {
    func actionSheet(_ actionSheet: ActionSheetLauncher, didSelectOption option: ActionSheetOption)
}

class ActionSheetLauncher: NSObject {
    
    // MARK: - External properties
    
    weak var myDelagte: ActionSheetLauncherDelegate?
    
    
    // MARK: - Private properties
    
    private let user: User
    private let tableView = UITableView()
    private var window: UIWindow?
    private lazy var viewModel = ActionSheetViewModel(user: user)
    private var tableHeight: CGFloat {
        return TableActionSheetConstants.heightForCell * CGFloat(viewModel.options.count) + TableActionSheetConstants.heightForTableFooterView + 50
    }
    
    private lazy var fadeView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFadeViewTapped)))
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGroupedBackground
        button.addTarget(self, action: #selector(handleCancelButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 50 / 2
        return button
    }()
    
    private lazy var tableFooterView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: window?.frame.width ?? 0, height: TableActionSheetConstants.heightForTableFooterView)
        view.addSubview(cancelButton)
        
        cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        cancelButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return view
    }()
    
    // MARK: - Live cycle
    
    init(user: User) {
        self.user = user
        super.init()
        
        configureTableView()
    }
    
    // MARK: - Public properties
    
    func show() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        self.window = window
        
        window.addSubview(fadeView)
        window.addSubview(tableView)
        
        fadeView.frame = window.bounds
        tableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: tableHeight)
        
        UIView.animate(withDuration: 0.35) { [weak self] in
            guard let self = self else { return }
            self.fadeView.alpha = 1
            self.tableView.transform = CGAffineTransform(translationX: 0, y: -self.tableHeight)
        }
    }
    
    // MARK: - Selector methods
    
    @objc private func handleFadeViewTapped() {
        dismissTable()
    }
    
    @objc private func handleCancelButtonTapped() {
        dismissTable()
    }
    
    // MARK: - Private methods
    
    private func configureTableView() {
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = TableActionSheetConstants.heightForCell
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 5
        tableView.register(ActionSheetCell.self, forCellReuseIdentifier: ActionSheetCell.reuseId)
        tableView.backgroundColor = .white
        tableView.tableFooterView = tableFooterView
    }
    
    private func dismissTable() {
        UIView.animate(withDuration: 0.35, delay: 0, options: [], animations: {
            self.fadeView.alpha = 0
            self.tableView.transform = .identity

        }) { (_) in
            self.fadeView.removeFromSuperview()
            self.tableView.removeFromSuperview()
        }
    }
}


// MARK: - UITableViewDataSource
extension ActionSheetLauncher: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ActionSheetCell.reuseId, for: indexPath) as? ActionSheetCell else { return UITableViewCell() }
        
        cell.option = viewModel.options[indexPath.row]
        
        return cell
    }
}


// MARK: - UITableViewDelegate
extension ActionSheetLauncher: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = viewModel.options[indexPath.row]
        dismissTable()
        myDelagte?.actionSheet(self, didSelectOption: option)
    }
}


