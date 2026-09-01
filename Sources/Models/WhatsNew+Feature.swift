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
    /// A WhatsNew Feature
//    struct Feature {
//        
//        // MARK: Properties
//        
//        /// The default feature
//        var feature: Default?
//        
//        /// For custom SwiftUI views
//        let customViewBuilder: (() -> AnyView)?
//        
//        var useDefaultStyling: Bool = true
//        
//        var id = UUID()
//        
//        // MARK: Initializers
//        
//        /// Creates a new instance of `WhatsNew.Feature` using the `Default` method
//        /// - Parameters:
//        ///   - image: The image
//        ///   - title: The title Text
//        ///   - subtitle: The subtitle Text
//        public init(
//            image: Image,
//            title: String,
//            subtitle: String
//        ) {
//            self.feature = Default(image: image, title: title, subtitle: subtitle)
//            self.customViewBuilder = nil
//        }
//
//        /// Creates a new instance of `WhatsNew.Feature` using the `Default` method, but accept string peramiters
//        /// - Parameters:
//        ///   - image: The system image name (String)
//        ///   - title: The title String
//        ///   - subtitle: The subtitle String
//        public init(
//            systemName: String,
//            title: String,
//            subtitle: String,
//            foregroundStyle: Color? = .accentColor,
//        ) {
//            self.feature = Default(image: .init(systemName: systemName, foregroundColor: foregroundStyle), title: title, subtitle: subtitle)
//            self.customViewBuilder = nil
//        }
//        
//        /// Creates a new instance of `WhatsNew.Feature` in custom view mode
//        ///  - Parameters:
//        ///   - customView: The SwiftUI view that should be presented
//        ///   - useDefaultStyling: This sets the button style to be the same as the main action button, it defaults to `true`
//        public init<Content: View>(
//            @ViewBuilder customView: @escaping () -> Content,
//            useDefaultStyling: Bool = true,
//            foregroundStyle: Color = .accentColor,
//        ) {
//            self.feature = nil
//            self.customViewBuilder = { AnyView(
//                customView()
//                    .foregroundStyle(foregroundStyle)
//            ) }
//            self.useDefaultStyling = useDefaultStyling
//        }
    //}
}

extension WhatsNew.WhatsNewFeature {
    
    /// Representing a default `Feature` (`WhatsNew.Feature.Default`)``
    public struct Default: Feature {
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
    }
}

typealias Default = WhatsNew.WhatsNewFeature.Default

extension WhatsNew.WhatsNewFeature {
    
    /// Representing a default `Feature` (`WhatsNew.Feature.Default`)``
    public struct Custom: Feature {
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
        
        public static func == (
            lhs: Self,
            rhs: Self
        ) -> Bool {
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
// MARK: - Feature+Equatable
//
//extension WhatsNew.Feature: Equatable {
//    
//    /// Returns a Boolean value indicating whether two values are equal.
//    /// - Parameters:
//    ///   - lhs: A value to compare.
//    ///   - rhs: Another value to compare.
//    public static func == (
//        lhs: Self,
//        rhs: Self
//    ) -> Bool {
//        lhs.id == rhs.id
//    }
//    
//}
//
//// MARK: - Feature+Hashable
//
//extension WhatsNew.Feature: Hashable {
//    
//    /// Hashes the essential components of this value by feeding them into the given hasher.
//    /// - Parameter hasher: The hasher to use when combining the components of this instance.
//    public func hash(
//        into hasher: inout Hasher
//    ) {
//        if let d = self.feature {
//            hasher.combine(d.title)
//            hasher.combine(d.subtitle)
//            hasher.combine(d.image.id)
//        } else {
//            hasher.combine(self.id)
//        }
//    }
//    
//}
