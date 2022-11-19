//
//  TodoView.swift
//  Space HUD
//
//  Created by Pavel Makhov on 2022-11-18.
//

import SwiftUI

struct TodoView: View {

    var todo: TodoItemRecord?
    var loading: Bool
    var model: Model?
    @State private var isHovering = false

    var body: some View {
        HStack {
            Button(action: {
                if let t = todo {
                    SpaceClient().toggleTodoStatus(todo: t) {
                        model?.getTodos()
                    }
                }
            }) {
                Image(systemName: (todo?._status == "Open") ? "square" : "checkmark.square")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .padding(.top, 1)
            }.buttonStyle(PlainButtonStyle())
                .skeleton(with: loading)

            
            todo?._status == "Open"
            ? Text(try! AttributedString(markdown: todo?.content.text.replacingOccurrences(of: "](/", with: "](https://streetturtle.jetbrains.space//") ?? ""))
                        .skeleton(with: loading)
            : Text(try! AttributedString(markdown: todo?.content.text.replacingOccurrences(of: "](/", with: "](https://streetturtle.jetbrains.space//") ?? ""))
                .foregroundColor(.secondary).strikethrough()
                        .skeleton(with: loading)
            
            
            Spacer()
                Button(action: {
                    if let id = todo?.id {
                    SpaceClient().deleteTodo(id: id) {
                        model?.getTodos()
                        }
                            }
                }) {
                    
                    if isHovering {
                    Image(systemName: "trash")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .padding(.top, 1)
                        .foregroundColor(.red)
                    }
                }
                .buttonStyle(PlainButtonStyle())
        }
        .padding(4)
        .onHover { over in
            isHovering = over
        }
        .background(
            isHovering
            ? RoundedRectangle(cornerRadius: 4, style: .continuous).fill(Color.secondary.opacity(0.5))
            : RoundedRectangle(cornerRadius: 4, style: .continuous).fill(Color.accentColor.opacity(0))
        )
    }
}

struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        TodoView(loading: false)
    }
}
