import SwiftUI

// MARK: - View+sheet(whatsNew:)

public extension View {
    func sheet(
        whatsNew: WhatsNew?,
        layout: WhatsNew.Layout = .default,
        onDismiss: (() -> Void)? = nil,
        isPresented: Binding<Bool> = .constant(true)
    ) -> some View {
        let presented = Binding<Bool>(get: {
            return isPresented.wrappedValue && whatsNew != nil
        }, set: {
            print("setting isPresented")
            isPresented.wrappedValue = $0
            if $0 { } else {
                //whatsNew.wrappedValue = nil
            }
        })
        return self.modifier(
            WhatsNewSheetViewModifier(
                whatsNew: whatsNew ?? WhatsNew(title: "FILLER", featureGroups: []),
                layout: layout,
                onDismiss: onDismiss,
                isPresented: presented
            )
        )
    }
}

// MARK: - ManualWhatsNewSheetViewModifierWithDismisser

private struct WhatsNewSheetViewModifier: ViewModifier {
    
    // MARK: Properties
    
    /// A Binding to an optional WhatsNew object
    @Bindable var whatsNew: WhatsNew
    
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
            WhatsNewView(
                whatsNew: whatsNew,
                layout: self.layout
            )
        }
    }
}
