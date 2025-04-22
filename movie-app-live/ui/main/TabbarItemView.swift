//
//  TabbarItemView.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 04. 21..
//

import SwiftUI

struct TabBarItemView: View {
    @Binding var selectedTab: TabType
    var icon: TabIcon
    var height: CGFloat = 26.0
    
    var body: some View {
        let tabColor = icon.tab == selectedTab ? Color.tabBarBackground : .white
        let borderColor = icon.tab == selectedTab ? .white : Color.tabBarBackground
        HStack {
            ZStack {
                RoundedCorner(radius: 20)
                    .foregroundStyle(borderColor)
                icon.image
                    .renderingMode(.template)
                    .foregroundStyle(tabColor)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40.0, height: height)
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                    .accessibilityLabel(icon.tab.rawValue)
            }
        }.frame(width: 40.0, height: 40.0)
            .onTapGesture {
                selectedTab = icon.tab
            }
    }
}
