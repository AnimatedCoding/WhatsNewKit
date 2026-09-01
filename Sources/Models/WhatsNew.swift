import Foundation

// MARK: - WhatsNew

/// A WhatsNew object
@Observable
public class WhatsNew: Equatable {
    
    // MARK: Properties
    
    /// The Version
    //public var version: Version
    
    /// The Title
    public var title: String
    
    /// The Features
    public var featureGroups: [FeatureGroup]
    
    /// The selected `FeatureGroup`
    public var selectedFeature: WhatsNew.FeatureGroup?
    
    // MARK: Initializer
    
    /// Creates a new instance of `WhatsNew` using `Feature`
    /// - Parameters:
    ///   - version: The Version. Default value `.current()`
    ///   - title: The Title
    ///   - features: The Features
    ///   - primaryAction: The PrimaryAction. Default value `.init()`
    ///   - secondaryAction: The optional SecondaryAction. Default value `nil`
    public init(
        //version: Version = .current(),
        title: String,
        features: [WhatsNew.WhatsNewFeature],
        primaryAction: PrimaryAction = .init(),
        secondaryAction: SecondaryAction? = nil
    ) {
        //self.version = version
        self.title = title
        self.featureGroups = [FeatureGroup(feature: features, action: primaryAction, secondaryAction: secondaryAction)]
        self.selectedFeature = featureGroups[0]
    }
    /// Creates a new instance of `WhatsNew` using `FeatureGroup`
    /// - Parameters:
    ///   - version: The Version. Default value `.current()`
    ///   - title: The Title
    ///   - featuresGroups: The FeaturesGroups
    public init(
        //version: Version = .current(),
        title: String,
        featureGroups: [FeatureGroup],
    ) {
        //self.version = version
        self.title = title
        self.featureGroups = featureGroups
        if !featureGroups.isEmpty {
            self.selectedFeature = featureGroups[0]
        }
    }
    
    public static func ==(lhs: WhatsNew, rhs: WhatsNew) -> Bool {
        lhs.title == rhs.title && lhs.featureGroups == rhs.featureGroups
    }
}

// MARK: - Identifiable

//extension WhatsNew: Identifiable {
//    
//    /// The stable identity of the entity associated with this instance.
//    public var id: Version {
//        self.version
//    }
//    
//}
