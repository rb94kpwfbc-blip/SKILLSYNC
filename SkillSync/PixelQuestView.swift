import SwiftUI

struct PixelQuestView: View {
    let isActive: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var transitionProgress: CGFloat = 0
    @State private var transitionID = 0
    @State private var isQuestVisible = false

    var body: some View {
        ZStack {
            Color(red: 0.018, green: 0.019, blue: 0.024)
                .ignoresSafeArea()

            if isQuestVisible {
                NavigationStack {
                    PixelQuestStartView()
                }
                .transition(.identity)
            }
        }
        .overlay {
            if transitionProgress < 1.999 {
                PixelQuestTransition(progress: transitionProgress)
                    .allowsHitTesting(true)
            }
        }
        .onAppear {
            if isActive {
                playEntrance()
            } else {
                prepareEntrance()
            }
        }
        .onChange(of: isActive) { _, active in
            if active {
                playEntrance()
            } else {
                prepareEntrance()
            }
        }
    }

    private func prepareEntrance() {
        transitionID += 1
        transitionProgress = 0
        isQuestVisible = false
    }

    private func playEntrance() {
        transitionID += 1
        let currentTransition = transitionID
        transitionProgress = 0
        isQuestVisible = false

        guard !reduceMotion else {
            isQuestVisible = true
            transitionProgress = 2
            return
        }

        withAnimation(.smooth(duration: 0.82)) {
            transitionProgress = 1
        }

        Task {
            try? await Task.sleep(for: .milliseconds(840))

            guard currentTransition == transitionID else { return }
            // Swap screens only while every pixel is covered.
            isQuestVisible = true

            try? await Task.sleep(for: .milliseconds(80))

            guard currentTransition == transitionID else { return }
            withAnimation(.smooth(duration: 0.94)) {
                transitionProgress = 2
            }
        }
    }
}

struct PixelQuestStartView: View {
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        ZStack {
            PixelQuestBackground()

            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 22) {
                        VStack(spacing: 8) {
                            Text("SKILLSYNC PLAY")
                                .font(.system(size: 11, weight: .black, design: .monospaced))
                                .tracking(3)
                                .foregroundStyle(.cyan)

                            Text("PIXEL QUEST")
                                .font(.system(size: 42, weight: .black, design: .monospaced))
                                .multilineTextAlignment(.center)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.white, .cyan, .blue, .purple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .shadow(color: .cyan.opacity(0.5), radius: 10)

                            Text("CHOOSE A LEARNING GAME")
                                .font(.system(size: 13, weight: .bold, design: .monospaced))
                                .tracking(2)
                                .foregroundStyle(.white.opacity(0.66))
                        }

                        LazyVGrid(columns: columns, spacing: 12) {
                            NavigationLink {
                                PixelQuestGameView()
                            } label: {
                                PixelQuestGameTab(
                                    title: "Learning Elements",
                                    subtitle: "A short gameplay",
                                    icon: "atom",
                                    accent: .cyan,
                                    isAvailable: true
                                )
                            }
                            .buttonStyle(.plain)

                            ForEach(2...6, id: \.self) { number in
                                PixelQuestGameTab(
                                    title: "Game Placeholder \(number)",
                                    subtitle: "Coming soon",
                                    icon: "lock.fill",
                                    accent: number.isMultiple(of: 2) ? .purple : .blue,
                                    isAvailable: false
                                )
                            }
                        }

                        Text("More interactive learning games will appear here as Pixel Quest grows.")
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundStyle(.white.opacity(0.45))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 8)
                    }
                    .frame(
                        width: min(
                            max(geometry.size.width - 40, 0),
                            560
                        )
                    )
                    .padding(.top, 28)
                    .padding(.bottom, 30)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

private struct PixelQuestGameTab: View {
    let title: String
    let subtitle: String
    let icon: String
    let accent: Color
    let isAvailable: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .black))
                    .foregroundStyle(isAvailable ? accent : .white.opacity(0.35))
                Spacer()
                Text(isAvailable ? "PLAY" : "SOON")
                    .font(.system(size: 8, weight: .black, design: .monospaced))
                    .foregroundStyle(isAvailable ? accent : .white.opacity(0.34))
            }

            Spacer(minLength: 4)

            Text(title.uppercased())
                .font(.system(size: 13, weight: .black, design: .monospaced))
                .foregroundStyle(isAvailable ? .white : .white.opacity(0.52))
                .multilineTextAlignment(.leading)

            Text(subtitle)
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.48))
        }
        .frame(maxWidth: .infinity, minHeight: 132, alignment: .leading)
        .padding(16)
        .background(
            LinearGradient(
                colors: [accent.opacity(isAvailable ? 0.20 : 0.07), Color.black.opacity(0.38)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 18)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .stroke(accent.opacity(isAvailable ? 0.55 : 0.16), lineWidth: 1.5)
        }
        .shadow(color: isAvailable ? accent.opacity(0.15) : .clear, radius: 12, y: 6)
        .contentShape(RoundedRectangle(cornerRadius: 18))
    }
}

private enum PixelQuestCrystalFieldStyle {
    case screen
    case card
}

private struct PixelQuestCrystalPlacement: Identifiable {
    let id: Int
    let imageName: String
    let color: Color
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat
    let phase: Double
}

private struct PixelQuestCrystalField: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let style: PixelQuestCrystalFieldStyle

    private var baseOpacity: Double {
        switch style {
        case .screen: 0.52
        case .card: 0.92
        }
    }

    private var placements: [PixelQuestCrystalPlacement] {
        switch style {
        case .screen:
            return [
                .init(id: 0, imageName: "PixelQuestCrystalCyan", color: .cyan, x: 0.07, y: 0.14, size: 25, phase: 0.2),
                .init(id: 1, imageName: "PixelQuestCrystalAmber", color: .orange, x: 0.91, y: 0.19, size: 22, phase: 1.4),
                .init(id: 2, imageName: "PixelQuestCrystalMagenta", color: .pink, x: 0.08, y: 0.47, size: 20, phase: 2.8),
                .init(id: 3, imageName: "PixelQuestCrystalEmerald", color: .green, x: 0.92, y: 0.55, size: 24, phase: 4.1),
                .init(id: 4, imageName: "PixelQuestCrystalScarlet", color: .red, x: 0.1, y: 0.83, size: 18, phase: 5.3),
                .init(id: 5, imageName: "PixelQuestCrystalCyan", color: .cyan, x: 0.9, y: 0.86, size: 19, phase: 6.5),
                .init(id: 6, imageName: "PixelQuestCrystalAmber", color: .orange, x: 0.17, y: 0.3, size: 16, phase: 7.2),
                .init(id: 7, imageName: "PixelQuestCrystalMagenta", color: .pink, x: 0.82, y: 0.35, size: 17, phase: 8.1),
                .init(id: 8, imageName: "PixelQuestCrystalEmerald", color: .green, x: 0.16, y: 0.65, size: 15, phase: 9.0),
                .init(id: 9, imageName: "PixelQuestCrystalScarlet", color: .red, x: 0.84, y: 0.72, size: 16, phase: 10.2),
                .init(id: 20, imageName: "PixelQuestCrystalEmerald", color: .green, x: 0.04, y: 0.27, size: 13, phase: 11.1),
                .init(id: 21, imageName: "PixelQuestCrystalMagenta", color: .pink, x: 0.96, y: 0.31, size: 14, phase: 12.0),
                .init(id: 22, imageName: "PixelQuestCrystalAmber", color: .orange, x: 0.05, y: 0.59, size: 12, phase: 12.9),
                .init(id: 23, imageName: "PixelQuestCrystalCyan", color: .cyan, x: 0.95, y: 0.67, size: 14, phase: 13.8),
                .init(id: 24, imageName: "PixelQuestCrystalScarlet", color: .red, x: 0.22, y: 0.09, size: 12, phase: 14.7),
                .init(id: 25, imageName: "PixelQuestCrystalEmerald", color: .green, x: 0.77, y: 0.1, size: 13, phase: 15.6),
                .init(id: 26, imageName: "PixelQuestCrystalMagenta", color: .pink, x: 0.23, y: 0.91, size: 14, phase: 16.5),
                .init(id: 27, imageName: "PixelQuestCrystalAmber", color: .orange, x: 0.76, y: 0.92, size: 12, phase: 17.4),
                .init(id: 28, imageName: "PixelQuestCrystalCyan", color: .cyan, x: 0.13, y: 0.75, size: 11, phase: 18.3),
                .init(id: 29, imageName: "PixelQuestCrystalScarlet", color: .red, x: 0.88, y: 0.44, size: 12, phase: 19.2)
            ]
        case .card:
            return [
                .init(id: 10, imageName: "PixelQuestCrystalCyan", color: .cyan, x: 0.13, y: 0.22, size: 43, phase: 0.5),
                .init(id: 11, imageName: "PixelQuestCrystalAmber", color: .orange, x: 0.84, y: 0.2, size: 38, phase: 1.7),
                .init(id: 12, imageName: "PixelQuestCrystalMagenta", color: .pink, x: 0.24, y: 0.7, size: 34, phase: 3.0),
                .init(id: 13, imageName: "PixelQuestCrystalEmerald", color: .green, x: 0.76, y: 0.67, size: 36, phase: 4.2),
                .init(id: 14, imageName: "PixelQuestCrystalScarlet", color: .red, x: 0.49, y: 0.17, size: 27, phase: 5.6),
                .init(id: 15, imageName: "PixelQuestCrystalEmerald", color: .green, x: 0.08, y: 0.53, size: 25, phase: 6.7),
                .init(id: 16, imageName: "PixelQuestCrystalScarlet", color: .red, x: 0.92, y: 0.48, size: 23, phase: 7.8),
                .init(id: 17, imageName: "PixelQuestCrystalAmber", color: .orange, x: 0.39, y: 0.77, size: 24, phase: 8.9),
                .init(id: 18, imageName: "PixelQuestCrystalCyan", color: .cyan, x: 0.61, y: 0.75, size: 22, phase: 9.8),
                .init(id: 19, imageName: "PixelQuestCrystalMagenta", color: .pink, x: 0.68, y: 0.28, size: 20, phase: 10.9),
                .init(id: 30, imageName: "PixelQuestCrystalAmber", color: .orange, x: 0.05, y: 0.28, size: 20, phase: 11.8),
                .init(id: 31, imageName: "PixelQuestCrystalCyan", color: .cyan, x: 0.95, y: 0.27, size: 21, phase: 12.7),
                .init(id: 32, imageName: "PixelQuestCrystalScarlet", color: .red, x: 0.14, y: 0.8, size: 22, phase: 13.6),
                .init(id: 33, imageName: "PixelQuestCrystalEmerald", color: .green, x: 0.87, y: 0.79, size: 20, phase: 14.5),
                .init(id: 34, imageName: "PixelQuestCrystalMagenta", color: .pink, x: 0.32, y: 0.18, size: 18, phase: 15.4),
                .init(id: 35, imageName: "PixelQuestCrystalAmber", color: .orange, x: 0.78, y: 0.39, size: 17, phase: 16.3),
                .init(id: 36, imageName: "PixelQuestCrystalCyan", color: .cyan, x: 0.19, y: 0.43, size: 18, phase: 17.2),
                .init(id: 37, imageName: "PixelQuestCrystalScarlet", color: .red, x: 0.55, y: 0.82, size: 19, phase: 18.1),
                .init(id: 38, imageName: "PixelQuestCrystalEmerald", color: .green, x: 0.43, y: 0.27, size: 16, phase: 19.0),
                .init(id: 39, imageName: "PixelQuestCrystalMagenta", color: .pink, x: 0.66, y: 0.61, size: 17, phase: 19.9)
            ]
        }
    }

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { context in
            GeometryReader { geometry in
                let elapsed = context.date.timeIntervalSinceReferenceDate

                ForEach(placements) { crystal in
                    let wave = reduceMotion
                        ? 0
                        : sin(elapsed * 0.9 + crystal.phase)
                    let sideWave = reduceMotion
                        ? 0
                        : cos(elapsed * 0.62 + crystal.phase)
                    let pulse = reduceMotion ? 1 : 1 + wave * 0.055

                    Image(crystal.imageName)
                        .resizable()
                        .interpolation(.none)
                        .scaledToFit()
                        .frame(width: crystal.size, height: crystal.size)
                        .scaleEffect(CGFloat(pulse))
                        .offset(
                            x: CGFloat(sideWave) * 2.2,
                            y: CGFloat(wave) * 4.5
                        )
                        .shadow(
                            color: crystal.color.opacity(0.42 + wave * 0.12),
                            radius: CGFloat(9 + wave * 2)
                        )
                        .opacity(baseOpacity)
                        .position(
                            x: geometry.size.width * crystal.x,
                            y: geometry.size.height * crystal.y
                        )
                }
            }
        }
        .accessibilityHidden(true)
    }
}

struct PixelQuestWorldCard: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22)
                .fill(Color(red: 0.035, green: 0.09, blue: 0.12))

            Image("PixelQuestBackdrop")
                .resizable()
                .interpolation(.none)
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 22))

            LinearGradient(
                colors: [
                    Color.black.opacity(0.05),
                    Color.black.opacity(0.26)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .clipShape(RoundedRectangle(cornerRadius: 22))

            PixelQuestCrystalField(style: .card)
                .allowsHitTesting(false)

            RobotSpriteView(direction: .south, isWalking: false)
                .frame(width: 112, height: 112)
                .shadow(color: .black.opacity(0.65), radius: 0, x: 4, y: 5)

            VStack {
                Spacer()
                Text("YOUR FIRST QUEST: FORGE STEEL")
                    .font(.system(size: 11, weight: .black, design: .monospaced))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.7), in: Capsule())
                    .padding(.bottom, 14)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 255)
        .clipped()
        .overlay {
            RoundedRectangle(cornerRadius: 22)
                .stroke(
                    LinearGradient(
                        colors: [.cyan.opacity(0.7), .blue.opacity(0.25), .purple.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        }
        .shadow(color: .cyan.opacity(0.16), radius: 20, y: 10)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Pixel map preview with the player, iron, and carbon")
    }
}

struct PixelQuestLoopRow: View {
    let icon: String
    let title: String
    let detail: String
    let accent: Color

    var body: some View {
        HStack(spacing: 13) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(accent)
                .frame(width: 40, height: 40)
                .background(accent.opacity(0.12), in: RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 14, weight: .black, design: .rounded))
                    .foregroundStyle(.white)

                Text(detail)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.58))
            }

            Spacer(minLength: 0)
        }
    }
}

struct PixelQuestGameView: View {
    private let mapRows = 21
    private let mapColumns = 14
    private let zoneSize = 7
    private let viewportColumns = 10
    private let viewportRows = 7
    private let requiredIronCount = 5
    private let requiredCarbonCount = 1
    private let ironDeposits = [
        PixelResourceDeposit(id: 0, position: PixelPosition(x: 4.15, y: 10.86)),
        PixelResourceDeposit(id: 1, position: PixelPosition(x: 6.45, y: 10.38)),
        PixelResourceDeposit(id: 2, position: PixelPosition(x: 10.72, y: 11.18)),
        PixelResourceDeposit(id: 3, position: PixelPosition(x: 2.55, y: 18.10)),
        PixelResourceDeposit(id: 4, position: PixelPosition(x: 8.15, y: 17.45))
    ]
    private let carbonPosition = PixelPosition(x: 10.92, y: 18.62)
    private let forgePosition = PixelPosition(x: 11, y: 9)
    private let ironCavernsSignPosition = CGPoint(x: 3.25, y: 4.25)

    // The landing, crystal pit, and lower cavern are one continuous world.
    // These boundaries sit slightly inside the visible stonework so the
    // robot's full sprite cannot appear to clip through the walls.
    private let wallCollisionZones = [
        PixelCollisionRect(minX: 1.15, maxX: 8.30, minY: -0.5, maxY: 1.16),
        PixelCollisionRect(minX: -0.5, maxX: 2.46, minY: 0.62, maxY: 6.55),
        PixelCollisionRect(minX: 7.10, maxX: 13.5, minY: -0.5, maxY: 6.55),
        PixelCollisionRect(minX: -0.5, maxX: 4.20, minY: 4.96, maxY: 6.55),
        PixelCollisionRect(minX: 5.32, maxX: 13.5, minY: 4.96, maxY: 6.55),

        PixelCollisionRect(minX: -0.5, maxX: 3.75, minY: 6.5, maxY: 8.82),
        PixelCollisionRect(minX: 6.02, maxX: 13.5, minY: 6.5, maxY: 9.02),
        PixelCollisionRect(minX: -0.5, maxX: 1.18, minY: 8.35, maxY: 12.62),
        PixelCollisionRect(minX: 11.72, maxX: 13.5, minY: 8.65, maxY: 12.62),
        PixelCollisionRect(minX: -0.5, maxX: 5.20, minY: 11.90, maxY: 13.55),
        PixelCollisionRect(minX: 7.80, maxX: 13.5, minY: 11.90, maxY: 13.55),

        PixelCollisionRect(minX: -0.5, maxX: 3.00, minY: 13.45, maxY: 14.60),
        PixelCollisionRect(minX: 9.80, maxX: 13.5, minY: 13.45, maxY: 14.60),
        PixelCollisionRect(minX: -0.5, maxX: 0.78, minY: 14.45, maxY: 20.5),
        PixelCollisionRect(minX: 12.22, maxX: 13.5, minY: 14.45, maxY: 20.5),
        PixelCollisionRect(minX: -0.5, maxX: 13.5, minY: 19.55, maxY: 21.5)
    ]

    // Each visible starting boulder has its own compact footprint. The same
    // treatment is used for the largest rocks in the deeper cavern.
    private let objectCollisionZones = [
        PixelCollisionCircle(x: 3.25, y: 4.60, radius: 0.26),
        PixelCollisionCircle(x: 3.06, y: 2.37, radius: 0.48),
        PixelCollisionCircle(x: 5.96, y: 2.40, radius: 0.48),
        PixelCollisionCircle(x: 7.02, y: 3.25, radius: 0.42),
        PixelCollisionCircle(x: 2.35, y: 3.58, radius: 0.35),
        PixelCollisionCircle(x: 3.60, y: 4.22, radius: 0.42),
        PixelCollisionCircle(x: 6.86, y: 4.40, radius: 0.45),
        PixelCollisionCircle(x: 2.05, y: 9.96, radius: 0.46),
        PixelCollisionCircle(x: 3.16, y: 10.70, radius: 0.45),
        PixelCollisionCircle(x: 5.14, y: 8.86, radius: 0.46),
        PixelCollisionCircle(x: 7.92, y: 9.58, radius: 0.50),
        PixelCollisionCircle(x: 8.75, y: 10.95, radius: 0.50),
        PixelCollisionCircle(x: 9.70, y: 9.83, radius: 0.48),
        PixelCollisionCircle(x: 3.00, y: 15.34, radius: 0.20),
        PixelCollisionCircle(x: 5.55, y: 15.36, radius: 0.42),
        PixelCollisionCircle(x: 8.70, y: 15.20, radius: 0.40),
        PixelCollisionCircle(x: 10.48, y: 16.08, radius: 0.46),
        PixelCollisionCircle(x: 11.00, y: 9.00, radius: 0.62)
    ]

    // Raised lunar ridges add depth and create routes in Crystal Depths.
    // Their gaps deliberately keep the left and right sides accessible.
    private let thirdAreaBarrierZones = [
        PixelCollisionRect(minX: 3.72, maxX: 5.18, minY: 16.22, maxY: 16.70),
        PixelCollisionRect(minX: 8.82, maxX: 10.12, minY: 15.86, maxY: 16.34),
        PixelCollisionRect(minX: 5.72, maxX: 7.32, minY: 18.18, maxY: 18.68)
    ]

    private let thirdAreaBarriers = [
        PixelDepthBarrier(id: 0, position: PixelPosition(x: 4.45, y: 16.46), width: 1.46),
        PixelDepthBarrier(id: 1, position: PixelPosition(x: 9.47, y: 16.10), width: 1.30),
        PixelDepthBarrier(id: 2, position: PixelPosition(x: 6.52, y: 18.43), width: 1.60)
    ]

    @State private var playerPosition = CGPoint(x: 4.75, y: 3)
    @State private var ironCount = 0
    @State private var carbonCount = 0
    @State private var collectedIronIDs: Set<Int> = []
    @State private var collectedCarbon = false
    @State private var hasSteelIngot = false
    @State private var hasSteelSword = false
    @State private var showingForge = false
    @State private var selectedLearningMaterial: PixelLearningMaterial?
    @State private var pickupMaterial: PixelLearningMaterial?
    @State private var forgeHint = "Walk south through the gateway into the crystal pit."
    @State private var robotDirection = RobotDirection.south
    @State private var robotIsWalking = false
    @State private var lastDirectionChange = Date.distantPast
    @State private var shieldCount = 3
    @State private var lastRustHit = Date.distantPast
    @State private var rustMonsters = [
        PixelRustMonster(id: 0, position: CGPoint(x: 2.20, y: 16.20), direction: .east, action: .moving, ticksRemaining: 38),
        PixelRustMonster(id: 1, position: CGPoint(x: 7.60, y: 17.10), direction: .southWest, action: .idle, ticksRemaining: 14),
        PixelRustMonster(id: 2, position: CGPoint(x: 10.60, y: 18.10), direction: .northWest, action: .moving, ticksRemaining: 52)
    ]

    private var currentColumn: Int {
        playerPosition.x < CGFloat(zoneSize) ? 0 : 1
    }

    private var currentRow: Int {
        min(Int(playerPosition.y / CGFloat(zoneSize)), 2)
    }

    // The landing artwork is exactly one viewport wide and begins 1.75 cells
    // into the full world image. Keep the camera locked to that framed room
    // until the robot enters its exit road, otherwise following the robot at
    // the room edges exposes the black canvas outside the stone border.
    private var landingCameraBlend: CGFloat {
        min(max((playerPosition.y - 5.1) / 2.0, 0), 1)
    }

    private var horizontalCameraOffsetCells: CGFloat {
        let normalOffset = min(
            max(playerPosition.x - 3, 0),
            CGFloat(mapColumns - viewportColumns)
        )
        let lockedLandingOffset: CGFloat = 1.75
        return lockedLandingOffset
            + (normalOffset - lockedLandingOffset) * landingCameraBlend
    }

    private var verticalCameraOffsetCells: CGFloat {
        let normalOffset = min(
            max(playerPosition.y - 3, 0),
            CGFloat(mapRows - viewportRows)
        )
        return normalOffset * landingCameraBlend
    }

    private var areaTitle: String {
        if currentRow == 0 { return "MOON LANDING" }
        if currentRow == 2 { return "CRYSTAL DEPTHS" }
        return currentColumn == 0 ? "CRYSTAL PIT" : "MOON FORGE"
    }

    private var areaAccent: Color {
        if currentRow == 0 { return .purple }
        if currentRow == 2 { return .blue }
        return currentColumn == 0 ? .cyan : .orange
    }

    private var objectiveText: String {
        if hasSteelSword {
            return "Steel sword complete. The Moon Forge remains available."
        }
        if hasSteelIngot {
            return "Steel forged. Use the crafting table to finish the sword."
        }
        if forgeUnlocked {
            return currentRow == 1 && currentColumn == 1
                ? "All materials found. Tap the Moon Forge to craft the steel sword."
                : "Return to the Moon Forge with 5 iron and 1 carbon shard."
        }
        if currentRow == 0 {
            return "Follow the southern path to begin collecting materials."
        }
        if currentRow == 2 {
            return "Search every side of the depths for rare carbon."
        }
        return currentColumn == 0
            ? "Iron collected: \(ironCount)/\(requiredIronCount). Carbon: \(carbonCount)/1."
            : "The forge unlocks at 5 iron and 1 carbon shard."
    }

    private var isNearForge: Bool {
        isNear(playerPosition, forgePosition, radius: 1.55)
    }

    private var forgeUnlocked: Bool {
        ironCount >= requiredIronCount && carbonCount >= requiredCarbonCount
    }

    private var forgeAccessGranted: Bool {
        forgeUnlocked || hasSteelIngot || hasSteelSword
    }

    var body: some View {
        ZStack {
            PixelQuestBackground()

            ScrollView {
                VStack(spacing: 18) {
                    VStack(alignment: .leading, spacing: 9) {
                        Text("MISSION: LEARNING ELEMENTS")
                            .font(.system(size: 12, weight: .black, design: .monospaced))
                            .foregroundStyle(.cyan)

                        Text("Explore the caverns, collect 5 iron ores and 1 rare carbon shard, then tap the Moon Forge to craft a steel sword.")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundStyle(.white.opacity(0.84))
                            .lineSpacing(3)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(Color.cyan.opacity(0.08), in: RoundedRectangle(cornerRadius: 16))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.cyan.opacity(0.34), lineWidth: 1)
                    }

                    VStack(spacing: 5) {
                        Text("FORGE STEEL")
                            .font(.system(size: 28, weight: .black, design: .monospaced))
                            .foregroundStyle(.white)

                        Text(objectiveText)
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white.opacity(0.58))
                    }

                    PixelQuestInventory(
                        ironCount: ironCount,
                        carbonCount: carbonCount,
                        hasSteelIngot: hasSteelIngot,
                        hasSteelSword: hasSteelSword
                    )

                    GeometryReader { geometry in
                        let cell = geometry.size.width / CGFloat(viewportColumns)
                        let worldWidth = cell * CGFloat(mapColumns)
                        let worldHeight = cell * CGFloat(mapRows)

                        ZStack(alignment: .topLeading) {
                            ZStack(alignment: .topLeading) {
                                Image("PixelQuestMoonWorldMap")
                                    .resizable()
                                    .interpolation(.none)
                                    .scaledToFill()
                                    .clipped()
                                .frame(width: worldWidth, height: worldHeight)

                                ForEach(ironDeposits) { deposit in
                                    if !collectedIronIDs.contains(deposit.id) {
                                        PixelResourceSprite(
                                            imageName: "PixelQuestIronOre",
                                            label: "Iron ore \(deposit.id + 1)",
                                            glowColor: .orange
                                        )
                                            .frame(width: cell * 0.76, height: cell * 0.76)
                                            .position(
                                                x: (deposit.position.x + 0.5) * cell,
                                                y: (deposit.position.y + 0.5) * cell
                                            )
                                    }
                                }

                                if !collectedCarbon {
                                    PixelResourceSprite(
                                        imageName: "PixelQuestCarbonCrystal",
                                        label: "Rare carbon shard",
                                        glowColor: .cyan
                                    )
                                        .frame(width: cell * 0.78, height: cell * 0.78)
                                        .position(
                                            x: (carbonPosition.x + 0.5) * cell,
                                            y: (carbonPosition.y + 0.5) * cell
                                        )
                                }

                                ForEach(thirdAreaBarriers) { barrier in
                                    PixelMoonDepthBarrier(seed: barrier.id)
                                        .frame(
                                            width: cell * barrier.width,
                                            height: cell * 0.72
                                        )
                                        .position(
                                            x: (barrier.position.x + 0.5) * cell,
                                            y: (barrier.position.y + 0.5) * cell
                                        )
                                }

                                ForEach(rustMonsters) { monster in
                                    PixelRustMonsterSprite(
                                        direction: monster.direction,
                                        action: monster.action
                                    )
                                        .frame(width: cell * 0.92, height: cell * 0.92)
                                        .position(
                                            x: (monster.position.x + 0.5) * cell,
                                            y: (monster.position.y + 0.5) * cell
                                        )
                                }

                                Image("PixelQuestIronCavernsSign")
                                    .resizable()
                                    .interpolation(.none)
                                    .scaledToFit()
                                    .saturation(0.28)
                                    .contrast(0.82)
                                    .brightness(-0.16)
                                    .opacity(0.84)
                                    .frame(width: cell * 1.55, height: cell * 1.1)
                                    .position(
                                        x: (ironCavernsSignPosition.x + 0.5) * cell,
                                        y: (ironCavernsSignPosition.y + 0.5) * cell
                                    )
                                    .accessibilityLabel(
                                        "Iron Caverns sign pointing toward the main area"
                                    )

                                Button {
                                    if isNearForge && forgeAccessGranted {
                                        showingForge = true
                                    } else if !forgeAccessGranted {
                                        forgeHint = "Moon Forge locked: collect 5 iron ores and 1 carbon shard."
                                    } else {
                                        forgeHint = "Move closer to the robotic forge, then tap it."
                                    }
                                } label: {
                                    PixelForgeMapSprite(isUnlocked: forgeAccessGranted)
                                        .frame(width: cell * 1.78, height: cell * 1.78)
                                        .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)
                                .frame(width: cell * 2.15, height: cell * 2.15)
                                .contentShape(Rectangle())
                                .position(
                                    x: (forgePosition.x + 0.5) * cell,
                                    y: (forgePosition.y + 0.5) * cell
                                )
                                .accessibilityLabel(
                                    forgeAccessGranted
                                        ? "Interactive moon forge"
                                        : "Locked moon forge. Requires five iron ores and one carbon shard."
                                )

                                RobotSpriteView(
                                    direction: robotDirection,
                                    isWalking: robotIsWalking
                                )
                                    .frame(width: cell * 1.18, height: cell * 1.18)
                                    .position(
                                        x: (playerPosition.x + 0.5) * cell,
                                        y: (playerPosition.y + 0.54) * cell
                                    )
                                    .animation(
                                        .linear(duration: 0.034),
                                        value: playerPosition
                                    )
                            }
                            .frame(width: worldWidth, height: worldHeight)
                            .offset(
                                x: -cell * horizontalCameraOffsetCells,
                                y: -cell * verticalCameraOffsetCells
                            )
                            .animation(.linear(duration: 0.05), value: playerPosition.x)
                            .animation(.linear(duration: 0.05), value: playerPosition.y)

                            VStack {
                                HStack {
                                    Text(areaTitle)
                                        .font(.system(size: 9, weight: .black, design: .monospaced))
                                        .foregroundStyle(areaAccent)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 5)
                                        .background(.black.opacity(0.7), in: Capsule())
                                    Spacer()

                                    if currentRow == 1 && currentColumn == 1 && isNearForge {
                                        Label(
                                            forgeAccessGranted
                                                ? "CRAFT STEEL SWORD"
                                                : "LOCKED \(ironCount)/5 Fe · \(carbonCount)/1 C",
                                            systemImage: forgeAccessGranted ? "hand.tap.fill" : "lock.fill"
                                        )
                                            .font(.system(size: 8, weight: .black, design: .monospaced))
                                            .foregroundStyle(.white)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 5)
                                            .background(
                                                forgeAccessGranted ? Color.orange : Color.gray.opacity(0.82),
                                                in: Capsule()
                                            )
                                    }
                                }

                                Spacer()

                                HStack {
                                    PixelJoystick(
                                        isEnabled: pickupMaterial == nil,
                                        move: move,
                                        stopped: { robotIsWalking = false }
                                    )
                                    .scaleEffect(0.84, anchor: .bottomLeading)

                                    Spacer()

                                    VStack(alignment: .trailing, spacing: 7) {
                                        Label("SHIELD \(shieldCount)/3", systemImage: "shield.fill")
                                            .font(.system(size: 8, weight: .black, design: .monospaced))
                                            .foregroundStyle(shieldCount > 1 ? .cyan : .orange)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 5)
                                            .background(.black.opacity(0.72), in: Capsule())

                                        PixelLearningHUD(
                                            ironUnlocked: ironCount > 0,
                                            carbonUnlocked: collectedCarbon,
                                            steelUnlocked: hasSteelIngot || hasSteelSword
                                        ) { material in
                                            selectedLearningMaterial = material
                                        }
                                    }
                                }
                            }
                            .padding(10)
                        }
                    }
                    .aspectRatio(
                        CGFloat(viewportColumns) / CGFloat(viewportRows),
                        contentMode: .fit
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .overlay {
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(.cyan.opacity(0.34), lineWidth: 2)
                    }

                    HStack(spacing: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("LANDSCAPE QUEST CONTROLS")
                                .font(.system(size: 11, weight: .black, design: .monospaced))
                                .foregroundStyle(.cyan)

                            Text("Turn your phone sideways for the widest view. The joystick now stays inside the map.")
                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                                .foregroundStyle(.white.opacity(0.58))

                            Text(forgeHint)
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .foregroundStyle(isNearForge ? .orange : .white.opacity(0.46))
                                .lineLimit(2)
                        }

                        Spacer(minLength: 0)
                    }
                    .padding(14)
                    .background(Color.black.opacity(0.28), in: RoundedRectangle(cornerRadius: 18))
                    .overlay {
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(.cyan.opacity(0.22), lineWidth: 1)
                    }

                    Button(action: restart) {
                        Label(
                            "Restart Quest",
                            systemImage: "arrow.counterclockwise"
                        )
                        .font(.system(size: 13, weight: .black, design: .monospaced))
                        .foregroundStyle(.cyan)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            Color.cyan.opacity(0.1),
                            in: RoundedRectangle(cornerRadius: 14)
                        )
                        .overlay {
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(.cyan.opacity(0.35), lineWidth: 1)
                        }
                        .contentShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom, 90)
                }
                .frame(maxWidth: 900)
                .padding(20)
                .frame(maxWidth: .infinity)
            }

            if let pickupMaterial {
                PixelMaterialPickupCutscene(material: pickupMaterial) {
                    self.pickupMaterial = nil
                }
                .zIndex(20)
            }
        }
        .navigationTitle("Pixel Quest")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedLearningMaterial) { material in
            PixelMaterialLearningView(material: material)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .navigationDestination(isPresented: $showingForge) {
            PixelQuestForgeView(
                ironCount: $ironCount,
                carbonCount: $carbonCount,
                hasSteelIngot: $hasSteelIngot,
                hasSteelSword: $hasSteelSword,
                selectedLearningMaterial: $selectedLearningMaterial
            )
        }
        .task {
            await runRustMonsterLoop()
        }
    }

    private func move(dx: CGFloat, dy: CGFloat) {
        guard pickupMaterial == nil else {
            robotIsWalking = false
            return
        }

        let proposedDirection = RobotDirection(dx: dx, dy: dy)
        let now = Date()
        if proposedDirection == robotDirection
            || now.timeIntervalSince(lastDirectionChange) >= 0.08 {
            if proposedDirection != robotDirection {
                lastDirectionChange = now
            }
            robotDirection = proposedDirection
        }

        let proposedPosition = CGPoint(
            x: min(max(playerPosition.x + dx, 0), CGFloat(mapColumns - 1)),
            y: min(max(playerPosition.y + dy, 0), CGFloat(mapRows - 1))
        )
        let nextPosition = resolveCollision(
            from: playerPosition,
            toward: proposedPosition,
            dx: dx,
            dy: dy
        )

        robotIsWalking = nextPosition != playerPosition
        playerPosition = nextPosition

        if nextPosition.y >= CGFloat(zoneSize),
           forgeHint == "Walk south through the gateway into the crystal pit." {
            forgeHint = "Collect all 5 iron ores and the rare carbon shard."
        }

        if let deposit = ironDeposits.first(where: {
            !collectedIronIDs.contains($0.id)
                && isNear(playerPosition, $0.position, radius: 0.50)
        }) {
            collectedIronIDs.insert(deposit.id)
            let newIronCount = ironCount + 1
            ironCount = newIronCount
            robotIsWalking = false
            forgeHint = newIronCount >= requiredIronCount && carbonCount >= requiredCarbonCount
                ? "All materials found. Tap the Moon Forge to craft the steel sword."
                : "Iron collected: \(newIronCount)/\(requiredIronCount). Keep searching."
            if newIronCount == 1 {
                pickupMaterial = .iron
            }
        }

        if isNear(playerPosition, carbonPosition) && !collectedCarbon {
            collectedCarbon = true
            carbonCount += 1
            robotIsWalking = false
            pickupMaterial = .carbon
            forgeHint = ironCount >= requiredIronCount
                ? "All materials found. Tap the Moon Forge to craft the steel sword."
                : "Rare carbon found. Keep searching for all 5 iron ores."
        }

        checkRustMonsterContact()
    }

    private func resolveCollision(
        from current: CGPoint,
        toward proposed: CGPoint,
        dx: CGFloat,
        dy: CGFloat
    ) -> CGPoint {
        if isWalkable(proposed) {
            return proposed
        }

        let horizontal = CGPoint(x: proposed.x, y: current.y)
        let vertical = CGPoint(x: current.x, y: proposed.y)
        let first = abs(dx) >= abs(dy) ? horizontal : vertical
        let second = abs(dx) >= abs(dy) ? vertical : horizontal

        if isWalkable(first) {
            return first
        }
        if isWalkable(second) {
            return second
        }
        return current
    }

    private func isWalkable(_ position: CGPoint) -> Bool {
        guard position.x >= 0,
              position.x <= CGFloat(mapColumns - 1),
              position.y >= 0,
              position.y <= CGFloat(mapRows - 1),
              isInsidePlayableRegion(position) else {
            return false
        }

        if wallCollisionZones.contains(where: { $0.contains(position) }) {
            return false
        }

        if thirdAreaBarrierZones.contains(where: { $0.contains(position) }) {
            return false
        }

        return !objectCollisionZones.contains(where: { $0.contains(position) })
    }

    private func isInsidePlayableRegion(_ position: CGPoint) -> Bool {
        if position.y < CGFloat(zoneSize) {
            let landingFloor = PixelCollisionRect(
                minX: 2.46,
                maxX: 7.10,
                minY: 1.16,
                maxY: 5.08
            )
            let landingGateway = PixelCollisionRect(
                minX: 4.20,
                maxX: 5.32,
                minY: 4.82,
                maxY: 7.15
            )
            return landingFloor.contains(position)
                || landingGateway.contains(position)
        }

        let pitEntrance = PixelCollisionRect(
            minX: 3.75,
            maxX: 6.02,
            minY: 6.5,
            maxY: 9.25
        )
        let pitFloor = PixelCollisionRect(
            minX: 1.18,
            maxX: 11.72,
            minY: 8.95,
            maxY: 11.90
        )
        let lowerGateway = PixelCollisionRect(
            minX: 3.00,
            maxX: 9.80,
            minY: 11.55,
            maxY: 15.35
        )
        let lowerCavern = PixelCollisionRect(
            minX: 0.78,
            maxX: 12.22,
            minY: 14.65,
            maxY: 19.55
        )
        return pitEntrance.contains(position)
            || pitFloor.contains(position)
            || lowerGateway.contains(position)
            || lowerCavern.contains(position)
    }

    private func isNear(
        _ player: CGPoint,
        _ resource: PixelPosition,
        radius: CGFloat = 0.42
    ) -> Bool {
        hypot(
            player.x - resource.x,
            player.y - resource.y
        ) < radius
    }

    private func restart() {
        playerPosition = CGPoint(x: 4.75, y: 3)
        ironCount = 0
        carbonCount = 0
        collectedIronIDs.removeAll()
        collectedCarbon = false
        hasSteelIngot = false
        hasSteelSword = false
        selectedLearningMaterial = nil
        pickupMaterial = nil
        showingForge = false
        forgeHint = "Walk south through the gateway into the crystal pit."
        robotDirection = .south
        robotIsWalking = false
        lastDirectionChange = .distantPast
        shieldCount = 3
        lastRustHit = .distantPast
        rustMonsters = [
            PixelRustMonster(id: 0, position: CGPoint(x: 2.20, y: 16.20), direction: .east, action: .moving, ticksRemaining: 38),
            PixelRustMonster(id: 1, position: CGPoint(x: 7.60, y: 17.10), direction: .southWest, action: .idle, ticksRemaining: 14),
            PixelRustMonster(id: 2, position: CGPoint(x: 10.60, y: 18.10), direction: .northWest, action: .moving, ticksRemaining: 52)
        ]
    }

    @MainActor
    private func runRustMonsterLoop() async {
        while !Task.isCancelled {
            try? await Task.sleep(for: .milliseconds(110))
            guard !Task.isCancelled, pickupMaterial == nil, !showingForge else { continue }
            updateRustMonsters()
            checkRustMonsterContact()
        }
    }

    private func updateRustMonsters() {
        for index in rustMonsters.indices {
            if rustMonsters[index].action == .attacking {
                rustMonsters[index].ticksRemaining -= 1
                if rustMonsters[index].ticksRemaining <= 0 {
                    rustMonsters[index].action = .idle
                    rustMonsters[index].ticksRemaining = 10 + index * 3
                }
                continue
            }

            if rustMonsters[index].action == .idle {
                rustMonsters[index].ticksRemaining -= 1
                if rustMonsters[index].ticksRemaining <= 0 {
                    rustMonsters[index].action = .moving
                    rustMonsters[index].ticksRemaining = 34 + index * 8
                }
                continue
            }

            let vector = rustMonsters[index].direction.movementVector
            let proposed = CGPoint(
                x: rustMonsters[index].position.x + vector.dx * 0.035,
                y: rustMonsters[index].position.y + vector.dy * 0.035
            )

            if isRustMonsterWalkable(proposed) {
                rustMonsters[index].position = proposed
            } else {
                rustMonsters[index].direction = rustMonsters[index].direction.nextClockwise
            }

            rustMonsters[index].ticksRemaining -= 1
            if rustMonsters[index].ticksRemaining <= 0 {
                rustMonsters[index].action = .idle
                rustMonsters[index].ticksRemaining = 11 + index * 4
            }
        }
    }

    private func isRustMonsterWalkable(_ position: CGPoint) -> Bool {
        let monsterBounds = PixelCollisionRect(
            minX: 1.05,
            maxX: 11.95,
            minY: 14.95,
            maxY: 19.25
        )
        guard monsterBounds.contains(position),
              !thirdAreaBarrierZones.contains(where: { $0.contains(position) }) else {
            return false
        }
        return !objectCollisionZones.contains(where: { $0.contains(position) })
    }

    private func checkRustMonsterContact() {
        guard Date().timeIntervalSince(lastRustHit) > 1.25,
              let monsterIndex = rustMonsters.firstIndex(where: {
                  hypot(playerPosition.x - $0.position.x, playerPosition.y - $0.position.y) < 0.62
              }) else { return }

        lastRustHit = Date()
        robotIsWalking = false
        let monsterID = rustMonsters[monsterIndex].id
        rustMonsters[monsterIndex].direction = RobotDirection(
            dx: playerPosition.x - rustMonsters[monsterIndex].position.x,
            dy: playerPosition.y - rustMonsters[monsterIndex].position.y
        )
        rustMonsters[monsterIndex].action = .attacking
        rustMonsters[monsterIndex].ticksRemaining = 8

        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(320))
            guard let attackingMonster = rustMonsters.first(where: { $0.id == monsterID }),
                  hypot(
                    playerPosition.x - attackingMonster.position.x,
                    playerPosition.y - attackingMonster.position.y
                  ) < 0.92 else { return }
            applyRustMonsterDamage()
        }
    }

    private func applyRustMonsterDamage() {
        if shieldCount > 1 {
            shieldCount -= 1
            playerPosition = CGPoint(x: 6.45, y: 14.95)
            forgeHint = "Rust monster hit! Shield \(shieldCount)/3. You were moved to the cavern entrance."
        } else {
            restart()
            forgeHint = "Rust monsters broke your shield. The Learning Elements quest restarted."
        }
    }
}

enum RobotDirection: String {
    case north
    case northEast
    case southEast
    case south
    case southWest
    case northWest
    case east
    case west

    var assetName: String {
        rawValue.prefix(1).uppercased() + rawValue.dropFirst()
    }

    var movementVector: (dx: CGFloat, dy: CGFloat) {
        switch self {
        case .north: (0, -1)
        case .northEast: (0.707, -0.707)
        case .east: (1, 0)
        case .southEast: (0.707, 0.707)
        case .south: (0, 1)
        case .southWest: (-0.707, 0.707)
        case .west: (-1, 0)
        case .northWest: (-0.707, -0.707)
        }
    }

    var nextClockwise: RobotDirection {
        switch self {
        case .north: .northEast
        case .northEast: .east
        case .east: .southEast
        case .southEast: .south
        case .south: .southWest
        case .southWest: .west
        case .west: .northWest
        case .northWest: .north
        }
    }

    init(dx: CGFloat, dy: CGFloat) {
        let angle = atan2(dy, dx)
        switch angle {
        case -7 * .pi / 8 ..< -5 * .pi / 8:
            self = .northWest
        case -5 * .pi / 8 ..< -3 * .pi / 8:
            self = .north
        case -3 * .pi / 8 ..< -.pi / 8:
            self = .northEast
        case -.pi / 8 ..< .pi / 8:
            self = .east
        case .pi / 8 ..< 3 * .pi / 8:
            self = .southEast
        case 3 * .pi / 8 ..< 5 * .pi / 8:
            self = .south
        case 5 * .pi / 8 ..< 7 * .pi / 8:
            self = .southWest
        default:
            self = .west
        }
    }
}

struct RobotSpriteView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let direction: RobotDirection
    let isWalking: Bool

    @State private var animationStart = Date()

    private var frameNames: [String] {
        if isWalking {
            return (0..<8).map {
                "RobotWalk\(direction.assetName)\($0)"
            }
        }

        if direction == .south {
            return (0..<4).map { "RobotIdleSouth\($0)" }
        }

        return ["RobotStill\(direction.assetName)"]
    }

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { context in
            let frames = frameNames
            let framesPerSecond = isWalking ? 12.0 : 5.0
            let elapsed = max(context.date.timeIntervalSince(animationStart), 0)
            let frameIndex = reduceMotion
                ? 0
                : Int(elapsed * framesPerSecond) % frames.count
            Image(frames[frameIndex])
                .resizable()
                .interpolation(.none)
                .scaledToFit()
        }
        .onChange(of: direction.rawValue) {
            animationStart = Date()
        }
        .onChange(of: isWalking) {
            animationStart = Date()
        }
        .accessibilityLabel(
            isWalking ? "Robot walking" : "Robot standing"
        )
    }
}

struct PixelPosition: Equatable {
    let x: CGFloat
    let y: CGFloat
}

private struct PixelResourceDeposit: Identifiable {
    let id: Int
    let position: PixelPosition
}

private struct PixelDepthBarrier: Identifiable {
    let id: Int
    let position: PixelPosition
    let width: CGFloat
}

private struct PixelRustMonster: Identifiable {
    let id: Int
    var position: CGPoint
    var direction: RobotDirection
    var action: PixelRustMonsterAction
    var ticksRemaining: Int
}

private enum PixelRustMonsterAction: String {
    case idle
    case moving
    case attacking
}

private struct PixelCollisionRect {
    let minX: CGFloat
    let maxX: CGFloat
    let minY: CGFloat
    let maxY: CGFloat

    func contains(_ point: CGPoint) -> Bool {
        point.x >= minX && point.x <= maxX
            && point.y >= minY && point.y <= maxY
    }
}

private struct PixelCollisionCircle {
    let x: CGFloat
    let y: CGFloat
    let radius: CGFloat

    func contains(_ point: CGPoint) -> Bool {
        hypot(point.x - x, point.y - y) <= radius
    }
}

struct PixelQuestInventory: View {
    let ironCount: Int
    let carbonCount: Int
    let hasSteelIngot: Bool
    let hasSteelSword: Bool

    var body: some View {
        HStack(spacing: 10) {
            inventoryItem("Fe", count: ironCount, target: 5, color: .orange)
            inventoryItem("C", count: carbonCount, target: 1, color: .cyan)

            HStack(spacing: 6) {
                Image(systemName: hasSteelSword ? "shield.lefthalf.filled" : "cube.fill")
                Text(hasSteelSword ? "SWORD" : (hasSteelIngot ? "STEEL" : "LOCKED"))
            }
            .foregroundStyle(
                hasSteelSword
                    ? .purple
                    : (hasSteelIngot ? .blue : .white.opacity(0.32))
            )
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 11))
        }
        .font(.system(size: 12, weight: .black, design: .monospaced))
    }

    private func inventoryItem(
        _ symbol: String,
        count: Int,
        target: Int,
        color: Color
    ) -> some View {
        HStack(spacing: 6) {
            Text(symbol)
                .foregroundStyle(color)
            Text("\(count)/\(target)")
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(color.opacity(0.1), in: RoundedRectangle(cornerRadius: 11))
    }
}

struct PixelJoystick: View {
    let isEnabled: Bool
    let move: (CGFloat, CGFloat) -> Void
    let stopped: () -> Void

    private let controlSize: CGFloat = 112
    private let knobSize: CGFloat = 42

    @State private var knobOffset = CGSize.zero
    @State private var movementVector = CGVector.zero
    @State private var movementTask: Task<Void, Never>?

    var body: some View {
        ZStack {
            Image("PixelQuestJoystickBase")
                .resizable()
                .interpolation(.none)
                .scaledToFit()
                .frame(width: controlSize, height: controlSize)

            PixelJoystickThumbShape()
                .fill(Color(red: 0.48, green: 0.56, blue: 0.66))
                .overlay {
                    PixelJoystickThumbShape()
                        .stroke(Color.black.opacity(0.78), lineWidth: 3)
                }
                .frame(width: knobSize, height: knobSize)
                .offset(knobOffset)
        }
        .frame(width: controlSize, height: controlSize)
        .opacity(isEnabled ? 1 : 0.58)
        .contentShape(Circle())
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged(updateJoystick)
                .onEnded { _ in endMoving() }
        )
        .allowsHitTesting(isEnabled)
        .accessibilityElement()
        .accessibilityLabel("Eight direction movement joystick")
        .accessibilityHint("Drag in the direction you want the robot to walk")
        .onChange(of: isEnabled) { _, enabled in
            if !enabled {
                endMoving()
            }
        }
        .onDisappear(perform: endMoving)
    }

    private func updateJoystick(_ value: DragGesture.Value) {
        let radius = (controlSize - knobSize) * 0.5
        let rawX = value.location.x - controlSize * 0.5
        let rawY = value.location.y - controlSize * 0.5
        let length = max(hypot(rawX, rawY), 0.001)
        let limitedLength = min(length, radius)
        let normalizedX = rawX / length
        let normalizedY = rawY / length

        knobOffset = CGSize(
            width: normalizedX * limitedLength,
            height: normalizedY * limitedLength
        )
        movementVector = CGVector(dx: normalizedX, dy: normalizedY)

        guard movementTask == nil else { return }
        movementTask = Task {
            while !Task.isCancelled {
                let vector = movementVector
                let stride: CGFloat = 0.07
                move(vector.dx * stride, vector.dy * stride)
                try? await Task.sleep(for: .milliseconds(33))
            }
        }
    }

    private func endMoving() {
        movementTask?.cancel()
        movementTask = nil
        movementVector = .zero
        withAnimation(.spring(response: 0.22, dampingFraction: 0.72)) {
            knobOffset = .zero
        }
        stopped()
    }
}

private struct PixelJoystickThumbShape: Shape {
    func path(in rect: CGRect) -> Path {
        let points = [
            CGPoint(x: 0.25, y: 0),
            CGPoint(x: 0.75, y: 0),
            CGPoint(x: 0.75, y: 0.06),
            CGPoint(x: 0.88, y: 0.06),
            CGPoint(x: 0.88, y: 0.13),
            CGPoint(x: 0.94, y: 0.13),
            CGPoint(x: 0.94, y: 0.25),
            CGPoint(x: 1, y: 0.25),
            CGPoint(x: 1, y: 0.75),
            CGPoint(x: 0.94, y: 0.75),
            CGPoint(x: 0.94, y: 0.88),
            CGPoint(x: 0.88, y: 0.88),
            CGPoint(x: 0.88, y: 0.94),
            CGPoint(x: 0.75, y: 0.94),
            CGPoint(x: 0.75, y: 1),
            CGPoint(x: 0.25, y: 1),
            CGPoint(x: 0.25, y: 0.94),
            CGPoint(x: 0.13, y: 0.94),
            CGPoint(x: 0.13, y: 0.88),
            CGPoint(x: 0.06, y: 0.88),
            CGPoint(x: 0.06, y: 0.75),
            CGPoint(x: 0, y: 0.75),
            CGPoint(x: 0, y: 0.25),
            CGPoint(x: 0.06, y: 0.25),
            CGPoint(x: 0.06, y: 0.13),
            CGPoint(x: 0.13, y: 0.13),
            CGPoint(x: 0.13, y: 0.06),
            CGPoint(x: 0.25, y: 0.06)
        ]

        var path = Path()
        guard let first = points.first else { return path }
        path.move(
            to: CGPoint(
                x: rect.minX + first.x * rect.width,
                y: rect.minY + first.y * rect.height
            )
        )
        for point in points.dropFirst() {
            path.addLine(
                to: CGPoint(
                    x: rect.minX + point.x * rect.width,
                    y: rect.minY + point.y * rect.height
                )
            )
        }
        path.closeSubpath()
        return path
    }
}

enum PixelLearningMaterial: String, Identifiable {
    case iron
    case carbon
    case steel

    var id: String { rawValue }

    var title: String {
        switch self {
        case .iron: "Iron"
        case .carbon: "Carbon"
        case .steel: "Steel"
        }
    }

    var symbol: String {
        switch self {
        case .iron: "Fe"
        case .carbon: "C"
        case .steel: "Fe–C"
        }
    }

    var imageName: String {
        switch self {
        case .iron: "PixelQuestIronOre"
        case .carbon: "PixelQuestCarbonCrystal"
        case .steel: "PixelQuestSteelSword"
        }
    }

    var accent: Color {
        switch self {
        case .iron: .orange
        case .carbon: .cyan
        case .steel: .purple
        }
    }

    var summary: String {
        switch self {
        case .iron:
            "Iron is a metallic element. It is strong, magnetic in common forms, and is the main element used to make steel."
        case .carbon:
            "Carbon is a nonmetal that can form very different structures, including graphite and diamond. Small amounts strongly affect steel."
        case .steel:
            "Steel is not a single element. It is an iron-based alloy whose carbon content and processing change its strength, hardness, and flexibility."
        }
    }

    var facts: [String] {
        switch self {
        case .iron:
            [
                "Atomic number: 26",
                "Symbol: Fe, from the Latin word ferrum",
                "Iron is usually obtained from ores such as hematite and magnetite."
            ]
        case .carbon:
            [
                "Atomic number: 6",
                "Diamond and graphite are different structural forms of carbon.",
                "Carbon atoms can fit between iron atoms and change how the material behaves."
            ]
        case .steel:
            [
                "Most steel is mainly iron with a controlled amount of carbon.",
                "Heat treatment changes the microscopic structure and properties of steel.",
                "The game recipe is simplified; real steelmaking requires controlled composition and processing."
            ]
        }
    }

    var roomTemperatureState: String {
        switch self {
        case .iron:
            "Solid metal"
        case .carbon:
            "Solid nonmetal"
        case .steel:
            "Solid alloy"
        }
    }

    var phaseDetails: String {
        switch self {
        case .iron:
            "Iron is solid at room temperature. It melts near 1,538°C and boils near 2,862°C."
        case .carbon:
            "Carbon is solid at room temperature. At ordinary pressure it changes directly from solid to gas at extremely high temperature; liquid carbon requires extreme conditions."
        case .steel:
            "Steel is solid at room temperature. Its melting range depends on its exact carbon content and other alloying elements."
        }
    }

    var compositionDetails: String {
        switch self {
        case .iron:
            "The element is made of iron atoms (Fe). This collectible represents iron ore, where iron is commonly bonded with oxygen in minerals such as hematite (Fe₂O₃) and magnetite (Fe₃O₄)."
        case .carbon:
            "Pure carbon is made only of carbon atoms (C). Different arrangements of those atoms create graphite, diamond, graphene, and amorphous carbon such as soot or charcoal."
        case .steel:
            "Steel is mainly iron atoms with a controlled amount of carbon, often alongside small amounts of other elements chosen for specific properties."
        }
    }

    var whereFound: [String] {
        switch self {
        case .iron:
            [
                "Hematite and magnetite deposits in Earth's crust",
                "Earth's iron-rich core and many metallic meteorites",
                "Living organisms in small amounts, including iron used in hemoglobin"
            ]
        case .carbon:
            [
                "Every known living organism and organic molecule",
                "Graphite, diamond, coal, petroleum, and natural gas deposits",
                "Carbonate rocks and carbon dioxide in the atmosphere and oceans"
            ]
        case .steel:
            [
                "Buildings, vehicles, tools, rails, machines, and appliances",
                "Produced in steelworks rather than mined as a natural element"
            ]
        }
    }

    var commonForms: [String] {
        switch self {
        case .iron:
            [
                "Silvery-gray metallic iron",
                "Dark magnetite and reddish-brown hematite ore",
                "Iron oxides commonly recognized as rust"
            ]
        case .carbon:
            [
                "Soft, dark, layered graphite",
                "Clear or colored crystalline diamond",
                "Graphene sheets and amorphous soot or charcoal"
            ]
        case .steel:
            [
                "Carbon steel, stainless steel, and specialized alloy steels",
                "Sheets, beams, wire, tools, and cast or forged components"
            ]
        }
    }

    var tutorPrompt: String {
        "Teach me about \(title.lowercased()) using short questions and memory tips. Connect the explanation to the Pixel Quest steel-sword recipe, but clearly separate real science from the simplified game mechanic."
    }

    var studyContext: String {
        "Pixel Quest material: \(title) (\(symbol)). \(summary) Key facts: \(facts.joined(separator: " ")) Ask recall questions, give hints before answers, correct misconceptions, and explain that combining one crystal of iron with one crystal of carbon is only a game abstraction."
    }
}

private struct PixelLearningHUD: View {
    let ironUnlocked: Bool
    let carbonUnlocked: Bool
    let steelUnlocked: Bool
    let select: (PixelLearningMaterial) -> Void

    var body: some View {
        HStack(spacing: 7) {
            if ironUnlocked {
                materialButton(.iron)
            }
            if carbonUnlocked {
                materialButton(.carbon)
            }
            if steelUnlocked {
                materialButton(.steel)
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.72), value: ironUnlocked)
        .animation(.spring(response: 0.35, dampingFraction: 0.72), value: carbonUnlocked)
        .animation(.spring(response: 0.35, dampingFraction: 0.72), value: steelUnlocked)
    }

    private func materialButton(_ material: PixelLearningMaterial) -> some View {
        Button {
            select(material)
        } label: {
            ZStack(alignment: .bottomTrailing) {
                Image(material.imageName)
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                    .padding(5)

                Text(material.symbol)
                    .font(.system(size: 7, weight: .black, design: .monospaced))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(material.accent, in: Capsule())
            }
            .frame(width: 48, height: 48)
            .background(.black.opacity(0.76), in: RoundedRectangle(cornerRadius: 11))
            .overlay {
                RoundedRectangle(cornerRadius: 11)
                    .stroke(material.accent.opacity(0.62), lineWidth: 1)
            }
            .shadow(color: material.accent.opacity(0.3), radius: 7)
        }
        .buttonStyle(.plain)
        .transition(.scale.combined(with: .opacity))
        .accessibilityLabel("Learn about \(material.title)")
    }
}

private struct PixelMaterialPickupCutscene: View {
    let material: PixelLearningMaterial
    let onFinished: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var transitionProgress: CGFloat = 0
    @State private var isContentVisible = false
    @State private var isTransitioning = true

    var body: some View {
        ZStack {
            if isContentVisible {
                PixelQuestBackground()

                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 18) {
                        Text("MATERIAL ACQUIRED")
                            .font(.system(size: 11, weight: .black, design: .monospaced))
                            .tracking(3)
                            .foregroundStyle(material.accent)

                        Image(material.imageName)
                            .resizable()
                            .interpolation(.none)
                            .scaledToFit()
                            .frame(width: 132, height: 132)
                            .padding(12)
                            .background(
                                material.accent.opacity(0.09),
                                in: RoundedRectangle(cornerRadius: 24)
                            )
                            .overlay {
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(material.accent.opacity(0.38), lineWidth: 2)
                            }

                        Text("\(material.title.uppercased()) ACQUIRED")
                            .font(.system(size: 34, weight: .black, design: .monospaced))
                            .minimumScaleFactor(0.68)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white)

                        HStack(spacing: 10) {
                            PixelPickupStat(
                                heading: "SYMBOL",
                                value: material.symbol,
                                accent: material.accent
                            )
                            PixelPickupStat(
                                heading: "AT ROOM TEMP",
                                value: material.roomTemperatureState,
                                accent: material.accent
                            )
                        }

                        PixelPickupInfoCard(
                            heading: "PHYSICAL STATE",
                            text: material.phaseDetails,
                            accent: material.accent
                        )

                        PixelPickupInfoCard(
                            heading: "WHAT IT IS MADE OF",
                            text: material.compositionDetails,
                            accent: material.accent
                        )

                        PixelPickupBulletCard(
                            heading: "WHERE IT APPEARS",
                            items: material.whereFound,
                            accent: material.accent
                        )

                        PixelPickupBulletCard(
                            heading: "COMMON FORMS",
                            items: material.commonForms,
                            accent: material.accent
                        )
                        }
                        .frame(maxWidth: 520)
                        .padding(.horizontal, 22)
                        .padding(.top, 56)
                        .padding(.bottom, 24)
                        .frame(maxWidth: .infinity)
                    }

                    backToQuestButton
                        .zIndex(2)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
        .overlay {
            if transitionProgress < 1.999 {
                PixelQuestTransition(progress: transitionProgress)
                    .allowsHitTesting(true)
            }
        }
        .ignoresSafeArea(edges: [.top, .horizontal])
        .onAppear(perform: enterCutscene)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(material.title) material acquired")
    }

    private var backToQuestButton: some View {
        Button(action: leaveCutscene) {
            Text("BACK TO QUEST")
                .font(.system(size: 14, weight: .black, design: .monospaced))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background(
                    LinearGradient(
                        colors: [
                            material.accent.opacity(0.92),
                            .blue.opacity(0.88),
                            .purple.opacity(0.84)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    in: RoundedRectangle(cornerRadius: 15)
                )
        }
        .buttonStyle(.plain)
        .disabled(isTransitioning)
        .padding(.horizontal, 22)
        .padding(.top, 12)
        .padding(.bottom, 76)
        .background(.black.opacity(0.86))
    }

    private func enterCutscene() {
        guard !reduceMotion else {
            isContentVisible = true
            isTransitioning = false
            transitionProgress = 2
            return
        }

        transitionProgress = 0
        isContentVisible = false
        isTransitioning = true

        withAnimation(.smooth(duration: 0.64)) {
            transitionProgress = 1
        }

        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(660))
            isContentVisible = true
            try? await Task.sleep(for: .milliseconds(70))
            withAnimation(.smooth(duration: 0.74)) {
                transitionProgress = 2
            }
            try? await Task.sleep(for: .milliseconds(760))
            isTransitioning = false
        }
    }

    private func leaveCutscene() {
        guard !isTransitioning else { return }
        guard !reduceMotion else {
            onFinished()
            return
        }

        isTransitioning = true
        transitionProgress = 0
        withAnimation(.smooth(duration: 0.58)) {
            transitionProgress = 1
        }

        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(600))
            isContentVisible = false
            try? await Task.sleep(for: .milliseconds(70))
            withAnimation(.smooth(duration: 0.72)) {
                transitionProgress = 2
            }
            try? await Task.sleep(for: .milliseconds(740))
            onFinished()
        }
    }
}

private struct PixelPickupStat: View {
    let heading: String
    let value: String
    let accent: Color

    var body: some View {
        VStack(spacing: 5) {
            Text(heading)
                .font(.system(size: 8, weight: .black, design: .monospaced))
                .foregroundStyle(accent)
            Text(value)
                .font(.system(size: 13, weight: .black, design: .monospaced))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 62)
        .padding(.horizontal, 8)
        .background(.black.opacity(0.34), in: RoundedRectangle(cornerRadius: 13))
        .overlay {
            RoundedRectangle(cornerRadius: 13)
                .stroke(accent.opacity(0.25), lineWidth: 1)
        }
    }
}

private struct PixelPickupInfoCard: View {
    let heading: String
    let text: String
    let accent: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text(heading)
                .font(.system(size: 10, weight: .black, design: .monospaced))
                .foregroundStyle(accent)
            Text(text)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.78))
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.black.opacity(0.3), in: RoundedRectangle(cornerRadius: 16))
    }
}

private struct PixelPickupBulletCard: View {
    let heading: String
    let items: [String]
    let accent: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 11) {
            Text(heading)
                .font(.system(size: 10, weight: .black, design: .monospaced))
                .foregroundStyle(accent)

            ForEach(items, id: \.self) { item in
                HStack(alignment: .top, spacing: 9) {
                    Rectangle()
                        .fill(accent)
                        .frame(width: 6, height: 6)
                        .padding(.top, 6)
                    Text(item)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.76))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.black.opacity(0.3), in: RoundedRectangle(cornerRadius: 16))
    }
}

private struct PixelMaterialLearningView: View {
    let material: PixelLearningMaterial

    @State private var isShowingTutor = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                PixelQuestBackground()

                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        HStack(spacing: 16) {
                            Image(material.imageName)
                                .resizable()
                                .interpolation(.none)
                                .scaledToFit()
                                .frame(width: 88, height: 88)
                                .padding(8)
                                .background(material.accent.opacity(0.1), in: RoundedRectangle(cornerRadius: 18))

                            VStack(alignment: .leading, spacing: 5) {
                                Text(material.symbol)
                                    .font(.system(size: 12, weight: .black, design: .monospaced))
                                    .foregroundStyle(material.accent)

                                Text(material.title.uppercased())
                                    .font(.system(size: 27, weight: .black, design: .monospaced))
                                    .foregroundStyle(.white)

                                Text("PIXEL QUEST LEARNING MOMENT")
                                    .font(.system(size: 9, weight: .black, design: .monospaced))
                                    .foregroundStyle(.white.opacity(0.46))
                            }
                        }

                        Text(material.summary)
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white.opacity(0.78))
                            .lineSpacing(4)

                        VStack(alignment: .leading, spacing: 12) {
                            Text("REMEMBER")
                                .font(.system(size: 11, weight: .black, design: .monospaced))
                                .foregroundStyle(material.accent)

                            ForEach(material.facts, id: \.self) { fact in
                                HStack(alignment: .top, spacing: 10) {
                                    Image(systemName: "sparkle")
                                        .foregroundStyle(material.accent)
                                    Text(fact)
                                        .font(.system(size: 14, weight: .medium, design: .rounded))
                                        .foregroundStyle(.white.opacity(0.72))
                                }
                            }
                        }
                        .padding(16)
                        .background(.black.opacity(0.28), in: RoundedRectangle(cornerRadius: 16))

                        Button {
                            isShowingTutor = true
                        } label: {
                            Label("ASK THE AI TUTOR", systemImage: "sparkles")
                                .font(.system(size: 13, weight: .black, design: .monospaced))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                                .background(
                                    LinearGradient(
                                        colors: [.cyan, .blue, .purple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ),
                                    in: RoundedRectangle(cornerRadius: 15)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(22)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(.cyan)
                }
            }
        }
        .sheet(isPresented: $isShowingTutor) {
            TutorView(
                initialPrompt: material.tutorPrompt,
                isPresentedModally: true,
                contextTitle: "\(material.title) AI Tutor",
                studyContext: material.studyContext
            )
        }
    }
}

struct PixelQuestForgeView: View {
    private let requiredIronCount = 5
    private let requiredCarbonCount = 1

    @Binding var ironCount: Int
    @Binding var carbonCount: Int
    @Binding var hasSteelIngot: Bool
    @Binding var hasSteelSword: Bool
    @Binding var selectedLearningMaterial: PixelLearningMaterial?

    @State private var ironLoaded = false
    @State private var carbonLoaded = false
    @State private var isForging = false
    @State private var workshopMessage = "Load 5 iron ores and 1 measured carbon shard."

    private var forgeReady: Bool {
        ironLoaded && carbonLoaded && !isForging && !hasSteelIngot && !hasSteelSword
    }

    var body: some View {
        ZStack {
            PixelQuestBackground()

            ScrollView {
                VStack(spacing: 18) {
                    VStack(spacing: 5) {
                        Text("MOON FORGE")
                            .font(.system(size: 28, weight: .black, design: .monospaced))
                            .foregroundStyle(.white)

                        Text("5 iron ores + 1 carbon shard → steel")
                            .font(.system(size: 13, weight: .bold, design: .monospaced))
                            .foregroundStyle(.cyan.opacity(0.78))

                        Text("The shard represents a small measured carbon dose; real steel remains overwhelmingly iron.")
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white.opacity(0.52))
                            .multilineTextAlignment(.center)
                    }

                    PixelForgeWorkshopScene(isForging: isForging)

                    Text(workshopMessage)
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(Color.black.opacity(0.3), in: RoundedRectangle(cornerRadius: 12))

                    VStack(spacing: 9) {
                        Text("TAP BOTH MATERIAL TABS TO LOAD THE FORGE")
                            .font(.system(size: 10, weight: .black, design: .monospaced))
                            .foregroundStyle(.white.opacity(0.58))

                        ZStack {
                            Image("PixelQuestMaterialTabs")
                                .resizable()
                                .interpolation(.none)
                                .scaledToFill()
                                .opacity(0.78)
                                .allowsHitTesting(false)

                            HStack(spacing: 12) {
                                PixelTapMaterialTab(
                                    imageName: "PixelQuestIronOre",
                                    title: "IRON ORE",
                                    countText: "\(ironCount)/5",
                                    color: .orange,
                                    isLoaded: ironLoaded,
                                    isAvailable: ironCount >= requiredIronCount && !ironLoaded,
                                    action: loadIron
                                )

                                PixelTapMaterialTab(
                                    imageName: "PixelQuestCarbonCrystal",
                                    title: "CARBON SHARD",
                                    countText: "\(carbonCount)/1",
                                    color: .cyan,
                                    isLoaded: carbonLoaded,
                                    isAvailable: carbonCount >= requiredCarbonCount && !carbonLoaded,
                                    action: loadCarbon
                                )
                            }
                            .padding(11)
                        }
                        .frame(height: 132)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }

                    Button(action: smeltSteel) {
                        HStack(spacing: 10) {
                            Image(systemName: "flame.fill")
                            Text(isForging ? "FORGING…" : "FIRE THE FORGE")
                        }
                        .font(.system(size: 13, weight: .black, design: .monospaced))
                        .foregroundStyle(forgeReady ? .white : .white.opacity(0.35))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            forgeReady ? Color.orange.opacity(0.86) : Color.white.opacity(0.07),
                            in: RoundedRectangle(cornerRadius: 14)
                        )
                    }
                    .buttonStyle(.plain)
                    .disabled(!forgeReady)

                    VStack(spacing: 12) {
                        Text("CRAFTING TABLE")
                            .font(.system(size: 12, weight: .black, design: .monospaced))
                            .foregroundStyle(.purple)

                        HStack(spacing: 18) {
                            if hasSteelIngot && !hasSteelSword {
                                Button(action: craftSteelSword) {
                                    VStack(spacing: 4) {
                                        Image("PixelQuestSteelIngot")
                                            .resizable()
                                            .interpolation(.none)
                                            .scaledToFit()
                                            .frame(width: 68, height: 54)
                                        Text("TAP STEEL")
                                            .font(.system(size: 9, weight: .black, design: .monospaced))
                                            .foregroundStyle(.white)
                                    }
                                    .padding(8)
                                    .background(.purple.opacity(0.18), in: RoundedRectangle(cornerRadius: 12))
                                }
                                .buttonStyle(.plain)
                            } else {
                                Text(hasSteelSword ? "STEEL USED" : "SMELT STEEL FIRST")
                                    .font(.system(size: 10, weight: .black, design: .monospaced))
                                    .foregroundStyle(.white.opacity(0.34))
                                    .frame(width: 94)
                            }

                            Image(systemName: "arrow.right")
                                .foregroundStyle(.white.opacity(0.42))

                            ZStack {
                                Image("PixelQuestCraftingTable")
                                    .resizable()
                                    .interpolation(.none)
                                    .scaledToFit()
                                    .frame(width: 112, height: 90)

                                if hasSteelSword {
                                    Image("PixelQuestSteelSword")
                                        .resizable()
                                        .interpolation(.none)
                                        .scaledToFit()
                                        .frame(width: 74, height: 74)
                                        .shadow(color: .cyan.opacity(0.45), radius: 10)
                                } else {
                                    Text("TAP STEEL\nTO CRAFT")
                                        .font(.system(size: 9, weight: .black, design: .monospaced))
                                        .foregroundStyle(.white.opacity(0.78))
                                        .multilineTextAlignment(.center)
                                }
                            }
                            .frame(width: 130, height: 100)
                            .background(.black.opacity(0.24), in: RoundedRectangle(cornerRadius: 14))
                            .overlay {
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(.purple.opacity(0.45), style: StrokeStyle(lineWidth: 2, dash: [5, 4]))
                            }
                        }
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .background(Color.black.opacity(0.3), in: RoundedRectangle(cornerRadius: 18))
                    .overlay {
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(.purple.opacity(0.28), lineWidth: 1)
                    }
                    .padding(.bottom, 80)
                }
                .frame(maxWidth: 520)
                .padding(20)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Forge Workshop")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func smeltSteel() {
        guard forgeReady,
              ironCount >= requiredIronCount,
              carbonCount >= requiredCarbonCount else { return }
        ironCount -= requiredIronCount
        carbonCount -= requiredCarbonCount
        isForging = true
        workshopMessage = "The forge is heating and combining the materials…"

        Task {
            try? await Task.sleep(for: .milliseconds(1300))
            guard !Task.isCancelled else { return }
            ironLoaded = false
            carbonLoaded = false
            hasSteelIngot = true
            isForging = false
            workshopMessage = "Steel created. Drag the ingot onto the crafting table."
        }
    }

    private func loadIron() {
        guard ironCount >= requiredIronCount, !ironLoaded else { return }
        withAnimation(.spring(response: 0.3, dampingFraction: 0.72)) {
            ironLoaded = true
        }
        workshopMessage = carbonLoaded
            ? "Both materials loaded. Fire the forge!"
            : "Five iron ores loaded. Tap the carbon shard."
    }

    private func loadCarbon() {
        guard carbonCount >= requiredCarbonCount, !carbonLoaded else { return }
        withAnimation(.spring(response: 0.3, dampingFraction: 0.72)) {
            carbonLoaded = true
        }
        workshopMessage = ironLoaded
            ? "Both materials loaded. Fire the forge!"
            : "Carbon loaded. Tap the iron ore tab."
    }

    private func craftSteelSword() {
        guard hasSteelIngot, !hasSteelSword else { return }
        hasSteelIngot = false
        hasSteelSword = true
        workshopMessage = "Steel sword complete! Knowledge became gear."
        selectedLearningMaterial = .steel
    }
}

private struct PixelForgeWorkshopScene: View {
    let isForging: Bool

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 20.0)) { context in
            let elapsed = context.date.timeIntervalSinceReferenceDate
            let flame = isForging ? (sin(elapsed * 12) + 1) * 0.5 : 0.18

            ZStack {
                PixelForgeFloor()

                PixelForgeAnimatedImage(isActive: true)
                    .frame(width: 150, height: 150)
                    .scaleEffect(isForging ? 1 + flame * 0.018 : 1)
                    .shadow(
                        color: .orange.opacity(isForging ? 0.42 + flame * 0.3 : 0.12),
                        radius: isForging ? 18 + flame * 10 : 7
                    )

                if isForging {
                    ForEach(0..<5, id: \.self) { index in
                        Circle()
                            .fill(index.isMultiple(of: 2) ? .yellow : .orange)
                            .frame(width: 4, height: 4)
                            .offset(
                                x: CGFloat(index - 2) * 11,
                                y: 20 - CGFloat((elapsed * 34 + Double(index * 13)).truncatingRemainder(dividingBy: 48))
                            )
                            .opacity(0.8)
                    }
                }
            }
        }
        .frame(height: 220)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(.orange.opacity(0.28), lineWidth: 2)
        }
    }
}

private struct PixelCraftDropSlot: View {
    let title: String
    let symbol: String
    let color: Color
    let isFilled: Bool
    let receive: (String) -> Bool

    var body: some View {
        VStack(spacing: 7) {
            Text(title)
                .font(.system(size: 9, weight: .black, design: .monospaced))
                .foregroundStyle(.white.opacity(0.46))

            Text(isFilled ? symbol : "DROP")
                .font(.system(size: isFilled ? 24 : 11, weight: .black, design: .monospaced))
                .foregroundStyle(isFilled ? color : .white.opacity(0.42))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 82)
        .background(color.opacity(isFilled ? 0.18 : 0.05), in: RoundedRectangle(cornerRadius: 14))
        .overlay {
            RoundedRectangle(cornerRadius: 14)
                .stroke(
                    color.opacity(isFilled ? 0.72 : 0.3),
                    style: StrokeStyle(lineWidth: 2, dash: isFilled ? [] : [5, 4])
                )
        }
        .dropDestination(for: String.self) { items, _ in
            guard let item = items.first else { return false }
            return receive(item)
        }
    }
}

private struct PixelDraggableMaterial: View {
    let imageName: String
    let title: String
    let payload: String
    let color: Color
    let isAvailable: Bool

    var body: some View {
        VStack(spacing: 5) {
            Image(imageName)
                .resizable()
                .interpolation(.none)
                .scaledToFit()
                .saturation(0.42)
                .frame(width: 52, height: 44)

            Text(title)
                .font(.system(size: 9, weight: .black, design: .monospaced))
                .foregroundStyle(isAvailable ? .white : .white.opacity(0.3))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(color.opacity(isAvailable ? 0.1 : 0.03), in: RoundedRectangle(cornerRadius: 12))
        .opacity(isAvailable ? 1 : 0.46)
        .draggable(payload)
        .allowsHitTesting(isAvailable)
    }
}

private struct PixelTapMaterialTab: View {
    let imageName: String
    let title: String
    let countText: String
    let color: Color
    let isLoaded: Bool
    let isAvailable: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 9) {
                Image(imageName)
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: 46, height: 46)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 10, weight: .black, design: .monospaced))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.72)
                    Text(isLoaded ? "LOADED" : countText)
                        .font(.system(size: 11, weight: .black, design: .monospaced))
                        .foregroundStyle(isLoaded ? .green : color)
                }

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity, minHeight: 82)
            .background(
                Color.black.opacity(isAvailable || isLoaded ? 0.38 : 0.58),
                in: RoundedRectangle(cornerRadius: 10)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isLoaded ? Color.green : color.opacity(0.76), lineWidth: isLoaded ? 3 : 2)
            }
            .scaleEffect(isLoaded ? 0.96 : 1)
            .opacity(isAvailable || isLoaded ? 1 : 0.46)
        }
        .buttonStyle(.plain)
        .disabled(!isAvailable || isLoaded)
        .accessibilityLabel("\(title), \(isLoaded ? "loaded" : countText)")
    }
}

private struct PixelForgeFloor: View {
    var body: some View {
        Canvas { context, size in
            context.fill(
                Path(CGRect(origin: .zero, size: size)),
                with: .color(Color(red: 0.07, green: 0.068, blue: 0.075))
            )

            let tile: CGFloat = 32
            for x in stride(from: 0, through: size.width, by: tile) {
                context.stroke(
                    Path(CGRect(x: x, y: 0, width: 1, height: size.height)),
                    with: .color(.white.opacity(0.025)),
                    lineWidth: 1
                )
            }
            for y in stride(from: 0, through: size.height, by: tile) {
                context.stroke(
                    Path(CGRect(x: 0, y: y, width: size.width, height: 1)),
                    with: .color(.white.opacity(0.025)),
                    lineWidth: 1
                )
            }

            for index in 0..<56 {
                let x = CGFloat((index * 83 + 17) % 991) / 990 * size.width
                let y = CGFloat((index * 47 + 31) % 983) / 982 * size.height
                let color: Color = index.isMultiple(of: 7)
                    ? .orange.opacity(0.18)
                    : .white.opacity(0.08)
                context.fill(
                    Path(CGRect(x: x, y: y, width: index.isMultiple(of: 9) ? 2 : 1, height: 1)),
                    with: .color(color)
                )
            }
        }
    }
}

struct SteelLearningMoment: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.skillSyncBackground.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "sparkles")
                        .foregroundStyle(.cyan)
                    Text("STEEL SWORD CREATED")
                        .font(.system(size: 17, weight: .black, design: .monospaced))
                        .foregroundStyle(.white)
                }

                learningFact(
                    label: "SCIENTIFIC FACT",
                    text: "Steel is an iron-based alloy. Carbon content and processing can strongly affect properties such as hardness and strength.",
                    color: .cyan
                )

                learningFact(
                    label: "GAME INTERPRETATION",
                    text: "Collecting one iron and one carbon creates a stronger sword. Real steelmaking is more complex than this recipe.",
                    color: .purple
                )

                Text("Think about it: Why might changing carbon content change the behavior of an iron-based material?")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                Button("Continue Quest") {
                    dismiss()
                }
                .buttonStyle(SkillSyncButtonStyle())
                .frame(maxWidth: .infinity)
            }
            .padding(24)
        }
    }

    private func learningFact(
        label: String,
        text: String,
        color: Color
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 11, weight: .black, design: .monospaced))
                .foregroundStyle(color)

            Text(text)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.72))
        }
        .padding(14)
        .background(color.opacity(0.08), in: RoundedRectangle(cornerRadius: 14))
    }
}

struct PixelResourceSprite: View {
    let imageName: String
    let label: String
    let glowColor: Color

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 12.0)) { context in
            let elapsed = context.date.timeIntervalSinceReferenceDate
            let pulse = reduceMotion ? 0.5 : (sin(elapsed * 3.2) + 1) * 0.5

            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                glowColor.opacity(0.38 + pulse * 0.18),
                                glowColor.opacity(0.08),
                                .clear
                            ],
                            center: .center,
                            startRadius: 1,
                            endRadius: 28
                        )
                    )
                    .scaleEffect(0.90 + pulse * 0.16)

                Image(imageName)
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .saturation(0.72)
                    .contrast(0.96)
                    .brightness(-0.035)
                    .padding(3)
                    .shadow(
                        color: glowColor.opacity(0.52 + pulse * 0.24),
                        radius: 4 + pulse * 4
                    )
            }
        }
        .accessibilityLabel(label)
    }
}

private struct PixelRustMonsterSprite: View {
    let direction: RobotDirection
    let action: PixelRustMonsterAction

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var animationStart = Date()

    private var frameNames: [String] {
        let prefix: String
        let frameCount: Int
        switch action {
        case .idle:
            prefix = "Idle"
            frameCount = 5
        case .moving:
            prefix = "Walk"
            frameCount = 9
        case .attacking:
            prefix = "Attack"
            frameCount = 7
        }
        return (0..<frameCount).map {
            "PixelQuestRustMonster\(prefix)\(direction.assetName)\($0)"
        }
    }

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { context in
            let frames = frameNames
            let framesPerSecond: Double = switch action {
            case .idle: 6
            case .moving: 12
            case .attacking: 15
            }
            let elapsed = max(context.date.timeIntervalSince(animationStart), 0)
            let frameIndex = reduceMotion
                ? 0
                : Int(elapsed * framesPerSecond) % frames.count

            Image(frames[frameIndex])
                .resizable()
                .interpolation(.none)
                .scaledToFit()
                .shadow(color: .orange.opacity(0.32), radius: 5, y: 3)
        }
        .onChange(of: direction.rawValue) { animationStart = Date() }
        .onChange(of: action.rawValue) { animationStart = Date() }
        .accessibilityLabel("Rust monster \(action.rawValue)")
    }
}

private struct PixelMoonDepthBarrier: View {
    let seed: Int

    var body: some View {
        Canvas { context, size in
            let back = CGRect(
                x: size.width * 0.04,
                y: size.height * 0.12,
                width: size.width * 0.92,
                height: size.height * 0.58
            )
            context.fill(
                Path(roundedRect: back, cornerRadius: size.height * 0.2),
                with: .linearGradient(
                    Gradient(colors: [
                        Color(red: 0.30, green: 0.30, blue: 0.34),
                        Color(red: 0.13, green: 0.13, blue: 0.16),
                        Color(red: 0.055, green: 0.055, blue: 0.07)
                    ]),
                    startPoint: CGPoint(x: back.midX, y: back.minY),
                    endPoint: CGPoint(x: back.midX, y: back.maxY)
                )
            )

            let front = CGRect(
                x: size.width * 0.08,
                y: size.height * 0.46,
                width: size.width * 0.84,
                height: size.height * 0.34
            )
            context.fill(
                Path(roundedRect: front, cornerRadius: size.height * 0.12),
                with: .color(Color.black.opacity(0.62))
            )

            for index in 0..<8 {
                let x = CGFloat((index * 31 + seed * 17) % 89) / 89 * size.width
                let y = size.height * (0.18 + CGFloat((index * 13 + seed * 7) % 31) / 100)
                let pebble = CGRect(x: x, y: y, width: 3, height: 2)
                context.fill(Path(ellipseIn: pebble), with: .color(.white.opacity(0.16)))
            }
        }
        .shadow(color: .black.opacity(0.72), radius: 4, y: 5)
        .accessibilityHidden(true)
    }
}

private struct PixelForgeAnimatedImage: View {
    let isActive: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let frameNames = (0..<5).map { "PixelQuestForgeFrame\($0)" }

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 10.0)) { context in
            let elapsed = context.date.timeIntervalSinceReferenceDate
            let framesPerSecond = isActive ? 6.0 : 2.0
            let frameIndex = reduceMotion
                ? 0
                : Int(elapsed * framesPerSecond) % frameNames.count

            Image(frameNames[frameIndex])
                .resizable()
                .interpolation(.none)
                .scaledToFit()
        }
        .accessibilityHidden(true)
    }
}

private struct PixelForgeMapSprite: View {
    let isUnlocked: Bool

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            (isUnlocked ? Color.orange : Color.gray).opacity(0.28),
                            .clear
                        ],
                        center: .center,
                        startRadius: 2,
                        endRadius: 36
                    )
                )

            PixelForgeAnimatedImage(isActive: true)
                .saturation(isUnlocked ? 1 : 0.48)
                .brightness(isUnlocked ? 0 : -0.12)
                .shadow(
                    color: isUnlocked ? .orange.opacity(0.46) : .black.opacity(0.62),
                    radius: isUnlocked ? 9 : 4,
                    y: 3
                )
        }
        .accessibilityHidden(true)
    }
}

struct PixelMapGrid: View {
    var body: some View {
        Canvas { context, size in
            let tile: CGFloat = 22
            let columns = Int(ceil(size.width / tile))
            let rows = Int(ceil(size.height / tile))

            for row in 0..<rows {
                for column in 0..<columns {
                    let rect = CGRect(
                        x: CGFloat(column) * tile,
                        y: CGFloat(row) * tile,
                        width: tile,
                        height: tile
                    )
                    let isPath = row == rows / 2
                        || column == columns / 2
                        || (row + column) % 7 == 0
                    let color = isPath
                        ? Color(red: 0.13, green: 0.22, blue: 0.19)
                        : ((row + column).isMultiple(of: 2)
                            ? Color(red: 0.045, green: 0.15, blue: 0.13)
                            : Color(red: 0.035, green: 0.12, blue: 0.11))
                    context.fill(Path(rect), with: .color(color))
                }
            }
        }
    }
}

struct PixelGameBoard: View {
    let size: Int

    var body: some View {
        Canvas { context, canvasSize in
            let base = CGRect(origin: .zero, size: canvasSize)
            context.fill(
                Path(base),
                with: .color(
                    Color(red: 0.115, green: 0.112, blue: 0.12)
                )
            )

            let cell = canvasSize.width / CGFloat(size)
            for row in 0..<size {
                for column in 0..<size {
                    let tileRect = CGRect(
                        x: CGFloat(column) * cell,
                        y: CGFloat(row) * cell,
                        width: cell,
                        height: cell
                    )
                    let tone = (row * 7 + column * 11).isMultiple(of: 3)
                        ? Color.white.opacity(0.012)
                        : Color.black.opacity(0.016)
                    context.fill(Path(tileRect), with: .color(tone))
                }
            }

            let craterCenters: [CGPoint] = [
                CGPoint(
                    x: canvasSize.width * 0.61,
                    y: canvasSize.height * 0.63
                ),
                CGPoint(
                    x: canvasSize.width * 0.34,
                    y: canvasSize.height * 0.39
                )
            ]
            for (index, center) in craterCenters.enumerated() {
                let diameter = cell * (index == 0 ? 0.68 : 0.44)
                let crater = CGRect(
                    x: center.x - diameter * 0.5,
                    y: center.y - diameter * 0.5,
                    width: diameter,
                    height: diameter * 0.72
                )
                context.fill(
                    Path(ellipseIn: crater),
                    with: .color(.black.opacity(0.12))
                )
                let inner = crater.insetBy(
                    dx: diameter * 0.13,
                    dy: diameter * 0.09
                )
                context.stroke(
                    Path(ellipseIn: inner),
                    with: .color(.white.opacity(0.035)),
                    lineWidth: 1
                )
            }

            let speckColors: [Color] = [
                Color(red: 0.38, green: 0.38, blue: 0.4),
                Color(red: 0.25, green: 0.24, blue: 0.25),
                Color(red: 0.31, green: 0.23, blue: 0.18)
            ]
            let speckCount = max(70, Int(canvasSize.width / 4))
            for index in 0..<speckCount {
                let xSeed = (index * 73 + 19) % 997
                let ySeed = (index * 151 + 47) % 991
                let x = CGFloat(xSeed) / 996 * canvasSize.width
                let y = CGFloat(ySeed) / 990 * canvasSize.height
                let side: CGFloat = index.isMultiple(of: 11) ? 2 : 1
                let speck = CGRect(x: x, y: y, width: side, height: side)
                context.fill(
                    Path(speck),
                    with: .color(
                        speckColors[index % speckColors.count]
                            .opacity(index.isMultiple(of: 5) ? 0.42 : 0.25)
                    )
                )
            }
        }
    }
}

struct PixelQuestBackground: View {
    var body: some View {
        ZStack {
            Color(red: 0.012, green: 0.025, blue: 0.075)

            LinearGradient(
                colors: [
                    .cyan.opacity(0.13),
                    .clear,
                    .purple.opacity(0.15)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Canvas { context, size in
                let spacing: CGFloat = 24
                for x in stride(from: 0, through: size.width, by: spacing) {
                    for y in stride(from: 0, through: size.height, by: spacing) {
                        let seed = Int(x / spacing) * 17 + Int(y / spacing) * 31
                        guard seed.isMultiple(of: 9) else { continue }
                        context.fill(
                            Path(
                                CGRect(
                                    x: x,
                                    y: y,
                                    width: 2,
                                    height: 2
                                )
                            ),
                            with: .color(.cyan.opacity(0.25))
                        )
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct PixelQuestTransition: View, Animatable {
    var progress: CGFloat

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    var body: some View {
        Canvas { context, size in
            let block: CGFloat = 9
            let columns = Int(ceil(size.width / block)) + 1
            let rows = Int(ceil(size.height / block)) + 1
            let isFilling = progress <= 1
            let phase = min(max(isFilling ? progress : progress - 1, 0), 1)
            let travel = size.width + block * 4
            let baseBoundary = -block * 2 + travel * phase
            let colors: [Color] = [
                Color(red: 0.025, green: 0.027, blue: 0.032),
                Color(red: 0.065, green: 0.069, blue: 0.078),
                Color(red: 0.11, green: 0.116, blue: 0.13),
                Color(red: 0.17, green: 0.178, blue: 0.195),
                Color(red: 0.25, green: 0.26, blue: 0.28),
                Color(red: 0.36, green: 0.37, blue: 0.39)
            ]

            for row in 0..<rows {
                for column in 0..<columns {
                    let center = CGPoint(
                        x: (CGFloat(column) + 0.5) * block,
                        y: (CGFloat(row) + 0.5) * block
                    )
                    let verticalPhase = center.y / max(size.height, 1)
                    let waveOffset =
                        sin(verticalPhase * .pi * 3.2 + phase * .pi * 2.4) * 20
                        + sin(verticalPhase * .pi * 8.5 - phase * .pi) * 6
                    let boundary = baseBoundary + waveOffset
                    let hasWaveCrossedBlock = center.x <= boundary
                    let shouldDraw = isFilling
                        ? hasWaveCrossedBlock
                        : !hasWaveCrossedBlock

                    guard shouldDraw else { continue }

                    let side = block + 0.75
                    let rect = CGRect(
                        x: center.x - side * 0.5,
                        y: center.y - side * 0.5,
                        width: side,
                        height: side
                    )

                    context.fill(
                        Path(rect),
                        with: .linearGradient(
                            Gradient(colors: [
                                colors[(row * 3 + column * 5) % colors.count],
                                colors[(row * 7 + column * 2 + 1) % colors.count]
                            ]),
                            startPoint: rect.origin,
                            endPoint: CGPoint(x: rect.maxX, y: rect.maxY)
                        )
                    )
                }
            }
        }
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }
}
