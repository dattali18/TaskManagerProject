//
//  AddProjectViewModel.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/22/23.
//

import Foundation

class AddEditProjectViewViewModel : ObservableObject {
    @Published var name: String = ""
    @Published var url: String = ""
    @Published var descriptions: String = ""
    
    @Published var icons: [String] = ["GitHub", "Git"]
    @Published var semesters: [Semester] = []
    @Published var courses: [[Course]] = []
    @Published var noSemesterCourse : [Course] = []
    
    @Published var selectedIcon: Int = 0
    @Published var selectedSemester: Int = 0
    @Published var selectedCourse: Int = 0
    
    @Published var hasCourse: Bool = false
    
    @Published var showingAlert: Bool = false
    
    @Published var navigationtitle: String = "Add Project"
    
    var project: Project?
    
    var mode: Mode = .add
    
    init(project: Project? = nil) {
        if(project != nil) {
            self.project = project
            mode = .edit
            navigationtitle = "Edit Project"
        }
        
        fetchSemestersAndCourses()
        editMode()
    }
    
    func editMode() {
        if(mode == .add)
        {
            return
        }
        
        // Populate the fields with assignment data
        name = project!.name ?? ""
        descriptions = project!.descriptions ?? ""
        url = project!.url ?? ""
        
        selectedIcon = icons.firstIndex(where: { $0 == project!.icon ?? "GitHub" }) ?? 0
        
        if(semesters.isEmpty || courses.isEmpty) {
            return
        }
        
        if(self.project?.course != nil) {
            if(self.project?.course?.semester == nil) {
                selectedSemester = semesters.count
                selectedCourse = noSemesterCourse.firstIndex(where: { $0 == project?.course }) ?? 0
            } else {
                
                selectedSemester = semesters.firstIndex(where: {$0 == project!.course?.semester}) ?? 0
                selectedCourse = courses[selectedSemester].firstIndex(where: {$0 == project!.course}) ?? 0
            }
            self.hasCourse = true
        } else {
            self.hasCourse = false
        }
        
    }
    
    func fetchSemestersAndCourses() {
        let semesters = CoreDataManager.shared.fetch(entity: Semester.self) ?? []
        self.semesters = semesters

        // Fetch all courses
        let courses = CoreDataManager.shared.fetch(entity: Course.self) ?? []

        // Group courses by their associated semester
        var courseGroups: [[Course]] = Array(repeating: [], count: semesters.count)
        for course in courses {
            if let semester = course.semester, let index = semesters.firstIndex(of: semester) {
                courseGroups[index].append(course)
            }
        }
        self.courses = courseGroups
        self.noSemesterCourse = courses.filter { $0.semester == nil }
    }
    
    func validateInput() -> Bool {
        return name != ""
    }
    
    func saveProject() -> Project? {
        let managedObjectContext = CoreDataStack.shared.managedObjectContext
        
        if(mode == .add) {
            
            project = Project(context: managedObjectContext)
            project?.id = UUID()
        }
        
        project?.name = name
        project?.descriptions = descriptions
        project?.url = url
        project?.icon = icons[selectedIcon]
        if(hasCourse) {
            if(selectedSemester == self.semesters.count) {
                project?.course = self.noSemesterCourse[selectedCourse]
            } else {
                project?.course = self.courses[selectedSemester][selectedCourse]
            }
        } else {
            project?.course = nil
        }
        
        do {
            try managedObjectContext.save()
            return project
            
        } catch {
            print("Error creating/updating entity: \(error)")
            return nil
        }
    }
    
    func deleteProject() {
        CoreDataManager.shared.delete(self.project)
    }
    
    func showAlert()  {
        self.showingAlert = true
    }
}
