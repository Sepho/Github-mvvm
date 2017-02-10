//
//  DetailViewController.swift
//  GithubRepoExample
//
//  Created by Javier Cancio on 16/1/17.
//  Copyright © 2017 Javier Cancio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DetailViewController: UIViewController {
  
  @IBOutlet weak var repositoryImageView: UIImageView!
  @IBOutlet weak var repositoryName: UILabel!
  @IBOutlet weak var repositoryStars: UILabel!
  @IBOutlet weak var repositoryForks: UILabel!
  
  @IBOutlet weak var repositoryDescription: UILabel!
  
  @IBOutlet weak var repositoryLanguage: UILabel!
  @IBOutlet weak var repositoryHomepage: UILabel!
  
  @IBOutlet weak var repositoryCreated: UILabel!
  @IBOutlet weak var repositoryUpdated: UILabel!
  
  var viewModel: DetailViewModel?
  
  private let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    guard let vm = viewModel else { return }

    self.repositoryName.text = vm.repositoryName
    self.repositoryDescription.text = vm.repositoryDescription
    self.repositoryStars.text = vm.repositoryStars
    self.repositoryForks.text = vm.repositoryForks
    self.repositoryLanguage.text = vm.repositoryLanguage
    self.repositoryHomepage.text = vm.repositoryHomepage
    self.repositoryCreated.text = vm.repositoryCreated
    self.repositoryUpdated.text = vm.repositoryUpdated
    
    vm.repositoryImage
      .bindTo(self.repositoryImageView.rx.image)
      .addDisposableTo(disposeBag)
  }
  
}
