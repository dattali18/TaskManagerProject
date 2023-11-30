//
//  SemesterInfoView.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/25/23.
//

import SwiftUI

struct SemesterView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel: SemesterViewModel

    init(semester: Semester? = nil) {
        _viewModel = StateObject(wrappedValue: SemesterViewModel(semester: semester))
    }
    
    var body: some View {
        List {
            Section("Semester info") {
                Text("Name")
                    .badge(Text(viewModel.name))
                Text("Start")
                    .badge(Text(viewModel.startDate))
                Text("End")
                    .badge(Text(viewModel.endDate))
            }
            
            Section("Totals") {
                Text("Total courses")
                    .badge(Text(String(viewModel.totalCourses)))
                
                Text("Total credits")
                    .badge(Text(String(viewModel.totalCredits)))
            }
            
            
            Section {
                Text("Average")
                    .badge(Text(String(format: "%.2f", viewModel.avg)))
            } header : {
                Text("Grade")
            } footer : {
                Text("This is a wighted avarge, based on course credits.")
            }
            
            Section("Courses") {
                ForEach(viewModel.courses) { course in
                    HStack {
                        Text(course.name ?? "")
                            .badge(Text(String(course.grade)))
                    }
                }
            }
        }
        .navigationTitle(viewModel.name)
    }
}

//#Preview {
//    SemesterInfoView(semester: SemesterInfoViewModel.semester)
//}
