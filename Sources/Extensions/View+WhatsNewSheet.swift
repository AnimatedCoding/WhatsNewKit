import SwiftUI

// MARK: - View+sheet(whatsNew:)

public extension View {

    /// Presents a WhatsNewView using the given WhatsNew object as a data source for the sheet’s content.
    /// - Parameters:
    ///   - whatsNew: A Binding to an optional WhatsNew object
    ///   - versionStore: The optional WhatsNewVersionStore. Default value `nil`
    ///   - layout: The WhatsNew Layout. Default value `.default`
    ///   - onDismiss: The closure to execute when dismissing the sheet. Default value `nil`
//    func sheet(
//        whatsNew: Binding<WhatsNew?>,
//        versionStore: WhatsNewVersionStore? = nil,
//        layout: WhatsNew.Layout = .default,
//        onDismiss: (() -> Void)? = nil
//    ) -> some View {
//        self.modifier(
//            ManualWhatsNewSheetViewModifier(
//                whatsNew: whatsNew,
//                versionStore: versionStore,
//                layout: layout,
//                onDismiss: onDismiss
//            )
//        )
//    }
    
    /// Presents a WhatsNewView using the given WhatsNew object as a data source for the sheet’s content.
    /// - Parameters:
    ///   - whatsNew: A Binding to an optional WhatsNew object
    ///   - versionStore: The optional WhatsNewVersionStore. Default value `nil`
    ///   - layout: The WhatsNew Layout. Default value `.default`
    ///   - onDismiss: The closure to execute when dismissing the sheet. Default value `nil`
    ///   - isPresented: The `Bool` for if the sheet is presented
    func sheet(
        whatsNew: Binding<WhatsNew?>,
        //versionStore: WhatsNewVersionStore? = nil,
        layout: WhatsNew.Layout = .default,
        onDismiss: (() -> Void)? = nil,
        isPresented: Binding<Bool> = .constant(true)
    ) -> some View {
        var presented = Binding<Bool>(get: {
            isPresented.wrappedValue && whatsNew.wrappedValue != nil
        }, set: {
            isPresented.wrappedValue = $0
            if $0 { } else {
                //whatsNew.wrappedValue = nil
            }
        })
        return self.modifier(
            ManualWhatsNewSheetViewModifierWithDismisser(
                whatsNew: whatsNew,
                //versionStore: versionStore,
                layout: layout,
                onDismiss: onDismiss,
                isPresented: presented
            )
        )
    }
    
}

// MARK: - ManualWhatsNewSheetViewModifier
//
///// A Manual WhatsNew Sheet ViewModifier
//private struct ManualWhatsNewSheetViewModifier: ViewModifier {
//    
//    // MARK: Properties
//    
//    /// A Binding to an optional WhatsNew object
//    @Binding var whatsNew: WhatsNew?
//    
//    /// The optional WhatsNewVersionStore
//    let versionStore: WhatsNewVersionStore?
//    
//    /// The WhatsNew Layout
//    let layout: WhatsNew.Layout
//    
//    /// The closure to execute when dismissing the sheet
//    let onDismiss: (() -> Void)?
//    
//    // MARK: ViewModifier
//    /// Gets the current body of the caller.
//    /// - Parameter content: The Content
//    func body(
//        content: Content
//    ) -> some View {
//        let showSheet = Binding<Bool>(
//            get: {
//                if whatsNew != nil {
//                    return true
//                } else {
//                    return false
//                }
//            },
//            set: {
//                if !$0 {
//                    whatsNew = nil
//                }
//            }
//        )
//        content.sheet(
//            isPresented: showSheet,
//            onDismiss: self.onDismiss
//        ) {
//            let binding = Binding<WhatsNew>(get: {
//                whatsNew!
//            }, set: {
//                print("Settings", $0.featureGroups.first?.features.first?.feature?.title)
//                whatsNew = $0
//            })
//            WhatsNewView(
//                whatsNew: binding,
//                versionStore: self.versionStore,
//                layout: self.layout
//            )
//        }
//    }
//}

// MARK: - ManualWhatsNewSheetViewModifierWithDismisser

private struct ManualWhatsNewSheetViewModifierWithDismisser: ViewModifier {
    
    // MARK: Properties
    
    /// A Binding to an optional WhatsNew object
    @Binding var whatsNew: WhatsNew?
    
    /// The optional WhatsNewVersionStore
    //let versionStore: WhatsNewVersionStore?
    
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
        content
            .sheet(isPresented: isPresented, onDismiss: self.onDismiss)
        {
            let binding = Binding<WhatsNew>(get: {
                whatsNew!
            }, set: {
                whatsNew = $0
            })
            WhatsNewView(
                whatsNew: binding,
                //versionStore: self.versionStore,
                layout: self.layout
            )
        }
    }
}

//// MARK: - View+whatsNewSheet()
//
//public extension View {
//    
//    /// Auto-Presents a WhatsNewView to the user if needed based on the `WhatsNewEnvironment`
//    /// - Parameters:
//    ///   - layout: The optional custom WhatsNew Layout. Default value `nil`
//    ///   - onDismiss: The closure to execute when dismissing the sheet. Default value `nil`
//    func whatsNewSheet(
//        layout: WhatsNew.Layout? = nil,
//        onDismiss: (() -> Void)? = nil
//    ) -> some View {
//        self.modifier(
//            AutomaticWhatsNewSheetViewModifier(
//                layout: layout,
//                onDismiss: onDismiss
//            )
//        )
//    }
//    
//}
//
//// MARK: - WhatsNewSheetViewModifier
//
///// A  Automatic WhatsNew Sheet ViewModifier
//private struct AutomaticWhatsNewSheetViewModifier: ViewModifier {
//    
//    // MARK: Properties
//    
//    /// The optional WhatsNew Layout
//    let layout: WhatsNew.Layout?
//    
//    /// The optional closure to execute when dismissing the sheet
//    let onDismiss: (() -> Void)?
//    
//    /// Bool value if sheet is dismissed
//    @State
//    private var isDismissed: Bool?
//    
//    /// The WhatsNewEnvironment
//    @Environment(\.whatsNew)
//    private var whatsNewEnvironment
//    
//    // MARK: ViewModifier
//    
//    /// Gets the current body of the caller.
//    /// - Parameter content: The Content
//    func body(
//        content: Content
//    ) -> some View {
//        content.sheet(
//            item: .init(
//                get: {
//                    self.isDismissed == true
//                        ? nil
//                        : self.whatsNewEnvironment.whatsNew()
//                },
//                set: {
//                    self.isDismissed = $0 == nil
//                }
//            ),
//            onDismiss: self.onDismiss
//        ) { whatsNew in
//            WhatsNewView(
//                whatsNew: .constant(whatsNew),
//                versionStore: self.whatsNewEnvironment.whatsNewVersionStore,
//                layout: self.layout ?? self.whatsNewEnvironment.defaultLayout
//            )
//        }
//    }
//    
//}
