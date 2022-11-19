//
//  Client.swift
//  Space HUD
//
//  Created by Pavel Makhov on 2022-11-18.
//

import Foundation
import Alamofire
import Defaults
import KeychainAccess

public class SpaceClient {
    @Default(.orgName) var orgName
    @Default(.projectId) var projectId
    @FromKeychain(.token) var token
    
    func getTodos(completion:@escaping (([TodoItemRecord]) -> Void)) -> Void {
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: token),
            .accept("application/json")
        ]
        
        AF.request("https://\(orgName).jetbrains.space/api/http/todo", method: .get, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Resp<TodoItemRecord>.self) { response in
                switch response.result {
                case .success(let resp):
                    completion(resp.data)
                case .failure(let error):
                    self.handleError(error: error,
                                     notificationSubTitle: "Get ToDos",
                                     debubMessage: response.debugDescription)
                    completion([TodoItemRecord]())
                }
            }
    }
    
    func createTodo(text: String, completion:@escaping (() -> Void)) -> Void {
        let headers: HTTPHeaders = [
            .authorization(bearerToken: token),
            .accept("application/json")
        ]
        
        let parameters = [
            "text": text
                ] as [String: Any]
        AF.request("https://\(orgName).jetbrains.space/api/http/todo", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: TodoItemRecord.self) { response in
                switch response.result {
                case .success(_):
                    completion()
                case .failure(let error):
                    self.handleError(error: error,
                                     notificationSubTitle: "Create ToDo",
                                     debubMessage: response.debugDescription)
                    completion()
                }
            }
    }
    
    func deleteTodo(id: String, completion:@escaping (() -> Void)) -> Void {
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: token),
            .accept("application/json")
        ]
        
        AF.request("https://\(orgName).jetbrains.space/api/http/todo/\(id)", method: .delete, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .response() { response in
                switch response.result {
                case .success(_):
                    completion()
                case .failure(let error):
                    self.handleError(error: error,
                                     notificationSubTitle: "Delete ToDo item with id \(id)",
                                     debubMessage: response.debugDescription)
                    completion()
                }
            }
    }

    func toggleTodoStatus(todo: TodoItemRecord, completion:@escaping (() -> Void)) -> Void {
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: token),
            .accept("application/json")
        ]
        
        let parameters = [
            "open": "\(todo._status != "Open")",
                ] as [String: Any]
        
        AF.request("https://\(orgName).jetbrains.space/api/http/todo/\(todo.id)", method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .response() { response in
                switch response.result {
                case .success(_):
                    completion()
                case .failure(let error):
                    self.handleError(error: error,
                                     notificationSubTitle: "Toggle status of ToDo item",
                                     debubMessage: response.debugDescription)
                    completion()
             
                }
            }
    }
    
    
    func getIssues(statusId: String = "", type: String = "", completion:@escaping (([Issue]) -> Void)) -> Void {
        NSLog("Getting Issues")
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: token),
            .accept("application/json")
        ]
        
        var url = "https://\(orgName).jetbrains.space/api/http/projects/\(projectId)/planning/issues?sorting=UPDATED&descending=true"
        
        if !statusId.isEmpty {
            url += "&statuses=\(statusId)"
        }
        
        if type == "assigned" {
            url += "&assigneeId=me"
        } else if type == "created" {
            url += "&createdByProfileId=me"
        }
        AF.request(url,
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Resp<Issue>.self) { response in
                switch response.result {
                case .success(let resp):
                    completion(resp.data)
                case .failure(let error):
                    self.handleError(error: error,
                                     notificationSubTitle: "Get issues",
                                     debubMessage: response.debugDescription)
                    completion([Issue]())
                }
            }
    }
    
    
    func getIssueStatuses(completion:@escaping (([IssueStatus]) -> Void)) -> Void {
        NSLog("Getting Issue Statuses")
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: token),
            .accept("application/json")
        ]
        
        AF.request("https://\(orgName).jetbrains.space/api/http/projects/\(projectId)/planning/issues/statuses", method: .get, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [IssueStatus].self) { response in
                switch response.result {
                case .success(let resp):
                    completion(resp)
                case .failure(let error):
                    self.handleError(error: error,
                                     notificationSubTitle: "Get issue statuses",
                                     debubMessage: response.debugDescription)
                    completion([IssueStatus]())
                }
            }
    }
    
    func updateIssueStatus(issueId: String, newStatusId: String, completion:@escaping (() -> Void)) -> Void {
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: token),
            .accept("application/json")
        ]
        
        let parameters = [
            "status": newStatusId,
                ] as [String: Any]
        
        AF.request("https://\(orgName).jetbrains.space/api/http/projects/\(projectId)/planning/issues/\(issueId)", method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .response() { response in
                switch response.result {
                case .success(_):
                    completion()
                case .failure(let error):
                    self.handleError(error: error,
                                     notificationSubTitle: "Update issue with id \(issueId) to status \(newStatusId)",
                                     debubMessage: response.debugDescription)
                    completion()
                }
            }
    }
    
    func getCodeReviews(type: String = "", completion:@escaping (([String]) -> Void)) -> Void {
        NSLog("Getting Code Reviews")
        
        var url = "https://\(orgName).jetbrains.space/api/http/projects/\(projectId)/code-reviews?sorting=UPDATED&descending=true"
        
        if type == "reviewRequested" {
            url += "&reviewer=me"
        } else if type == "created" {
            url += "&author=me"
        }
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: token),
            .accept("application/json")
        ]
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Resp<CodeReviewWithCount>.self) { response in
                switch response.result {
                case .success(let resp):
                    completion(resp.data.map{ r in r.review.id})
                case .failure(let error):
                    self.handleError(error: error,
                                     notificationSubTitle: "Get Code Reviews",
                                     debubMessage: response.debugDescription)
                    completion([String]())
                }
            }
    }
    
    func getCodeReview(id: String, completion:@escaping ((CodeReviewRecord?) -> Void)) -> Void {
        NSLog("Getting Code Review by id \(id)")
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: token),
            .accept("application/json")
        ]
        
        AF.request("https://\(orgName).jetbrains.space/api/http/projects/\(projectId)/code-reviews/\(id)", method: .get, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: CodeReviewRecord.self) { response in
                switch response.result {
                case .success(let resp):
                    completion(resp)
                case .failure(let error):
                    self.handleError(error: error,
                                     notificationSubTitle: "Get Code Review with id \(id)",
                                     debubMessage: response.debugDescription)

                    completion(nil)
                }
            }
    }
    
    func getProjects(completion:@escaping (([Project]) -> Void)) -> Void {
        NSLog("Getting Projects")
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: token),
            .accept("application/json")
        ]
                
        AF.request("https://\(orgName).jetbrains.space/api/http/projects", method: .get, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Resp<Project>.self) { response in
                switch response.result {
                case .success(let resp):
                    completion(resp.data)
                case .failure(let error):
                    self.handleError(error: error,
                                     notificationSubTitle: "Get projects",
                                     debubMessage: response.debugDescription)
                    completion([Project]())
                }
            }
    }
    
    func getProjectById(id: String, completion:@escaping ((Project?) -> Void)) -> Void {
        NSLog("Getting Project by id: \(id)")
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: token),
            .accept("application/json")
        ]
        
        AF.request("https://\(orgName).jetbrains.space/api/http/projects/\(id)", method: .get, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Project.self) { response in
                switch response.result {
                case .success(let resp):
                    completion(resp)
                case .failure(let error):
                    self.handleError(error: error,
                                     notificationSubTitle: "Get project by id: \(id)",
                                     debubMessage: response.debugDescription)
                    completion(nil)
                }
            }
    }
    
    private func handleError(error: AFError, notificationSubTitle: String, debubMessage: String) {
        sendNotification(subtitle: notificationSubTitle, body: error.localizedDescription)
        NSLog("\(notificationSubTitle): \(debubMessage)")
    }
}
