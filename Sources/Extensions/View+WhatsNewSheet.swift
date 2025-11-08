import SwiftUI

// MARK: - View+sheet(whatsNew:)

public extension View {

    /// Presents a WhatsNewView using the given WhatsNew object as a data source for the sheet’s content.
    /// - Parameters:
    ///   - whatsNew: A Binding to an optional WhatsNew object
    ///   - versionStore: The optional WhatsNewVersionStore. Default value `nil`
    ///   - layout: The WhatsNew Layout. Default value `.default`
    ///   - onDismiss: The closure to execute when dismissing the sheet. Default value `nil`
    func sheet(
        whatsNew: Binding<WhatsNew?>,
        versionStore: WhatsNewVersionStore? = nil,
        layout: WhatsNew.Layout = .default,
        onDismiss: (() -> Void)? = nil
    ) -> some View {
        self.modifier(
            ManualWhatsNewSheetViewModifier(
                whatsNew: whatsNew,
                versionStore: versionStore,
                layout: layout,
                onDismiss: onDismiss
            )
        )
    }
    
    /// Presents a WhatsNewView using the given WhatsNew object as a data source for the sheet’s content.
    /// - Parameters:
    ///   - whatsNew: A Binding to an optional WhatsNew object
    ///   - versionStore: The optional WhatsNewVersionStore. Default value `nil`
    ///   - layout: The WhatsNew Layout. Default value `.default`
    ///   - onDismiss: The closure to execute when dismissing the sheet. Default value `nil`
    ///   - isPresented: The `Bool` for if the sheet is presented
    func sheet(
        whatsNew: Binding<WhatsNew?>,
        versionStore: WhatsNewVersionStore? = nil,
        layout: WhatsNew.Layout = .default,
        onDismiss: (() -> Void)? = nil,
        isPresented: Binding<Bool>
    ) -> some View {
        self.modifier(
            ManualWhatsNewSheetViewModifierWithDismisser(
                whatsNew: whatsNew,
                versionStore: versionStore,
                layout: layout,
                onDismiss: onDismiss,
                isPresented: isPresented
            )
        )
    }
    
}

// MARK: - ManualWhatsNewSheetViewModifier

/// A Manual WhatsNew Sheet ViewModifier
private struct ManualWhatsNewSheetViewModifier: ViewModifier {
    
    // MARK: Properties
    
    /// A Binding to an optional WhatsNew object
    let whatsNew: Binding<WhatsNew?>
    
    /// The optional WhatsNewVersionStore
    let versionStore: WhatsNewVersionStore?
    
    /// The WhatsNew Layout
    let layout: WhatsNew.Layout
    
    /// The closure to execute when dismissing the sheet
    let onDismiss: (() -> Void)?
    
    // MARK: ViewModifier
    
    /// Gets the current body of the caller.
    /// - Parameter content: The Content
    func body(
        content: Content
    ) -> some View {
        // Check if a WhatsNew object is available
        if let whatsNew = self.whatsNew.wrappedValue {
            // Check if the WhatsNew Version has already been presented
            if self.versionStore?.hasPresented(whatsNew.version) == true {
                // Show content
                content
            } else {
                // Show WhatsNew Sheet
                content.sheet(
                    item: self.whatsNew,
                    onDismiss: self.onDismiss
                ) { whatsNew in
                    WhatsNewView(
                        whatsNew: whatsNew,
                        versionStore: self.versionStore,
                        layout: self.layout
                    )
                }
            }
        } else {
            // Otherwise show content
            content
        }
    }
    
}

// MARK: - ManualWhatsNewSheetViewModifierWithDismisser

private struct ManualWhatsNewSheetViewModifierWithDismisser: ViewModifier {
    
    // MARK: Properties
    
    /// A Binding to an optional WhatsNew object
    let whatsNew: Binding<WhatsNew?>
    
    /// The optional WhatsNewVersionStore
    let versionStore: WhatsNewVersionStore?
    
    /// The WhatsNew Layout
    let layout: WhatsNew.Layout
    
    /// The closure to execute when dismissing the sheet
    let onDismiss: (() -> Void)?
    
    /// A Binding to the Bool for presenting
    var isPresented: Binding<Bool>
    
    // MARK: ViewModifier
    
    /// Gets the current body of the caller.
    /// - Parameter content: The Content
    func body(
        content: Content
    ) -> some View {
        // Check if a WhatsNew object is available
        if let whatsNew = self.whatsNew.wrappedValue {
            // This sheet doesn't check if the version has been presented, because it is the one for use with custom isPresented
            // Show WhatsNew Sheet
            content
                .sheet(isPresented: isPresented, onDismiss: self.onDismiss)
            {
                WhatsNewView(
                    whatsNew: whatsNew,
                    versionStore: self.versionStore,
                    layout: self.layout
                )
            }
        } else {
            // Otherwise show content
            content
        }
    }
    
}

// MARK: - View+whatsNewSheet()

public extension View {
    
    /// Auto-Presents a WhatsNewView to the user if needed based on the `WhatsNewEnvironment`
    /// - Parameters:
    ///   - layout: The optional custom WhatsNew Layout. Default value `nil`
    ///   - onDismiss: The closure to execute when dismissing the sheet. Default value `nil`
    func whatsNewSheet(
        layout: WhatsNew.Layout? = nil,
        onDismiss: (() -> Void)? = nil
    ) -> some View {
        self.modifier(
            AutomaticWhatsNewSheetViewModifier(
                layout: layout,
                onDismiss: onDismiss
            )
        )
    }
    
}

// MARK: - WhatsNewSheetViewModifier

/// A Automatic WhatsNew Sheet ViewModifier
private struct AutomaticWhatsNewSheetViewModifier: ViewModifier {
    
    // MARK: Properties
    
    /// The optional WhatsNew Layout
    let layout: WhatsNew.Layout?
    
    /// The optional closure to execute when dismissing the sheet
    let onDismiss: (() -> Void)?
    
    /// Bool value if sheet is dismissed
    @State
    private var isDismissed: Bool?
    
    /// The WhatsNewEnvironment
    @Environment(\.whatsNew)
    private var whatsNewEnvironment
    
    // MARK: ViewModifier
    
    /// Gets the current body of the caller.
    /// - Parameter content: The Content
    func body(
        content: Content
    ) -> some View {
        content.sheet(
            item: .init(
                get: {
                    self.isDismissed == true
                        ? nil
                        : self.whatsNewEnvironment.whatsNew()
                },
                set: {
                    self.isDismissed = $0 == nil
                }
            ),
            onDismiss: self.onDismiss
        ) { whatsNew in
            WhatsNewView(
                whatsNew: whatsNew,
                versionStore: self.whatsNewEnvironment.whatsNewVersionStore,
                layout: self.layout ?? self.whatsNewEnvironment.defaultLayout
            )
        }
    }
    
}
