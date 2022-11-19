//
//  IssuesView.swift
//  Space HUD
//
//  Created by Pavel Makhov on 2022-11-18.
//

import SwiftUI
//import SkeletonUI

struct IssuesView: View {
    @ObservedObject var model: Model
    @State private var hoveringOver = false
    
    var body: some View {
        VStack(spacing: 0) {
            
            List(model.issues) { issue in
                IssueView(issue: issue, model: model)
            }
            
            HStack(alignment: .bottom) {
                HStack(spacing: 0) {
                    Button(action: {
                        if model.selectedType == "assigned"
                        {
                            model.selectedType = ""
                            model.getIssues()
                        } else {
                            model.selectedType = "assigned"
                            model.getIssues()
                        }
                        
                    })
                    {
                        Text("Assigned")
                            .padding([.leading, .trailing], 4)
                            .padding([.top, .bottom], 2)
                            .foregroundColor(.secondary)
                            .background(model.selectedType == "assigned" ? Color.secondary.opacity(0.5) : Color.red.opacity(0))
                            .roundedCorners(radius: 10, corners: [.topLeft, .bottomLeft])
                            .font(.subheadline)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        if model.selectedType == "created"
                        {
                            model.selectedType = ""
                            model.getIssues()
                        } else {
                            model.selectedType = "created"
                            model.getIssues()
                        }
                        
                    })
                    {
                        Text("Created")
                            .padding([.leading, .trailing], 4)
                            .padding([.top, .bottom], 2)
                            .foregroundColor(.secondary)
                            .background(model.selectedType == "created" ? Color.secondary.opacity(0.5) : Color.red.opacity(0))
                            .roundedCorners(radius: 10, corners: [.topRight, .bottomRight])
                            .font(.subheadline)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .overlay(RoundedRectangle(cornerRadius: 50).stroke(Color.secondary))
                .padding([.top, .bottom], 8)
                
                
                Spacer()
                
                HStack(spacing: 0) {
                    ForEach(Constants.issueStatuses, id: \.id) { status in
                        
                        Button(action: {
                            if model.selectedStatusId == status.id {
                                model.selectedStatusId = ""
                                model.getIssues()
                            } else {
                                model.selectedStatusId = status.id
                                model.getIssues()
                            }
                        })
                        {
                            Text(status.name)
                                .padding([.leading, .trailing], 4)
                                .padding([.top, .bottom], 2)
                                .background(model.selectedStatusId == status.id ? Color(hex: status.color) : Color.red.opacity(0))
                                .roundedCorners(radius: 10, corners: getCorners(status: status)
                                )
                                .foregroundColor(.secondary)
                                .font(.subheadline)
                            
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .overlay(RoundedRectangle(cornerRadius: 50).stroke(Color.secondary))
                .padding([.top, .bottom], 8)
                
            }
            .padding([.leading, .trailing], 16)
            
        }
    }
    
    func getCorners(status: IssueStatus) -> RectCorner {
        if (Constants.issueStatuses.first?.id == status.id) {
            return [.topLeft, .bottomLeft]
        } else if (Constants.issueStatuses.last?.id == status.id) {
            return [.topRight, .bottomRight]
        } else {
            return []
        }
    }
}

//struct IssuesView_Previews: PreviewProvider {
//    static var model = Model()
//    static let issues = [
//        Issue(id: "1a2b", title: "Title", status: FieldWithId(id: "123"), number: 1)
//    ]
//
//    static var previews: some View {
//        IssuesView(model: model, selectedStatus: .constant("asd"))
//    }
//}

