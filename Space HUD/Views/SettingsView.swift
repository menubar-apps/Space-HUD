//
//  SettingsView.swift
//  Space HUD
//
//  Created by Pavel Makhov on 2022-11-18.
//

import SwiftUI
import Defaults
import KeychainAccess

struct SettingsView: View {
    
    @Default(.orgName) var orgName
    @FromKeychain(.token) var token

    @Default(.projectId) var projectId
    
    @State private var selection = 1
    @ObservedObject var model = Model()
    
    @State var orgNameFieldValue = ""
    
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        Text("Organization:").frame(width: 90, alignment: .trailing)
                        TextField("", text: $orgNameFieldValue)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                            .textContentType(.password)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 140)
                            .onAppear {
                                orgNameFieldValue = orgName
                            }
                            .onChange(of: orgNameFieldValue, perform: { newVal in
                                orgName = orgNameFieldValue
                                self.model.projects.removeAll()
                                self.model.getProjects()
                            })
                        Text(".jetbrains.space")
                    }
                    
                    HStack(alignment: .center) {
                        Text("Required\nPermissions:")
                            .frame(width: 90, alignment: .trailing)
                        Text("Manage issue settings, Read Git repositories, Update issues, View code reviews, View issues, View project details")
                            .padding()
                    }
                    
                    HStack(alignment: .center) {
                        Text("Token:")
                            .frame(width: 90, alignment: .trailing)
                        VStack {
                            TextEditor(text: $token)
                                .frame(height: 150)
                                .padding(8)
                                .onChange(of: token) { _ in
                                    model.getProjects()
                                }
                        }
                        .cornerRadius(10)
                        .padding(8)
                        .shadow(radius: 5)
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

