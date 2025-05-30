//
//  StyledButton.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 05. 09..
//

import SwiftUI

enum ButtonStyleType {
    case outlined
    case filled
}

enum ButtonStyleAction {
    case simple
    case link(_ url: URL?)
}

struct StyledButton: View {
    let style: ButtonStyleType
    let action: ButtonStyleAction
    let title: String

    var body: some View {
        baseView
            .font(Fonts.subheading)
            .foregroundColor(style == .outlined ? .primary : .main)
            .padding(.horizontal, 20.0)
            .padding(.vertical, LayoutConst.normalPadding)
            .frame(maxWidth: .infinity)
            .background(backgroundView)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.primary, lineWidth: style == .outlined ? 1 : 0)
            )
    }
    
    @ViewBuilder
    private var baseView: some View {
        switch action {
        case .simple:
            Text(title.localized())
        case .link(let url):
            if let url = url {
                Link(title, destination: url)
            } else {
                Text(title.localized())
            }
            
        }
    }

    private var backgroundView: some View {
        switch style {
        case .filled:
            Color.primary
        case .outlined:
            Color.main
        }
    }
}

