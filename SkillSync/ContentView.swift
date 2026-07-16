import SwiftUI
import CryptoKit

struct ContentView: View {
    @State private var showingSplash = true
    @State private var isAuthenticated = LocalAccountStore.isSignedIn

    var body: some View {
        ZStack {
            Group {
                if isAuthenticated {
                    HomeView {
                        LocalAccountStore.endSession()
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isAuthenticated = false
                        }
                    }
                        .transition(
                            .opacity.combined(with: .scale(scale: 0.97))
                        )
                } else {
                    AuthenticationView {
                        withAnimation(.easeInOut(duration: 0.55)) {
                            isAuthenticated = true
                        }
                    }
                    .transition(.opacity)
                }
            }

            if showingSplash {
                SplashView {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        showingSplash = false
                    }
                }
                .transition(
                    .opacity.combined(with: .scale(scale: 1.06))
                )
                .zIndex(1)
            }
        }
    }
}

enum AuthenticationMode: String, CaseIterable, Identifiable {
    case logIn = "Log In"
    case createAccount = "Create Account"

    var id: Self { self }
}

enum LocalAccountStore {
    private static let accountsKey = "skillsync.localAccounts"
    private static let sessionEmailKey = "skillsync.sessionEmail"

    static var isSignedIn: Bool {
        guard let email = UserDefaults.standard.string(forKey: sessionEmailKey) else {
            return false
        }

        return contains(email: email)
    }

    static func contains(email: String) -> Bool {
        accounts[email] != nil
    }

    static func create(email: String, password: String) -> Bool {
        var savedAccounts = accounts
        guard savedAccounts[email] == nil else { return false }

        savedAccounts[email] = passwordHash(email: email, password: password)
        UserDefaults.standard.set(savedAccounts, forKey: accountsKey)
        return true
    }

    static func authenticate(email: String, password: String) -> Bool {
        guard let savedHash = accounts[email] else { return false }
        return savedHash == passwordHash(email: email, password: password)
    }

    static func beginSession(email: String) {
        guard contains(email: email) else { return }
        UserDefaults.standard.set(email, forKey: sessionEmailKey)
    }

    static func endSession() {
        UserDefaults.standard.removeObject(forKey: sessionEmailKey)
    }

    private static var accounts: [String: String] {
        UserDefaults.standard.dictionary(forKey: accountsKey) as? [String: String]
            ?? [:]
    }

    private static func passwordHash(email: String, password: String) -> String {
        let value = Data("\(email)|\(password)".utf8)
        return SHA256.hash(data: value)
            .map { String(format: "%02x", $0) }
            .joined()
    }
}

struct AuthenticationView: View {
    let completion: () -> Void

    @State private var mode = AuthenticationMode.logIn
    @State private var email = ""
    @State private var password = ""
    @State private var confirmedPassword = ""
    @State private var validationMessage: String?
    @State private var isTransitioning = false
    @State private var transitionProgress: CGFloat = 0

    var body: some View {
        ZStack {
            AmbientBackgroundView(isAnimated: true)

            GlowingWaveOverlay(
                intensity: 0.3,
                verticalOffset: 160,
                isAnimated: true
            )

            ScrollView {
                VStack(spacing: 24) {
                    Spacer(minLength: 44)

                    Image("SkillSyncLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 104, height: 104)
                        .shadow(color: .cyan.opacity(0.38), radius: 22)

                    BubbleTitle(
                        text: mode == .logIn
                            ? "Welcome Back"
                            : "Join SkillSync"
                    )

                    Text(
                        mode == .logIn
                            ? "Continue your learning journey."
                            : "Create your account and start learning."
                    )
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.68))
                    .multilineTextAlignment(.center)

                    VStack(spacing: 18) {
                        HStack(spacing: 8) {
                            ForEach(AuthenticationMode.allCases) { option in
                                Button {
                                    mode = option
                                    validationMessage = nil
                                } label: {
                                    Text(option.rawValue)
                                        .font(
                                            .system(
                                                size: 14,
                                                weight: .bold,
                                                design: .rounded
                                            )
                                        )
                                        .foregroundStyle(
                                            mode == option
                                                ? Color.white
                                                : Color.white.opacity(0.56)
                                        )
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background {
                                            if mode == option {
                                                LinearGradient(
                                                    colors: [.cyan, .blue, .purple],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            } else {
                                                Color.clear
                                            }
                                        }
                                        .clipShape(RoundedRectangle(cornerRadius: 13))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(4)
                        .background(
                            Color.white.opacity(0.07),
                            in: RoundedRectangle(cornerRadius: 17)
                        )
                        .overlay {
                            RoundedRectangle(cornerRadius: 17)
                                .stroke(.white.opacity(0.1), lineWidth: 1)
                        }

                        authenticationField(
                            systemImage: "envelope.fill",
                            accent: .cyan
                        ) {
                            TextField("Email address", text: $email)
                                .textContentType(.emailAddress)
                        }

                        authenticationField(
                            systemImage: "lock.fill",
                            accent: .blue
                        ) {
                            SecureField("Password", text: $password)
                                .textContentType(
                                    mode == .logIn ? .password : .newPassword
                                )
                        }

                        if mode == .createAccount {
                            authenticationField(
                                systemImage: "checkmark.shield.fill",
                                accent: .purple
                            ) {
                                SecureField(
                                    "Confirm password",
                                    text: $confirmedPassword
                                )
                                .textContentType(.newPassword)
                            }
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }

                        if let validationMessage {
                            Text(validationMessage)
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundStyle(.red.opacity(0.9))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .transition(.opacity)
                        }

                        Button(action: submit) {
                            HStack(spacing: 10) {
                                Text(
                                    mode == .logIn
                                        ? "Log In"
                                        : "Create Account"
                                )

                                Image(systemName: "arrow.right")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(SkillSyncButtonStyle())
                    }
                    .padding(24)
                    .background(
                        .ultraThinMaterial,
                        in: RoundedRectangle(cornerRadius: 28)
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(.white.opacity(0.15), lineWidth: 1)
                    }
                    .shadow(color: .cyan.opacity(0.16), radius: 28, y: 14)

                    Text("Authentication is currently a local prototype.")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.4))

                    Spacer(minLength: 36)
                }
                .frame(maxWidth: 480)
                .padding(.horizontal, 22)
                .frame(maxWidth: .infinity)
            }
            .scaleEffect(isTransitioning ? 1.05 : 1)
            .offset(y: isTransitioning ? -24 : 0)
            .blur(radius: isTransitioning ? 9 : 0)
            .opacity(isTransitioning ? 0 : 1)
            .allowsHitTesting(!isTransitioning)

            LiquidScreenTransition(progress: transitionProgress)
                .allowsHitTesting(false)
        }
        .preferredColorScheme(.dark)
        .animation(.easeInOut(duration: 0.3), value: mode)
    }

    private func authenticationField<Content: View>(
        systemImage: String,
        accent: Color,
        @ViewBuilder content: () -> Content
    ) -> some View {
        HStack(spacing: 14) {
            Image(systemName: systemImage)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(accent)
                .frame(width: 22)
                .shadow(color: accent.opacity(0.45), radius: 8)

            content()
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .frame(maxWidth: .infinity)
        }
            .padding(.horizontal, 18)
            .frame(height: 58)
            .background(
                LinearGradient(
                    colors: [
                        accent.opacity(0.12),
                        Color.white.opacity(0.055)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                in: RoundedRectangle(cornerRadius: 16)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(accent.opacity(0.28), lineWidth: 1)
            }
    }

    private func submit() {
        let cleanedEmail = email
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        guard cleanedEmail.contains("@"), cleanedEmail.contains(".") else {
            validationMessage = "Enter a valid email address."
            return
        }

        guard password.count >= 6 else {
            validationMessage = "Password must contain at least 6 characters."
            return
        }

        if mode == .createAccount, password != confirmedPassword {
            validationMessage = "Passwords do not match."
            return
        }

        switch mode {
        case .createAccount:
            guard LocalAccountStore.create(
                email: cleanedEmail,
                password: password
            ) else {
                validationMessage = "An account with this email already exists."
                return
            }

        case .logIn:
            guard LocalAccountStore.contains(email: cleanedEmail) else {
                validationMessage = "No account exists for this email. Create one first."
                return
            }

            guard LocalAccountStore.authenticate(
                email: cleanedEmail,
                password: password
            ) else {
                validationMessage = "The password is incorrect."
                return
            }
        }

        LocalAccountStore.beginSession(email: cleanedEmail)
        validationMessage = nil
        beginHomeTransition()
    }

    private func beginHomeTransition() {
        guard !isTransitioning else { return }
        isTransitioning = true

        withAnimation(.easeInOut(duration: 0.85)) {
            transitionProgress = 1
        }

        Task {
            try? await Task.sleep(for: .milliseconds(620))
            completion()
        }
    }
}

struct LiquidScreenTransition: View, Animatable {
    var progress: CGFloat

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    var body: some View {
        Canvas { context, size in
            let clampedProgress = min(max(progress, 0), 1)
            let waveAmplitude = sin(.pi * clampedProgress) * 34
            var liquid = Path()
            var waveEdge = Path()

            for x in stride(from: 0.0, through: size.width, by: 3) {
                let baseY = size.height * (1 - clampedProgress)
                let ripple = sin(x * 0.022 + clampedProgress * 8) * waveAmplitude
                let secondaryRipple = cos(x * 0.009 - clampedProgress * 5)
                    * waveAmplitude * 0.32
                let y = min(max(baseY + ripple + secondaryRipple, 0), size.height)

                if x == 0 {
                    liquid.move(to: CGPoint(x: x, y: size.height))
                    liquid.addLine(to: CGPoint(x: x, y: y))
                    waveEdge.move(to: CGPoint(x: x, y: y))
                } else {
                    liquid.addLine(to: CGPoint(x: x, y: y))
                    waveEdge.addLine(to: CGPoint(x: x, y: y))
                }
            }

            liquid.addLine(to: CGPoint(x: size.width, y: size.height))
            liquid.closeSubpath()

            context.fill(
                liquid,
                with: .linearGradient(
                    Gradient(colors: [
                        .cyan.opacity(0.82),
                        .blue,
                        .purple,
                        Color.skillSyncBackground
                    ]),
                    startPoint: CGPoint(x: 0, y: 0),
                    endPoint: CGPoint(x: size.width, y: size.height)
                )
            )

            context.stroke(
                waveEdge,
                with: .color(.white.opacity(0.38)),
                lineWidth: 2
            )
        }
        .opacity(progress <= 0.001 ? 0 : 1)
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }
}

struct HomeView: View {
    let logout: () -> Void
    @State private var selectedTab = SkillSyncTab.home

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                ZStack {
                    AmbientBackgroundView(isAnimated: true)

                    GlowingWaveOverlay(
                        intensity: 0.38,
                        verticalOffset: 110,
                        isAnimated: true
                    )

                    ScrollView {
                        VStack(spacing: 22) {
                        BubbleTitle(text: "Welcome to\nSkillSync")

                        Text("Understand It, Don’t Just Answer It.")
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white.opacity(0.72))
                            .tracking(0.4)

                        Text("What knowledge would you like to gain today?")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white, .cyan.opacity(0.9)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )

                        VStack(spacing: 14) {
                            ExploreTopicsView()

                            ExpandableLearningTab(
                                title: "Continue Learning",
                                systemImage: "arrow.trianglehead.2.clockwise.rotate.90",
                                accent: .blue,
                                placeholder: "Your recent lessons will appear here."
                            )

                            ExpandableLearningTab(
                                title: "Learning Goals",
                                systemImage: "target",
                                accent: .purple,
                                placeholder: "Your learning goals will appear here."
                            )
                        }
                        .padding(.top, 4)

                        Button(action: logout) {
                            Label(
                                "Log Out",
                                systemImage: "rectangle.portrait.and.arrow.right"
                            )
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .frame(minWidth: 150)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red.opacity(0.72))
                        .padding(.bottom, 24)
                    }
                        .frame(maxWidth: 560)
                        .padding(.horizontal, 20)
                        .padding(.top, 28)
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(SkillSyncTab.home)

            LearningProgressView()
                .tabItem {
                    Label("Progress", systemImage: "chart.bar.fill")
                }
                .tag(SkillSyncTab.progress)
        }
        .tint(.cyan)
        .preferredColorScheme(.dark)
    }
}

enum SkillSyncTab {
    case home
    case progress
}

struct LearningProgressView: View {
    @State private var selectedTopic = ProgressTopic.science

    private var units: [LearningUnit] {
        if selectedTopic == .science {
            return [
                LearningUnit(title: "Periodic Table of Elements", topic: "Science", isCompleted: false),
                LearningUnit(title: "Placeholder 1", topic: "Science", isCompleted: false),
                LearningUnit(title: "Placeholder 2", topic: "Science", isCompleted: false),
                LearningUnit(title: "Placeholder 3", topic: "Science", isCompleted: false),
                LearningUnit(title: "Placeholder 4", topic: "Science", isCompleted: false),
                LearningUnit(title: "Placeholder 5", topic: "Science", isCompleted: false),
                LearningUnit(title: "Placeholder 6", topic: "Science", isCompleted: false)
            ]
        }

        return (1...7).map { number in
            LearningUnit(
                title: "Placeholder Unit \(number)",
                topic: selectedTopic.title,
                isCompleted: false
            )
        }
    }

    private var completedCount: Int {
        units.filter(\.isCompleted).count
    }

    private var progress: Double {
        guard !units.isEmpty else { return 0 }
        return Double(completedCount) / Double(units.count)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AmbientBackgroundView(isAnimated: true)

                ScrollView {
                    VStack(spacing: 22) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(ProgressTopic.allCases) { topic in
                                    Button {
                                        withAnimation(.easeInOut(duration: 0.25)) {
                                            selectedTopic = topic
                                        }
                                    } label: {
                                        HStack(spacing: 7) {
                                            Image(systemName: topic == .science ? "atom" : "square.dashed")

                                            Text(topic.title)
                                        }
                                        .font(.system(size: 13, weight: .bold, design: .rounded))
                                        .foregroundStyle(selectedTopic == topic ? .white : .white.opacity(0.5))
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 10)
                                        .background {
                                            if selectedTopic == topic {
                                                LinearGradient(
                                                    colors: [.cyan, .blue, .purple],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            } else {
                                                Color.white.opacity(0.07)
                                            }
                                        }
                                        .clipShape(Capsule())
                                        .overlay {
                                            Capsule()
                                                .stroke(.white.opacity(0.1), lineWidth: 1)
                                        }
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 2)
                        }

                        BubbleTitle(text: "Your Progress")

                        Text(selectedTopic.title)
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.cyan, .blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )

                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .stroke(.white.opacity(0.1), lineWidth: 16)

                                Circle()
                                    .trim(from: 0, to: progress)
                                    .stroke(
                                        LinearGradient(
                                            colors: [.cyan, .blue, .purple],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        style: StrokeStyle(lineWidth: 16, lineCap: .round)
                                    )
                                    .rotationEffect(.degrees(-90))

                                VStack(spacing: 3) {
                                    Text("\(Int(progress * 100))%")
                                        .font(.system(size: 34, weight: .black, design: .rounded))
                                        .foregroundStyle(.white)

                                    Text("completed")
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.white.opacity(0.6))
                                }
                            }
                            .frame(width: 170, height: 170)

                            Text("\(completedCount) of \(units.count) units completed")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundStyle(.white.opacity(0.8))
                        }
                        .padding(24)
                        .frame(maxWidth: .infinity)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 26))
                        .overlay {
                            RoundedRectangle(cornerRadius: 26)
                                .stroke(.cyan.opacity(0.2), lineWidth: 1)
                        }

                        VStack(alignment: .leading, spacing: 14) {
                            Text("Learning Topics")
                                .font(.title2.bold())
                                .foregroundStyle(.white)

                            ForEach(units) { unit in
                                if selectedTopic == .science &&
                                    unit.title == "Periodic Table of Elements" {
                                    NavigationLink {
                                        PeriodicTableLessonView()
                                    } label: {
                                        LearningUnitRow(unit: unit, showsChevron: true)
                                    }
                                    .buttonStyle(.plain)
                                } else {
                                    LearningUnitRow(unit: unit, showsChevron: false)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: 560)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 28)
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

struct LearningUnitRow: View {
    let unit: LearningUnit
    let showsChevron: Bool

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: unit.isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 25, weight: .semibold))
                .foregroundStyle(unit.isCompleted ? .cyan : .white.opacity(0.3))

            VStack(alignment: .leading, spacing: 4) {
                Text(unit.title)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                Text(unit.topic)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.white.opacity(0.55))
            }

            Spacer()

            if showsChevron {
                Image(systemName: "chevron.right")
                    .font(.caption.bold())
                    .foregroundStyle(.cyan)
            } else {
                Text(unit.isCompleted ? "Completed" : "Not started")
                    .font(.caption2.bold())
                    .foregroundStyle(unit.isCompleted ? .cyan : .white.opacity(0.4))
            }
        }
        .padding(15)
        .background(
            Color.white.opacity(0.06),
            in: RoundedRectangle(cornerRadius: 17)
        )
    }
}

struct LearningUnit: Identifiable {
    let id = UUID()
    let title: String
    let topic: String
    let isCompleted: Bool
}

enum ProgressTopic: String, CaseIterable, Identifiable {
    case science
    case placeholder1
    case placeholder2
    case placeholder3
    case placeholder4
    case placeholder5
    case placeholder6

    var id: Self { self }

    var title: String {
        switch self {
        case .science:
            return "Science"
        case .placeholder1:
            return "Placeholder 1"
        case .placeholder2:
            return "Placeholder 2"
        case .placeholder3:
            return "Placeholder 3"
        case .placeholder4:
            return "Placeholder 4"
        case .placeholder5:
            return "Placeholder 5"
        case .placeholder6:
            return "Placeholder 6"
        }
    }
}

struct ExpandableLearningTab: View {
    let title: String
    let systemImage: String
    let accent: Color
    let placeholder: String

    @State private var isExpanded = false

    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            Text(placeholder)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.62))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 14)
                .padding(.leading, 38)
        } label: {
            HStack(spacing: 14) {
                Image(systemName: systemImage)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(accent)
                    .frame(width: 24)
                    .shadow(color: accent.opacity(0.45), radius: 8)

                Text(title)
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                Spacer()

                CartoonLightbulb(isLit: isExpanded)
            }
        }
        .tint(accent)
        .padding(18)
        .background(
            LinearGradient(
                colors: [accent.opacity(0.13), .white.opacity(0.055)],
                startPoint: .leading,
                endPoint: .trailing
            ),
            in: RoundedRectangle(cornerRadius: 20)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(accent.opacity(isExpanded ? 0.4 : 0.2), lineWidth: 1)
        }
        .shadow(color: accent.opacity(isExpanded ? 0.18 : 0.08), radius: 18, y: 8)
        .animation(.spring(response: 0.45, dampingFraction: 0.82), value: isExpanded)
    }
}

struct CartoonLightbulb: View {
    let isLit: Bool

    var body: some View {
        ZStack {
            ForEach(0..<8, id: \.self) { ray in
                Capsule()
                    .fill(.yellow)
                    .frame(width: 3, height: isLit ? 8 : 2)
                    .offset(y: -23)
                    .rotationEffect(.degrees(Double(ray) * 45))
                    .opacity(isLit ? 0.9 : 0)
            }

            Circle()
                .fill(.yellow.opacity(isLit ? 0.28 : 0))
                .frame(width: 34, height: 34)
                .blur(radius: 6)

            Image(systemName: isLit ? "lightbulb.fill" : "lightbulb")
                .font(.system(size: 19, weight: .black))
                .foregroundStyle(isLit ? .yellow : .white.opacity(0.5))
                .shadow(color: .yellow.opacity(isLit ? 0.9 : 0), radius: 10)
                .scaleEffect(isLit ? 1.22 : 0.9)
                .rotationEffect(.degrees(isLit ? 8 : 0))
        }
        .frame(width: 42, height: 42)
        .animation(
            .spring(response: 0.42, dampingFraction: 0.48),
            value: isLit
        )
        .accessibilityHidden(true)
    }
}

struct BubbleTitle: View {
    let text: String

    private let outlineOffsets: [CGSize] = [
        CGSize(width: -4, height: 0),
        CGSize(width: 4, height: 0),
        CGSize(width: 0, height: -4),
        CGSize(width: 0, height: 4),
        CGSize(width: -3, height: -3),
        CGSize(width: 3, height: -3),
        CGSize(width: -3, height: 3),
        CGSize(width: 3, height: 3)
    ]

    var body: some View {
        ZStack {
            ForEach(Array(outlineOffsets.enumerated()), id: \.offset) { _, offset in
                titleText
                    .multilineTextAlignment(.center)
                    .lineSpacing(-8)
                    .foregroundStyle(Color.skillSyncBackground)
                    .offset(offset)
            }

            titleText
                .multilineTextAlignment(.center)
                .lineSpacing(-8)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, .cyan, .blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
        .shadow(color: .cyan.opacity(0.3), radius: 20, y: 7)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(text.replacingOccurrences(of: "\n", with: " "))
    }

    private var titleText: Text {
        Text(text)
            .font(.custom("Arial Rounded MT Bold", fixedSize: 48))
            .tracking(-1.8)
    }
}

struct TutorPlaceholderView: View {
    var body: some View {
        ZStack {
            AmbientBackgroundView(isAnimated: true)

            GlowingWaveOverlay(
                intensity: 0.46,
                verticalOffset: -120,
                isAnimated: true
            )

            VStack(spacing: 18) {
                Image(systemName: "person.2.wave.2.fill")
                    .font(.system(size: 54, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.cyan, .blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .cyan.opacity(0.4), radius: 18)

                Text("Tutor list goes here")
                    .font(.title2.bold())
                    .foregroundStyle(.white)

                Text("Placeholder content")
                    .foregroundStyle(.white.opacity(0.58))

            }
            .padding(32)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 28))
            .overlay {
                RoundedRectangle(cornerRadius: 28)
                    .stroke(.white.opacity(0.14), lineWidth: 1)
            }
            .shadow(color: .purple.opacity(0.2), radius: 30, y: 14)
            .padding()
        }
        .navigationTitle("Find a Tutor")
    }
}

extension Color {
    static let skillSyncBackground = Color(
        red: 0.005,
        green: 0.01,
        blue: 0.04
    )
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
