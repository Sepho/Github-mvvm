//
//  HistoryCell.swift
//  GithubRepoExample
//
//  Created by Javier Cancio on 8/2/17.
//  Copyright © 2017 Javier Cancio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HistoryCell: UITableViewCell {
  
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var lastView: UILabel!
  
  static let cellIdentifier = "HistoryCell"
  
  private var disposeBag = DisposeBag()

  func configureCell(viewModel: HistoryCellViewModel) {
    name.text = viewModel.name
    lastView.text = viewModel.lastViewed
  }

}
