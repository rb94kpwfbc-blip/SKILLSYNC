import SwiftUI

struct SplashView: View {
    let completion: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var linesConverged = false
    @State private var showLogo = false
    @State private var showLetters = false
    @State private var showCallToAction = false
    @State private var isExiting = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AmbientBackgroundView(isAnimated: !reduceMotion)

                GlowingWaveOverlay(
                    intensity: 0.24,
                    verticalOffset: geometry.size.height * 0.16,
                    isAnimated: !reduceMotion
                )

                if !showLogo {
                    FluidLinesView(converged: linesConverged)
                        .transition(.opacity)
                }

                VStack(spacing: 28) {
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        .blue.opacity(0.22),
                                        .purple.opacity(0.08),
                                        .clear
                                    ],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 125
                                )
                            )
                            .frame(width: 310, height: 310)
                            .blur(radius: 12)

                        FluidLogoView(
                            revealProgress: showLogo ? 1 : 0,
                            isAnimated: !reduceMotion
                        )
                            .frame(width: min(geometry.size.width * 0.72, 340))
                            .aspectRatio(1, contentMode: .fit)
                            .shadow(color: .cyan.opacity(0.28), radius: 18)
                    }
                    .scaleEffect(showLogo ? 1 : 0.94)

                    AnimatedTitle(
                        title: "SkillSync",
                        containerSize: geometry.size,
                        visible: showLetters,
                        reduceMotion: reduceMotion
                    )

                    Text("BUILDING REAL UNDERSTANDING")
                        .font(.system(size: 12, weight: .medium))
                        .tracking(4)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.cyan, .blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .opacity(showLetters ? 1 : 0)

                    Button(action: beginTransition) {
                        HStack(spacing: 12) {
                            Text("Start Learning")

                            Image(systemName: "arrow.right")
                                .font(.system(size: 15, weight: .bold))
                        }
                        .frame(minWidth: 190)
                    }
                    .buttonStyle(SkillSyncButtonStyle())
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white.opacity(0.22), lineWidth: 1)
                            .allowsHitTesting(false)
                    }
                    .shadow(color: .cyan.opacity(0.22), radius: 24, y: 8)
                    .opacity(showCallToAction ? 1 : 0)
                    .scaleEffect(showCallToAction ? 1 : 0.82)
                    .offset(y: showCallToAction ? 0 : 18)
                    .animation(
                        .spring(response: 0.65, dampingFraction: 0.72),
                        value: showCallToAction
                    )
                    .disabled(!showCallToAction)
                }
                .scaleEffect(isExiting ? 1.08 : 1)
                .blur(radius: isExiting ? 10 : 0)
                .opacity(isExiting ? 0 : 1)

                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.skillSyncBackground,
                                .blue.opacity(0.92),
                                .cyan.opacity(0.7)
                            ],
                            center: .center,
                            startRadius: 15,
                            endRadius: 90
                        )
                    )
                    .frame(width: 140, height: 140)
                    .scaleEffect(
                        isExiting
                            ? max(geometry.size.width, geometry.size.height) / 42
                            : 0.01
                    )
                    .opacity(isExiting ? 1 : 0)
                    .blendMode(.screen)
                    .allowsHitTesting(false)
            }
        }
        .task {
            withAnimation(reduceMotion ? nil : .easeInOut(duration: 1.3)) {
                linesConverged = true
            }

            if !reduceMotion {
                try? await Task.sleep(for: .milliseconds(800))
            }

            withAnimation(reduceMotion ? nil : .easeInOut(duration: 1.25)) {
                showLogo = true
            }

            if !reduceMotion {
                try? await Task.sleep(for: .milliseconds(350))
            }

            showLetters = true

            if !reduceMotion {
                try? await Task.sleep(for: .milliseconds(900))
            }
            showCallToAction = true
        }
    }

    private func beginTransition() {
        guard !isExiting else { return }

        withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.75)) {
            isExiting = true
        }

        Task {
            if !reduceMotion {
                try? await Task.sleep(for: .milliseconds(800))
            }
            completion()
        }
    }
}

struct AmbientBackgroundView: View {
    let isAnimated: Bool

    var body: some View {
        TimelineView(
            .animation(
                minimumInterval: 1 / 10,
                paused: !isAnimated
            )
        ) { timeline in
            background(at: animationTime(for: timeline.date))
        }
        .ignoresSafeArea()
    }

    private func background(at time: TimeInterval) -> some View {
        GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height

                ZStack {
                    Color.skillSyncBackground

                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [.cyan.opacity(0.22), .cyan.opacity(0.06), .clear],
                                center: .center,
                                startRadius: 0,
                                endRadius: width * 0.45
                            )
                        )
                        .frame(width: width * 0.9)
                        .offset(
                            x: -width * 0.42 + CGFloat(sin(time * 0.23)) * 38,
                            y: -height * 0.3 + CGFloat(cos(time * 0.19)) * 45
                        )

                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [.purple.opacity(0.24), .purple.opacity(0.07), .clear],
                                center: .center,
                                startRadius: 0,
                                endRadius: width * 0.42
                            )
                        )
                        .frame(width: width * 0.82)
                        .offset(
                            x: width * 0.45 + CGFloat(cos(time * 0.17)) * 42,
                            y: height * 0.28 + CGFloat(sin(time * 0.21)) * 52
                        )

                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [.blue.opacity(0.16), .blue.opacity(0.04), .clear],
                                center: .center,
                                startRadius: 0,
                                endRadius: width * 0.34
                            )
                        )
                        .frame(width: width * 0.68)
                        .offset(
                            x: CGFloat(sin(time * 0.14)) * width * 0.2,
                            y: CGFloat(cos(time * 0.16)) * height * 0.18
                        )

                    Canvas { context, size in
                        for particle in 0..<16 {
                            let seed = Double(particle)
                            let x = size.width * CGFloat(
                                (sin(seed * 12.9898) + 1) / 2
                            )
                            let baseY = size.height * CGFloat(
                                (cos(seed * 7.233) + 1) / 2
                            )
                            let drift = CGFloat(sin(time * 0.32 + seed)) * 12
                            let diameter = CGFloat(1.2) + CGFloat(particle % 3)
                            let opacity = 0.08 + 0.12 * (
                                sin(time * 0.7 + seed * 1.8) + 1
                            ) / 2

                            context.opacity = opacity
                            context.fill(
                                Path(
                                    ellipseIn: CGRect(
                                        x: x,
                                        y: baseY + drift,
                                        width: diameter,
                                        height: diameter
                                    )
                                ),
                                with: .color(particle.isMultiple(of: 2) ? .cyan : .purple)
                            )
                        }
                    }

                    RadialGradient(
                        colors: [.clear, Color.skillSyncBackground.opacity(0.7)],
                        center: .center,
                        startRadius: min(width, height) * 0.2,
                        endRadius: max(width, height) * 0.72
                    )
                }
        }
    }

    private func animationTime(for date: Date) -> TimeInterval {
        isAnimated ? date.timeIntervalSinceReferenceDate : 0
    }
}

struct FluidLogoView: View {
    let revealProgress: CGFloat
    let isAnimated: Bool

    var body: some View {
        TimelineView(
            .animation(
                minimumInterval: 1 / 10,
                paused: !isAnimated
            )
        ) { timeline in
            let time = animationTime(for: timeline.date)

            ZStack {
                Image("SkillSyncLogo")
                    .resizable()
                    .scaledToFit()
                    .opacity(0.58)

                Canvas { context, size in
                    for lineNumber in 0..<12 {
                        var path = Path()
                        let baseY = size.height * CGFloat(lineNumber + 1) / 13

                        for x in stride(from: 0.0, through: size.width, by: 3) {
                            let primaryWave = sin(
                                x * 0.045 + time * 2.2 + Double(lineNumber) * 0.7
                            ) * 9
                            let secondaryWave = cos(
                                x * 0.018 - time * 1.4 + Double(lineNumber)
                            ) * 4
                            let y = baseY + primaryWave + secondaryWave

                            if x == 0 {
                                path.move(to: CGPoint(x: x, y: y))
                            } else {
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }

                        context.stroke(
                            path,
                            with: .linearGradient(
                                Gradient(colors: [.cyan, .blue, .purple]),
                                startPoint: CGPoint(x: 0, y: baseY),
                                endPoint: CGPoint(x: size.width, y: baseY)
                            ),
                            lineWidth: 3
                        )
                    }
                }
                .mask {
                    Image("SkillSyncLogo")
                        .resizable()
                        .scaledToFit()
                }
                .blendMode(.screen)
            }
            .mask {
                RiverRevealMask(
                    progress: revealProgress,
                    time: time
                )
            }
            .opacity(revealProgress <= 0.001 ? 0 : 1)
        }
        .accessibilityHidden(true)
    }

    private func animationTime(for date: Date) -> TimeInterval {
        isAnimated ? date.timeIntervalSinceReferenceDate : 0
    }
}

struct GlowingWaveOverlay: View {
    let intensity: Double
    let verticalOffset: CGFloat
    let isAnimated: Bool

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let time = isAnimated
                    ? timeline.date.timeIntervalSinceReferenceDate
                    : 0

                for lineNumber in 0..<5 {
                    var path = Path()
                    let line = Double(lineNumber)
                    let baseY = size.height * 0.48 + verticalOffset + CGFloat(lineNumber - 2) * 22

                    for x in stride(from: 0.0, through: size.width, by: 4) {
                        let broadWave = sin(x * 0.012 + time * 0.75 + line * 0.65) * 34
                        let softRipple = cos(x * 0.027 - time * 0.52 + line) * 9
                        let y = baseY + broadWave + softRipple

                        if x == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }

                    context.opacity = intensity * (1 - line * 0.11)
                    context.stroke(
                        path,
                        with: .linearGradient(
                            Gradient(colors: [.clear, .cyan, .blue, .purple, .clear]),
                            startPoint: CGPoint(x: 0, y: baseY),
                            endPoint: CGPoint(x: size.width, y: baseY)
                        ),
                        lineWidth: 2.4
                    )
                }
            }
            .blur(radius: 2.5)
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

struct RiverRevealMask: View, Animatable {
    var progress: CGFloat
    let time: TimeInterval

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    var body: some View {
        Canvas { context, size in
            var riverBank = Path()
            let clampedProgress = min(max(progress, 0), 1)
            let amplitude = sin(.pi * clampedProgress) * 24

            riverBank.move(to: .zero)

            for y in stride(from: 0.0, through: size.height, by: 3) {
                let ripple = sin(y * 0.055 - time * 3.4) * amplitude
                let smallerRipple = cos(y * 0.021 + time * 2.1) * amplitude * 0.35
                let leadingX = min(
                    max(size.width * clampedProgress + ripple + smallerRipple, 0),
                    size.width
                )

                riverBank.addLine(to: CGPoint(x: leadingX, y: y))
            }

            riverBank.addLine(to: CGPoint(x: 0, y: size.height))
            riverBank.closeSubpath()
            context.fill(riverBank, with: .color(.white))
        }
    }
}

struct FluidLinesView: View {
    let converged: Bool

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate

                for lineNumber in 0..<7 {
                    var path = Path()
                    let progress = converged ? 1.0 : 0.0
                    let centerY = size.height / 2
                    let startingY =
                        size.height * CGFloat(lineNumber + 1) / 8

                    for x in stride(
                        from: 0.0,
                        through: size.width,
                        by: 5
                    ) {
                        let wave = sin(
                            x * 0.018 +
                            time * 2 +
                            Double(lineNumber)
                        ) * 30

                        let normalY = startingY + wave
                        let targetY = centerY + wave * 0.08
                        let y = normalY + (targetY - normalY) * progress

                        if x == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }

                    let colors: [Color] = [
                        .cyan,
                        .blue,
                        .purple
                    ]

                    context.stroke(
                        path,
                        with: .linearGradient(
                            Gradient(colors: colors),
                            startPoint: .zero,
                            endPoint: CGPoint(
                                x: size.width,
                                y: size.height
                            )
                        ),
                        lineWidth: 2
                    )
                }
            }
        }
        .blur(radius: converged ? 2 : 0)
    }
}

struct AnimatedTitle: View {
    let title: String
    let containerSize: CGSize
    let visible: Bool
    let reduceMotion: Bool

    var body: some View {
        HStack(spacing: 1) {
            ForEach(
                Array(title.enumerated()),
                id: \.offset
            ) { index, letter in
                Text(String(letter))
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        letterGradient(for: index)
                    )
                    .offset(
                        x: visible || reduceMotion ? 0 : startingOffset(for: index).width,
                        y: visible || reduceMotion ? 0 : startingOffset(for: index).height
                    )
                    .opacity(visible ? 1 : 0)
                    .animation(
                        reduceMotion
                            ? .easeInOut(duration: 0.2)
                            : .spring(
                                response: 0.75,
                                dampingFraction: 0.68
                            )
                            .delay(Double(index) * 0.08),
                        value: visible
                    )
            }
        }
    }

    private func startingOffset(for index: Int) -> CGSize {
        switch index % 4 {
        case 0:
            return CGSize(width: -containerSize.width, height: 0)
        case 1:
            return CGSize(width: containerSize.width, height: 0)
        case 2:
            return CGSize(width: 0, height: -containerSize.height)
        default:
            return CGSize(width: 0, height: containerSize.height)
        }
    }

    private func letterGradient(for index: Int) -> LinearGradient {
        let colors: [Color] = index < 5
            ? [.white, .white.opacity(0.85)]
            : [.cyan, .blue, .purple]

        return LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

struct SkillSyncButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(.white)
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
            .background(
                LinearGradient(
                    colors: [.cyan, .blue, .purple],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .opacity(configuration.isPressed ? 0.7 : 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .shadow(color: .blue.opacity(0.3), radius: 12, y: 5)
    }
}
