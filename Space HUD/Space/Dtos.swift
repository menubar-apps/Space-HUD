//
//  Dtos.swift
//  Space HUD
//
//  Created by Pavel Makhov on 2022-11-18.
//

import Foundation
import Defaults

struct Resp<T: Codable & Hashable>: Codable {
    var next: String
    var totalCount: Int
    var data: [T]
    
    enum CodingKeys: String, CodingKey {
        case next
        case totalCount
        case data
    }
}

struct TodoItemRecord: Codable, Identifiable, Hashable {
    var id: String
    var archived: Bool
    var content: TodoItemContent
    var _status: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case archived
        case content
        case _status
    }
}

struct TodoItemContent: Codable, Hashable {
    var text: String
    
    enum CodingKeys: String, CodingKey {
        case text
    }
}

struct Issue: Codable, Identifiable, Hashable {
    var id: String
    var title: String
    var status: FieldWithId
    var number: Int
    var createdBy: User
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case number
        case status
        case createdBy
    }
}

struct FieldWithId: Codable, Hashable {
    var id: String
    
    enum CodingKeys: String, CodingKey {
        case id
    }
}

struct IssueStatus: Codable, Identifiable, Hashable {
    var id: String
    var archived: Bool
    var name: String
    var resolved: Bool
    var color: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case archived
        case name
        case resolved
        case color
    }
}

struct CodeReviewRecord: Codable, Identifiable, Hashable {
    var id: String
    var project: ProjectKey
    var projectId: String
    var number: Int
    var title: String
    var state: String
    var branchPairs: [MergeRequestBranchPair]
    
    enum CodingKeys: String, CodingKey {
        case id
        case project
        case projectId
        case number
        case title
        case state
        case branchPairs
    }
}

struct ProjectKey: Codable, Hashable {
    var key: String
    
    enum CodingKeys: String, CodingKey {
        case key
    }
}

struct CodeReviewWithCount: Codable, Hashable {
    var review: FieldWithId
    
    enum CodingKeys: String, CodingKey {
        case review
    }
}

struct MergeRequestBranchPair: Codable, Hashable {
    var repository: String
    var sourceBranch: String
    var targetBranch: String
    
    enum CodingKeys: String, CodingKey {
        case repository
        case sourceBranch
        case targetBranch
    }
}

struct Project: Codable, Hashable, Identifiable, Defaults.Serializable {
    var id: String
    var name: String
    var icon: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case icon
    }
}

struct User: Codable, Hashable {
    var name: String
    
    enum CodlingKeys: String, CodingKey {
        case name
    }
}
