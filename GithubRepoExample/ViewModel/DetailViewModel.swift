//
//  DetailViewModel.swift
//  GithubRepoExample
//
//  Created by Javier Cancio on 23/1/17.
//  Copyright © 2017 Javier Cancio. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class DetailViewModel {
  
  // Outputs
  /* Computed properties */
  var repositoryName: String {
    return "\(repository.organization) / \(repository.name)"
  }
  
  var repositoryStars: String {
    return "Stars: \(repository.stars)"
  }
  
  var repositoryForks: String {
    return "Forks: \(repository.forks)"
  }
  
  var repositoryDescription: String {
    return repository.desc
  }
  
  var repositoryCreated: String {
    return "Created " + formatDate(repository.created)
  }
  
  var repositoryUpdated: String {
    return "Updated " + formatDate(repository.updated)
  }
  
  var repositoryLanguage: String {
    return "Language: \(repository.language)"
  }
  
  var repositoryHomepage: String {
    return repository.homepage.isEmpty ? "Not available" : repository.homepage
  }
  
  /* Observable */
  var repositoryImage:    Observable<UIImage?>
  
  private var service:    ServiceType
  private var repository: Repository
  private let realmStore: RealmStore
  
  private let disposeBag = DisposeBag()
  
  init(service: ServiceType, store: RealmStore, repository: Repository) {
    self.service = service
    self.realmStore = store
    self.repository = repository

    store.update(repository: repository, lastViewed: NSDate())
    
    let url = URL(string: repository.avatar)
    self.repositoryImage = service.downloadImage(from: url)
  }

  private func formatDate(_ date: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    let formattedDate = dateFormatter.date(from: date) ?? Date()
    dateFormatter.dateFormat = "dd/MM/yyy"
    
    return dateFormatter.string(from: formattedDate)
  }
}
  
