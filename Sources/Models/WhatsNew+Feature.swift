import SwiftUI

// MARK: - WhatsNew+Feature

protocol Feature: Equatable, Hashable {
    var id: UUID { get }
}

public extension WhatsNew {
    enum WhatsNewFeature: Feature {
        case `default`(Default)
        case custom(Custom)
        var id: UUID {
            switch self {
            case .default(let `default`):
                return `default`.id
            case .custom(let custom):
                return custom.id
            }
        }
        
        public static func == (
            lhs: Self,
            rhs: Self
        ) -> Bool {
            lhs.id == rhs.id
        }
        
        public func hash(
            into hasher: inout Hasher
        ) {
            switch self {
            case .default(let `default`):
                hasher.combine(`default`)
            case .custom(let custom):
                hasher.combine(custom)
            }
        }
    }
}

extension WhatsNew.WhatsNewFeature {
    
    /// Representing a default `Feature` (`WhatsNew.Feature.Default`)``
    @Observable
    public class Default: Feature {
        public let id = UUID()
        
        // MARK: Properties
        
        /// The image
        public var image: String
        
        /// The title Text
        public var title: String
        
        /// The subtitle Text
        public var subtitle: String
        
        public var foregroundStyle: Color
        
        /// Creates a new instance of `WhatsNew.Feature` using the `Default` method, but accept string peramiters
        /// - Parameters:
        ///   - image: The system image name (String)
        ///   - title: The title String
        ///   - subtitle: The subtitle String
        public init(
            systemName: String,
            title: String,
            subtitle: String,
            foregroundStyle: Color = .accentColor,
        ) {
            self.image = systemName
            self.title = title
            self.subtitle = subtitle
            self.foregroundStyle = foregroundStyle
        }
        
        public func hash(
            into hasher: inout Hasher
        ) {
            hasher.combine(title)
            hasher.combine(subtitle)
            hasher.combine(image)
        }
        
        public static func ==(lhs: Default, rhs: Default) -> Bool {
            lhs.image == rhs.image && lhs.title == rhs.title && lhs.subtitle == rhs.subtitle && lhs.foregroundStyle == rhs.foregroundStyle
        }
    }
}

typealias Default = WhatsNew.WhatsNewFeature.Default

extension WhatsNew.WhatsNewFeature {
    
    /// Representing a default `Feature` (`WhatsNew.Feature.Default`)``
    @Observable
    public class Custom: Feature {
        public let id = UUID()
        
        let viewBuilder: (() -> AnyView)
        
        var useDefaultStyling: Bool = true
        
        public init<Content: View>(
            @ViewBuilder customView: @escaping () -> Content,
            useDefaultStyling: Bool = true,
            foregroundStyle: Color = .accentColor,
        ) {
            self.viewBuilder = { AnyView(
                customView()
                    .foregroundStyle(foregroundStyle)
            ) }
            self.useDefaultStyling = useDefaultStyling
        }
        
        public static func == (lhs: Custom, rhs: Custom) -> Bool {
            lhs.id == rhs.id
        }
        
        public func hash(
            into hasher: inout Hasher
        ) {
            hasher.combine(self.id)
        }
    }
}

typealias Custom = WhatsNew.WhatsNewFeature.Custom
