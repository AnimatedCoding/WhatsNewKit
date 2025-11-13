import SwiftUI

// MARK: - WhatsNew+PrimaryAction

public extension WhatsNew {
    
    /// The WhatsNew PrimaryAction
    protocol PrimaryAction {
        var title: Text { get set }
        
        /// The background color
        var backgroundColor: Color { get set }
        
        /// The foreground color
        var foregroundColor: Color { get set }
        
        /// The optional HapticFeedback
        var hapticFeedback: HapticFeedback? { get set }
        
        /// The optional on dismiss closure
        var action: ((_ progress: () -> Void, _ dismiss: () -> Void) -> Void)? { get set }
    }
    ///
    struct StructPrimaryAction: PrimaryAction {
        
        // MARK: Properties
        
        /// The title Text
        public var title: Text
        
        /// The background color
        public var backgroundColor: Color
        
        /// The foreground color
        public var foregroundColor: Color
        
        /// The optional HapticFeedback
        public var hapticFeedback: HapticFeedback?
        
        /// The optional on dismiss closure
        public var action: ((_ progress: () -> Void, _ dismiss: () -> Void) -> Void)?
        
        // MARK: Initializer
        
        /// Creates a new instance of `WhatsNew.PrimaryAction`
        /// - Parameters:
        ///   - title: The title Text. Default value `Continue`
        ///   - backgroundColor: The background color. Default value `.accentColor`
        ///   - foregroundColor: The foreground color. Default value `.white`
        ///   - hapticFeedback: The optional HapticFeedback. Default value `nil`
        ///   - onDismiss: The optional on dismiss closure. Default value `nil`
        public init(
            title: Text = "Continue",
            backgroundColor: Color = .accentColor,
            foregroundColor: Color = .white,
            hapticFeedback: HapticFeedback? = nil,
            action: ((_ progress: () -> Void, _ dismiss: () -> Void) -> Void)? = FeatureGroup.defaultAction
        ) {
            self.title = title
            self.backgroundColor = backgroundColor
            self.foregroundColor = foregroundColor
            self.hapticFeedback = hapticFeedback
            self.action = action
        }
        
    }
    
    /// A percistant WhatsNew PrimaryAction, so you can edit it while it is presented
    class PercistablePrimaryAction: PrimaryAction {
        
        // MARK: Properties
        
        /// The title Text
        public var title: Text
        
        /// The background color
        public var backgroundColor: Color
        
        /// The foreground color
        public var foregroundColor: Color
        
        /// The optional HapticFeedback
        public var hapticFeedback: HapticFeedback?
        
        /// The optional on dismiss closure
        public var action: ((_ progress: () -> Void, _ dismiss: () -> Void) -> Void)?
        
        // MARK: Initializer
        
        /// Creates a new instance of `WhatsNew.PrimaryAction`
        /// - Parameters:
        ///   - title: The title Text. Default value `Continue`
        ///   - backgroundColor: The background color. Default value `.accentColor`
        ///   - foregroundColor: The foreground color. Default value `.white`
        ///   - hapticFeedback: The optional HapticFeedback. Default value `nil`
        ///   - onDismiss: The optional on dismiss closure. Default value `nil`
        public init(
            title: Text = "Continue",
            backgroundColor: Color = .accentColor,
            foregroundColor: Color = .white,
            hapticFeedback: HapticFeedback? = nil,
            action: ((_ progress: () -> Void, _ dismiss: () -> Void) -> Void)? = FeatureGroup.defaultAction
        ) {
            self.title = title
            self.backgroundColor = backgroundColor
            self.foregroundColor = foregroundColor
            self.hapticFeedback = hapticFeedback
            self.action = action
        }
        
    }
    
}
