import SwiftUI

// MARK: -- FeatureView
/// View that present a feature like in the onboarding
/// - Parameters:
///   - feature: The `Feature` (of type `WhatsNew.Feature.Default`)
///   - layout: The `WhatsNew.Layout`
public struct FeatureView: View {
    
    @Bindable var feature: WhatsNewFeature
    
    public init(feature: WhatsNewFeature) {
        self.feature = feature
    }
    
    public var body: some View {
        HStack(alignment: .top) {
            Image(systemName: feature.image)
                .font(.title)
                .frame(width: 40)
                .foregroundStyle(feature.foregroundStyle)
            VStack(
                alignment: .leading,
            ) {
                if !feature.title.isEmpty {
                    Text(feature.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                if !feature.subtitle.isEmpty {
                    Text(feature.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .multilineTextAlignment(.leading)
            Spacer()
        }
    }
}

public typealias WhatsNewFeature = WhatsNew.WhatsNewFeature.Default

#Preview {
    FeatureView(feature: (WhatsNewFeature(systemName: "pencil", title: "", subtitle: "Subtitle")))
}
