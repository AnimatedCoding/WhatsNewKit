import SwiftUI

// MARK: -- FeatureView
/// View that present a feature like in the onboarding
public struct FeatureView: View {
    @State var feature: Feature
    let layout: WhatsNew.Layout
    
    // MARK: -- Initializer
    
    /// Creates a new instance of `FeatureView`
    /// - Parameters:
    ///   - feature: The `Feature` (of type `WhatsNew.Feature.Default`)
    ///   - layout: The `WhatsNew.Layout`
    public init(feature: Feature, layout: WhatsNew.Layout = .default) {
        self.feature = feature
        self.layout = layout
    }
    public var body: some View {
        HStack(
            alignment: self.layout.featureHorizontalAlignment,
            spacing: self.layout.featureHorizontalSpacing
        ) {
            feature
                .image
                .view()
                .frame(width: self.layout.featureImageWidth)
            VStack(
                alignment: .leading,
                spacing: self.layout.featureVerticalSpacing
            ) {
                Text(
                    whatsNewText: feature.title
                )
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
                Text(
                    whatsNewText: feature.subtitle
                )
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            }
            .multilineTextAlignment(.leading)
        }
    }
}

public typealias Feature = WhatsNew.Feature.Default

#Preview {
    FeatureView(feature: .init(image: .init(systemName: "pencil"), title: "Title", subtitle: "Subtitle"))
}
