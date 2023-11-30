//
//  MainTabBarView.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 11/1/23.
//

import SwiftUI

struct MainTabBarView: View {
    var body: some View {
        TabView {
            CoursesView()
                .tabItem {
                    Label("Courses", systemImage: "book.closed.fill")
                }

            AssignmentsView()
                .tabItem {
                    Label("Assignments", systemImage: "list.bullet.clipboard.fill")
                }

            ProjectView()
                .tabItem {
                    Label("Projects", systemImage: "tray.full.fill")
                }
            
            GitHubView()
                .tabItem {
                    Label("GitHub", systemImage: "folder.fill")
                }
        }
    }
}

// #Preview {
//    MainTabBarView()
// }
