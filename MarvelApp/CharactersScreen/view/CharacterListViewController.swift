//
//  CharactersListViewController.swift
//  Marvel_test_example_app
//
//  Created by Artur Stepaniuk on 13/02/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import UIKit
import SnapKit

class CharacterListViewController: UIViewController {
    
    private let viewModel: CharacterListViewModel
    private let tableView = UITableView()
    private var viewSize: CGRect!
    init(viewModel: CharacterListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.onCharactersLoaded = {  [weak self] loadedIndexes in
            DispatchQueue.main.async {
                guard let loadedIndexes = loadedIndexes else {
                    self?.tableView.reloadData()
                    return
                }
                
                let rowsToReload = self?.calculateVisibleRowsToReload(loadedRows: loadedIndexes) ?? []
                self?.tableView.reloadRows(at: rowsToReload, with: .automatic)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupView()
        viewModel.loadCharacters(at: viewModel.defaultIndexesToLoad)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectionIndexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
    }
    
    private func setupView() {
        title = "Marvel characters"
        
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.prefetchDataSource = self
        tableView.estimatedRowHeight = MarvelCharacterCell.estimatedRowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(MarvelCharacterCell.self, forCellReuseIdentifier: MarvelCharacterCell.description())
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
        }
    }
    
    private func calculateVisibleRowsToReload(loadedRows: [IndexPath]) -> [IndexPath] {
        let visibleRows = tableView.indexPathsForVisibleRows ?? []
        return Array(Set(visibleRows).intersection(loadedRows))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewSize = view.bounds
        tableView.delegate = self

    }
}

// MARK: - TableView data source
extension CharacterListViewController: UITableViewDataSource, UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        viewModel.loadCharacters(at: indexPaths.map { $0.row })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.shownCharactersCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MarvelCharacterCell.description(), for: indexPath) as? MarvelCharacterCell else {
            fatalError("error in tableView configuration")
        }
        
        if let cellVM = viewModel.getCellViewModel(at: indexPath.row) {
            cell.configure(model: cellVM)
        } else {
            cell.setNotLoaded()
        }
        return cell
    }
}

// MARK: - TableView delegate
extension CharacterListViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if !viewModel.canProvideMoreCharacters() {
            return
        }
        let left = tableView.contentSize.height - tableView.contentOffset.y
        if left < (view.bounds.height * 2) {
            tableView.insertRows(at: viewModel.getNextCellsBatch(), with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = viewModel.loadedCharacters[indexPath.row]
        let coreDataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let repository = CoreDataMessagesRepository(coreDataContext: coreDataContext, characterId: character.id)
        let vm = CharacterChatViewModel(messagesRepository: repository, characterName: character.name)
        let vc = CharacterChatViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
}
