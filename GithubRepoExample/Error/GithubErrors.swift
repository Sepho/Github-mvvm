//
//  CustomErrors.swift
//  GithubRepoExample
//
//  Created by Javier Cancio on 19/1/17.
//  Copyright © 2017 Javier Cancio. All rights reserved.
//

enum GithubError: Error {
  case repositoryNotExists
  case couldNotDeleteRepository
}
