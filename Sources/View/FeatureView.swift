import SwiftUI

// MARK: -- FeatureView
/// View that present a feature like in the onboarding
/// - Parameters:
///   - feature: The `Feature` (of type `WhatsNew.Feature.Default`)
///   - layout: The `WhatsNew.Layout`
public struct FeatureView: View {
    
    @Binding var feature: WhatsNewFeature
    
    public var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Image(systemName: feature.image)
                .frame(width: 40)
                .foregroundStyle(feature.foregroundStyle)
            VStack(
                alignment: .leading,
            ) {
                Text(feature.title)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
                Text(feature.subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            }
            .multilineTextAlignment(.leading)
            Spacer()
        }
    }
}

public typealias WhatsNewFeature = WhatsNew.WhatsNewFeature.Default

#Preview {
    FeatureView(feature: .constant(WhatsNewFeature(systemName: "pencil", title: "Title", subtitle: "Subtitle")))
}
