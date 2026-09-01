import Foundation

public extension WhatsNew {
    /// The struct representing a group of feature that apear on the same screen
    @Observable
    class FeatureGroup: Equatable {
        /// The list of `Feature`
        public var features: [WhatsNew.WhatsNewFeature]
        /// The ondismiss
        public var primaryAction: PrimaryAction
        /// The optional SecondaryAction
        public var secondaryAction: SecondaryAction?
        
        /// Initializer
        /// - Parameters:
        ///   - features: An `Array` of features
        ///   - action: The `PrimaryAction` that the main button calls
        ///   - secondaryAction: The optional `SecondaryAction`
        public init(feature: [WhatsNew.WhatsNewFeature],
                    action: PrimaryAction = PrimaryAction(action: FeatureGroup.defaultAction),
                    secondaryAction: SecondaryAction? = nil
        ) {
            self.features = feature
            self.primaryAction = action
            self.secondaryAction = secondaryAction
        }
        /// The default action
        public static func defaultAction(_ c: () -> Void, _ d: () -> Void) {
            c()
        }
        public static func ==(lhs: FeatureGroup, rhs: FeatureGroup) -> Bool {
            lhs.features == rhs.features && lhs.primaryAction == rhs.primaryAction && lhs.secondaryAction == rhs.secondaryAction
        }
    }
}
