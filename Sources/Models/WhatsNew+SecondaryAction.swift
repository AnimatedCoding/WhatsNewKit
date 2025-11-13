import SwiftUI

// MARK: - WhatsNew+SecondaryAction

public extension WhatsNew {
    
    /// The WhatsNew SecondaryActionProtocol
    protocol SecondaryActionProtocol {
        var title: Text { get set }
        
        /// The foreground color
        var foregroundColor: Color { get set }
        
        /// The optional HapticFeedback
        var hapticFeedback: HapticFeedback? { get set }
        
        /// The Action
        var action: StructSecondaryAction.Action { get set }
    }
    ///
    struct StructSecondaryAction: SecondaryActionProtocol {
        
        // MARK: Properties
        
        /// The title Text
        public var title: Text
        
        /// The foreground color
        public var foregroundColor: Color
        
        /// The optional HapticFeedback
        public var hapticFeedback: HapticFeedback?
        
        /// The Action
        public var action: Action
        
        // MARK: Initializer
        
        /// Creates a new instance of `WhatsNew.SecondaryAction`
        /// - Parameters:
        ///   - title: The title Text
        ///   - foregroundColor: The foreground color. Default value `.accentColor`
        ///   - hapticFeedback: The optional HapticFeedback. Default value `nil`
        ///   - action: The Action
        public init(
            title: Text,
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
        
    }
    
    /// A persistant WhatsNew SecondaryAction
    class PersistantSecondaryAction: SecondaryActionProtocol {
        
        // MARK: Properties
        
        /// The title Text
        public var title: Text
        
        /// The foreground color
        public var foregroundColor: Color
        
        /// The optional HapticFeedback
        public var hapticFeedback: HapticFeedback?
        
        /// The Action
        public var action: StructSecondaryAction.Action
        
        // MARK: Initializer
        
        /// Creates a new instance of `WhatsNew.SecondaryAction`
        /// - Parameters:
        ///   - title: The title Text
        ///   - foregroundColor: The foreground color. Default value `.accentColor`
        ///   - hapticFeedback: The optional HapticFeedback. Default value `nil`
        ///   - action: The Action
        public init(
            title: Text,
            foregroundColor: Color = {
                #if os(visionOS)
                .primary
                #else
                .accentColor
                #endif
            }(),
            hapticFeedback: HapticFeedback? = nil,
            action: StructSecondaryAction.Action
        ) {
            self.title = title
            self.foregroundColor = foregroundColor
            self.hapticFeedback = hapticFeedback
            self.action = action
        }
        
    }
}

public typealias SecondaryAction = WhatsNew.StructSecondaryAction
