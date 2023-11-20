//
//  GitHubViewModel.swift
//  TaskManager
//
//  Created by Daniel Attali on 11/30/23.
//

import Foundation

class GitHubViewModel: ObservableObject {
    @Published var user: GitHubUser?
    @Published var repos: [GitHubRepo] = []
    
    @Published var name: String = ""
    
//    var userName: String?
    
    init(_ name: String) {
        self.name = name
    }
    
    func getUser() async throws -> GitHubUser? {
        let endPoint = "https://api.github.com/users/" + (self.name)
        guard let url = URL(string: endPoint) else {
            // throw an error
            print("Error in URL")
            return nil
        }
         
        let (data, response) = try await URLSession.shared.data(from: url)
         
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            // throw an error
            print("Error getting the data")
            return nil
        }
         
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(GitHubUser.self, from: data)
        } catch {
            // throw an error
            print("Error Data could not be decoder")
            return nil
        }
    }
    
    func getRepos() async throws -> [GitHubRepo] {
        let endPoint = "https://api.github.com/users/\(self.name)/repos"
        guard let url = URL(string: endPoint) else {
            // throw an error
            print("Error in URL")
            return []
        }
           
        let (data, response) = try await URLSession.shared.data(from: url)
           
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            // throw an error
            print("Error getting the data")
            return []
        }
           
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([GitHubRepo].self, from: data)
        } catch {
            // throw an error
            print("Error Data could not be decoded")
            return []
        }
    }
    
    static func getLanguages(_ url: String) async throws -> [String: Int] {
        guard let url = URL(string: url) else {
            print("Error in URL")
            return [:]
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            print("Error getting the data")
            return [:]
        }

        do {
            let decoder = JSONDecoder()
            let githubLanguages = try decoder.decode([String: Int].self, from: data)
            return githubLanguages
        } catch {
            print("Error Data could not be decoded")
            return [:]
        }
    }
}

struct GitHubUser: Codable {
    let login: String
    let avatar_url: String
    let name: String
    let public_repos: Int
}

struct GitHubRepo: Codable {
    let name: String
    let languages_url: String
}
