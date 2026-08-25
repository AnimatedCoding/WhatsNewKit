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
    private var secondaryActionPresentedView: WhatsNew.SecondaryAction.Action.PresentedView?
    
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
            .overlay(alignment: .bottom) {
                // Footer
                if #available(iOS 26, macOS 26, *) {
                    self.footer
                        .buttonStyle(.glassProminent)
                        .padding(.bottom)
                        .padding(.horizontal)
                } else if #available(iOS 15, macOS 12, *) {
                    VStack {
                        VStack {
                            self.footer
                        }
                         .buttonStyle(.borderedProminent)
                         .padding(.bottom, 0)
                     }
                     .padding(.horizontal)
                     .padding(.top, 40)
                     .background {
#if os(macOS)
                         let color = Color(.windowBackgroundColor)
#else
                         let color = Color(.systemBackground)
#endif
                         VStack(spacing: 0) {
                             color
                                 .mask(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.clear, .black]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                 )
                                 .frame(height: 40) // same as top padding
                             color
                         }
                         .edgesIgnoringSafeArea(.bottom)
                     }
                 }
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
            if whatsNew.selectedFeature != nil {
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
                    if self.layout.featureSidewaysAlignment == .trailing {
                        Spacer()
                    }
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
                    if self.layout.featureSidewaysAlignment == .leading {
                        Spacer()
                    }
                }
            } else if let customViewBuilder = feature.customViewBuilder {
                /// Present a custom view
                if feature.useDefaultStyling {
                    customViewBuilder()
                        .multilineTextAlignment(.leading)
                        .environment(\.whatsNewLayout, self.layout)
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
                        // Invoke on dismiss, if available
                        primaryAction.action?(moveToNext, dismiss)
                    }
                ) {
                    HStack {
                        Spacer()
                        Text(
                            whatsNewText:primaryAction.title
                        )
                        .font(.headline.weight(.semibold))
                        Spacer()
                    }
                    .padding()
                }
#if os(macOS)
                .keyboardShortcut(.defaultAction)
#endif
            } else {
                Button(action: {}) {
                    Text("Loading")
                }
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

@available(iOS 17, macOS 14, *)
#Preview {
    @Previewable @State var whatsNew: WhatsNew? = WhatsNew(title: "PPPP", featureGroups: [
        .init(feature: [
            .init(systemName: "richtext.page.ja", title: "Yay", subtitle: "TAK", foregroundStyle: .red),
            .init(systemName: "pencil", title: "🍡🍡🍡", subtitle: "", foregroundStyle: .orange),
            .init(systemName: "pencil", title: "Yay", subtitle: "", foregroundStyle: .yellow),
            .init(systemName: "pencil", title: "Yay", subtitle: "t", foregroundStyle: .green),
            .init(systemName: "pencil", title: "P", subtitle: "a", foregroundStyle: .cyan),
            .init(systemName: "pencil", title: "P", subtitle: "k", foregroundStyle: .blue),
            .init(systemName: "formfitting.gamecontroller.fill", title: "P", subtitle: "", foregroundStyle: .purple),
            .init(systemName: "pencil", title: "P", subtitle: "", foregroundStyle: .pink),
            .init(systemName: "pencil", title: "Hay", subtitle: "", foregroundStyle: .red),
            .init(systemName: "a.book.closed.ja", title: "Miku", subtitle: "", foregroundStyle: .pink),
            .init(systemName: "star", title: "Miku", subtitle: "", foregroundStyle: .pink),
            .init(systemName: "pencil", title: "Beam", subtitle: "☆", foregroundStyle: .pink),
        ]),
    ])
    Text("YAY")
        .sheet(whatsNew: $whatsNew)
    #if os(macOS)
        .frame(minWidth: 500, minHeight:  500)
    #endif
}
