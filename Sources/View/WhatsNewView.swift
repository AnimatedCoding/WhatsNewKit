import SwiftUI

// MARK: - WhatsNewView

/// A WhatsNewView
public struct WhatsNewView {
    
    // MARK: Properties
    
    
    /// The current `FeatureGroup`
    @State public var groupIndex: Int? = nil
    /// The WhatsNew object
    @State private var whatsNew: WhatsNew
    
    /// The WhatsNewVersionStore
    private let whatsNewVersionStore: WhatsNewVersionStore?
    
    /// The WhatsNew Layout
    private let layout: WhatsNew.Layout
    
    /// The View that is presented by the SecondaryAction
    @State
    private var secondaryActionPresentedView: WhatsNew.StructSecondaryAction.Action.PresentedView?
    
    /// The PresentationMode
    @Environment(\.presentationMode)
    private var presentationMode
    
    // MARK: Initializer
    
    /// Creates a new instance of `WhatsNewView`
    /// - Parameters:
    ///   - whatsNew: The WhatsNew object
    ///   - versionStore: The optional WhatsNewVersionStore. Default value `nil`
    ///   - layout: The WhatsNew Layout. Default value `.default`
    public init(
        whatsNew: WhatsNew,
        versionStore: WhatsNewVersionStore? = nil,
        layout: WhatsNew.Layout = .default
    ) {
        self.whatsNew = whatsNew
        self.whatsNewVersionStore = versionStore
        self.layout = layout
    }
    /// Sets the `WhatsNew.selectedFeature` to the first in `WhatsNew.featureGroups`
}

// MARK: - View

extension WhatsNewView: View {
    
    /// The content and behavior of the view.
    public var body: some View {
        ZStack {
            // Content ScrollView
            ScrollView(
                .vertical,
                showsIndicators: self.layout.showsScrollViewIndicators
            ) {
                // Content Stack
                VStack(
                    spacing: self.layout.contentSpacing
                ) {
                    // Title
                    self.title
                        .transition(.slide)
                        .frame(maxWidth: .infinity)
                    // Feature List
                    VStack(
                        alignment: .leading,
                        spacing: self.layout.featureListSpacing
                    ) {
                        // Feature
                        ForEach(
                            self.whatsNew.selectedFeature?.features ?? [],
                            id: \.self,
                            content: self.feature
                        )
                    }
                    .modifier(FeaturesPadding())
                    .padding(self.layout.featureListPadding)
                }
                .padding(.horizontal)
                .padding(self.layout.contentPadding)
                // ScrollView bottom content inset
                Color.clear
                    .padding(
                        .bottom,
                        self.layout.scrollViewBottomContentInset
                    )
            }
#if os(iOS)
            .alwaysBounceVertical(false)
#endif
            // Footer
            if #available(iOS 15, macOS 12, *) {
                VStack {
                    VStack {
                        self.footer
                    }
                    .modifier(FooterPadding())
#if os(iOS)
                    .background(
                        UIVisualEffectView
                            .Representable()
                            .edgesIgnoringSafeArea(.horizontal)
                            .padding(self.layout.footerVisualEffectViewPadding)
                    )
#endif
                }
                .frame(maxWidth: .infinity)
                .padding(.top)
                .background {
#if os(macOS)
                    Color(nsColor: NSColor.windowBackgroundColor)
#else
                    Color(uiColor: UIColor.systemBackground)
#endif
                }
                .edgesIgnoringSafeArea(.bottom)
                .frame(maxHeight: .infinity, alignment: .bottom)
            } else {
                VStack {
                    Spacer()
                    VStack {
                        self.footer
                    }
                    .modifier(FooterPadding())
                }
                .edgesIgnoringSafeArea(.bottom)
            }
        }
        .sheet(
            item: self.$secondaryActionPresentedView,
            content: { $0.view }
        )
        .onDisappear {
            // Save presented WhatsNew Version, if available
            self.whatsNewVersionStore?.save(
                presentedVersion: self.whatsNew.version
            )
        }
        .onAppear {
            if let i = whatsNew.selectedFeature {
                groupIndex = 0
            }
        }
    }
}

// MARK: - Title

private extension WhatsNewView {
    
    /// The Title View
    var title: some View {
        Text(
            whatsNewText: self.whatsNew.title.text
        )
        .font(.largeTitle.bold())
        .multilineTextAlignment(.center)
        .fixedSize(horizontal: false, vertical: true)
    }
    
}

// MARK: - Feature

private extension WhatsNewView {
    
    /// The Feature View
    /// - Parameter feature: A WhatsNew Feature
    func feature(
        _ feature: WhatsNew.Feature
    ) -> some View {
        VStack {
            if let feature = feature.feature {
                /// If the `Feature` is using `Default` present the default view style
                HStack(
                    alignment: self.layout.featureHorizontalAlignment,
                    spacing: self.layout.featureHorizontalSpacing
                ) {
                    feature
                        .image
                        .view()
                        .frame(width: self.layout.featureImageWidth)
                    VStack(
                        alignment: .leading,
                        spacing: self.layout.featureVerticalSpacing
                    ) {
                        Text(
                            whatsNewText: feature.title
                        )
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                        Text(
                            whatsNewText: feature.subtitle
                        )
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    .multilineTextAlignment(.leading)
                }
            } else if let customViewBuilder = feature.customViewBuilder {
                /// Present a custom view
                if feature.useDefaultStyling, let groupIndex {
                    customViewBuilder()
                        .buttonStyle(PrimaryButtonStyle(
                            primaryAction: whatsNew.featureGroups[groupIndex].primaryAction,
                            layout: self.layout
                        ))
                        .multilineTextAlignment(.leading)
                } else {
                    customViewBuilder()
                }
            } else {
                /// If there is no feature or custom view
                VStack {
                    if #available(iOS 17.0, macOS 14.0, *) {
                        ContentUnavailableView("Error, there was no onboarding view", image: "exclamationmark.triangle.text.page.fill",
                                               description: Text("Contact the developer if this error persists"))
                    } else {
                        if #available(iOS 14.0, *) {
                            Label("Error, there was no onboarding view", systemImage: "exclamationmark.triangle.text.page.fill")
                        } else {
                            HStack {
                                Text("Error, there was no onboarding view")
                                Image(systemName: "exclamationmark.triangle.text.page.fill")
                            }
                        }
                        Text("Contact the developer if this error persists")
                    }
                }
                .onAppear {
                    print("There was nether a feature, nor a custom view, so this view could not be rendered")
                }
            }
        }
        .accessibilityElement(children: .combine)
        /*.transition(.asymmetric(
            insertion: .move(edge: .trailing), // Enters from the right
            removal: .move(edge: .leading)    // Exits towards the left
        ))*/
        .transition(.slideHorizontally)
        .frame(maxWidth: .infinity)
    }
    
}

/// Used for custom slide transition
extension AnyTransition {
    static var slideHorizontally: AnyTransition {
#if os(macOS)
        .asymmetric(
            insertion: .modifier(
                active: OffsetModifier(x: NSScreen.main?.frame.width ?? 0),
                identity: OffsetModifier(x: 0)
            ),
            removal: .modifier(
                active: OffsetModifier(x: -(NSScreen.main?.frame.width ?? 0)),
                identity: OffsetModifier(x: 0)
            )
        )
#else
        .asymmetric(
            insertion: .modifier(
                active: OffsetModifier(x: UIScreen.main.bounds.width),
                identity: OffsetModifier(x: 0)
            ),
            removal: .modifier(
                active: OffsetModifier(x: -UIScreen.main.bounds.width),
                identity: OffsetModifier(x: 0)
            )
        )
#endif
    }
}

struct OffsetModifier: ViewModifier {
    let x: CGFloat
    func body(content: Content) -> some View {
        content.offset(x: x)
    }
}

// MARK: - Footer

private extension WhatsNewView {
    
    /// The Footer View
    var footer: some View {
        VStack(
            spacing: self.layout.footerActionSpacing
        ) {
            // Check if a secondary action is available
            if let secondaryAction = self.whatsNew.selectedFeature?.secondaryAction {
                // Secondary Action Button
                Button(
                    action: {
                        // Invoke HapticFeedback, if available
                        secondaryAction.hapticFeedback?()
                        // Switch on Action
                        switch secondaryAction.action {
                        case .present(let view):
                            // Set secondary action presented view
                            self.secondaryActionPresentedView = .init(view: view)
                        case .custom(let action):
                            // Invoke action with PresentationMode
                            action(self.presentationMode)
                        }
                    }
                ) {
                    Text(
                        whatsNewText: secondaryAction.title
                    )
                }
#if os(macOS)
                .buttonStyle(
                    PlainButtonStyle()
                )
#endif
                .foregroundColor(secondaryAction.foregroundColor)
            }
            // Primary Action Button
            if let primaryAction = self.whatsNew.selectedFeature?.primaryAction {
                Button(
                    action: {
                        // Invoke HapticFeedback, if available
                        primaryAction.hapticFeedback
                        // Invoke on dismiss, if available
                        primaryAction.action?(moveToNext, dismiss)
                    }
                ) {
                    Text(
                        whatsNewText:primaryAction.title
                    )
                }
                .buttonStyle(
                    PrimaryButtonStyle(
                        primaryAction: primaryAction,
                        layout: self.layout
                    )
                )
#if os(macOS)
                .keyboardShortcut(.defaultAction)
#endif
            } else {
                Button(action: {}) {
                    Text("Loading")
                }
                .buttonStyle(
                    PrimaryButtonStyle(
                        primaryAction: PrimaryAction(),
                        layout: self.layout
                    )
                )
#if os(macOS)
                .keyboardShortcut(.defaultAction)
#endif
            }
        }
    }
    func moveToNext() {
        withAnimation {
            if var groupIndex = groupIndex {
                groupIndex += 1
                if groupIndex < whatsNew.featureGroups.count {
                    let newSelect = whatsNew.featureGroups[groupIndex]
                    whatsNew.selectedFeature = newSelect
                } else {
                    dismiss()
                }
            } else {
                groupIndex = 0
            }
        }
    }
    func dismiss() {
        withAnimation {
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}
