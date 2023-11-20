//
//  GitHubView.swift
//  TaskManager
//
//  Created by Daniel Attali on 11/30/23.
//

import SwiftUI

struct GitHubView: View {
    @StateObject var viewModel: GitHubViewModel

    init(_ name: String) {
        self._viewModel = StateObject(wrappedValue: GitHubViewModel(name))
    }

    var body: some View {
        List {
            Section {
                ForEach(viewModel.repos, id: \.name) { repo in
                    NavigationLink(destination: GitHubRepoView(repo: repo)) {
                        Text(repo.name)
                    }
                }

                if viewModel.repos.isEmpty {
                    ProgressView("Fetching data...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            } header: {
                HStack(alignment: .center) {
                    AsyncImage(url: URL(string: viewModel.user?.avatar_url ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(.circle)
                    } placeholder: {
                        Circle()
                            .foregroundStyle(.gray)
                    }
                    .frame(width: 40, height: 40)

                    Text(viewModel.user?.login ?? "")
                        .font(.title3)
                        .textCase(nil)
                }
            }
        }
        .navigationTitle("GitHub Info")
        .task {
            do {
                viewModel.user = try await viewModel.getUser()
                viewModel.repos = try await viewModel.getRepos()
            } catch {
                print("there was some error")
            }
        }
    }
}

// #Preview {
//    GitHubView()
// }
