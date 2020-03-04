//
//  CharacterChatViewController.swift
//  MarvelApp
//
//  Created by Artur Stepaniuk on 21/02/2020.
//  Copyright © 2020 Artur Stepaniuk. All rights reserved.
//

import UIKit

class CharacterChatViewController: UIViewController {
    
    let tableView = UITableView()
    
    private let viewModel: CharacterChatViewModel
    
    init(viewModel: CharacterChatViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("no storyboards")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        viewModel.delegate = self
        title = viewModel.characterName

        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: ChatMessageCell.description())
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        let responseView = ResponseView(frame: .zero)
        responseView.responseHandler = { [weak self] response in
            self?.viewModel.addMessage(content: response)
        }

        view.addSubview(tableView)
        view.addSubview(responseView)

        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
                
        responseView.translatesAutoresizingMaskIntoConstraints = false
        responseView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(tableView.snp.bottom).offset(4)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(100)
        }
        
    }
}

// MARK: Table view data source
extension CharacterChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.loadedMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatMessageCell.description(), for: indexPath) as? ChatMessageCell else {
            fatalError("tableView for chat not configured")
        }
        
        cell.configure(with: viewModel.getCellModel(for: indexPath))
        return cell
    }
}

// MARK: Messages updates
extension CharacterChatViewController: MessagesAddedDelegate {
    func messagesAdded(at indexes: [IndexPath]) {
        tableView.insertRows(at: indexes, with: .bottom)
    }
}
