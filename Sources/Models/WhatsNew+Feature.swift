import SwiftUI

// MARK: - WhatsNew+Feature

public extension WhatsNew {
    
    /// A WhatsNew Feature
    struct Feature {
        
        // MARK: Properties
        
        /// The default feature
        var feature: Default?
        
        /// For custom SwiftUI views
        let customViewBuilder: (() -> AnyView)?
        
        var useDefaultStyling: Bool = true
        
        // MARK: Initializer
        
        /// Creates a new instance of `WhatsNew.Feature`
        /// - Parameters:
        ///   - image: The image
        ///   - title: The title Text
        ///   - subtitle: The subtitle Text
        public init(
            image: Image,
            title: Text,
            subtitle: Text
        ) {
            self.feature = Default(image: image, title: title, subtitle: subtitle)
            self.customViewBuilder = nil
        }
        
        public init<Content: View>(
            @ViewBuilder customView: @escaping () -> Content,
            useDefaultStyling: Bool = true
        ) {
            self.feature = nil
            self.customViewBuilder = { AnyView(customView()) }
            self.useDefaultStyling = useDefaultStyling
        }
    }
    
}

extension WhatsNew.Feature {
    
    /// Representing a default `Feature`
    struct Default {
        // MARK: Properties
        
        /// The image
        public var image: Image
        
        /// The title Text
        public var title: WhatsNew.Text
        
        /// The subtitle Text
        public var subtitle: WhatsNew.Text
        
        public init(
            image: Image,
            title: WhatsNew.Text,
            subtitle: WhatsNew.Text
        ) {
            self.image = image
            self.title = title
            self.subtitle = subtitle
        }
    }
    
}
// MARK: - Feature+Equatable

extension WhatsNew.Feature: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func == (
        lhs: Self,
        rhs: Self
    ) -> Bool {
        if let lhs = lhs.feature, let rhs = rhs.feature {
            return lhs.title == rhs.title
                && lhs.subtitle == rhs.subtitle
        } else {
            return false
        }
    }
    
}

// MARK: - Feature+Hashable

extension WhatsNew.Feature: Hashable {
    
    /// Hashes the essential components of this value by feeding them into the given hasher.
    /// - Parameter hasher: The hasher to use when combining the components of this instance.
    public func hash(
        into hasher: inout Hasher
    ) {
        if let d = self.feature {
            hasher.combine(d.title)
            hasher.combine(d.subtitle)
        } else {
            
        }
    }
    
}
