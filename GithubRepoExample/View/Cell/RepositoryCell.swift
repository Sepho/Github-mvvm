//
//  RepositoryCell.swift
//  GithubRepoExample
//
//  Created by Javier Cancio on 21/1/17.
//  Copyright © 2017 Javier Cancio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RepositoryCell: UITableViewCell {

  @IBOutlet weak var avatar: UIImageView!
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var organization: UILabel!
  @IBOutlet weak var stars: UILabel!
  @IBOutlet weak var forks: UILabel!
  
  static let cellIdentifier = "RepositoryCell"
  
  private var disposeBag = DisposeBag()
  
  func configureCell(viewModel: RepositoryCellViewModel) {
    
    viewModel.repositoryName
      .asObservable()
      .bindTo(self.name.rx.text)
      .addDisposableTo(disposeBag)
    
    viewModel.repositoryOrganization
      .asObservable()
      .bindTo(self.organization.rx.text)
      .addDisposableTo(disposeBag)
    
    viewModel.repositoryStars
      .asObservable()
      .bindTo(self.stars.rx.text)
      .addDisposableTo(disposeBag)
    
    viewModel.repositoryForks
      .asObservable()
      .bindTo(self.forks.rx.text)
      .addDisposableTo(disposeBag)
    
    viewModel.repositoryImage
      .asObservable()
      .bindTo(self.avatar.rx.image)      
      .addDisposableTo(disposeBag)
  }

}
