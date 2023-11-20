//
//  GitHubRepoView.swift
//  TaskManager
//
//  Created by Daniel Attali on 11/30/23.
//

import SwiftUI

struct GitHubRepoView: View {
    @State private var languages: [(String, Int)] = []

    var repo: GitHubRepo?

    var body: some View {
        VStack {
            Form {
                Section("Langauges") {
                    ForEach(self.languages, id: \.0) { key, count in
                        Text(key)
                            .badge(count)
                    }
                }
            }
        }
        .navigationTitle(repo?.name ?? "Repo Name")
        .task {
            do {
                let languages = try await GitHubViewModel.getLanguages(repo?.languages_url ?? "")
                self.languages = Array(languages.keys).map { ($0, languages[$0] ?? 0) }
            } catch {
                print("there was some error")
            }
        }
    }
}

// #Preview {
//    GitHubRepoView()
// }
