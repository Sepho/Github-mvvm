//
//  SearchViewController.swift
//  GithubRepoExample
//
//  Created by Javier Cancio on 16/1/17.
//  Copyright © 2017 Javier Cancio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var loadingView: UIView!
  
  let disposeBag = DisposeBag()
  var viewModel: SearchViewModel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let vm = viewModel else { return }
  
    bindRxTo(viewModel: vm)
    configureTableView()
  }
  
  private func bindRxTo(viewModel: SearchViewModel) {
    
    searchBar
      .rx
      .text
      .orEmpty
      .bind(to: viewModel.searchQuery)
      .disposed(by: disposeBag)
    
    viewModel
      .repositories
      .bind(to: tableView
        .rx
        .items(cellIdentifier: RepositoryCell.cellIdentifier,
               cellType: RepositoryCell.self)) { row, viewModel, cell in                
                cell.configureCell(viewModel: viewModel)
      }
      .disposed(by: disposeBag)
    
    viewModel
      .showLoading
      .subscribe(onNext: { showing in
        self.showLoading(showing)
      })
      .disposed(by: disposeBag)
 
    tableView
      .rx
      .itemSelected
      .do(onNext: { indexPath in
        self.tableView.deselectRow(at: indexPath, animated: true)
      })
      .bind(to: viewModel.selectedIndex)
      .disposed(by: disposeBag)
    
    tableView
      .rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    
    
    viewModel
      .selectedRepo
      .subscribe(onNext: { viewModel in
        self.performSegue(withIdentifier: "showRepository", sender: viewModel)
      })
      .disposed(by: disposeBag)
  }
  
  private func showLoading(_ showing: Bool) {
    self.loadingView.show(showing)
  }
  
  private func configureTableView() {
    tableView.tableFooterView = UIView()
    tableView.estimatedRowHeight = 64.0;
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let detailViewController = segue.destination as? DetailViewController,
      let viewModel = sender as? DetailViewModel{
      
      detailViewController.viewModel = viewModel
    }
  }
}

extension SearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 64
  }
}
