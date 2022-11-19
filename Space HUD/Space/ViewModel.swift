//
//  ViewModel.swift
//  Space HUD
//
//  Created by Pavel Makhov on 2022-11-18.
//

import Foundation
import Defaults

class Model: ObservableObject{
    private var client = SpaceClient()
    
    @Default(.projectId) var projectId
    
    @Published var todos: [TodoItemRecord] = []
    @Published var issues: [Issue] = []
    @Published var codeReviews: [CodeReviewRecord] = []
    @Published var projects: [Project] = []
    @Published var projectName: String = ""
    @Published var iconName: String?
    @Published var selected: String?
    
    @Published var selectedStatusId: String = ""
    @Published var selectedType: String = ""

    init() {
        NSLog("Model initialized")
    }
    
    func initialize() {
        client.getIssueStatuses{ resp in
            Constants.issueStatuses = resp
        }

        client.getProjectById(id: projectId) { project in
            if let pr = project {
                self.projectName = pr.name
                self.iconName = pr.icon
            }
        }
    }
    
    func refresh(){
        getTodos()
        getIssues(type: "assigned")
        getCodeReviews()
        client.getIssueStatuses{ resp in
            Constants.issueStatuses = resp
        }
    }
    
    func getTodos() {
        client.getTodos() { t in
            self.todos = t.sorted {
                $0._status > $1._status
            }
        }
    }
    
    func getProjects() {
        client.getProjects() { ps in
            self.projects = ps
        }
    }
    
    func getIssues(statusId: String = "", type: String = "") {
        client.getIssues(statusId: selectedStatusId, type: selectedType) { ps in
            self.issues = ps
        }
    }
    
    func getCodeReviews(type: String = "") {
        client.getCodeReviews(type: type) { crIds in
            self.codeReviews.removeAll()
            crIds.forEach { id in
                self.client.getCodeReview(id: id) { cr in
                    if let codeReview = cr {
                        self.codeReviews.append(codeReview)
                    }
                }
            }
        }
    }
    
    func setIssues(issues: [Issue]) {
        self.issues = issues
    }

    
}
