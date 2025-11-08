//
//  SwiftUIView 2.swift
//  WhatsNewKit
//
//  Created by Noah on 11/7/25.
//

import SwiftUI

struct SwiftUIView_2: View {
    var body: some View {
        FeatureView(feature: .init(
            image: .init(
                systemName: "star.fill",
                foregroundColor: .orange
            ),
            title: "Showcase your new App Features",
            subtitle: "Present your new app features..."
        ))
    }
}
