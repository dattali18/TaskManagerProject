//
//  ProjectView.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/22/23.
//

import SwiftUI

struct ProjectsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel: ProjectsViewModel
    
    init(project: Project?) {
        self._viewModel = StateObject(wrappedValue: ProjectsViewModel(project: project))
    }
    
    var body: some View {
        Form {
            Section {
                    Text(viewModel.project?.descriptions ?? "Project Description")
                        .foregroundStyle(.gray)
                    Text((viewModel.project?.url ?? "Project URL").toDetectedAttributedString())
            } header : {
                Text(viewModel.project?.name ?? "Project Name")
                    .foregroundStyle(.black)
                    .font(.headline)
            } footer : {
                Text("Please make sure the link to the github repo is correct and the repo is public.")
            }
            
            Section("Latest Commits") {
                List(viewModel.commits, id: \.id) { commit in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(commit.authorName)
                                .font(.headline)
                            
                            Spacer()
                            
                            Text(commit.commitDate)
                                .font(.subheadline)
                                .foregroundStyle(.blue)
                        }
                        Text(commit.commitMessage)
                            .font(.body)
                            .foregroundStyle(.gray)
                            .lineLimit(1)
                    }
                }
                
                
                if viewModel.isFetchingData {
                    ProgressView("Fetching data...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .onAppear {
            if !viewModel.isFetchingData {
                viewModel.fetchData()
            }
        }
        .navigationBarTitle("Project") // Set a navigation title
    }
}


//#Preview {
//    ProjectView(project: nil)
//}
