//
//  RepositorySpec.swift
//  GithubRepoExample
//
//  Created by Javier Cancio on 16/1/17.
//  Copyright © 2017 Javier Cancio. All rights reserved.
//

import Quick
import Nimble
import RxSwift
import RxTest
import SwiftyJSON

@testable import GithubRepoExample

class RepositorySpec: QuickSpec {
  override func spec() {
    describe("A Repository object") {
      
      context("given server response data") {
        
        var result: Repository!
        
        beforeEach {
          let data = GithubStubResponse.fakeData()
          let json = JSON(data)
          result  = Repository.fromJSON(json["items"].arrayValue.first!)
        }
        
        it("creates a Repository object") {
          expect(result).toNot(beNil())
        }
        
        it("has a valid id") {
          expect(result.id).to(equal(3081286))
        }
        
        it("has a valid name") {
          expect(result.name).to(equal("Tetris"))
        }
        
        it("has a valid organization") {
          expect(result.organization).to(equal("dtrupenn"))
        }
        
        it("has a valid url") {
          expect(result.url).to(equal("https://github.com/dtrupenn/Tetris"))
        }
        
        it("has a valid avatar") {
          expect(result.avatar).to(equal("https://secure.gravatar.com/avatar/e7956084e75f239de85d3a31bc172ace?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png"))
        }
        
        it("has a valid stars count") {
          expect(result.stars).to(equal(1))
        }
        
        it("has a valid forks count") {
          expect(result.forks).to(equal(0))
        }
        
        it("has a valid lastViewed value") {
            expect(result.lastViewed).toNot(beNil())
        }
        
        it("assigns a valid date") {
            let currentDate = NSDate()
            result.lastViewed = currentDate
            expect(result.lastViewed).to(be(currentDate))
        }
      }
    
      context("given wrong response data") {
        
        let wrongJSON = ["ids": "foo"]
        var result: Repository!
        
        beforeEach {
          result = Repository.fromJSON(JSON(wrongJSON))
        }
        
        it("emits has invalid id") {
          expect(result.id).to(equal(0))
        }
        
        it("has no name") {
          expect(result.name).to(beEmpty())
        }
      }
      
    }
  }
}
