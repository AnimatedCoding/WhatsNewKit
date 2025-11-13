import Foundation

public extension WhatsNew {
    /// The struct representing a group of feature that apear on the same screen
    struct FeatureGroup {
        /// The list of `Feature`
        public var features: [Feature]
        /// The ondismiss
        public var primaryAction: PrimaryActionProtocal
        /// The optional SecondaryAction
        public var secondaryAction: SecondaryActionProtocol?
        
        /// Initializer
        /// - Parameters:
        ///   - features: An `Array` of features
        ///   - action: The `PrimaryAction` that the main button calls
        ///   - secondaryAction: The optional `SecondaryAction`
        public init(feature: [Feature],
                    action: PrimaryActionProtocal = StructPrimaryAction(action: FeatureGroup.defaultAction),
                    secondaryAction: SecondaryActionProtocol? = nil
        ) {
            self.features = feature
            self.primaryAction = action
            self.secondaryAction = secondaryAction
        }
        /// The default action
        static public func defaultAction(_ c: () -> Void, _ d: () -> Void) {
            c()
        }
    }
}
