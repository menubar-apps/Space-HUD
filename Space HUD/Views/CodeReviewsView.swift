//
//  CodeReviewsView.swift
//  Space HUD
//
//  Created by Pavel Makhov on 2022-11-18.
//

import SwiftUI
//import SkeletonUI

struct CodeReviewsView: View {
    
    @ObservedObject var model: Model
    
    @Binding var selectedCrType: String
    
    
    var body: some View {
        VStack {
            List(model.codeReviews) { codeReview in
                CodeReviewView(codeReview: codeReview)
            }
            
            HStack(alignment: .bottom) {
                HStack(spacing: 0) {
                    Button(action: {
                        if selectedCrType == "reviewRequested"
                        {
                            model.getCodeReviews()
                            selectedCrType = ""
                        } else {
                            model.getCodeReviews(type: "reviewRequested")
                            selectedCrType = "reviewRequested"
                        }
                    })
                    {
                        Text("Review Requested")
                            .padding([.leading, .trailing], 4)
                            .padding([.top, .bottom], 2)
                            .foregroundColor(.secondary)
                            .background(selectedCrType == "reviewRequested" ? Color.secondary.opacity(0.5) : Color.red.opacity(0))
                            .roundedCorners(radius: 10, corners: [.topLeft, .bottomLeft])
                        
                            .font(.subheadline)
                            .padding([.top, .bottom], 8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        if selectedCrType == "created"
                        {
                            model.getCodeReviews()
                            selectedCrType = ""
                        } else {
                            model.getCodeReviews(type: "created")
                            selectedCrType = "created"
                        }
                    })
                    {
                        Text("Created")
                            .padding([.leading, .trailing], 4)
                            .padding([.top, .bottom], 2)
                            .foregroundColor(.secondary)
                            .background(selectedCrType == "created" ? Color.secondary.opacity(0.5) : Color.red.opacity(0))
                            .roundedCorners(radius: 10, corners: [.topRight, .bottomRight])
                            .font(.subheadline)
                            .padding([.top, .bottom], 8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}
