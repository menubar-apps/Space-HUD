//
//  TodosView.swift
//  Space HUD
//
//  Created by Pavel Makhov on 2022-11-18.
//

import SwiftUI
import SkeletonUI

struct ToDosView: View {
    private let spaceClient = SpaceClient()
    var model: Model
    @State private var newTodo: String = ""
    
    private let text = "Add a task (**bold**, _italic_, [link text](link))"
    
    var body: some View {
        VStack {
            SkeletonList(with: model.todos, quantity: 3) { loading, todo in
                TodoView(todo: todo, loading: loading, model: model)
            }
            
            TextField(text, text: $newTodo)
                .padding(.vertical, 8)
                .padding(.horizontal, 8)
                .padding(.leading, 22)
                .cornerRadius(8)
                .textFieldStyle(PlainTextFieldStyle())
                .overlay(
                    Image(systemName: "plus.circle.fill")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.gray)
                        .padding(.leading, 8)
                ).onSubmit {
                    spaceClient.createTodo(text: newTodo) {
                        model.getTodos()
                    }
                    newTodo = ""
                }.padding(.bottom, 8)
            
        }
    }
}

struct ToDosView_Previews: PreviewProvider {
    static var previews: some View {
        ToDosView(model: Model())
    }
}
