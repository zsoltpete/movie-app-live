//
//  GlobalMethods.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 04. 21..
//

import UIKit

func safeArea() -> UIEdgeInsets {
    (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
        .windows.first?.safeAreaInsets ?? .zero
}
