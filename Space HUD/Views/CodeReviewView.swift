//
//  CodeReviewView.swift
//  Space HUD
//
//  Created by Pavel Makhov on 2022-11-18.
//

import SwiftUI
import Defaults

struct CodeReviewView: View {
    @Default(.orgName) var orgName
    @State private var isHovering = false
    
    var codeReview: CodeReviewRecord?
    
    var body: some View {
        Link(destination: URL(string: "https://\(orgName).jetbrains.space/p/spcbr/reviews/\(String(codeReview?.number ?? 1))")!) {
            
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(codeReview?.title)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        .font(.headline)
                    Text("#" + String(codeReview?.number ?? 1))
                        .foregroundColor(.secondary)
                }
                
                HStack(spacing: 20) {
                    Text(codeReview?.state)
                        .padding([.leading, .trailing], 4)
                        .padding([.top, .bottom], 2)
                        .foregroundColor(isHovering ? Color.black : Color.blue)
                        .overlay(RoundedRectangle(cornerRadius: 50).stroke(isHovering ? Color.black : Color.blue))
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                    
                    HStack(spacing: 2) {
                        Text(codeReview?.branchPairs.first?.targetBranch)
                            .padding([.leading, .trailing], 4)
                            .padding([.top, .bottom], 2)
                            .foregroundColor(isHovering ? Color.black : Color.blue)
                            .background(RoundedRectangle(cornerRadius: 50, style: .continuous).fill(Color.secondary.opacity(0.3)))
                            .font(.subheadline)
                        Image(systemName: "arrow.left")
                        Text(codeReview?.branchPairs.first?.sourceBranch)
                            .padding([.leading, .trailing], 4)
                            .padding([.top, .bottom], 2)
                            .foregroundColor(isHovering ? Color.black : Color.blue)
                            .background(RoundedRectangle(cornerRadius: 50, style: .continuous).fill(Color.secondary.opacity(0.3)))
                            .font(.subheadline)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .onHover { over in
            isHovering = over
        }
        .padding(4)
        .background(
            isHovering
            ? RoundedRectangle(cornerRadius: 4, style: .continuous).fill(Color.accentColor)
            : RoundedRectangle(cornerRadius: 4, style: .continuous).fill(Color.accentColor.opacity(0))
        )
        
    }
}

struct CodeReviewView_Previews: PreviewProvider {
    static var previews: some View {
        CodeReviewView()
    }
}
