//
//  NavLink.swift
//  Space HUD
//
//  Created by Pavel Makhov on 2022-11-18.
//

import SwiftUI

struct NavLink: View {
    var text: String
    var count: String
    var systemName: String
    
    var body: some View {
        Label {
            Text(text)
                .badge(count)
        } icon: {
            Image(systemName: systemName)
        }
    }
}
