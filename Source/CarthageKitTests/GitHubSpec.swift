//
//  GitHubSpec.swift
//  Carthage
//
//  Created by Eli Perkins on 6/26/15.
//  Copyright (c) 2015 Carthage. All rights reserved.
//

import CarthageKit
import Foundation
import Result
import Nimble
import Quick

class GitHubSpec: QuickSpec {
	override func spec() {
		it("should generate repositories from NWOs") {
			let result = GitHubRepository.fromNWO("octocat/Hello-World")
			expect(result.error).to(beNil())
			
			let repo = result.value!
			expect(repo.owner).to(equal("octocat"))
			expect(repo.name).to(equal("Hello-World"))
			
			expect(repo.server).to(equal(GitHubServer.DotCom))
		}
		
		it("should generate repositories from enterprise URLs") {
			let result = GitHubRepository.fromEnterpriseURL("https://enterprise.local/octocat/Hello-World")
			expect(result.error).to(beNil())
			
			let repo = result.value!
			expect(repo.owner).to(equal("octocat"))
			expect(repo.name).to(equal("Hello-World"))
			
			let URL = NSURL(string: "https://enterprise.local")!
			expect(repo.server).to(equal(GitHubServer.Enterprise(URL)))
		}
		
		it("should decide what type of server for a repository based on the input string") {
			let dotComResult = GitHubRepository.fromString("ReactiveCocoa/ReactiveCocoa")
			expect(dotComResult.error).to(beNil())
			
			let dotComRepo = dotComResult.value!
			
			expect(dotComRepo.server).to(equal(GitHubServer.DotCom))

			let enterpriseResult = GitHubRepository.fromString("https://enterprise.local/lol/wtf")
			expect(enterpriseResult.error).to(beNil())
			
			let enterpriseRepo = enterpriseResult.value!
			
			let URL = NSURL(string: "https://enterprise.local")!
			expect(enterpriseRepo.server).to(equal(GitHubServer.Enterprise(URL)))
		}
		
		it("should fail to create a repo with invalid input") {
			let result = GitHubRepository.fromString("lol")
			expect(result.error).notTo(beNil())
		}
		
		it("should create a GitHub.com server with appropriate URLS") {
			let URL = NSURL(string: "https://enterprise.local")!
			let server = GitHubServer.DotCom
			
			expect(server.webURL()).to(equal("https://github.com"))
			expect(server.baseHost()).to(equal("github.com"))
			expect(server.APIURL()).to(equal("https://api.github.com"))
		}

		it("should generate enterprise servers with appropriate URLS") {
			let URL = NSURL(string: "https://enterprise.local")!
			let server = GitHubServer.Enterprise(URL)
			
			expect(server.webURL()).to(equal("https://enterprise.local"))
			expect(server.baseHost()).to(equal("enterprise.local"))
			expect(server.APIURL()).to(equal("https://enterprise.local/api/v3/"))
		}
	}
}