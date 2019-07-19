//
//  ChatConversationViewController.swift
//  ios-target
//
//  Created by sol manini on 7/16/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import UIKit

class ChatListViewController: UIViewController {
  
  @IBOutlet weak var chatsTableView: UITableView!
  
  var viewModel = ChatListViewModel()
  
  let unwindChatSegue = "unwindChatSegue"
  let openConversationSegue = "openConversationSegue"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.delegate = self
    viewModel.loadConversations()
    setupView()
  }
  
  func setupView() {
    chatsTableView.register(UINib(nibName: ChatListTableViewCell.reuseIdentifier,
                                  bundle: nil),
                            forCellReuseIdentifier: ChatListTableViewCell.reuseIdentifier)
    chatsTableView.dataSource = self
    chatsTableView.delegate = self
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if
      segue.identifier == openConversationSegue,
      let viewController = segue.destination as? ConversationViewController,
      let sender = sender as? ChatListTableViewCell,
      let match = sender.match
    {
      viewController.viewModel.delegate = viewController
      viewController.viewModel.match = match
    }
  }
}

extension ChatListViewController: ChatListViewModelDelegate {
  func didLoadMatches() {
    chatsTableView.reloadData()
  }
  
  func didUpdateState() {
    UIApplication.toggleNetworkActivity(viewModel.state == .loading)
    if case .error(let errorDescription) = viewModel.state {
      showMessage(title: "Error", message: errorDescription)
    }
  }
}

extension ChatListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.matchCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ChatListTableViewCell.reuseIdentifier,
                                             for: indexPath)
    if let cell = cell as? ChatListTableViewCell {
      let match = viewModel.matches[indexPath.item]
      cell.match = match
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    tableView.deselectRow(at: indexPath, animated: true)
    performSegue(withIdentifier: openConversationSegue, sender: cell)
  }
}

