import SwiftUI
import WhatsNewKit

struct ContentView: View {
    @State
    var whatsNew: WhatsNew? = WhatsNew(
        title: "WhatsNewKit",
        features: [
            .init(
                image: .init(
                    systemName: "star.fill",
                    foregroundColor: .orange
                ),
                title: "Showcase your new App Features",
                subtitle: "Present your new app features..."
            ),
            // MARK: -- init for custom view
            .init(customView: {
                Button(action: {
                    print("Pressed")
                }) {
                    Text("This is a custom view")
                }
            })
        ]
    )

    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
            }
        }
        .sheet(
            whatsNew: self.$whatsNew
        )
    }
}
