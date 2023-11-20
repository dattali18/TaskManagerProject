//
//  GitHubUserView.swift
//  TaskManager
//
//  Created by Daniel Attali on 11/20/23.
//

import SwiftUI

struct GitHubUserView: View {
    @State var name: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        TextField("User Name", text: $name)
                            .autocapitalization(.none)
                    } header: {
                        Text("GitHub User Info")
                    }
                    footer: {
                        NavigationLink(destination: GitHubView(name)) {
                            Label("Search", systemImage: "magnifyingglass")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                }
            }
            .navigationTitle("GitHub Repos")
        }
    }
}

// #Preview {
//    GitHubUserView()
// }
