//
//  RepositoryCellViewModel.swift
//  GithubRepoExample
//
//  Created by Javier Cancio on 21/1/17.
//  Copyright © 2017 Javier Cancio. All rights reserved.
//

import Foundation
import RxSwift


class RepositoryCellViewModel {
  
  // Output
  var repositoryName = Variable("")
  var repositoryOrganization = Variable("")
  var repositoryStars = Variable("")
  var repositoryForks = Variable("")
  
  var repositoryImage: Observable<UIImage?>
  
  private var service: ServiceType
  private let repository: Repository
  
  init(repository: Repository, service: ServiceType) {
    self.repository = repository
    self.service = service
    
    self.repositoryName.value = repository.name
    self.repositoryOrganization.value = repository.organization
    self.repositoryStars.value = "✭ \(repository.stars)"
    self.repositoryForks.value = "⑂ \(repository.forks)"
    
    let url = URL(string: self.repository.avatar)
    
    if let url = url {
      self.repositoryImage = service.downloadImage(from: url)
    } else {
      self.repositoryImage = Observable.just(UIImage())
    }
  }
  
}

