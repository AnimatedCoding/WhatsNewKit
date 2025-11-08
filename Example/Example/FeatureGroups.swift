//
//  SwiftUIView.swift
//  WhatsNewKit
//
//  Created by Noah on 11/7/25.
//

import SwiftUI

struct SwiftUIView: View {
    @State var whatsNew: WhatsNew?
    var body: some View {
        Text("Whats New Feature Groups")
            .onAppear {
                whatsNew = WhatsNew(
                    title: "WhatsNewKit",
                    featuresGroups: [
                        .init(feature: [
                            .init(
                                image: .init(
                                    systemName: "star.fill",
                                    foregroundColor: .orange
                                ),
                                title: "Showcase your new App Features",
                                subtitle: "Present your new app features"
                            ),
                            .init(customView: {
                                Button(action: {
                                    print("Pressed")
                                }) {
                                    Text("This is a custom view")
                                }
                            })
                        ],
                        ),
                        .init(feature: [
                            .init(
                                image: .init(
                                    systemName: "pencil",
                                    foregroundColor: .orange
                                ),
                                title: "Make your onboarding look good",
                                subtitle: "Custimize it"
                            ),
                        ],
                              action: .init(title: "Close",
                                            backgroundColor: .red,
                                            action: { progress, dismiss in
                                  progress()
                              })
                        )
                    ],
                )
                }

            }
    }
}
