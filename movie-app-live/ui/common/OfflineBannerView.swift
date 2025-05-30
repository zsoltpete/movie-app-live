//
//  OfflineBannerView.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 05. 15..
//

import SwiftUI

struct OfflineBannerView: View {
    var body: some View {
        HStack {
            Image(systemName: "wifi.slash")
            Text("noInternet".localized())
                .font(Fonts.caption)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.red.opacity(0.9))
        .foregroundColor(.white)
    }
}
