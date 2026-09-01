import SwiftUI

// MARK: - WhatsNew+SecondaryAction

public extension WhatsNew {
    
    /// The WhatsNew SecondaryAction
    struct SecondaryAction: Equatable {
        
        // MARK: Properties
        
        /// The title Text
        public var title: String
        
        /// The foreground color
        public var foregroundColor: Color
        
        /// The optional HapticFeedback
        public var hapticFeedback: HapticFeedback?
        
        /// The Action
        public var action: Action
        
        public var id = UUID()
        
        // MARK: Initializer
        
        /// Creates a new instance of `WhatsNew.PrimaryAction`
        /// - Parameters:
        ///   - title: The title Text
        ///   - foregroundColor: The foreground color. Default value `.accentColor`
        ///   - hapticFeedback: The optional HapticFeedback. Default value `nil`
        ///   - action: The Action
        public init(
            title: String,
            foregroundColor: Color = {
                #if os(visionOS)
                .primary
                #else
                .accentColor
                #endif
            }(),
            hapticFeedback: HapticFeedback? = nil,
            action: Action
        ) {
            self.title = title
            self.foregroundColor = foregroundColor
            self.hapticFeedback = hapticFeedback
            self.action = action
        }
        
        public static func ==(lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }
    }
}
