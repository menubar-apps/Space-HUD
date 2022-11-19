//
//  ContentView.swift
//  Space HUD
//
//  Created by Pavel Makhov on 2022-11-18.
//

import SwiftUI
import Defaults

struct ContentView: View {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var selectedStatusId = ""
    @State var type = "assigned"
    @State var cRType = "reviewRequested"
    @ObservedObject var model: Model
    
    @Default(.orgName) var orgName
    @Default(.projectId) var projectId
    var body: some View {
        
        NavigationView {
            List {
                VStack(alignment: .center) {
                    Image("space-logo")
                        .resizable()
                        .frame(width: 40, height: 40, alignment: .center)
                    
                    Text(orgName)
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    
                    Picker("", selection: $projectId, content: {
                        ForEach(model.projects, id: \.id) { i in
                            Text("\(i.name)").tag(i)
                        }
                    }).labelsHidden()
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: 140)
                        .onAppear{
                            self.model.getProjects()
                        }
                        .onChange(of: projectId) { id in
                            model.selected = ""
                            model.selectedType = ""
                            model.selectedStatusId = ""
                            model.refresh()
                        }
                    
                }
                Section ("Features") {
                    NavigationLink(destination: IssuesView(model: model),
                                   tag: "1",
                                   selection: $model.selected) {
                        NavLink(text: "Issues", count: "\(model.issues.count)", systemName: "staroflife.fill")
                    }
                    
                    NavigationLink(destination: CodeReviewsView(model: model, selectedCrType: $cRType),
                                   tag: "2",
                                   selection: $model.selected) {
                        NavLink(text: "Code Reviews", count: "\(model.codeReviews.count)", systemName: "highlighter")
                    }
                    
                    NavigationLink(destination: ToDosView(model: model),
                                   tag: "3",
                                   selection: $model.selected) {
                        NavLink(text: "ToDos", count: "\(model.todos.count)", systemName: "bolt.fill") }
                }
                
                Section("App"){
                    NavigationLink{ SettingsView()} label: { Label("Settings", systemImage: "gearshape") }
                    NavigationLink{ AboutView()} label: { Label("About", systemImage: "info") }
                    Label("Quit", systemImage: "power")
                        .onTapGesture {
                            appDelegate.quit()
                        }
                }
            }
            .listStyle(.sidebar)
            .frame(width: 180)
            
            ZStack {
                Text("No selection")
                    .foregroundColor(.secondary)
                    .font(.headline)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image("space-man")
                            .resizable()
                            .frame(width: 150, height: 150)
                            .opacity(0.5)
                    }
                }
            }
                
        }.onAppear {
            NSLog("Content view appeared")
        }
    }
}

struct CustomText: View {
    let text: String
    
    var body: some View {
        Text(text)
    }
    
    init(_ text: String) {
        self.text = text
    }
}
