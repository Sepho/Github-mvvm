//
//  HistoryViewController.swift
//  GithubRepoExample
//
//  Created by Javier Cancio on 30/1/17.
//  Copyright © 2017 Javier Cancio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HistoryViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  private let disposeBag = DisposeBag()
  var viewModel: HistoryViewModel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let vm = viewModel else { return }
    
    bindToRx(viewModel: vm)
    configureTableView()
  }
  
  private func bindToRx(viewModel: HistoryViewModel) {
        viewModel
          .history?
          .bindTo(tableView
            .rx
            .items(cellIdentifier: HistoryCell.cellIdentifier, cellType: HistoryCell.self)) {row, viewModel, cell in
              cell.configureCell(viewModel: viewModel)
          }
          .addDisposableTo(disposeBag)    
  }
  
  private func configureTableView() {
    tableView.tableFooterView = UIView()
    tableView.estimatedRowHeight = 64.0;
  }
}
