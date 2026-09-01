import SwiftUI

// MARK: - WhatsNewView

/// A WhatsNewView
public struct WhatsNewView: View {
    
    // MARK: Properties
    
    @Environment(\.dismiss) private var dismissSheet
    
    @State private var top: UUID?
    
    /// The current `FeatureGroup`
    @State public var groupIndex: Int? = nil
    
    /// The WhatsNew object
    @Bindable var whatsNew: WhatsNew
    
    /// The WhatsNew Layout
    let layout: WhatsNew.Layout
    
    /// The View that is presented by the SecondaryAction
    @State private var secondaryActionPresentedView: WhatsNew.SecondaryAction.Action.PresentedView?
    
    /// The PresentationMode
    @Environment(\.presentationMode) private var presentationMode
    
    public var body: some View {
        NavigationStack {
            // Content ScrollView
            if #available(iOS 18.0, macOS 15, *) {
                ScrollView(
                    .vertical,
                    showsIndicators: self.layout.showsScrollViewIndicators
                ) {
                    //                // Content Stack
                    LazyVStack(
                        spacing: self.layout.contentSpacing
                    ) {
                        // Title
#if os(iOS) && !targetEnvironment(macCatalyst)
#else
                        self.title
                            .frame(maxWidth: .infinity)
#endif
                        // Feature List
                        LazyVStack(
                            alignment: .leading,
                            spacing: self.layout.featureListSpacing
                        ) {
                            // Feature
                            ForEach(self.whatsNew.selectedFeature?.features ?? Array<WhatsNew.WhatsNewFeature>(), id: \.id) { feature in
                                VStack {
                                    switch feature {
                                    case .default(var feature):
                                        let bind = Binding<WhatsNewFeature>(get: {
                                            feature
                                        }, set: {
                                            feature = $0
                                        })
                                        FeatureView(feature: bind)
                                    case .custom(let custom):
                                        if custom.useDefaultStyling {
                                            custom.viewBuilder()
                                                .multilineTextAlignment(.leading)
                                                .environment(\.whatsNewLayout, self.layout)
                                        } else {
                                            custom.viewBuilder()
                                        }
                                    }
                                }
                                .accessibilityElement(children: .combine)
                                .frame(maxWidth: .infinity)
                                .id(feature.id)
                            }
                            
                        }
                        .scrollTargetLayout()
                        .modifier(FeaturesPadding())
                        .padding(self.layout.featureListPadding)
                    }
                    .padding(.top, 40)
                    .padding(.horizontal)
                    //.padding(self.layout.contentPadding)
#if targetEnvironment(macCatalyst)
                    // Stupid that this is needed for scroll view to work
                    .background {
                        Color(.systemBackground)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
#endif
#if os(iOS) && !targetEnvironment(macCatalyst)
                    .toolbar {
                        var isScrolled: Bool {
                            if let groupIndex, top == whatsNew.featureGroups[groupIndex].features.first?.id {
                                return false
                            }
                            return true
                        }
                        ToolbarItem(placement: .title, content: {
                            self.title
                                .padding(.top, isScrolled ? 20 : 40)
                                .transition(.scale)
                                .scaleEffect(isScrolled ? CGSize(width: 0.5, height: 0.5) : CGSize(width: 1, height: 1))
                                .animation(.bouncy, value: isScrolled)
                            //.frame(maxWidth: .infinity)
                        })
                    }
                    .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
                    .toolbarTitleDisplayMode(.inlineLarge)
#endif
                    // ScrollView bottom content inset
                    Color.clear
                        .padding(
                            .bottom,
                            self.layout.scrollViewBottomContentInset
                        )
                }
                //.padding(.top)
                //.ignoresSafeArea(edges: .top)
                .onScrollTargetVisibilityChange(idType: UUID.self, { visible in
                    let newTop = visible.first
                    guard newTop != top else { return }
                    withAnimation {
                        top = newTop
                    }
                })
#if targetEnvironment(macCatalyst)
                .background {
                    Color(.systemBackground)
                }
#endif
                .overlay(alignment: .bottom) {
                    // Footer
                    if #available(iOS 26, macOS 26, *) {
                        self.footer
                            .buttonStyle(.glassProminent)
                            .padding(.bottom)
                            .padding(.horizontal)
                    } else {
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
                .onChange(of: whatsNew) {
                    switch whatsNew.featureGroups.first?.features.first {
                    case .default(let d):
                        print(d.title)
                    default:
                        break
                    }
                }
            //MARK: -- Older
            } else {
                ScrollView(
                    .vertical,
                    showsIndicators: self.layout.showsScrollViewIndicators
                ) {
                    //                // Content Stack
                    VStack(
                        spacing: self.layout.contentSpacing
                    ) {
                        // Title
                        self.title
                            .frame(maxWidth: .infinity)
                        // Feature List
                        VStack(
                            alignment: .leading,
                            spacing: self.layout.featureListSpacing
                        ) {
                            // Feature
                            ForEach(self.whatsNew.selectedFeature?.features ?? [], id: \.self) { feature in
                                VStack {
                                    switch feature {
                                    case .default(var feature):
                                        let bind = Binding<WhatsNewFeature>(get: {
                                            feature
                                        }, set: {
                                            feature = $0
                                        })
                                        FeatureView(feature: bind)
                                    case .custom(let custom):
                                        if custom.useDefaultStyling {
                                            custom.viewBuilder()
                                                .multilineTextAlignment(.leading)
                                                .environment(\.whatsNewLayout, self.layout)
                                        } else {
                                            custom.viewBuilder()
                                        }
                                    }
                                }
                                .accessibilityElement(children: .combine)
                                .frame(maxWidth: .infinity)
                            }
                            
                        }
                        .modifier(FeaturesPadding())
                        .padding(self.layout.featureListPadding)
                    }
                    .padding(.top, 40)
                    .padding(.horizontal)
                    //.padding(self.layout.contentPadding)
#if targetEnvironment(macCatalyst)
                    .background {
                        Color(.systemBackground)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
#endif
                    // ScrollView bottom content inset
                    Color.clear
                        .padding(
                            .bottom,
                            self.layout.scrollViewBottomContentInset
                        )
                }
#if targetEnvironment(macCatalyst)
                .background {
                    Color(.systemBackground)
                }
#endif
                .overlay(alignment: .bottom) {
                    // Footer
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
        .transition(.slide)
        .sheet(
            item: self.$secondaryActionPresentedView,
            content: { $0.view }
        )
        .onAppear {
            if whatsNew.selectedFeature != nil {
                groupIndex = whatsNew.featureGroups.firstIndex(where: { $0 == whatsNew.selectedFeature }) ?? 0
            }
        }
    }
}

// MARK: - Title

private extension WhatsNewView {
    
    /// The Title View
    var title: some View {
        Text(self.whatsNew.title)
        .font(.largeTitle.bold())
        .multilineTextAlignment(.center)
        .fixedSize(horizontal: false, vertical: true)
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
                    Text(secondaryAction.title)
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
                        Text(primaryAction.title)
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
            dismissSheet()
        }
    }
}

@available(iOS 17, macOS 14, *)
#Preview {
    PreviewViewYay()
}

@available(iOS 17, macOS 14, *)
struct PreviewViewYay: View {
    @State var yays = 1
    @State var show = true
    @State var whatsNew: WhatsNew?
    @State var first: Default?
    var body: some View {
        Text("YAY")
            .onAppear {
                first = Default(systemName: "richtext.page.ja", title: String(repeating: "Yay", count: yays), subtitle: "TAK \(yays.description)", foregroundStyle: .red)
                whatsNew = WhatsNew(title: "PPPP", featureGroups: [
                    .init(feature: [
                        .default(first ?? Default(systemName: "", title: "Filler", subtitle: "_-_-_")),
                        .default(Default(systemName: "richtext.page.ja", title: "This is a long title that is for testing purposes only", subtitle: "TAKTAKTAKTAKTAKTAKTAKTAKTAKTAK", foregroundStyle: .red)),
                        .default(Default(systemName: "pencil", title: "🍡🍡🍡", subtitle: "", foregroundStyle: .orange)),
                        .default(Default(systemName: "pencil", title: "Yay", subtitle: "", foregroundStyle: .yellow)),
                        .default(Default(systemName: "pencil", title: "Yay", subtitle: "t", foregroundStyle: .green)),
                        .default(Default(systemName: "pencil", title: "P", subtitle: "a", foregroundStyle: .cyan)),
                        .default(Default(systemName: "pencil", title: "P", subtitle: "k", foregroundStyle: .blue)),
                        .default(Default(systemName: "formfitting.gamecontroller.fill", title: "P", subtitle: "", foregroundStyle: .purple)),
                        .default(Default(systemName: "pencil", title: "P", subtitle: "", foregroundStyle: .pink)),
                        .default(Default(systemName: "pencil", title: "Hay", subtitle: "", foregroundStyle: .red)),
                        .default(Default(systemName: "a.book.closed.ja", title: "Miku", subtitle: "", foregroundStyle: .pink)),
                        .default(Default(systemName: "star", title: "Miku", subtitle: "", foregroundStyle: .pink)),
                        .default(Default(systemName: "pencil", title: "Beam", subtitle: "☆", foregroundStyle: .pink)),
                        .custom(Custom {
                            MikuMikuBeam(yays: $yays)
                        }),
                    ]),
                ])
            }
            .onChange(of: yays) {
                first?.title = String(repeating: "Yay", count: yays)
            }
            .sheet(whatsNew: whatsNew)
    #if os(macOS)
            .frame(minWidth: 500, minHeight:  500)
    #endif
    }
}

struct MikuMikuBeam: View {
    @Binding var yays: Int
    var body: some View {
        VStack(alignment: .leading) {
            Text("And now its time for the moment you've been waiting for...1...2...3...Ready? Miku Miku Beam!")
            Button(action: {
                print("Executing", yays)
                yays += 1
//                if let wn = whatsNew {
//                    print("Changing")
//                    switch wn.featureGroups[0].features[0] {
//                    case .default(let feature):
//                        print("Feature")
//                        feature.title = String(repeating: "Yay", count: yays)
//                    case .custom(_):
//                        break
//                    }
//                    whatsNew = wn
//                }

            }) {
                Text("Keep going!")
                    .font(.caption)
            }
            .buttonStyle(.plain)
            Text("yays: \(yays.description)")
                .font(.caption)
        }
        .foregroundStyle(.black)
    }
}
