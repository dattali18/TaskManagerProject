//
//  ProjectsView.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/19/23.
//

import SwiftUI

struct ProjectView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel: ProjectViewModel
    
    init(resource: Resource? = nil, course: Course? = nil) {
        _viewModel = StateObject(wrappedValue: ProjectViewModel())
    }
    
    var body: some View {
        NavigationView
        {
            Form
            {
                Section {
                    List(viewModel.projects, id:\.id) { project in
                        NavigationLink(destination: ProjectsView(project: project)) {
                            HStack {
                                Image(project.icon!)
                                    .font(.largeTitle)
                                
                                Spacer()
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(project.name!)
                                    
                                    Text(project.url ?? "")
                                        .font(.caption2)
                                        .lineLimit(1)
                                    
                                    Text(project.descriptions ?? "")
                                        .font(.caption2)
                                        .foregroundStyle(.gray)
                                        .lineLimit(1)
                                }
                                
                                Spacer()
                           
                            }
                            .frame(height: 74)
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                viewModel.editProject(project)
                            } label : {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                        .swipeActions(edge: .trailing) {
                            Button {
                                viewModel.showDeleteAlert()
                            } label : {
                                Label("Delete", systemImage: "trash.fill")
                            }
                            .tint(.red)
                        }
                        .alert(isPresented: $viewModel.deleteAlertShowing) {
                            Alert(
                                title: Text("Delete?"),
                                message: Text("Are you sure you want to delete this project?"),
                                primaryButton: .destructive(Text("Delete")) {
                                    viewModel.deleteProject(project: project)

                                },
                                secondaryButton: .cancel(Text("Cancel"))
                            )
                        }
                    }
                } header : {
                    Text("Project")
                } footer : {
                    Text("Project Assignment.")
                }
            }
            .navigationTitle("Projects")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.addProject()
                    } label : {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.isPresented, onDismiss: { viewModel.fetchProject() }) {
                switch viewModel.action {
                case .add:
                    AddEditProjectView(project: nil)
                case .edit:
                    AddEditProjectView(project: viewModel.project)
                }
            }
            .onAppear {
                viewModel.fetchProject()
            }
        }

    }
}

//#Preview {
//    ProjectView()
//}
