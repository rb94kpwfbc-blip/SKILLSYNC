import SwiftUI
import SceneKit
import AudioToolbox

struct ExploreTopicsView: View {
    @State private var isExpanded = false

    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            VStack(spacing: 11) {
                NavigationLink {
                    ScienceTopicsView()
                } label: {
                    TopicRowLabel(
                        title: "Science",
                        systemImage: "atom",
                        accent: .cyan,
                        isPlaceholder: false
                    )
                }
                .buttonStyle(.plain)

                ForEach(1...5, id: \.self) { number in
                    TopicRowLabel(
                        title: "Placeholder \(number)",
                        systemImage: "plus.circle.fill",
                        accent: .purple,
                        isPlaceholder: true
                    )
                }
            }
            .padding(.top, 14)
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "books.vertical.fill")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.cyan)
                    .frame(width: 24)
                    .shadow(color: .cyan.opacity(0.45), radius: 8)

                Text("Explore Topics")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                Spacer()
                CartoonLightbulb(isLit: isExpanded)
            }
        }
        .tint(.cyan)
        .padding(18)
        .background(
            LinearGradient(
                colors: [.cyan.opacity(0.13), .white.opacity(0.055)],
                startPoint: .leading,
                endPoint: .trailing
            ),
            in: RoundedRectangle(cornerRadius: 20)
        )
        .overlay {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        .cyan.opacity(isExpanded ? 0.48 : 0.22),
                        lineWidth: 1
                    )

                AuroraConstellationOverlay(
                    cornerRadius: 20,
                    intensity: isExpanded ? 0.95 : 0.4,
                    isActive: isExpanded
                )
            }
        }
        .animation(.spring(response: 0.45, dampingFraction: 0.82), value: isExpanded)
    }
}

struct ScienceTopicsView: View {
    var body: some View {
        ZStack {
            AmbientBackgroundView(isAnimated: true)

            ScrollView {
                VStack(spacing: 16) {
                    BubbleTitle(text: "Science")

                    Text("Choose a topic to begin learning.")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.65))

                    NavigationLink {
                        PeriodicTableLessonView()
                    } label: {
                        TopicRowLabel(
                            title: "Periodic Table of Elements",
                            systemImage: "atom",
                            accent: .cyan,
                            isPlaceholder: false
                        )
                    }
                    .buttonStyle(.plain)

                    ForEach(1...6, id: \.self) { number in
                        TopicRowLabel(
                            title: "Placeholder \(number)",
                            systemImage: "plus.circle.fill",
                            accent: .purple,
                            isPlaceholder: true
                        )
                    }
                }
                .frame(maxWidth: 560)
                .padding(.horizontal, 20)
                .padding(.vertical, 28)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Science Topics")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TopicRowLabel: View {
    let title: String
    let systemImage: String
    let accent: Color
    let isPlaceholder: Bool

    var body: some View {
        HStack(spacing: 13) {
            Image(systemName: systemImage)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(isPlaceholder ? .white.opacity(0.35) : accent)
                .frame(width: 38, height: 38)
                .background(
                    accent.opacity(isPlaceholder ? 0.06 : 0.14),
                    in: RoundedRectangle(cornerRadius: 11)
                )

            Text(title)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(isPlaceholder ? .white.opacity(0.48) : .white)

            Spacer()

            Image(systemName: isPlaceholder ? "lock.fill" : "chevron.right")
                .font(.caption.bold())
                .foregroundStyle(isPlaceholder ? .white.opacity(0.22) : accent)
        }
        .padding(13)
        .background(Color.white.opacity(0.055), in: RoundedRectangle(cornerRadius: 16))
        .overlay {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        accent.opacity(isPlaceholder ? 0.08 : 0.28),
                        lineWidth: 1
                    )

                AuroraConstellationOverlay(
                    cornerRadius: 16,
                    intensity: isPlaceholder ? 0.18 : 0.72,
                    isActive: !isPlaceholder
                )
            }
        }
    }
}

struct PeriodicTableLessonView: View {
    @State private var selectedElement: PeriodicElement?
    @State private var selectedCategory: ElementCategory?

    private let tableRows = Array(
        repeating: GridItem(.fixed(62), spacing: 5),
        count: 7
    )
    private let tableColumnCount = 18
    private let tableRowCount = 7

    var body: some View {
        ZStack {
            AmbientBackgroundView(isAnimated: false)

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Periodic Table")
                            .font(.system(size: 38, weight: .black, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white, .cyan, .blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )

                        Text("Elements are arranged by atomic number and repeating chemical properties.")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white.opacity(0.62))
                    }
                    .padding(.horizontal, 20)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Element Types")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)

                        LazyVGrid(
                            columns: [
                                GridItem(.adaptive(minimum: 140), spacing: 8)
                            ],
                            alignment: .leading,
                            spacing: 8
                        ) {
                            ForEach(ElementCategory.allCases) { category in
                                Button {
                                    selectedCategory = category
                                } label: {
                                    HStack(spacing: 8) {
                                        Circle()
                                            .fill(category.color)
                                            .frame(width: 9, height: 9)
                                            .shadow(color: category.color, radius: 4)

                                        Text(category.title)
                                            .font(.system(size: 12, weight: .bold, design: .rounded))
                                            .foregroundStyle(.white.opacity(0.78))

                                        Spacer(minLength: 2)

                                        Image(systemName: "info.circle")
                                            .font(.caption)
                                            .foregroundStyle(category.color.opacity(0.8))
                                    }
                                    .padding(.horizontal, 11)
                                    .padding(.vertical, 8)
                                    .background(
                                        category.color.opacity(0.1),
                                        in: Capsule()
                                    )
                                    .overlay {
                                        AuroraConstellationOverlay(
                                            cornerRadius: 999,
                                            intensity: 0.48,
                                            isActive: false
                                        )
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal, 20)

                    ScrollView(.horizontal, showsIndicators: true) {
                        VStack(alignment: .leading, spacing: 16) {
                            LazyHGrid(rows: tableRows, spacing: 5) {
                                ForEach(
                                    0..<PeriodicTableData.mainGrid.count,
                                    id: \.self
                                ) { position in
                                    let column = position / tableRowCount
                                    let row = position % tableRowCount
                                    let dataIndex = row * tableColumnCount + column

                                    if let element = PeriodicTableData.mainGrid[dataIndex] {
                                        ElementTile(element: element) {
                                            selectedElement = element
                                        }
                                    } else {
                                        Color.clear.frame(width: 54, height: 62)
                                    }
                                }
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                ElementSeriesRow(
                                    label: "Lanthanides",
                                    elements: PeriodicTableData.lanthanides,
                                    onSelect: { selectedElement = $0 }
                                )
                                ElementSeriesRow(
                                    label: "Actinides",
                                    elements: PeriodicTableData.actinides,
                                    onSelect: { selectedElement = $0 }
                                )
                            }
                            .padding(.leading, 54)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 28)
                    }
                }
                .padding(.top, 20)
            }
        }
        .navigationTitle("Periodic Table")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedElement) { element in
            ElementDetailView(element: element)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .sheet(item: $selectedCategory) { category in
            ElementCategoryDetailView(category: category)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
}

struct ElementTile: View {
    let element: PeriodicElement
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 1) {
                Text("\(element.number)")
                    .font(.system(size: 9, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(element.symbol)
                    .font(.system(size: 21, weight: .black, design: .rounded))

                Text(element.materialKind.label)
                    .font(.system(size: 6.2, weight: .black, design: .rounded))
                    .textCase(.uppercase)
                    .tracking(0.35)
            }
            .foregroundStyle(.white)
            .padding(5)
            .frame(width: 54, height: 62)
            .background(
                LinearGradient(
                    colors: [
                        element.category.color.opacity(0.3),
                        .blue.opacity(0.1),
                        .white.opacity(0.045)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                in: RoundedRectangle(cornerRadius: 9)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 9)
                    .stroke(element.category.color.opacity(0.55), lineWidth: 0.8)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(
            "\(element.name), atomic number \(element.number), \(element.materialKind.label)"
        )
        .accessibilityHint("Shows the element texture and details")
    }
}

struct RealisticElementTile: View {
    let element: PeriodicElement
    let time: TimeInterval
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            ZStack {
                switch element.materialKind {
                case .gas:
                    GasVolumeTexture(element: element, time: time)
                        .frame(width: 82, height: 70)

                case .liquid:
                    ElementLiquidSpecimen(element: element, time: time)

                case .metal, .crystal:
                    SolidElementSpecimen(
                        element: element,
                        time: floor(time * 5) / 5
                    )
                    .equatable()
                }

                ElementFloatingLabel(element: element)
            }
            .frame(width: 54, height: 62)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(
            "\(element.name), \(element.appearanceDescription)"
        )
    }
}

struct SolidElementSpecimen: View, Equatable {
    let element: PeriodicElement
    let time: TimeInterval

    var body: some View {
        let movement = element.materialKind.movement(
            at: time * element.motionRate
        )
        let chunk = NaturalElementChunkShape(
            seed: element.number,
            isCrystal: element.materialKind == .crystal
        )

        ZStack {
            LinearGradient(
                colors: element.surfaceColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            if element.sharedTextureOpacity > 0 {
                Image(element.materialKind.textureName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 66, height: 60)
                    .scaleEffect(element.textureScale)
                    .rotationEffect(.degrees(element.textureRotation))
                    .offset(x: movement.x, y: movement.y)
                    .saturation(element.textureSaturation)
                    .contrast(element.textureContrast)
                    .hueRotation(.degrees(element.textureHueRotation))
                    .opacity(element.sharedTextureOpacity)
            }

            UniqueElementMicrotexture(element: element)
                .equatable()
                .blendMode(.overlay)

            SpecimenReliefOverlay(element: element)
                .equatable()

            element.materialTint
                .opacity(element.tintStrength)
                .blendMode(.color)

            if element.materialKind == .metal {
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [.clear, .white.opacity(0.78), .clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 10, height: 70)
                    .blur(radius: 1)
                    .rotationEffect(.degrees(element.highlightAngle))
                    .offset(x: movement.highlightX)
                    .blendMode(.screen)
            }
        }
        .frame(width: 49, height: 52)
        .mask(chunk)
        .overlay {
            ZStack {
                chunk
                    .stroke(.black.opacity(0.48), lineWidth: 3)
                    .mask(chunk)

                chunk.stroke(.white.opacity(0.3), lineWidth: 0.75)
            }
        }
        .shadow(
            color: element.materialTint.opacity(0.42),
            radius: element.isAppearancePredicted ? 4 : 7,
            y: 3
        )
        .rotationEffect(.degrees(Double((element.number * 5) % 9) - 4))
    }
}

struct NaturalElementChunkShape: Shape {
    let seed: Int
    let isCrystal: Bool

    func path(in rect: CGRect) -> Path {
        let vertexCount = isCrystal ? 8 : 12
        let center = CGPoint(x: rect.midX, y: rect.midY)
        var path = Path()

        for index in 0..<vertexCount {
            let angleStep = Double.pi * 2 / Double(vertexCount)
            let angleJitter = Double(
                unit(Double(seed * 41 + index * 23)) - 0.5
            ) * angleStep * 0.38
            let angle = Double(index) * angleStep - .pi / 2 + angleJitter
            let variation = 0.68 + unit(Double(seed * 29 + index * 17)) * 0.32
            let xRadius = rect.width * 0.48 * variation
            let yRadius = rect.height * 0.46
                * (0.72 + unit(Double(seed * 13 + index * 31)) * 0.28)
            let point = CGPoint(
                x: center.x + CGFloat(cos(angle)) * xRadius,
                y: center.y + CGFloat(sin(angle)) * yRadius
            )

            if index == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }

        path.closeSubpath()
        return path
    }

    private func unit(_ value: Double) -> CGFloat {
        let raw = sin(value * 12.9898) * 43_758.5453
        return CGFloat(raw - floor(raw))
    }
}

struct SpecimenReliefOverlay: View, Equatable {
    let element: PeriodicElement

    var body: some View {
        Canvas { context, size in
            let center = CGPoint(
                x: size.width * (0.46 + unit(5.7) * 0.08),
                y: size.height * (0.43 + unit(9.1) * 0.1)
            )
            let facetCount = element.materialKind == .crystal ? 7 : 5

            for facet in 0..<facetCount {
                let seed = Double(element.number * 53 + facet * 29)
                let angle = unit(seed) * .pi * 2
                let secondAngle = angle + 0.45 + unit(seed + 7.2) * 0.9
                let radius = min(size.width, size.height)
                    * (0.34 + unit(seed + 3.4) * 0.22)
                var face = Path()
                face.move(to: center)
                face.addLine(
                    to: CGPoint(
                        x: center.x + CGFloat(cos(angle)) * radius,
                        y: center.y + CGFloat(sin(angle)) * radius
                    )
                )
                face.addLine(
                    to: CGPoint(
                        x: center.x + CGFloat(cos(secondAngle)) * radius,
                        y: center.y + CGFloat(sin(secondAngle)) * radius
                    )
                )
                face.closeSubpath()

                context.fill(
                    face,
                    with: .color(
                        facet.isMultiple(of: 2)
                            ? .white.opacity(element.materialKind == .crystal ? 0.18 : 0.1)
                            : .black.opacity(element.materialKind == .crystal ? 0.2 : 0.14)
                    )
                )
            }

            for grain in 0..<10 {
                let seed = Double(element.number * 71 + grain * 19)
                let diameter = 0.7 + unit(seed + 4.8) * 1.7
                let point = CGPoint(
                    x: size.width * unit(seed),
                    y: size.height * unit(seed + 8.3)
                )
                context.fill(
                    Path(
                        ellipseIn: CGRect(
                            x: point.x,
                            y: point.y,
                            width: diameter,
                            height: diameter * 0.7
                        )
                    ),
                    with: .color(
                        grain.isMultiple(of: 3)
                            ? .white.opacity(0.24)
                            : .black.opacity(0.2)
                    )
                )
            }

            if element.materialKind == .crystal {
                for crack in 0..<3 {
                    let seed = Double(element.number * 83 + crack * 31)
                    let start = CGPoint(
                        x: size.width * (0.18 + unit(seed) * 0.58),
                        y: size.height * (0.16 + unit(seed + 2.9) * 0.55)
                    )
                    var fracture = Path()
                    fracture.move(to: start)
                    fracture.addLine(
                        to: CGPoint(
                            x: start.x + (unit(seed + 5.4) - 0.5) * 15,
                            y: start.y + 5 + unit(seed + 7.8) * 10
                        )
                    )
                    fracture.addLine(
                        to: CGPoint(
                            x: start.x + (unit(seed + 10.1) - 0.5) * 20,
                            y: start.y + 12 + unit(seed + 12.6) * 12
                        )
                    )
                    context.stroke(
                        fracture,
                        with: .color(.black.opacity(0.3)),
                        lineWidth: 0.65
                    )
                }
            }
        }
        .allowsHitTesting(false)
    }

    private func unit(_ value: Double) -> CGFloat {
        let raw = sin((value + Double(element.number)) * 12.9898) * 43_758.5453
        return CGFloat(raw - floor(raw))
    }
}

struct ElementLiquidSpecimen: View {
    let element: PeriodicElement
    let time: TimeInterval

    var body: some View {
        ElementLiquidTexture(element: element, time: time)
            .frame(width: 50, height: 50)
            .clipped()
            .shadow(
                color: element.materialTint.opacity(0.38),
                radius: 6,
                y: 3
            )
    }
}

struct ElementFloatingLabel: View {
    let element: PeriodicElement

    var body: some View {
        VStack(spacing: 1) {
            Text("\(element.number)")
                .font(.system(size: 9, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(element.symbol)
                .font(.system(size: 20, weight: .black, design: .rounded))

            Text(
                element.isAppearancePredicted
                    ? "predicted"
                    : element.surfaceLabel
            )
            .font(.system(size: 6.2, weight: .bold, design: .rounded))
            .textCase(.uppercase)
            .lineLimit(1)
        }
        .foregroundStyle(element.isAppearancePredicted ? .black : .white)
        .shadow(
            color: element.isAppearancePredicted
                ? .white.opacity(0.9)
                : .black.opacity(0.95),
            radius: 2
        )
        .padding(5)
    }
}

struct GasVolumeTexture: View {
    let element: PeriodicElement
    let time: TimeInterval

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size

            ZStack {
                ForEach(0..<4, id: \.self) { cloud in
                    let seed = Double(element.number * 37 + cloud * 23)
                    let duration = 4.2 + Double(cloud % 4) * 0.6
                    let elapsed = (
                        time * (0.72 + Double(cloud % 3) * 0.08)
                            + seed * 0.11
                    ).truncatingRemainder(dividingBy: duration)
                    let progress = max(0, min(1, elapsed / duration))
                    let direction: CGFloat = cloud.isMultiple(of: 2) ? -1 : 1
                    let horizontalSpread = CGFloat(progress)
                        * (size.width * 0.58 + 14)
                    let baseY = size.height
                        * (0.25 + unit(seed + 4.2) * 0.5)
                    let bob = CGFloat(
                        sin(time * 0.85 + seed) * (2.5 + Double(cloud % 3))
                    )
                    let puffSize = 20 + unit(seed + 8.6) * 15
                    let fade = sin(progress * .pi)

                    PuffyGasCloud(
                        color: element.materialTint,
                        seed: seed,
                        time: time,
                        size: puffSize
                    )
                    .scaleEffect(0.7 + CGFloat(progress) * 0.9)
                    .opacity(max(0, fade))
                    .position(
                        x: size.width / 2 + direction * horizontalSpread,
                        y: baseY + bob
                    )
                }

                PuffyGasCloud(
                    color: element.materialTint,
                    seed: Double(element.number) * 19.7,
                    time: time,
                    size: 30
                )
                .scaleEffect(
                    0.88
                        + CGFloat(
                            sin(time * 0.75 + element.animationPhase)
                        ) * 0.12
                )
                .opacity(0.8)
                .position(x: size.width / 2, y: size.height * 0.52)
            }
            .blendMode(.screen)
        }
        .allowsHitTesting(false)
    }

    private func unit(_ seed: Double) -> CGFloat {
        let raw = sin(seed * 12.9898) * 43_758.5453
        return CGFloat(raw - floor(raw))
    }
}

struct PuffyGasCloud: View {
    let color: Color
    let seed: Double
    let time: TimeInterval
    let size: CGFloat

    var body: some View {
        ZStack {
            ForEach(0..<4, id: \.self) { puff in
                let puffSeed = seed + Double(puff) * 11.73
                let diameter = size * (0.42 + unit(puffSeed) * 0.46)
                let x = (unit(puffSeed + 3.1) - 0.5) * size * 0.92
                let y = (unit(puffSeed + 7.4) - 0.5) * size * 0.5
                    + CGFloat(sin(time * 0.7 + puffSeed)) * 1.5

                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                .white.opacity(0.74),
                                color.opacity(0.68),
                                color.opacity(0.24),
                                .clear
                            ],
                            center: .topLeading,
                            startRadius: 0,
                            endRadius: diameter * 0.58
                        )
                    )
                    .frame(width: diameter, height: diameter)
                    .offset(x: x, y: y)
            }
        }
        .frame(width: size * 1.7, height: size)
    }

    private func unit(_ seed: Double) -> CGFloat {
        let raw = sin(seed * 12.9898) * 43_758.5453
        return CGFloat(raw - floor(raw))
    }
}

struct ContainedGasSpecimen: View {
    let element: PeriodicElement
    let time: TimeInterval

    private var sideCount: Int {
        6 + element.number % 4
    }

    var body: some View {
        let container = IrregularPolygonShape(
            seed: element.number,
            sideCount: sideCount
        )

        ZStack {
            container
                .fill(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.055),
                            element.materialTint.opacity(0.035),
                            .black.opacity(0.12)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            GasVaporCanvas(
                color: element.materialTint,
                seed: element.number,
                time: time
            )
            .mask(container)

            container
                .fill(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.12),
                            .clear,
                            element.materialTint.opacity(0.08)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .blendMode(.screen)

            container
                .stroke(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.42),
                            element.materialTint.opacity(0.52),
                            .white.opacity(0.12)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.25
                )
        }
        .compositingGroup()
        .shadow(color: element.materialTint.opacity(0.2), radius: 10, y: 4)
        .allowsHitTesting(false)
    }
}

private struct GasVaporCanvas: View {
    let color: Color
    let seed: Int
    let time: TimeInterval

    var body: some View {
        Canvas(rendersAsynchronously: true) { context, size in
            context.addFilter(.blur(radius: 7))

            for cloud in 0..<8 {
                let cloudSeed = Double(seed * 47 + cloud * 29)
                let speed = 0.045 + unit(cloudSeed + 2.7) * 0.024
                let progress = (
                    time * speed + unit(cloudSeed + 7.1)
                ).truncatingRemainder(dividingBy: 1)
                let direction = cloud.isMultiple(of: 3) ? -1.0 : 1.0
                let travel = direction > 0 ? progress : 1 - progress
                let width = size.width
                    * (0.23 + unit(cloudSeed + 11.4) * 0.24)
                let height = size.height
                    * (0.16 + unit(cloudSeed + 16.8) * 0.2)
                let x = -width * 0.25
                    + CGFloat(travel) * (size.width + width * 0.5)
                let baseY = size.height
                    * (0.18 + unit(cloudSeed + 20.2) * 0.64)
                let drift = CGFloat(
                    sin(time * 0.34 + cloudSeed)
                ) * size.height * 0.08
                let fade = max(0, sin(progress * .pi))

                var cloudContext = context
                cloudContext.opacity = fade
                    * (0.32 + unit(cloudSeed + 25.6) * 0.28)

                let cloudRect = CGRect(
                    x: x - width / 2,
                    y: baseY + drift - height / 2,
                    width: width,
                    height: height
                )
                let cloudPath = Path(ellipseIn: cloudRect)

                cloudContext.fill(
                    cloudPath,
                    with: .radialGradient(
                        Gradient(colors: [
                            .white.opacity(0.62),
                            color.opacity(0.56),
                            color.opacity(0.18),
                            .clear
                        ]),
                        center: CGPoint(
                            x: cloudRect.midX - width * 0.12,
                            y: cloudRect.midY - height * 0.08
                        ),
                        startRadius: 0,
                        endRadius: max(width, height) * 0.58
                    )
                )
            }

            for wisp in 0..<3 {
                let wispSeed = Double(seed * 61 + wisp * 37)
                let progress = (
                    time * (0.035 + unit(wispSeed) * 0.018)
                        + unit(wispSeed + 4.9)
                ).truncatingRemainder(dividingBy: 1)
                let startX = CGFloat(progress) * (size.width + 50) - 25
                let startY = size.height
                    * (0.26 + unit(wispSeed + 8.2) * 0.5)
                var path = Path()
                path.move(to: CGPoint(x: startX - 30, y: startY + 8))
                path.addCurve(
                    to: CGPoint(x: startX + 34, y: startY - 6),
                    control1: CGPoint(
                        x: startX - 10,
                        y: startY - 18
                            + CGFloat(sin(time * 0.42 + wispSeed)) * 6
                    ),
                    control2: CGPoint(
                        x: startX + 12,
                        y: startY + 16
                    )
                )

                var wispContext = context
                wispContext.opacity = max(0, sin(progress * .pi)) * 0.32
                wispContext.stroke(
                    path,
                    with: .linearGradient(
                        Gradient(colors: [
                            .clear,
                            color.opacity(0.7),
                            .white.opacity(0.48),
                            .clear
                        ]),
                        startPoint: CGPoint(x: startX - 30, y: startY),
                        endPoint: CGPoint(x: startX + 34, y: startY)
                    ),
                    style: StrokeStyle(lineWidth: 5, lineCap: .round)
                )
            }
        }
        .allowsHitTesting(false)
    }

    private func unit(_ value: Double) -> Double {
        let raw = sin(value * 12.9898) * 43_758.5453
        return raw - floor(raw)
    }
}

struct ElementLiquidTexture: View {
    let element: PeriodicElement
    let time: TimeInterval

    private var textureName: String {
        element.number == 80
            ? "ElementMetalTexture"
            : "HydrogenWaterTexture"
    }

    private var flowSpeed: Double {
        element.number == 80 ? 7.5 : 12
    }

    var body: some View {
        let flowOffset = CGFloat(
            (time * flowSpeed).truncatingRemainder(dividingBy: 64)
        ) - 64
        let waveSpeed = element.number == 80 ? 1.15 : 2.1
        let waveAmplitude = element.number == 80 ? 1.6 : 2.8

        ZStack {
            ZStack {
                HStack(spacing: 0) {
                    ForEach(0..<3, id: \.self) { _ in
                        Image(textureName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 64, height: 62)
                            .clipped()
                    }
                }
                .offset(x: flowOffset)
                .saturation(element.number == 35 ? 1.35 : 0.05)
                .contrast(element.number == 80 ? 1.45 : 1.2)

                LinearGradient(
                    colors: element.number == 35
                        ? [
                            Color(red: 0.17, green: 0.005, blue: 0),
                            Color(red: 0.72, green: 0.08, blue: 0.02),
                            Color(red: 0.22, green: 0.005, blue: 0)
                        ]
                        : [
                            Color(white: 0.18),
                            .white.opacity(0.82),
                            Color(white: 0.42)
                        ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .opacity(element.number == 35 ? 0.68 : 0.55)
                .blendMode(element.number == 35 ? .multiply : .screen)
            }
            .frame(width: 50, height: 50)
            .mask {
                ElementLiquidFillMask(
                    time: time,
                    phase: element.animationPhase,
                    waveSpeed: waveSpeed,
                    waveAmplitude: waveAmplitude
                )
            }

            Canvas { context, size in
                let surface = size.height * 0.53
                var surfaceLine = Path()

                for x in stride(from: 0.0, through: size.width, by: 1.4) {
                    let wave = sin(
                        x * 0.17
                            - time * waveSpeed
                            + element.animationPhase
                    ) * waveAmplitude
                        + sin(x * 0.06 - time * 0.7) * 1.05
                    let y = surface + wave

                    if x == 0 {
                        surfaceLine.move(to: CGPoint(x: x, y: y))
                    } else {
                        surfaceLine.addLine(to: CGPoint(x: x, y: y))
                    }
                }

                context.stroke(
                    surfaceLine,
                    with: .color(.white.opacity(element.number == 80 ? 0.9 : 0.58)),
                    lineWidth: element.number == 80 ? 1.35 : 1
                )

                for glint in 0..<4 {
                    let seed = Double(glint * 13 + element.number)
                    let travel = (
                        time * (element.number == 80 ? 4.5 : 7.5) + seed
                    ).truncatingRemainder(
                        dividingBy: Double(size.width + 12)
                    )
                    let diameter = CGFloat(2 + glint % 3)
                    let y = size.height * (0.66 + CGFloat(glint % 3) * 0.1)

                    context.stroke(
                        Path(
                            ellipseIn: CGRect(
                                x: CGFloat(travel) - 6,
                                y: y,
                                width: diameter,
                                height: diameter * 0.7
                            )
                        ),
                        with: .color(.white.opacity(0.55)),
                        lineWidth: 0.75
                    )
                }
            }
        }
        .allowsHitTesting(false)
    }
}

struct ElementLiquidFillMask: View {
    let time: TimeInterval
    let phase: Double
    let waveSpeed: Double
    let waveAmplitude: Double

    var body: some View {
        Canvas { context, size in
            let surface = size.height * 0.53
            var liquid = Path()
            liquid.move(to: CGPoint(x: 0, y: size.height))
            liquid.addLine(to: CGPoint(x: 0, y: surface))

            for x in stride(from: 0.0, through: size.width, by: 1.4) {
                let wave = sin(x * 0.17 - time * waveSpeed + phase)
                    * waveAmplitude
                    + sin(x * 0.06 - time * 0.7) * 1.05
                liquid.addLine(to: CGPoint(x: x, y: surface + wave))
            }

            liquid.addLine(to: CGPoint(x: size.width, y: size.height))
            liquid.closeSubpath()
            context.fill(liquid, with: .color(.white))
        }
    }
}

struct UniqueElementMicrotexture: View, Equatable {
    let element: PeriodicElement

    var body: some View {
        Canvas { context, size in
            let baseSeed = Double(element.number) * 37.17

            for mark in 0..<22 {
                let seed = baseSeed + Double(mark) * 19.31
                let x = size.width * unit(seed)
                let y = size.height * unit(seed + 4.7)
                let length = 2 + 7 * unit(seed + 8.4)

                switch element.surfaceStyle {
                case .polishedMetal:
                    var sheen = Path()
                    sheen.move(to: CGPoint(x: x - length, y: size.height))
                    sheen.addLine(to: CGPoint(x: x + length * 1.7, y: 0))
                    context.opacity = mark.isMultiple(of: 5) ? 0.2 : 0.035
                    context.stroke(
                        sheen,
                        with: .color(.white),
                        lineWidth: mark.isMultiple(of: 5) ? 0.8 : 0.25
                    )

                case .brushedMetal:
                    var scratch = Path()
                    scratch.move(to: CGPoint(x: 0, y: y))
                    scratch.addLine(
                        to: CGPoint(
                            x: size.width,
                            y: y + CGFloat(sin(seed)) * 0.7
                        )
                    )
                    context.opacity = 0.08 + Double(mark % 4) * 0.03
                    context.stroke(
                        scratch,
                        with: .color(mark.isMultiple(of: 3) ? .white : .black),
                        lineWidth: mark.isMultiple(of: 6) ? 0.8 : 0.3
                    )

                case .hammeredMetal:
                    let diameter = 4 + length * 1.4
                    context.opacity = 0.07 + Double(mark % 5) * 0.022
                    context.stroke(
                        Path(
                            ellipseIn: CGRect(
                                x: x - diameter / 2,
                                y: y - diameter / 2,
                                width: diameter,
                                height: diameter
                            )
                        ),
                        with: .color(mark.isMultiple(of: 2) ? .white : .black),
                        lineWidth: 0.65
                    )

                case .softCutMetal:
                    var dent = Path()
                    dent.move(to: CGPoint(x: x - length, y: y))
                    dent.addQuadCurve(
                        to: CGPoint(x: x + length, y: y),
                        control: CGPoint(x: x, y: y + length * 0.45)
                    )
                    context.opacity = 0.1 + Double(mark % 4) * 0.03
                    context.stroke(
                        dent,
                        with: .color(mark.isMultiple(of: 2) ? .white : .black),
                        lineWidth: 0.7
                    )

                case .dullMetal:
                    let diameter = 0.8 + length * 0.25
                    context.opacity = 0.08 + Double(mark % 5) * 0.025
                    context.fill(
                        Path(
                            ellipseIn: CGRect(
                                x: x,
                                y: y,
                                width: diameter,
                                height: diameter * 0.72
                            )
                        ),
                        with: .color(mark.isMultiple(of: 3) ? .white : .black)
                    )

                case .brittleMetal:
                    let radius = 2.5 + length * 0.5
                    var fracture = Path()
                    fracture.move(to: CGPoint(x: x - radius, y: y - radius * 0.2))
                    fracture.addLine(to: CGPoint(x: x, y: y + radius * 0.22))
                    fracture.addLine(to: CGPoint(x: x + radius, y: y - radius * 0.55))
                    fracture.move(to: CGPoint(x: x, y: y + radius * 0.22))
                    fracture.addLine(to: CGPoint(x: x + radius * 0.35, y: y + radius))
                    context.opacity = 0.11 + Double(mark % 4) * 0.035
                    context.stroke(
                        fracture,
                        with: .color(mark.isMultiple(of: 3) ? .white : .black),
                        lineWidth: 0.65
                    )

                case .facetedCrystal:
                    let radius = 2.5 + length * 0.45
                    var facet = Path()
                    facet.move(to: CGPoint(x: x, y: y - radius))
                    facet.addLine(
                        to: CGPoint(x: x + radius * 0.82, y: y - radius * 0.1)
                    )
                    facet.addLine(to: CGPoint(x: x + radius * 0.45, y: y + radius))
                    facet.addLine(to: CGPoint(x: x - radius, y: y + radius))
                    facet.closeSubpath()
                    context.opacity = 0.11 + Double(mark % 4) * 0.035
                    context.stroke(
                        facet,
                        with: .color(mark.isMultiple(of: 3) ? .white : .black),
                        lineWidth: 0.65
                    )

                case .cubicCrystal:
                    let side = 3 + length * 0.72
                    let inset = side * 0.28
                    var cube = Path()
                    cube.move(to: CGPoint(x: x - side / 2, y: y - side / 2))
                    cube.addLine(to: CGPoint(x: x + side / 2, y: y - side / 2))
                    cube.addLine(to: CGPoint(x: x + side / 2, y: y + side / 2))
                    cube.addLine(to: CGPoint(x: x - side / 2, y: y + side / 2))
                    cube.closeSubpath()
                    cube.move(to: CGPoint(x: x - side / 2, y: y - side / 2))
                    cube.addLine(to: CGPoint(x: x - inset, y: y - inset))
                    cube.addLine(to: CGPoint(x: x + side / 2, y: y - side / 2))
                    context.opacity = 0.1 + Double(mark % 4) * 0.04
                    context.stroke(
                        cube,
                        with: .color(mark.isMultiple(of: 3) ? .white : .black),
                        lineWidth: 0.7
                    )

                case .needleCrystal:
                    var needle = Path()
                    let rise = 5 + length * 1.6
                    needle.move(to: CGPoint(x: x, y: y + rise / 2))
                    needle.addLine(
                        to: CGPoint(
                            x: x + CGFloat(sin(seed)) * 3,
                            y: y - rise / 2
                        )
                    )
                    context.opacity = 0.13 + Double(mark % 4) * 0.04
                    context.stroke(
                        needle,
                        with: .color(mark.isMultiple(of: 3) ? .white : .black),
                        lineWidth: mark.isMultiple(of: 5) ? 1.5 : 0.65
                    )

                case .layeredCrystal:
                    let width = 5 + length
                    var plate = Path()
                    plate.move(to: CGPoint(x: x - width / 2, y: y))
                    plate.addLine(
                        to: CGPoint(x: x - width * 0.18, y: y - width * 0.24)
                    )
                    plate.addLine(to: CGPoint(x: x + width / 2, y: y - 1))
                    plate.addLine(
                        to: CGPoint(x: x + width * 0.22, y: y + width * 0.24)
                    )
                    plate.closeSubpath()
                    context.opacity = 0.11 + Double(mark % 4) * 0.035
                    context.stroke(
                        plate,
                        with: .color(mark.isMultiple(of: 3) ? .white : .black),
                        lineWidth: 0.7
                    )

                case .layeredGraphite:
                    var layer = Path()
                    layer.move(to: CGPoint(x: -2, y: y))
                    for step in 0...6 {
                        let layerX = CGFloat(step) * (size.width + 4) / 6 - 2
                        let layerY = y + CGFloat(
                            sin(Double(step) * 1.7 + seed)
                        ) * 1.1
                        layer.addLine(to: CGPoint(x: layerX, y: layerY))
                    }
                    context.opacity = 0.18 + Double(mark % 4) * 0.04
                    context.stroke(
                        layer,
                        with: .color(mark.isMultiple(of: 4) ? .white : .black),
                        lineWidth: mark.isMultiple(of: 5) ? 1.2 : 0.45
                    )

                case .waxy:
                    let diameter = 5 + length
                    context.opacity = 0.08 + Double(mark % 4) * 0.03
                    context.fill(
                        Path(
                            ellipseIn: CGRect(
                                x: x - diameter / 2,
                                y: y - diameter * 0.35,
                                width: diameter,
                                height: diameter * 0.7
                            )
                        ),
                        with: .color(mark.isMultiple(of: 3) ? .white : .black)
                    )

                case .granular:
                    let diameter = 1.2 + length * 0.35
                    context.opacity = 0.14 + Double(mark % 5) * 0.035
                    context.fill(
                        Path(
                            ellipseIn: CGRect(
                                x: x,
                                y: y,
                                width: diameter,
                                height: diameter
                            )
                        ),
                        with: .color(mark.isMultiple(of: 3) ? .white : .black)
                    )

                case .flakyCrystal:
                    let radius = 2.2 + length * 0.5
                    var flake = Path()
                    flake.move(to: CGPoint(x: x - radius, y: y))
                    flake.addLine(
                        to: CGPoint(x: x - radius * 0.2, y: y - radius * 0.55)
                    )
                    flake.addLine(
                        to: CGPoint(x: x + radius, y: y - radius * 0.15)
                    )
                    flake.addLine(
                        to: CGPoint(x: x + radius * 0.35, y: y + radius * 0.5)
                    )
                    flake.closeSubpath()
                    context.opacity = 0.11 + Double(mark % 4) * 0.035
                    context.fill(
                        flake,
                        with: .color(mark.isMultiple(of: 3) ? .white : .black)
                    )

                case .iridescentCrystal:
                    let side = 4 + length
                    let hue = Double(
                        (element.number * 17 + mark * 11) % 100
                    ) / 100
                    context.opacity = 0.18 + Double(mark % 3) * 0.055
                    context.stroke(
                        Path(
                            roundedRect: CGRect(
                                x: x - side / 2,
                                y: y - side / 2,
                                width: side,
                                height: side
                            ),
                            cornerRadius: 1
                        ),
                        with: .color(
                            Color(hue: hue, saturation: 0.8, brightness: 1)
                        ),
                        lineWidth: 1
                    )

                case .gasCloud:
                    let diameter = 4 + length
                    context.opacity = 0.035 + Double(mark % 5) * 0.014
                    context.fill(
                        Path(
                            ellipseIn: CGRect(
                                x: x,
                                y: y,
                                width: diameter,
                                height: diameter * 0.7
                            )
                        ),
                        with: .color(element.materialTint)
                    )

                case .liquidFlow:
                    var ripple = Path()
                    ripple.move(to: CGPoint(x: x, y: y))
                    ripple.addCurve(
                        to: CGPoint(x: min(size.width, x + length), y: y),
                        control1: CGPoint(x: x + length * 0.3, y: y - 1.8),
                        control2: CGPoint(x: x + length * 0.7, y: y + 1.8)
                    )
                    context.opacity = 0.12 + Double(mark % 4) * 0.035
                    context.stroke(
                        ripple,
                        with: .color(.white),
                        lineWidth: 0.55
                    )

                case .radioactiveMetal:
                    let diameter = 1.5 + length * 0.65
                    context.opacity = 0.1 + Double(mark % 4) * 0.035
                    context.fill(
                        Path(
                            ellipseIn: CGRect(
                                x: x,
                                y: y,
                                width: diameter,
                                height: diameter
                            )
                        ),
                        with: .color(
                            mark.isMultiple(of: 4)
                                ? element.materialTint
                                : .black
                        )
                    )

                case .predicted:
                    var hatch = Path()
                    hatch.move(to: CGPoint(x: x - length, y: y + length))
                    hatch.addLine(to: CGPoint(x: x + length, y: y - length))
                    context.opacity = 0.12 + Double(mark % 4) * 0.025
                    context.stroke(
                        hatch,
                        with: .color(mark.isMultiple(of: 3) ? .black : .white),
                        lineWidth: 0.6
                    )
                }
            }
        }
    }

    private func unit(_ seed: Double) -> CGFloat {
        let raw = sin(seed * 12.9898) * 43_758.5453
        return CGFloat(raw - floor(raw))
    }
}

enum ElementSurfaceStyle: Equatable {
    case polishedMetal
    case brushedMetal
    case hammeredMetal
    case softCutMetal
    case dullMetal
    case brittleMetal
    case facetedCrystal
    case cubicCrystal
    case needleCrystal
    case layeredCrystal
    case layeredGraphite
    case waxy
    case granular
    case flakyCrystal
    case iridescentCrystal
    case gasCloud
    case liquidFlow
    case radioactiveMetal
    case predicted
}

struct MaterialMovement {
    let x: CGFloat
    let y: CGFloat
    let highlightX: CGFloat
}

enum ElementMaterialKind: Equatable {
    case metal
    case crystal
    case gas
    case liquid

    var textureName: String {
        switch self {
        case .metal: "ElementMetalTexture"
        case .crystal: "ElementCrystalTexture"
        case .gas: "ElementGasTexture"
        case .liquid: "HydrogenWaterTexture"
        }
    }

    var label: String {
        switch self {
        case .metal: "metal"
        case .crystal: "crystal"
        case .gas: "gas"
        case .liquid: "liquid"
        }
    }

    func movement(at time: TimeInterval) -> MaterialMovement {
        switch self {
        case .metal:
            return MaterialMovement(
                x: CGFloat(sin(time * 0.22)) * 4,
                y: CGFloat(cos(time * 0.17)) * 2,
                highlightX: CGFloat(
                    (time * 15).truncatingRemainder(dividingBy: 90)
                ) - 45
            )
        case .crystal:
            return MaterialMovement(
                x: CGFloat(sin(time * 0.18)) * 4,
                y: CGFloat(cos(time * 0.14)) * 4,
                highlightX: 0
            )
        case .gas:
            return MaterialMovement(
                x: CGFloat(
                    (time * 7).truncatingRemainder(dividingBy: 64)
                ) - 64,
                y: CGFloat(sin(time * 0.35)) * 3,
                highlightX: 0
            )
        case .liquid:
            return MaterialMovement(
                x: CGFloat(
                    (time * 12).truncatingRemainder(dividingBy: 64)
                ) - 64,
                y: CGFloat(sin(time * 0.8)) * 2,
                highlightX: CGFloat(
                    (time * 13).truncatingRemainder(dividingBy: 90)
                ) - 45
            )
        }
    }
}

struct ReactiveMetalTile: View {
    let element: PeriodicElement
    let onSelect: () -> Void
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var appearance: AlkaliMetalAppearance {
        AlkaliMetalAppearance.forElement(element.number)
    }

    var body: some View {
        Button(action: onSelect) {
            TimelineView(.animation(minimumInterval: 1 / 30)) { timeline in
                let time = reduceMotion
                    ? 0
                    : timeline.date.timeIntervalSinceReferenceDate
                let shimmer = CGFloat(
                    (time * appearance.shimmerSpeed)
                        .truncatingRemainder(dividingBy: 92)
                ) - 46

                ZStack {
                    LinearGradient(
                        colors: appearance.colors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )

                    Canvas { context, size in
                        for fleck in 0..<18 {
                            let seed = Double(fleck)
                            let x = size.width * CGFloat(
                                (sin(seed * 13.7) + 1) / 2
                            )
                            let y = size.height * CGFloat(
                                (cos(seed * 8.9) + 1) / 2
                            )
                            let diameter = CGFloat(fleck.isMultiple(of: 4) ? 1.4 : 0.7)

                            context.opacity = fleck.isMultiple(of: 3) ? 0.3 : 0.14
                            context.fill(
                                Path(
                                    ellipseIn: CGRect(
                                        x: x,
                                        y: y,
                                        width: diameter,
                                        height: diameter
                                    )
                                ),
                                with: .color(.white)
                            )
                        }
                    }
                    .blendMode(.overlay)

                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [
                                    .clear,
                                    .white.opacity(0.78),
                                    .clear
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: 16, height: 88)
                        .blur(radius: 3)
                        .rotationEffect(.degrees(18))
                        .offset(x: shimmer)
                        .blendMode(.screen)

                    if appearance.isPredicted {
                        Circle()
                            .fill(.purple.opacity(0.32))
                            .frame(width: 44, height: 44)
                            .blur(radius: 10)
                            .scaleEffect(0.9 + sin(time * 1.4) * 0.12)
                    }

                    VStack(spacing: 1) {
                        Text("\(element.number)")
                            .font(.system(size: 9, weight: .bold, design: .rounded))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text(element.symbol)
                            .font(.system(size: 20, weight: .black, design: .rounded))

                        Text(appearance.caption)
                            .font(.system(size: 6.2, weight: .bold, design: .rounded))
                            .lineLimit(1)
                    }
                    .foregroundStyle(appearance.textColor)
                    .padding(5)
                }
                .frame(width: 54, height: 62)
                .clipShape(RoundedRectangle(cornerRadius: 9))
                .overlay {
                    RoundedRectangle(cornerRadius: 9)
                        .stroke(.white.opacity(0.52), lineWidth: 1)
                }
                .shadow(color: appearance.glow.opacity(0.42), radius: 6, y: 2)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(
            "\(element.name), animated \(appearance.caption) appearance"
        )
    }
}

struct AlkaliMetalAppearance {
    let colors: [Color]
    let textColor: Color
    let glow: Color
    let caption: String
    let shimmerSpeed: Double
    let isPredicted: Bool

    static func forElement(_ number: Int) -> AlkaliMetalAppearance {
        switch number {
        case 3:
            return AlkaliMetalAppearance(
                colors: [.white, .gray.opacity(0.72), .white.opacity(0.86)],
                textColor: .black.opacity(0.78),
                glow: .white,
                caption: "silver-white",
                shimmerSpeed: 13,
                isPredicted: false
            )
        case 11:
            return AlkaliMetalAppearance(
                colors: [.white, .gray.opacity(0.58), .cyan.opacity(0.18)],
                textColor: .black.opacity(0.76),
                glow: .cyan,
                caption: "soft silver",
                shimmerSpeed: 15,
                isPredicted: false
            )
        case 19:
            return AlkaliMetalAppearance(
                colors: [.white, .indigo.opacity(0.32), .gray.opacity(0.7)],
                textColor: .black.opacity(0.75),
                glow: .indigo,
                caption: "silver-lilac",
                shimmerSpeed: 17,
                isPredicted: false
            )
        case 37:
            return AlkaliMetalAppearance(
                colors: [.white.opacity(0.9), .gray, .red.opacity(0.24)],
                textColor: .white,
                glow: .red,
                caption: "silver-gray",
                shimmerSpeed: 19,
                isPredicted: false
            )
        case 55:
            return AlkaliMetalAppearance(
                colors: [.yellow.opacity(0.82), .orange.opacity(0.58), .white],
                textColor: .black.opacity(0.76),
                glow: .yellow,
                caption: "pale gold",
                shimmerSpeed: 21,
                isPredicted: false
            )
        default:
            return AlkaliMetalAppearance(
                colors: [.gray.opacity(0.88), .purple.opacity(0.42), .white],
                textColor: .white,
                glow: .purple,
                caption: "predicted",
                shimmerSpeed: 12,
                isPredicted: true
            )
        }
    }
}

struct HydrogenWaterTile: View {
    let time: TimeInterval
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            ZStack {
                WaterLiquidSpecimen(time: time)

                VStack(spacing: 1) {
                    Text("1")
                        .font(.system(size: 9, weight: .bold, design: .rounded))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("H")
                        .font(.system(size: 21, weight: .black, design: .rounded))

                    Text("H₂O link")
                        .font(.system(size: 6.5, weight: .bold, design: .rounded))
                        .opacity(0.82)
                }
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.95), radius: 2)
                .padding(5)
            }
            .frame(width: 54, height: 62)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Hydrogen, water-inspired animated specimen")
        .accessibilityHint("Shows details about Hydrogen")
    }
}

struct WaterLiquidSpecimen: View {
    let time: TimeInterval

    var body: some View {
        let flowOffset = CGFloat(
            (time * 14).truncatingRemainder(dividingBy: 64)
        ) - 64

        ZStack {
            ZStack {
                HStack(spacing: 0) {
                    ForEach(0..<3, id: \.self) { _ in
                        Image("HydrogenWaterTexture")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 64, height: 62)
                            .clipped()
                    }
                }
                .offset(x: flowOffset)
                .saturation(1.18)
                .contrast(1.12)

                LinearGradient(
                    colors: [.cyan.opacity(0.25), .clear, .white.opacity(0.35)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .blendMode(.screen)
            }
            .frame(width: 50, height: 50)
            .mask {
                WaterFillMask(time: time)
            }

            Canvas { context, size in
                let surface = size.height * 0.52
                var surfaceLine = Path()

                for x in stride(from: 0.0, through: size.width, by: 1.5) {
                    let y = surface
                        + sin(x * 0.16 - time * 2.35) * 2.7
                        + sin(x * 0.055 - time * 0.9) * 1.25

                    if x == 0 {
                        surfaceLine.move(to: CGPoint(x: x, y: y))
                    } else {
                        surfaceLine.addLine(to: CGPoint(x: x, y: y))
                    }
                }

                context.stroke(
                    surfaceLine,
                    with: .color(.white.opacity(0.72)),
                    lineWidth: 1.15
                )

                for bubble in 0..<3 {
                    let seed = Double(bubble)
                    let travel = (
                        time * (8.5 + seed * 0.8) + seed * 13
                    ).truncatingRemainder(dividingBy: Double(size.width + 10))
                    let rise = (
                        time * (2.8 + seed * 0.4)
                    ).truncatingRemainder(dividingBy: Double(size.height * 0.4))
                    let diameter = CGFloat(2.2 + seed.truncatingRemainder(dividingBy: 3))

                    context.stroke(
                        Path(
                            ellipseIn: CGRect(
                                x: CGFloat(travel) - 5,
                                y: size.height - CGFloat(rise),
                                width: diameter,
                                height: diameter
                            )
                        ),
                        with: .color(.white.opacity(0.58)),
                        lineWidth: 0.8
                    )
                }
            }

        }
        .frame(width: 50, height: 50)
        .clipped()
        .shadow(color: .cyan.opacity(0.45), radius: 7, y: 3)
        .allowsHitTesting(false)
    }
}

struct WaterFillMask: View {
    let time: TimeInterval

    var body: some View {
        Canvas { context, size in
            let surface = size.height * 0.52
            var liquid = Path()
            liquid.move(to: CGPoint(x: 0, y: size.height))
            liquid.addLine(to: CGPoint(x: 0, y: surface))

            for x in stride(from: 0.0, through: size.width, by: 1.5) {
                let wave = sin(x * 0.16 - time * 2.35) * 2.7
                    + sin(x * 0.055 - time * 0.9) * 1.25
                liquid.addLine(to: CGPoint(x: x, y: surface + wave))
            }

            liquid.addLine(to: CGPoint(x: size.width, y: size.height))
            liquid.closeSubpath()
            context.fill(liquid, with: .color(.white))
        }
    }
}

struct ElementSeriesRow: View {
    let label: String
    let elements: [PeriodicElement]
    let onSelect: (PeriodicElement) -> Void

    var body: some View {
        HStack(spacing: 5) {
            Text(label)
                .font(.system(size: 9, weight: .bold, design: .rounded))
                .foregroundStyle(.purple)
                .frame(width: 100, alignment: .trailing)
                .padding(.trailing, 6)

            ForEach(elements) { element in
                ElementTile(element: element) {
                    onSelect(element)
                }
            }
        }
    }
}

struct PeriodicElement: Identifiable, Equatable {
    let number: Int
    let symbol: String
    let name: String
    let category: ElementCategory

    var id: Int { number }
}

struct MetalAppearanceProfile {
    let tint: Color
    let shadow: Color
    let highlight: Color
    let finish: ElementSurfaceStyle
    let label: String
    let referenceNote: String

    var gradient: [Color] {
        [shadow, tint, highlight, tint.opacity(0.88), shadow]
    }

    static func forElement(_ number: Int, name: String) -> MetalAppearanceProfile {
        if number == 87 || number >= 99 {
            return MetalAppearanceProfile(
                tint: .white,
                shadow: Color(white: 0.72),
                highlight: .white,
                finish: .predicted,
                label: "unobserved",
                referenceNote: "No macroscopic pure sample has a securely observed surface texture, so the app shows a neutral white prediction instead of inventing one."
            )
        }

        let silverWhite = Color(red: 0.82, green: 0.84, blue: 0.87)
        let brightSilver = Color(red: 0.9, green: 0.92, blue: 0.95)
        let neutralSilver = Color(red: 0.68, green: 0.7, blue: 0.73)
        let darkSilver = Color(red: 0.46, green: 0.48, blue: 0.51)
        let blueSilver = Color(red: 0.58, green: 0.67, blue: 0.77)

        let tint: Color
        let shadow: Color
        let highlight: Color
        let label: String

        switch number {
        case 24:
            tint = blueSilver
            shadow = Color(red: 0.25, green: 0.31, blue: 0.39)
            highlight = Color(red: 0.86, green: 0.91, blue: 0.98)
            label = "blue-silver"
        case 26:
            tint = Color(red: 0.52, green: 0.53, blue: 0.55)
            shadow = Color(red: 0.2, green: 0.21, blue: 0.23)
            highlight = Color(red: 0.78, green: 0.79, blue: 0.81)
            label = "gray metal"
        case 27:
            tint = blueSilver
            shadow = Color(red: 0.25, green: 0.3, blue: 0.38)
            highlight = Color(red: 0.86, green: 0.9, blue: 0.96)
            label = "silver-blue"
        case 29:
            tint = Color(red: 0.78, green: 0.34, blue: 0.16)
            shadow = Color(red: 0.24, green: 0.07, blue: 0.025)
            highlight = Color(red: 1, green: 0.69, blue: 0.38)
            label = "reddish-gold"
        case 30, 48:
            tint = Color(red: 0.7, green: 0.77, blue: 0.84)
            shadow = Color(red: 0.3, green: 0.35, blue: 0.42)
            highlight = Color(red: 0.92, green: 0.95, blue: 1)
            label = "blue-white"
        case 55:
            tint = Color(red: 0.91, green: 0.72, blue: 0.28)
            shadow = Color(red: 0.38, green: 0.24, blue: 0.05)
            highlight = Color(red: 1, green: 0.92, blue: 0.58)
            label = "pale gold"
        case 58:
            tint = Color(red: 0.5, green: 0.51, blue: 0.52)
            shadow = Color(red: 0.2, green: 0.2, blue: 0.21)
            highlight = Color(red: 0.73, green: 0.74, blue: 0.76)
            label = "gray metal"
        case 79:
            tint = Color(red: 0.96, green: 0.69, blue: 0.12)
            shadow = Color(red: 0.42, green: 0.23, blue: 0.015)
            highlight = Color(red: 1, green: 0.94, blue: 0.48)
            label = "yellow gold"
        case 82:
            tint = Color(red: 0.49, green: 0.53, blue: 0.58)
            shadow = Color(red: 0.18, green: 0.2, blue: 0.23)
            highlight = Color(red: 0.7, green: 0.74, blue: 0.78)
            label = "dull gray"
        case 83:
            tint = Color(red: 0.78, green: 0.67, blue: 0.7)
            shadow = Color(red: 0.32, green: 0.25, blue: 0.28)
            highlight = Color(red: 1, green: 0.9, blue: 0.91)
            label = "pink-silver"
        case 84:
            tint = Color(red: 0.55, green: 0.56, blue: 0.58)
            shadow = Color(red: 0.2, green: 0.21, blue: 0.23)
            highlight = Color(red: 0.78, green: 0.79, blue: 0.81)
            label = "silver-gray"
        case 3, 4, 11, 12, 13, 20, 31, 57, 60, 62, 71, 74, 78:
            tint = brightSilver
            shadow = Color(red: 0.34, green: 0.36, blue: 0.39)
            highlight = .white
            label = "silver-white"
        case 25, 43, 61, 89...98:
            tint = neutralSilver
            shadow = Color(red: 0.26, green: 0.27, blue: 0.29)
            highlight = Color(red: 0.86, green: 0.87, blue: 0.89)
            label = "silver metal"
        default:
            tint = silverWhite
            shadow = darkSilver
            highlight = brightSilver
            label = "silvery"
        }

        let finish: ElementSurfaceStyle
        switch number {
        case 3, 4, 11, 13, 19, 20, 31, 37, 38, 39, 49, 50, 55,
             56, 57, 59, 63, 64, 65, 68, 70, 81, 88:
            finish = .softCutMetal
        case 22, 23, 24, 27, 28, 30, 40, 41, 42, 44, 45, 46,
             47, 48, 71, 72, 73, 74, 76, 77, 78, 79:
            finish = .polishedMetal
        case 25, 83, 84:
            finish = .brittleMetal
        case 26, 58, 82:
            finish = .dullMetal
        case 43, 61, 89...98:
            finish = .radioactiveMetal
        default:
            finish = .brushedMetal
        }

        let note: String
        switch number {
        case 29:
            note = "Pure copper is naturally reddish-gold; this is intrinsic metal color, not a painted tint."
        case 55:
            note = "Fresh pure caesium is pale gold and extremely reactive, so the visible surface would change quickly in air."
        case 79:
            note = "Pure gold is characteristically yellow and soft, with a highly reflective fresh surface."
        case 83:
            note = "Pure bismuth is silvery with a pink tinge. Rainbow colors belong to an oxide film and are intentionally omitted here."
        case 89:
            note = "Actinium is silvery-white; its radiation can excite nearby air with a blue glow, but the metal itself is not blue."
        case 3, 11, 19, 20, 21, 30, 37, 38, 56, 57, 58, 60, 63, 70, 81, 96:
            note = "This is the fresh pure-metal appearance. The real surface tarnishes or oxidizes after air exposure."
        default:
            note = "This profile represents a fresh pure \(name) sample near room temperature, with per-element grain and reflectivity."
        }

        return MetalAppearanceProfile(
            tint: tint,
            shadow: shadow,
            highlight: highlight,
            finish: finish,
            label: label,
            referenceNote: note
        )
    }
}

extension PeriodicElement {
    var metalAppearanceProfile: MetalAppearanceProfile {
        MetalAppearanceProfile.forElement(number, name: name)
    }

    var materialKind: ElementMaterialKind {
        if [2, 7, 8, 9, 10, 17, 18, 36, 54, 86].contains(number) {
            return .gas
        }
        if [1, 35, 80].contains(number) {
            return .liquid
        }
        if category == .metalloid ||
            [6, 15, 16, 34, 53, 85, 117].contains(number) {
            return .crystal
        }
        return .metal
    }

    var materialTint: Color {
        if isAppearancePredicted {
            return .white
        }

        if materialKind == .metal {
            return metalAppearanceProfile.tint
        }

        switch number {
        case 2: return Color(red: 0.92, green: 0.82, blue: 1)
        case 5: return Color(red: 0.12, green: 0.1, blue: 0.08)
        case 6: return Color(white: 0.18)
        case 7: return Color(red: 0.52, green: 0.65, blue: 1)
        case 8: return Color(red: 0.3, green: 0.65, blue: 1)
        case 9: return Color(red: 0.93, green: 0.9, blue: 0.3)
        case 10: return Color(red: 1, green: 0.36, blue: 0.18)
        case 14: return Color(red: 0.22, green: 0.3, blue: 0.38)
        case 15: return Color(red: 0.68, green: 0.08, blue: 0.07)
        case 16: return .yellow
        case 17: return Color(red: 0.55, green: 0.9, blue: 0.24)
        case 18: return Color(red: 0.72, green: 0.46, blue: 1)
        case 29: return Color(red: 0.78, green: 0.33, blue: 0.16)
        case 31: return Color(red: 0.76, green: 0.8, blue: 0.88)
        case 32: return Color(red: 0.58, green: 0.62, blue: 0.66)
        case 33: return Color(red: 0.42, green: 0.45, blue: 0.5)
        case 34: return Color(white: 0.3)
        case 35: return Color(red: 0.52, green: 0.08, blue: 0.03)
        case 36: return Color(red: 0.82, green: 0.92, blue: 1)
        case 47: return Color(white: 0.92)
        case 51: return Color(red: 0.7, green: 0.72, blue: 0.76)
        case 52: return Color(red: 0.62, green: 0.67, blue: 0.72)
        case 53: return .purple
        case 54: return Color(red: 0.34, green: 0.58, blue: 1)
        case 55: return Color(red: 0.95, green: 0.76, blue: 0.27)
        case 78: return Color(red: 0.87, green: 0.9, blue: 0.96)
        case 79: return Color(red: 1, green: 0.72, blue: 0.08)
        case 80: return Color(white: 0.82)
        case 82: return Color(red: 0.42, green: 0.48, blue: 0.56)
        case 83: return Color(red: 0.85, green: 0.56, blue: 0.72)
        case 85, 117: return Color(red: 0.33, green: 0.12, blue: 0.3)
        case 86: return Color(red: 0.48, green: 0.38, blue: 0.72)
        case 92: return Color(red: 0.48, green: 0.5, blue: 0.48)
        case 94: return Color(red: 0.58, green: 0.6, blue: 0.58)
        default:
            switch materialKind {
            case .metal:
                return metalAppearanceProfile.tint
            case .crystal:
                return Color(white: 0.34 + Double(number % 6) * 0.06)
            case .gas:
                return Color(
                    hue: Double((number * 31) % 100) / 100,
                    saturation: 0.58,
                    brightness: 0.88
                )
            case .liquid:
                return number == 80
                    ? Color(white: 0.82)
                    : Color(red: 0.52, green: 0.08, blue: 0.03)
            }
        }
    }

    var surfaceStyle: ElementSurfaceStyle {
        if isAppearancePredicted {
            return .predicted
        }
        if materialKind == .metal {
            return metalAppearanceProfile.finish
        }
        switch number {
        case 6: return .layeredGraphite
        case 15: return .waxy
        case 16: return .facetedCrystal
        case 34: return .granular
        case 53: return .flakyCrystal
        case 1, 35, 80: return .liquidFlow
        case 2, 7, 8, 9, 10, 17, 18, 36, 54, 86:
            return .gasCloud
        case 5, 51:
            return .facetedCrystal
        case 14, 32:
            return .cubicCrystal
        case 33:
            return .layeredCrystal
        case 52:
            return .needleCrystal
        default:
            return number.isMultiple(of: 3) ? .hammeredMetal : .brushedMetal
        }
    }

    var surfaceLabel: String {
        if materialKind == .metal {
            return metalAppearanceProfile.label
        }
        return switch surfaceStyle {
        case .polishedMetal: "polished"
        case .brushedMetal: "brushed"
        case .hammeredMetal: "grained"
        case .softCutMetal: "soft metal"
        case .dullMetal: "dull metal"
        case .brittleMetal: "brittle"
        case .facetedCrystal: "faceted"
        case .cubicCrystal: "block crystal"
        case .needleCrystal: "needle crystal"
        case .layeredCrystal: "layered"
        case .layeredGraphite: "graphite"
        case .waxy: "waxy"
        case .granular: "granular"
        case .flakyCrystal: "flaky"
        case .iridescentCrystal: "iridescent"
        case .gasCloud: "gas"
        case .liquidFlow: "liquid"
        case .radioactiveMetal: "radioactive"
        case .predicted: "predicted"
        }
    }

    var surfaceColors: [Color] {
        if materialKind == .metal {
            return metalAppearanceProfile.gradient
        }
        return switch surfaceStyle {
        case .layeredGraphite:
            [Color(white: 0.04), Color(white: 0.3), Color(white: 0.08)]
        case .waxy:
            [Color(red: 0.2, green: 0.01, blue: 0.01), materialTint, .black]
        case .facetedCrystal, .cubicCrystal, .needleCrystal, .layeredCrystal:
            [.black, materialTint.opacity(0.9), .white.opacity(0.3)]
        case .granular:
            [.black, materialTint, Color(white: 0.16)]
        case .flakyCrystal:
            [.black, Color(red: 0.18, green: 0.02, blue: 0.25), materialTint]
        case .iridescentCrystal:
            [.cyan.opacity(0.8), .purple, .yellow.opacity(0.75), .pink]
        case .gasCloud:
            [.black, materialTint.opacity(0.72), .black]
        case .liquidFlow:
            [.black, Color(white: 0.025), .black]
        case .radioactiveMetal:
            [.black, materialTint.opacity(0.7), Color(white: 0.55)]
        case .predicted:
            [.white, Color(white: 0.78), .white]
        case .softCutMetal, .polishedMetal:
            [.white.opacity(0.88), materialTint, .gray.opacity(0.74)]
        case .brushedMetal, .hammeredMetal, .dullMetal, .brittleMetal:
            [.black, materialTint, .white.opacity(0.58)]
        }
    }

    var sharedTextureOpacity: Double {
        switch surfaceStyle {
        case .facetedCrystal, .cubicCrystal, .needleCrystal, .layeredCrystal,
             .layeredGraphite, .waxy, .granular,
             .flakyCrystal, .iridescentCrystal:
            0.2
        case .gasCloud:
            0
        case .predicted:
            0
        case .liquidFlow:
            0
        case .dullMetal:
            0.34
        case .polishedMetal:
            0.68
        default:
            0.56
        }
    }

    var textureScale: CGFloat {
        1.02 + CGFloat(number % 9) * 0.013
    }

    var textureRotation: Double {
        Double((number * 11) % 23) - 11
    }

    var textureSaturation: Double {
        switch materialKind {
        case .metal: 0.82 + Double(number % 5) * 0.055
        case .crystal: 0.94 + Double(number % 6) * 0.06
        case .gas: 0.42 + Double(number % 5) * 0.07
        case .liquid: 1.02 + Double(number % 4) * 0.08
        }
    }

    var textureContrast: Double {
        switch materialKind {
        case .metal: 1.08 + Double(number % 7) * 0.045
        case .crystal: 1.02 + Double(number % 5) * 0.04
        case .gas: 0.92 + Double(number % 6) * 0.035
        case .liquid: 1.05 + Double(number % 4) * 0.04
        }
    }

    var textureHueRotation: Double {
        Double((number * 7) % 17) - 8
    }

    var tintStrength: Double {
        switch materialKind {
        case .metal: 0.28 + Double(number % 5) * 0.035
        case .crystal: 0.46 + Double(number % 4) * 0.05
        case .gas: 0.52 + Double(number % 4) * 0.06
        case .liquid: 0.5
        }
    }

    var motionRate: Double {
        0.7 + Double((number * 13) % 17) / 20
    }

    var highlightAngle: Double {
        7 + Double((number * 5) % 24)
    }

    var animationPhase: Double {
        Double(number) * 0.73
    }

    var isAppearancePredicted: Bool {
        number == 85 || number == 87 || number >= 99
    }

    var appearanceDescription: String {
        if materialKind == .metal {
            return metalAppearanceProfile.referenceNote
        }
        return switch number {
        case 1:
            "Hydrogen is shown here in liquid form, which requires extremely low temperatures. The blue flowing texture is a learning visualization; real liquid hydrogen is colorless."
        case 2:
            "Helium is a colorless gas; an electrical discharge gives it a peach-to-pink glow."
        case 3:
            "Lithium is a very soft, silvery-white metal whose fresh-cut surface quickly tarnishes in air."
        case 5:
            "Boron is commonly shown as a hard, brittle, dark brown-to-black crystalline solid."
        case 6:
            "Carbon has very different allotropes. This tile uses black, shiny, soft graphite layers rather than a recolored gemstone."
        case 7:
            "Nitrogen is a colorless gas. The blue-violet light here represents its glow in an electrical discharge."
        case 8:
            "Oxygen is a colorless gas; liquid oxygen is pale blue. The cool blue mist hints at that condensed form."
        case 9:
            "Fluorine is a very pale yellow gas, represented by a thin yellow-green haze."
        case 10:
            "Neon is colorless normally but produces a famous orange-red glow in an electrical discharge."
        case 11:
            "Sodium is a soft, silvery-white metal. Its fresh surface is bright but rapidly forms a dull coating in air."
        case 14:
            "Crystalline silicon is a hard, brittle solid with a dark blue-gray metallic sheen."
        case 15:
            "Phosphorus has several forms. This tile uses the red amorphous form with a soft, waxy surface."
        case 16:
            "The common form of sulfur is a bright yellow crystalline solid or powder, shown with angular yellow facets."
        case 17:
            "Chlorine is a dense yellow-green gas, shown as layered drifting vapor."
        case 18:
            "Argon is colorless normally and appears lilac-to-violet when electrically excited."
        case 19:
            "Potassium is a very soft silvery metal with a subtle lilac tint on a fresh-cut surface."
        case 26:
            "Iron is a lustrous gray metal; the directional grain suggests a worked iron surface."
        case 29:
            "Copper is one of the few naturally colored metals, with a warm reddish-orange metallic surface."
        case 31:
            "Gallium is a soft, silvery metal that melts just above room temperature, so the surface is smooth and rounded."
        case 34:
            "The most stable selenium form is a dense gray solid with a metallic sheen; other red forms also exist."
        case 35:
            "Bromine is a fuming red-brown liquid at room temperature, represented by dark moving ripples."
        case 47:
            "Silver is a bright white, highly reflective metal, shown with a cool polished shine."
        case 53:
            "Iodine is a black, shiny crystalline solid that forms violet vapor when heated; the tile uses dark reflective flakes."
        case 54:
            "Xenon is colorless normally and can glow blue-violet in an electrical discharge."
        case 55:
            "Cesium is an unusually pale-gold, very soft metal with a glossy fresh-cut surface."
        case 78:
            "Platinum is a dense, silvery-white metal with a smooth, restrained luster."
        case 79:
            "Gold has a naturally rich yellow metallic color and a highly reflective, malleable surface."
        case 80:
            "Mercury is a dense silver liquid at room temperature, shown with a mobile mirror-like surface."
        case 82:
            "Lead is a dense blue-gray metal that becomes dull as its freshly cut surface oxidizes."
        case 83:
            "Bismuth is a brittle silvery metal with a pink tinge. The rainbow surface suggests the oxide colors often seen on grown crystals."
        case 85:
            "Astatine has never been collected as a visible bulk sample. The hatched tile shows that its appearance is uncertain, not observed."
        case 86:
            "Radon is a colorless radioactive gas. The violet haze is an educational visualization rather than a visible cloud."
        case 87:
            "Francium exists only in trace amounts, so no visible bulk surface has been observed. Its appearance is shown as predicted."
        case 92:
            "Uranium is a dense silvery-gray metal that develops a dark oxide surface in air."
        case 94:
            "Plutonium is a silvery metal when freshly prepared, but it tarnishes and can show several crystal structures."
        case 104...118:
            "\(name) has only been produced atom-by-atom or in extremely tiny quantities, so a bulk real-life texture has not been observed. This tile is intentionally marked predicted."
        default:
            switch surfaceStyle {
            case .gasCloud:
                "\(name) is a gas at room temperature. Its moving haze is a visibility aid; isolated gas is often colorless."
            case .facetedCrystal:
                "\(name) is represented by an angular crystalline surface based on its solid elemental form."
            case .radioactiveMetal:
                "\(name) is a radioactive metallic solid. The pitted moving surface distinguishes it from ordinary polished metals."
            case .softCutMetal:
                "\(name) is a soft metallic solid, shown as a freshly cut surface with shallow dents and subdued shine."
            case .brushedMetal:
                "\(name) is a metallic solid, shown with its own seeded directional grain and reflectivity."
            case .hammeredMetal:
                "\(name) is a metallic solid, shown with an individual granular, dimpled surface."
            default:
                "\(name) is represented using its room-temperature state and a material structure specific to this tile."
            }
        }
    }
}

extension PeriodicElement {
    var standardStateDescription: String {
        if [1, 2, 7, 8, 9, 10, 17, 18, 36, 54, 86].contains(number) {
            return "a gas"
        }
        if [35, 80].contains(number) {
            return "a liquid"
        }
        if number >= 104 {
            return "a predicted solid or gas; only a few atoms have been studied"
        }
        return "a solid"
    }

    var occurrenceDescription: String {
        switch number {
        case 1:
            "On Earth it is mainly bound in water and organic compounds; it is also the most abundant element in stars."
        case 2:
            "Found in stars, natural-gas deposits, and tiny atmospheric amounts. On Earth it is also created by radioactive decay."
        case 3:
            "Mined from spodumene and other lithium minerals, and recovered from salt-lake and underground brines."
        case 4:
            "Obtained mainly from the minerals beryl and bertrandite; emerald and aquamarine are gem varieties of beryl."
        case 5:
            "Occurs in borate minerals such as borax, kernite, and colemanite, commonly concentrated in dry lake deposits."
        case 6:
            "Occurs in living matter, carbonates, coal, oil, and natural gas, and naturally as graphite or diamond."
        case 7:
            "Makes up about 78% of Earth’s atmosphere and also occurs in nitrates, ammonia, proteins, and other living material."
        case 8:
            "Makes up about 21% of the atmosphere and is abundant in water, rocks, minerals, and living organisms."
        case 9:
            "Too reactive to occur freely; it is found chiefly in fluorite, fluorapatite, and cryolite."
        case 10:
            "Present as a trace gas in the atmosphere and obtained commercially by separating liquefied air."
        case 11:
            "Found in seawater, salt lakes, underground brines, and rock salt, mainly as sodium chloride."
        case 12:
            "Abundant in seawater and in magnesite, dolomite, carnallite, and many silicate minerals."
        case 13:
            "Obtained mostly from bauxite ore, with smaller sources including alunite and other aluminum-rich minerals."
        case 14:
            "The second-most abundant element in Earth’s crust, occurring mainly as silica and silicate minerals."
        case 15:
            "Found in phosphate rock, especially apatite; it also occurs in DNA, bones, teeth, and living cells."
        case 16:
            "Occurs naturally near volcanic areas and in sulfide and sulfate minerals, fossil fuels, and living organisms."
        case 17:
            "Found as chloride salts in seawater, brines, and minerals such as halite rather than as free chlorine."
        case 18:
            "Makes up just under 1% of the atmosphere and is separated commercially from liquefied air."
        case 19:
            "Occurs in minerals and evaporite deposits such as sylvite and carnallite, and as dissolved ions in seawater."
        case 20:
            "Very abundant in limestone, chalk, marble, gypsum, fluorite, shells, bones, and teeth."
        case 21:
            "Dispersed through rare-earth minerals and obtained mainly as a by-product from ores such as thortveitite."
        case 22:
            "Found mainly in ilmenite and rutile ores, with large deposits in mineral sands and igneous rocks."
        case 23:
            "Occurs in vanadinite, carnotite, magnetite, phosphate rock, and some crude oils."
        case 24:
            "Obtained almost entirely from chromite ore, which forms in certain layered igneous deposits."
        case 25:
            "Found mainly in pyrolusite and other manganese oxides, as well as in seafloor manganese nodules."
        case 26:
            "Common in Earth’s crust as hematite, magnetite, siderite, and other ores; Earth’s core is largely iron."
        case 27:
            "Usually recovered as a by-product of copper and nickel mining from minerals such as cobaltite."
        case 28:
            "Mined from sulfide ores such as pentlandite and from laterite deposits formed by tropical weathering."
        case 29:
            "Found in sulfide ores such as chalcopyrite and occasionally as native metallic copper."
        case 30:
            "Obtained mainly from sphalerite, often mined together with lead, silver, and other sulfide ores."
        case 31:
            "Rarely concentrated in its own minerals; it is recovered mainly while processing bauxite and zinc ores."
        case 32:
            "Recovered as a by-product from zinc, copper, and lead ores, including germanite and sphalerite."
        case 33:
            "Occurs mainly in arsenopyrite and related sulfide minerals, often associated with copper, lead, and gold ores."
        case 34:
            "Usually recovered from copper-refining residues and from metal sulfide ores rather than mined alone."
        case 35:
            "Found as bromide ions in seawater, salt lakes, and concentrated underground brines."
        case 36:
            "A trace component of the atmosphere, obtained by fractional distillation of liquefied air."
        case 37:
            "Occurs in lithium-rich minerals such as lepidolite and pollucite and is usually obtained as a by-product."
        case 38:
            "Mined chiefly from celestite and strontianite; it also occurs in small amounts in seawater."
        case 39:
            "Found with rare-earth elements in xenotime, monazite, zircon, and other resistant minerals."
        case 40:
            "Obtained mainly from zircon, a durable mineral common in igneous rocks and heavy mineral sands."
        case 41:
            "Found in columbite-tantalite and pyrochlore ores, usually together with tantalum."
        case 42:
            "Obtained mainly from molybdenite and also recovered as a by-product of copper mining."
        case 43:
            "Occurs only in extremely small natural traces from uranium fission; useful amounts are made in nuclear reactors."
        case 44:
            "A rare platinum-group metal recovered from nickel, copper, and platinum ores."
        case 45:
            "One of the rarest crustal elements, recovered as a by-product while refining platinum-group ores."
        case 46:
            "Found with platinum-group metals and in nickel-copper ores; major deposits occur in layered igneous rocks."
        case 47:
            "Occurs as native silver and in minerals such as acanthite, often recovered from lead, zinc, copper, and gold ores."
        case 48:
            "Obtained mainly as a by-product of zinc refining from ores such as sphalerite."
        case 49:
            "Recovered chiefly as a by-product from zinc ores and, to a lesser extent, tin and copper ores."
        case 50:
            "Mined mainly from cassiterite, including deposits concentrated in river and coastal sands."
        case 51:
            "Obtained mainly from stibnite and often associated with lead, silver, and gold deposits."
        case 52:
            "A rare element found in telluride minerals and recovered mostly from copper-refining residues."
        case 53:
            "Recovered from underground brines and iodate-rich caliche deposits; seawater contains only small amounts."
        case 54:
            "A trace atmospheric gas also found in some natural-gas wells and produced by radioactive fission."
        case 55:
            "Obtained chiefly from pollucite, a rare mineral commonly found in lithium-rich pegmatites."
        case 56:
            "Mined mainly from barite and witherite deposits."
        case 57...60, 62...71:
            "Found mixed with other rare-earth elements in minerals such as monazite, bastnäsite, and xenotime."
        case 61:
            "Not found in useful natural deposits; tiny traces may occur in uranium minerals, but it is produced in reactors."
        case 72:
            "Found with zirconium in zircon and related minerals; separating the two metals is difficult."
        case 73:
            "Obtained mainly from tantalite and columbite ores, often mined together with niobium."
        case 74:
            "Mined chiefly from wolframite and scheelite ores."
        case 75:
            "One of the rarest natural elements, recovered from molybdenite and some copper ores."
        case 76...78:
            "A rare platinum-group element found in platinum ores and recovered during nickel and copper refining."
        case 79:
            "Occurs unusually often as native metal in quartz veins and alluvial deposits, and also in telluride ores."
        case 80:
            "Obtained mainly from cinnabar, a bright red mercury sulfide mineral."
        case 81:
            "Recovered as a by-product from sulfide ores of copper, lead, and zinc."
        case 82:
            "Mined mainly from galena, commonly associated with zinc, silver, and copper minerals."
        case 83:
            "Found in bismuthinite and as native bismuth, and recovered as a by-product of lead and copper processing."
        case 84:
            "Occurs only in tiny radioactive traces in uranium ores and is also produced artificially."
        case 85:
            "Exists only as fleeting traces in uranium and thorium decay chains; research samples are made artificially."
        case 86:
            "A radioactive gas produced naturally when radium in rocks and soil decays; it can accumulate in buildings."
        case 87:
            "Occurs only momentarily in uranium decay chains; no weighable natural sample has ever been collected."
        case 88:
            "Present in tiny amounts in uranium ores as part of natural radioactive decay chains."
        case 89:
            "Occurs in minute traces in uranium ores and is mainly produced for research."
        case 90:
            "Found in monazite, thorite, and other minerals, commonly alongside rare-earth elements and uranium."
        case 91:
            "Occurs in extremely small amounts in uranium ores such as pitchblende."
        case 92:
            "Mined mainly from uraninite and related uranium-bearing minerals."
        case 93:
            "Tiny natural traces occur in uranium ores, but useful amounts are produced in nuclear reactors."
        case 94:
            "Tiny natural traces may occur in uranium ores; nearly all plutonium is manufactured in nuclear reactors."
        case 95...103:
            "Primarily produced by neutron irradiation in nuclear reactors or specialized laboratories; natural amounts are negligible."
        default:
            "A synthetic element produced atom-by-atom in particle accelerators. It does not occur in usable natural deposits."
        }
    }

    var formsDescription: String {
        let state = "Near room temperature, elemental \(name) is \(standardStateDescription). "

        let detail: String = switch number {
        case 1:
            "It commonly forms H₂ molecules, water, hydrocarbons, hydrides, and the isotopes protium, deuterium, and tritium."
        case 6:
            "Major allotropes include graphite, diamond, graphene, fullerenes, and amorphous carbon."
        case 8:
            "It occurs as O₂, ozone (O₃), water, oxides, silicates, and countless organic compounds."
        case 15:
            "Important allotropes include white, red, violet, and black phosphorus; nature mainly contains phosphate compounds."
        case 16:
            "It has many allotropes, commonly forming yellow S₈ crystals, and also occurs in sulfides and sulfates."
        case 34:
            "It has gray, red, and black allotropes and forms selenides, selenites, and selenates."
        case 35:
            "Elemental bromine forms Br₂ molecules; natural bromine is normally present as bromide salts."
        case 50:
            "It has metallic white beta-tin and brittle gray alpha-tin allotropes, and forms stannous and stannic compounds."
        case 53:
            "Elemental iodine forms I₂ crystals and violet vapor; nature mainly contains iodides and iodates."
        case 80:
            "It is a liquid metal under ordinary conditions and readily forms amalgams, sulfides, oxides, and ionic compounds."
        case 104...118:
            "Only short-lived isotopes and a limited number of atoms or compounds have been observed, so bulk forms are predicted."
        default:
            switch category {
            case .alkaliMetal:
                "It is a soft elemental metal but occurs naturally as \(name.lowercased()) ions in salts, oxides, and other ionic compounds."
            case .alkalineEarthMetal:
                "It forms the pure metal, oxides, hydroxides, carbonates, sulfates, and many other +2 ionic compounds."
            case .transitionMetal:
                "It can appear as pure metal, alloys, oxides, sulfides, halides, and compounds with several oxidation states."
            case .postTransitionMetal:
                "It occurs as elemental metal or metalloid-like solid, in alloys, and in oxides, sulfides, and salts."
            case .metalloid:
                "It can have crystalline or amorphous forms and commonly makes covalent oxides, sulfides, and semiconductor compounds."
            case .reactiveNonmetal:
                "It forms molecular or network elemental structures and a wide range of covalent and ionic compounds."
            case .halogen:
                "Its elemental form is normally diatomic, while natural material is dominated by halide salts and oxyanions."
            case .nobleGas:
                "It normally exists as individual monatomic gas atoms; only the heavier members form a small number of compounds."
            case .lanthanide:
                "It forms a silvery metal, alloys, oxides, halides, and mostly +3 rare-earth compounds."
            case .actinide:
                "It can form a radioactive metal, oxides, halides, and compounds in several oxidation states."
            }
        }

        return state + detail
    }

    var usesDescription: String {
        switch number {
        case 1: "Used to make ammonia and methanol, refine fuels, hydrogenate oils, power fuel cells, and fuel rockets."
        case 2: "Used for cryogenic cooling, MRI magnets, leak detection, shielding gas, scientific balloons, and spacecraft systems."
        case 3: "Important in rechargeable batteries, heat-resistant glass, ceramics, lightweight alloys, and lubricating greases."
        case 4: "Used in aerospace alloys, X-ray windows, precision instruments, and copper-beryllium springs and tools."
        case 5: "Used in heat-resistant glass, detergents, fiberglass, magnets, abrasives, and semiconductor doping."
        case 6: "Used in steel, fuels, electrodes, filters, lubricants, cutting tools, jewelry, composites, and electronics."
        case 7: "Used to make fertilizers and nitric acid, create inert atmospheres, freeze materials, and preserve foods."
        case 8: "Used in medicine, steelmaking, welding, water treatment, chemical production, and rocket oxidizers."
        case 9: "Used to make fluoropolymers, refrigerants, uranium fuel materials, pharmaceuticals, and fluoride compounds."
        case 10: "Used in illuminated signs, indicators, lasers, high-voltage equipment, and cryogenic refrigeration."
        case 11: "Used in chemical manufacture, sodium-vapor lamps, heat transfer, and many compounds including salt and glass."
        case 12: "Used in light alloys, flares, fireworks, steelmaking, medicines, and magnesium compounds."
        case 13: "Used extensively in transport, buildings, packaging, electrical conductors, cookware, and corrosion-resistant alloys."
        case 14: "Essential for computer chips, solar cells, glass, concrete, ceramics, silicones, and many alloys."
        case 15: "Used mainly in fertilizers, with additional roles in matches, pesticides, detergents, steel, and biological chemistry."
        case 16: "Most sulfur becomes sulfuric acid for fertilizers and industry; it is also used to vulcanize rubber."
        case 17: "Used to disinfect water, make PVC, bleach materials, and manufacture many chemicals and medicines."
        case 18: "Used as an inert welding gas, in lamps, metal production, insulated windows, and scientific instruments."
        case 19: "Used mainly as potassium compounds in fertilizers, soaps, glass, medicines, and biological nutrition."
        case 20: "Its compounds make cement, lime, plaster, steel fluxes, medicines, and agricultural soil treatments."
        case 21: "Used in high-performance aluminum alloys, stadium lighting, ceramics, and specialized research materials."
        case 22: "Used in strong lightweight aerospace alloys, implants, pigments, corrosion-resistant equipment, and catalysts."
        case 23: "Used to strengthen steel and titanium alloys, and in catalysts, pigments, and vanadium redox batteries."
        case 24: "Used in stainless steel, protective plating, pigments, refractories, and high-temperature alloys."
        case 25: "Used in steelmaking, aluminum alloys, batteries, pigments, fertilizers, and chemical oxidizers."
        case 26: "The basis of steel and cast iron used in buildings, vehicles, machinery, tools, magnets, and infrastructure."
        case 27: "Used in superalloys, lithium-ion batteries, magnets, catalysts, pigments, and vitamin B₁₂."
        case 28: "Used in stainless steel, superalloys, batteries, plating, catalysts, coins, and corrosion-resistant equipment."
        case 29: "Used in electrical wiring, motors, electronics, plumbing, heat exchangers, coins, and bronze and brass."
        case 30: "Used to galvanize steel, make brass and die-casting alloys, batteries, sunscreen, rubber, and chemicals."
        case 31: "Used in semiconductors, LEDs, high-speed electronics, low-melting alloys, and specialized solar cells."
        case 32: "Used in fiber optics, infrared optics, semiconductors, solar cells, detectors, and polymerization catalysts."
        case 33: "Used in some semiconductors, alloys, glass, and wood treatments, although toxicity has reduced many older uses."
        case 34: "Used in glassmaking, pigments, electronics, solar cells, photocopiers, metallurgy, and dietary supplements."
        case 35: "Used in flame retardants, drilling fluids, photography chemicals, medicines, dyes, and water treatment."
        case 36: "Used in high-performance lighting, photographic flashes, lasers, insulation, and specialized medical imaging."
        case 37: "Used in atomic clocks, research, photocells, specialty glass, and some navigation and timing systems."
        case 38: "Used in red fireworks, ferrite magnets, ceramics, pigments, medical imaging, and specialized glass."
        case 39: "Used in lasers, superconductors, ceramics, phosphors, and strong high-temperature alloys."
        case 40: "Used in nuclear-reactor cladding, corrosion-resistant equipment, ceramics, gemstones, and foundry materials."
        case 41: "Used mainly to strengthen steels and superalloys, and in superconducting magnets and electronic components."
        case 42: "Used in strong high-temperature steels, catalysts, lubricants, pigments, and electrical contacts."
        case 43: "Its medical isotope technetium-99m is widely used for diagnostic imaging; other uses are mainly research."
        case 44: "Used in wear-resistant electrical contacts, catalysts, chip resistors, and hard platinum-group alloys."
        case 45: "Used in automotive catalysts, chemical catalysts, reflective coatings, electrical contacts, and specialized alloys."
        case 46: "Used in catalytic converters, electronics, hydrogen purification, dentistry, jewelry, and chemical catalysts."
        case 47: "Used in electronics, solar cells, mirrors, jewelry, photography, brazing alloys, and antimicrobial products."
        case 48: "Used in rechargeable batteries, pigments, coatings, control rods, and specialized low-melting alloys."
        case 49: "Used in touchscreens, displays, semiconductors, solders, solar cells, and low-melting alloys."
        case 50: "Used in solder, tinplate, bronze, glass coatings, chemicals, and corrosion-resistant alloys."
        case 51: "Used in flame retardants, lead alloys, semiconductors, batteries, and low-friction metal products."
        case 52: "Used in solar cells, thermoelectric devices, alloys, optical discs, rubber production, and metal refining."
        case 53: "Used in medicines, disinfectants, nutrition, photography chemicals, catalysts, and polarizing films."
        case 54: "Used in bright lamps, camera flashes, ion engines, lasers, medical anesthesia, and particle detectors."
        case 55: "Used mainly in highly accurate atomic clocks, photoelectric devices, drilling fluids, and research."
        case 56: "Used in medical contrast agents, drilling fluids, ceramics, glass, vacuum tubes, and green fireworks."
        case 57: "Used in camera lenses, catalysts, battery electrodes, lighter flints, optical glass, and metal alloys."
        case 58: "Used in catalysts, glass polishing, self-cleaning ovens, lighter flints, and specialized alloys."
        case 59: "Used in strong permanent magnets, aircraft alloys, glass coloring, and specialized lighting."
        case 60: "Used in powerful magnets, lasers, glass coloring, headphones, motors, and wind-turbine generators."
        case 61: "Used mainly as a scientific tracer, nuclear battery material, and research source."
        case 62: "Used in magnets, reactor control materials, optical glass, lasers, and specialized medical applications."
        case 63: "Used in red and blue phosphors, anti-counterfeiting marks, lasers, and neutron-absorbing reactor materials."
        case 64: "Used in MRI contrast compounds, neutron shielding, phosphors, magnets, and high-temperature alloys."
        case 65: "Used in green phosphors, solid-state devices, lasers, magnets, and specialized alloys."
        case 66: "Used in powerful magnets, lasers, data storage, lighting, and reactor control materials."
        case 67: "Used in strong magnets, lasers, nuclear control rods, and specialized optical equipment."
        case 68: "Used in fiber-optic amplifiers, lasers, glass coloring, and specialized alloys."
        case 69: "Used in portable X-ray sources, lasers, and high-temperature ceramic and magnetic materials."
        case 70: "Used in fiber lasers, stainless-steel grain refinement, stress gauges, and specialized alloys."
        case 71: "Used in medical imaging and therapy compounds, catalysts, LEDs, detectors, and high-density materials."
        case 72: "Used in nuclear control rods, superalloys, plasma-cutting electrodes, microchips, and high-temperature ceramics."
        case 73: "Used in capacitors, surgical implants, chemical equipment, superalloys, and corrosion-resistant electronics."
        case 74: "Used in cutting tools, wear-resistant carbides, high-temperature alloys, weights, and lamp filaments."
        case 75: "Used in jet-engine superalloys, catalysts, electrical contacts, thermocouples, and wear-resistant components."
        case 76: "Used in very hard alloys, electrical contacts, instrument pivots, catalysts, and staining biological samples."
        case 77: "Used in spark plugs, crucibles, catalysts, electronics, and very corrosion-resistant high-temperature alloys."
        case 78: "Used in catalytic converters, chemical catalysts, laboratory equipment, jewelry, electronics, and medicines."
        case 79: "Used in electronics, connectors, jewelry, dentistry, aerospace coatings, investments, and some medicines."
        case 80: "Historically used in instruments, lamps, switches, and chemical processes; toxicity has greatly restricted use."
        case 81: "Used in electronics, infrared optics, specialized glass, detectors, and some medical diagnostic compounds."
        case 82: "Used mainly in lead-acid batteries, radiation shielding, weights, ammunition, and specialized alloys."
        case 83: "Used in low-melting alloys, medicines, cosmetics, pigments, fire-safety devices, and lead-free replacements."
        case 84: "Used mainly in research; historically it was used in compact heat sources and antistatic devices."
        case 85...91: "Used chiefly for scientific research, isotope studies, or specialized radioactive sources."
        case 92: "Used mainly as nuclear-reactor fuel; depleted uranium is also used in shielding and very dense counterweights."
        case 93: "Used in neutron detectors, research, and as a precursor for producing heavier synthetic elements."
        case 94: "Used in nuclear fuel, radioisotope power systems, research, and nuclear weapons."
        case 95: "Used in smoke detectors, industrial gauges, research, and as a source for producing heavier elements."
        case 96: "Used mainly in research and in specialized radioisotope power sources."
        case 97...118: "No routine public use; the small quantities produced are used to study nuclear structure and chemical behavior."
        default: "Used mainly in research and specialized industrial chemistry."
        }
    }

    var safetyDescription: String {
        if number >= 84 || [43, 61].contains(number) {
            return "Radioactive. Exposure must be minimized and handling requires trained personnel, shielding, monitoring, and licensed facilities."
        }

        return switch number {
        case 1:
            "Highly flammable and capable of forming explosive mixtures with air; compressed and cryogenic forms require specialist equipment."
        case 2, 10, 18, 36, 54:
            "Chemically unreactive but can displace oxygen in enclosed spaces. Cryogenic liquid can cause severe cold burns."
        case 4:
            "Beryllium dust and fumes are highly toxic when inhaled and can cause serious chronic lung disease."
        case 7:
            "Normally low-toxicity, but it can displace oxygen; liquid nitrogen can cause cold burns and pressure buildup."
        case 8:
            "Not itself flammable, but concentrated oxygen makes other materials ignite and burn much more vigorously."
        case 9:
            "Extremely reactive, corrosive, and toxic. Direct contact or inhalation can cause severe injury."
        case 11, 19, 37, 55:
            "The pure metal reacts violently with water and must be kept away from moisture; fires require special methods."
        case 12, 13, 22, 24, 25, 26, 30:
            "Bulk metal is commonly manageable, but fine powder or fumes can burn, explode, or damage the lungs."
        case 15:
            "White phosphorus is highly toxic and can ignite in air; red and black forms are much less reactive."
        case 17:
            "Chlorine gas is toxic and strongly irritating to the lungs, eyes, and skin."
        case 27, 28:
            "Dust and soluble compounds can be harmful; nickel and cobalt may cause skin sensitization and chronic health effects."
        case 33:
            "Arsenic and many of its compounds are highly toxic and carcinogenic."
        case 34:
            "Essential only in tiny dietary amounts; excessive selenium exposure is toxic."
        case 35:
            "Bromine is corrosive, toxic, and volatile, causing severe skin, eye, and respiratory burns."
        case 48:
            "Cadmium and its compounds are highly toxic and carcinogenic, especially when dust or fumes are inhaled."
        case 53:
            "Iodine vapor irritates tissues; excessive exposure can disrupt thyroid function."
        case 80:
            "Mercury vapor and many mercury compounds are highly toxic and can damage the nervous system."
        case 81:
            "Thallium and its compounds are extremely toxic and can be absorbed through the skin."
        case 82:
            "Lead is a cumulative poison that damages the nervous system, especially in children."
        default:
            "The elemental form may be manageable in bulk, but powders, fumes, reactive compounds, and laboratory samples require proper ventilation and protective equipment."
        }
    }
}

struct ElementDetailView: View {
    let element: PeriodicElement
    @Environment(\.dismiss) private var dismiss
    @State private var tutorPrompt = ""
    @State private var isShowingTutor = false

    var body: some View {
        ZStack {
            Color.skillSyncBackground.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Spacer()
                        Button("Done") { dismiss() }
                            .font(.headline)
                            .foregroundStyle(.cyan)
                    }

                    VStack(spacing: 6) {
                        Text("\(element.number)")
                            .font(.headline)
                            .foregroundStyle(.white.opacity(0.6))

                        Text(element.symbol)
                            .font(.system(size: 72, weight: .black, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white, element.category.color],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        Text(element.name)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)

                        Text(element.scienceSummaryLine)
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundStyle(.white.opacity(0.48))
                            .multilineTextAlignment(.center)
                    }

                    ElementDetailMaterialPreview(element: element)

                    Text(element.category.title)
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundStyle(element.category.color)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            element.category.color.opacity(0.13),
                            in: Capsule()
                        )

                    VStack(spacing: 9) {
                        Text(
                            element.isAppearancePredicted
                                ? "PREDICTED APPEARANCE"
                                : "REAL-WORLD APPEARANCE"
                        )
                        .font(.system(size: 11, weight: .black, design: .rounded))
                        .tracking(1.4)
                        .foregroundStyle(
                            element.isAppearancePredicted ? .purple : .cyan
                        )

                        if element.materialKind == .metal &&
                            !element.isAppearancePredicted {
                            Text("REFERENCE: FRESH PURE SAMPLE · NEAR ROOM TEMPERATURE")
                                .font(.system(size: 9, weight: .bold, design: .rounded))
                                .tracking(0.7)
                                .foregroundStyle(.white.opacity(0.42))
                        }

                        Text(element.appearanceDescription)
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .foregroundStyle(.white.opacity(0.78))
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)

                        Text(element.category.description)
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundStyle(.white.opacity(0.5))
                            .multilineTextAlignment(.center)
                            .lineSpacing(3)
                    }

                    ElementPhaseExplorer(element: element)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("LEARN MORE")
                            .font(.system(size: 12, weight: .black, design: .rounded))
                            .tracking(1.5)
                            .foregroundStyle(.cyan)
                            .padding(.leading, 4)

                        ElementInformationRow(
                            icon: "atom",
                            title: "Inside one atom",
                            text: element.atomicCompositionDescription,
                            accent: .cyan
                        )

                        ElementInformationRow(
                            icon: "cube.transparent.fill",
                            title: "Pure element vs. materials",
                            text: element.materialCompositionDescription,
                            accent: .purple
                        )

                        ElementInformationRow(
                            icon: "thermometer.medium",
                            title: "When each phase appears",
                            text: element.phaseConditionsDescription,
                            accent: .red
                        )

                        ElementInformationRow(
                            icon: "eye.fill",
                            title: "How the forms look",
                            text: element.formAppearanceDescription,
                            accent: .indigo
                        )

                        ElementInformationRow(
                            icon: "globe.americas.fill",
                            title: "Where it is found",
                            text: element.occurrenceDescription,
                            accent: .teal
                        )

                        ElementInformationRow(
                            icon: "hammer.fill",
                            title: "Common uses",
                            text: element.usesDescription,
                            accent: .blue
                        )

                        ElementInformationRow(
                            icon: "exclamationmark.shield.fill",
                            title: "Safety and handling",
                            text: element.safetyDescription,
                            accent: .orange
                        )
                    }

                    ElementTutorQuestionPanel(element: element) { prompt in
                        tutorPrompt = prompt
                        isShowingTutor = true
                    }
                }
                .padding(24)
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $isShowingTutor) {
            TutorView(
                initialPrompt: tutorPrompt,
                isPresentedModally: true,
                contextTitle: "\(element.name) Tutor",
                studyContext: element.tutorStudyContext
            )
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }
}

struct ElementInformationRow: View {
    let icon: String
    let title: String
    let text: String
    let accent: Color

    var body: some View {
        HStack(alignment: .top, spacing: 13) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(accent)
                .frame(width: 34, height: 34)
                .background(accent.opacity(0.13), in: RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                Text(text)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.67))
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .padding(14)
        .background(
            LinearGradient(
                colors: [accent.opacity(0.1), .white.opacity(0.035)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 17)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 17)
                .stroke(accent.opacity(0.18), lineWidth: 1)
        }
    }
}

extension ElementPhysicalForm {
    var icon: String {
        switch self {
        case .solid: "cube.fill"
        case .liquid: "drop.fill"
        case .gas: "cloud.fill"
        }
    }
}

struct ElementPhaseExplorer: View {
    let element: PeriodicElement
    @State private var selectedForm: ElementPhysicalForm
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(element: PeriodicElement) {
        self.element = element

        let state = element.scienceRecord.standardState.lowercased()
        let initialForm: ElementPhysicalForm
        if state.contains("liquid") {
            initialForm = .liquid
        } else if state.contains("gas") {
            initialForm = .gas
        } else {
            initialForm = .solid
        }
        _selectedForm = State(initialValue: initialForm)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("FORM EXPLORER")
                        .font(.system(size: 11, weight: .black, design: .rounded))
                        .tracking(1.4)
                        .foregroundStyle(.cyan)

                    Text("See how \(element.name) changes")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }

                Spacer()

                Image(systemName: "sparkles")
                    .foregroundStyle(.purple)
            }

            HStack(spacing: 8) {
                ForEach(ElementPhysicalForm.allCases) { form in
                    let isSelected = selectedForm == form

                    Button {
                        withAnimation(.easeInOut(duration: 0.22)) {
                            selectedForm = form
                        }
                    } label: {
                        Label(form.title, systemImage: form.icon)
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                isSelected ? .white : .white.opacity(0.52)
                            )
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(
                                isSelected
                                    ? element.category.color.opacity(0.34)
                                    : .white.opacity(0.055),
                                in: RoundedRectangle(cornerRadius: 12)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }

            Group {
                if selectedForm == .solid {
                    phasePreview(at: 0)
                } else {
                    TimelineView(
                        .animation(
                            minimumInterval: 1 / 12,
                            paused: reduceMotion
                        )
                    ) { timeline in
                        phasePreview(
                            at: reduceMotion
                                ? 0
                                : timeline.date.timeIntervalSinceReferenceDate
                        )
                    }
                }
            }

            Label(
                element.conditionDescription(for: selectedForm),
                systemImage: "thermometer.medium"
            )
            .font(.system(size: 12, weight: .semibold, design: .rounded))
            .foregroundStyle(.white.opacity(0.68))
            .fixedSize(horizontal: false, vertical: true)

            Text(element.formAppearanceDescription)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.62))
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)

            Text("Animated previews are educational visualizations, not photographs. Colors can change with pressure, purity, allotrope, and lighting.")
                .font(.system(size: 10, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.36))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [
                    element.category.color.opacity(0.12),
                    .purple.opacity(0.07),
                    .white.opacity(0.025)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 22)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 22)
                .stroke(element.category.color.opacity(0.24), lineWidth: 1)
        }
    }

    private func phasePreview(at time: TimeInterval) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(.black.opacity(0.26))

            switch selectedForm {
            case .solid:
                SolidElementSpecimen(element: element, time: 0)
                    .equatable()
                    .scaleEffect(2.15)
                    .frame(width: 150, height: 102)
            case .liquid:
                GenericElementLiquidPhase(element: element, time: time)
                    .frame(width: 168, height: 102)
            case .gas:
                ContainedGasSpecimen(element: element, time: time)
                    .frame(width: 174, height: 104)
            }

            VStack {
                HStack {
                    Label(
                        selectedForm.title.uppercased(),
                        systemImage: selectedForm.icon
                    )
                    .font(.system(size: 9, weight: .black, design: .rounded))
                    .tracking(1)
                    .foregroundStyle(.white.opacity(0.74))
                    .padding(.horizontal, 9)
                    .padding(.vertical, 6)
                    .background(.black.opacity(0.34), in: Capsule())

                    Spacer()
                }
                Spacer()
            }
            .padding(10)
        }
        .frame(height: 132)
        .clipped()
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .stroke(.white.opacity(0.1), lineWidth: 1)
        }
        .accessibilityLabel(
            "Animated \(selectedForm.rawValue) preview for \(element.name)"
        )
    }
}

private struct GenericElementLiquidPhase: View {
    let element: PeriodicElement
    let time: TimeInterval

    private var colors: [Color] {
        switch element.number {
        case 1, 2, 7:
            [.white.opacity(0.2), .cyan.opacity(0.28), .white.opacity(0.72)]
        case 8:
            [Color(red: 0.12, green: 0.48, blue: 0.95), .cyan, .white.opacity(0.7)]
        case 9, 17:
            [.yellow.opacity(0.55), .green.opacity(0.58), .white.opacity(0.64)]
        case 35:
            [Color(red: 0.18, green: 0.005, blue: 0), .red, .orange.opacity(0.55)]
        case 53:
            [.black, .purple.opacity(0.9), .indigo]
        case 80:
            [Color(white: 0.18), .white.opacity(0.92), Color(white: 0.42)]
        default:
            [
                element.materialTint.opacity(0.48),
                element.materialTint,
                .white.opacity(0.72)
            ]
        }
    }

    var body: some View {
        let container = IrregularPolygonShape(
            seed: element.number + 211,
            sideCount: 7 + element.number % 3
        )

        ZStack {
            container
                .fill(.white.opacity(0.025))

            LinearGradient(
                colors: colors,
                startPoint: .leading,
                endPoint: .trailing
            )
            .overlay {
                Canvas(rendersAsynchronously: true) { context, size in
                    for glint in 0..<5 {
                        let travel = (
                            time * Double(7 + glint)
                                + Double(glint * 19 + element.number)
                        ).truncatingRemainder(
                            dividingBy: Double(size.width + 24)
                        )
                        let y = size.height
                            * (0.55 + CGFloat(glint % 3) * 0.1)
                        let width = CGFloat(8 + glint * 3)
                        let rect = CGRect(
                            x: CGFloat(travel) - 12,
                            y: y,
                            width: width,
                            height: 1.3
                        )
                        context.fill(
                            Path(roundedRect: rect, cornerRadius: 1),
                            with: .color(.white.opacity(0.48))
                        )
                    }
                }
            }
            .mask {
                ElementLiquidFillMask(
                    time: time,
                    phase: element.animationPhase,
                    waveSpeed: 1.3,
                    waveAmplitude: 2.4
                )
            }
            .mask(container)

            container
                .stroke(.white.opacity(0.14), lineWidth: 1)
        }
        .shadow(color: element.materialTint.opacity(0.2), radius: 8, y: 3)
        .allowsHitTesting(false)
    }
}

struct ElementTutorQuestionPanel: View {
    let element: PeriodicElement
    let onAsk: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("ASK THE AI TUTOR", systemImage: "sparkles")
                .font(.system(size: 12, weight: .black, design: .rounded))
                .tracking(1.3)
                .foregroundStyle(.cyan)

            Text("Choose a guided review. The tutor will ask questions, wait for your answers, correct mistakes, and add memory tips.")
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.62))
                .fixedSize(horizontal: false, vertical: true)

            ForEach(
                Array(element.focusedTutorQuestions.enumerated()),
                id: \.offset
            ) { index, question in
                Button {
                    onAsk(question)
                } label: {
                    HStack(spacing: 12) {
                        Text("\(index + 1)")
                            .font(.system(size: 12, weight: .black, design: .rounded))
                            .foregroundStyle(.white)
                            .frame(width: 28, height: 28)
                            .background(
                                LinearGradient(
                                    colors: [.cyan, .blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                in: Circle()
                            )

                        Text(question)
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundStyle(.white.opacity(0.8))
                            .multilineTextAlignment(.leading)

                        Spacer(minLength: 0)

                        Image(systemName: "arrow.up.right")
                            .font(.caption.bold())
                            .foregroundStyle(.cyan)
                    }
                    .padding(12)
                    .background(.white.opacity(0.055))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .overlay {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.cyan.opacity(0.16), lineWidth: 1)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [.cyan.opacity(0.1), .purple.opacity(0.08)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 22)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 22)
                .stroke(.cyan.opacity(0.22), lineWidth: 1)
        }
    }
}

struct ElementDetailMaterialPreview: View {
    let element: PeriodicElement
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var rotationX = 0.0
    @State private var rotationY = 0.0
    @State private var wheelRotation = 0.0
    @State private var lastWheelTouchAngle: Double?
    @GestureState private var dragOffset = CGSize.zero

    private var isAnimatedMaterial: Bool {
        element.materialKind == .liquid
            || element.materialKind == .gas
    }

    private var isSpinnable: Bool {
        element.number == 1
            || element.materialKind == .metal
            || element.materialKind == .crystal
    }

    private var displayedRotationX: Double {
        rotationX - Double(dragOffset.height) * 0.48
    }

    private var displayedRotationY: Double {
        rotationY + Double(dragOffset.width) * 0.58
    }

    private var spinGesture: some Gesture {
        DragGesture(minimumDistance: 2)
            .updating($dragOffset) { value, state, _ in
                state = value.translation
            }
            .onEnded { value in
                rotationX -= Double(value.translation.height) * 0.48
                rotationY += Double(value.translation.width) * 0.58
            }
    }

    private var wheelGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged { value in
                let center = CGPoint(x: 75, y: 59)
                let x = value.location.x - center.x
                let y = value.location.y - center.y
                guard hypot(x, y) > 18 else { return }

                let angle = atan2(y, x) * 180 / .pi

                if let lastAngle = lastWheelTouchAngle {
                    var change = angle - lastAngle
                    if change > 180 {
                        change -= 360
                    } else if change < -180 {
                        change += 360
                    }

                    let previousTick = Int(wheelRotation / 5)
                    let nextRotation = wheelRotation + change
                    let nextTick = Int(nextRotation / 5)
                    wheelRotation = nextRotation

                    if previousTick != nextTick {
                        WheelTickFeedback.play(
                            steps: abs(nextTick - previousTick)
                        )
                    }
                }

                lastWheelTouchAngle = angle
            }
            .onEnded { _ in
                lastWheelTouchAngle = nil
            }
    }

    var body: some View {
        Group {
            if isAnimatedMaterial {
                TimelineView(
                    .animation(
                        minimumInterval: element.materialKind == .gas
                            ? 1 / 20
                            : 1 / 30,
                        paused: reduceMotion
                    )
                ) { timeline in
                    preview(
                        at: reduceMotion
                            ? 0
                            : timeline.date.timeIntervalSinceReferenceDate
                    )
                }
            } else {
                preview(at: 0)
            }
        }
    }

    private func preview(at time: TimeInterval) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [
                            element.category.color.opacity(0.13),
                            .blue.opacity(0.06),
                            .white.opacity(0.035)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            material(at: time)

            VStack {
                Spacer()
                Text(
                    element.materialKind == .gas
                        ? "VAPOR MOVING INSIDE A CONTAINER"
                        : (
                            isSpinnable
                                ? "DRAG TO SPIN · \(element.materialKind.label.uppercased())"
                                : "\(element.materialKind.label.uppercased()) TEXTURE"
                        )
                )
                    .font(.system(size: 10, weight: .black, design: .rounded))
                    .tracking(1.2)
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(.black.opacity(0.34), in: Capsule())
                    .padding(.bottom, 10)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 160)
        .overlay {
            RoundedRectangle(cornerRadius: 24)
                .stroke(element.category.color.opacity(0.3), lineWidth: 1)
        }
        .accessibilityLabel(
            "\(element.materialKind.label) texture preview for \(element.name)"
        )
        .accessibilityHint(
            element.materialKind == .gas
                ? "Shows an educational vapor visualization inside a container"
                : (isSpinnable ? "Drag to rotate the specimen" : "")
        )
    }

    @ViewBuilder
    private func material(at time: TimeInterval) -> some View {
        if element.number == 1 {
            WaterLiquidSpecimen(time: time)
                .scaleEffect(2.6)
                .frame(width: 138, height: 118)
                .mask(IrregularOctagonShape(seed: element.number))
                .rotation3DEffect(
                    .degrees(displayedRotationX),
                    axis: (x: 1, y: 0, z: 0),
                    perspective: 0.42
                )
                .rotation3DEffect(
                    .degrees(displayedRotationY),
                    axis: (x: 0, y: 1, z: 0),
                    perspective: 0.42
                )
                .shadow(color: .cyan.opacity(0.38), radius: 12, y: 5)
                .gesture(spinGesture)

        } else if element.materialKind == .metal ||
                    element.materialKind == .crystal {
            SolidElementSpecimen(
                element: element,
                time: 0
            )
            .equatable()
            .scaleEffect(2.15)
            .rotationEffect(.degrees(wheelRotation))
            .frame(width: 150, height: 118)
            .contentShape(Circle())
            .gesture(wheelGesture)

        } else if element.materialKind == .liquid {
            ElementLiquidSpecimen(element: element, time: time)
                .scaleEffect(2.25)

        } else if element.materialKind == .gas {
            ContainedGasSpecimen(element: element, time: time)
                .frame(width: 172, height: 116)

        }
    }
}

private enum WheelTickFeedback {
    private static let clickSound = SystemSoundID(1104)
    private static let haptic = UISelectionFeedbackGenerator()

    static func play(steps: Int) {
        for _ in 0..<steps {
            AudioServicesPlaySystemSound(clickSound)
            haptic.selectionChanged()
        }
        haptic.prepare()
    }
}

struct Solid3DSpecimen: View {
    let element: PeriodicElement

    var body: some View {
        CenteredSpecimenSceneView(
            scene: makeScene(),
            cameraName: "specimen-camera"
        )
        .background(.clear)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .accessibilityHidden(true)
    }

    private func makeScene() -> SCNScene {
        let scene = SCNScene()
        scene.rootNode.name = "specimen-scene-\(element.number)"
        scene.background.contents = UIColor.clear

        let geometry = rockGeometry(seed: element.number)
        geometry.materials = [specimenMaterial()]

        let specimen = SCNNode(geometry: geometry)
        specimen.castsShadow = false

        let specimenPivot = SCNNode()
        specimenPivot.name = "specimen-pivot"
        specimenPivot.eulerAngles = SCNVector3(-0.18, 0.44, 0.04)
        specimenPivot.addChildNode(specimen)
        scene.rootNode.addChildNode(specimenPivot)

        let camera = SCNCamera()
        camera.fieldOfView = 31
        camera.zNear = 0.1
        camera.zFar = 100
        camera.wantsHDR = false
        camera.wantsExposureAdaptation = false
        camera.exposureOffset = -0.35
        let cameraNode = SCNNode()
        cameraNode.name = "specimen-camera"
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(0, 0, 5.25)
        cameraNode.look(at: SCNVector3Zero)
        scene.rootNode.addChildNode(cameraNode)

        let keyLight = SCNLight()
        keyLight.type = .omni
        keyLight.intensity = 410
        keyLight.color = UIColor.white
        keyLight.castsShadow = false
        let keyNode = SCNNode()
        keyNode.light = keyLight
        keyNode.position = SCNVector3(-2.5, 3.2, 4.2)
        scene.rootNode.addChildNode(keyNode)

        let fillLight = SCNLight()
        fillLight.type = .omni
        fillLight.intensity = 80
        fillLight.color = UIColor(
            red: 0.96,
            green: 0.92,
            blue: 0.86,
            alpha: 1
        )
        let fillNode = SCNNode()
        fillNode.light = fillLight
        fillNode.position = SCNVector3(3.1, -1.2, 2.8)
        scene.rootNode.addChildNode(fillNode)

        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.intensity = 65
        ambientLight.color = UIColor(
            red: 0.74,
            green: 0.72,
            blue: 0.68,
            alpha: 1
        )
        let ambientNode = SCNNode()
        ambientNode.light = ambientLight
        scene.rootNode.addChildNode(ambientNode)

        return scene
    }

    private struct MeshPoint {
        let position: SCNVector3
        let textureCoordinate: CGPoint
    }

    private struct ShapeProfile {
        let xScale: CGFloat
        let yScale: CGFloat
        let zScale: CGFloat
        let ridgeStrength: CGFloat
        let lobeCount: Int
        let lobeStrength: CGFloat
        let taper: CGFloat
        let lean: CGFloat
        let twist: CGFloat
    }

    private func rockGeometry(seed: Int) -> SCNGeometry {
        let rawProfile = shapeProfile(seed: seed)
        let profile = element.materialKind == .metal
            ? naturalMetalProfile(rawProfile)
            : rawProfile
        let latitudeSegments = element.materialKind == .crystal ? 8 : 14
        let longitudeSegments = element.materialKind == .crystal
            ? 8 + seed % 4
            : 18 + seed % 5
        var rings: [[MeshPoint]] = []

        for latitude in 1..<latitudeSegments {
            let v = CGFloat(latitude) / CGFloat(latitudeSegments)
            let phi = .pi / 2 - Double(v) * .pi
            var ring: [MeshPoint] = []

            for longitude in 0..<longitudeSegments {
                let u = CGFloat(longitude) / CGFloat(longitudeSegments)
                let theta = Double(u) * .pi * 2
                let randomRidge = unit(
                    seed * 101 + latitude * 37 + longitude * 61
                )
                let fineRidge = unit(
                    seed * 211 + latitude * 83 + longitude * 47
                ) - 0.5
                let broadRidge = CGFloat(
                    sin(
                        theta * Double(profile.lobeCount)
                            + Double(seed) * 0.73
                            + phi * Double(2 + seed % 3)
                    )
                ) * profile.lobeStrength
                let latitudeRidge = CGFloat(
                    cos(phi * Double(3 + seed % 4) + Double(seed))
                ) * (element.materialKind == .metal ? 0.022 : 0.05)
                let randomSurface = element.materialKind == .metal
                    ? (randomRidge - 0.5) * profile.ridgeStrength
                    : randomRidge * profile.ridgeStrength
                let fineSurface = fineRidge
                    * (element.materialKind == .metal ? 0.024 : 0.09)
                let radius = 0.72
                    + randomSurface
                    + fineSurface
                    + broadRidge
                    + latitudeRidge
                let latitudeBulge = 0.86 + CGFloat(cos(phi)) * 0.2
                let ringRadius = CGFloat(cos(phi)) * radius * latitudeBulge
                let normalizedHeight = CGFloat(sin(phi))
                let taperFactor = 1 - profile.taper * normalizedHeight
                let twistedTheta = theta
                    + Double(profile.twist * normalizedHeight)
                let leanOffset = profile.lean
                    * (normalizedHeight + 0.2)
                    * (1 - abs(normalizedHeight) * 0.35)

                ring.append(
                    MeshPoint(
                        position: SCNVector3(
                            Float(
                                CGFloat(cos(twistedTheta))
                                    * ringRadius
                                    * profile.xScale
                                    * taperFactor
                                    + leanOffset
                            ),
                            Float(
                                normalizedHeight
                                    * radius
                                    * profile.yScale
                            ),
                            Float(
                                CGFloat(sin(twistedTheta))
                                    * ringRadius
                                    * profile.zScale
                                    * taperFactor
                            )
                        ),
                        textureCoordinate: CGPoint(x: u, y: v)
                    )
                )
            }

            rings.append(ring)
        }

        var vertices: [SCNVector3] = []
        var normals: [SCNVector3] = []
        var textureCoordinates: [CGPoint] = []

        func appendTriangle(_ first: MeshPoint, _ second: MeshPoint, _ third: MeshPoint) {
            var b = second
            var c = third
            var faceNormal = cross(
                subtract(b.position, first.position),
                subtract(c.position, first.position)
            )
            let center = SCNVector3(
                (first.position.x + b.position.x + c.position.x) / 3,
                (first.position.y + b.position.y + c.position.y) / 3,
                (first.position.z + b.position.z + c.position.z) / 3
            )

            if dot(faceNormal, center) < 0 {
                swap(&b, &c)
                faceNormal = cross(
                    subtract(b.position, first.position),
                    subtract(c.position, first.position)
                )
            }

            let normal = normalized(faceNormal)
            vertices.append(contentsOf: [first.position, b.position, c.position])
            normals.append(contentsOf: [normal, normal, normal])
            textureCoordinates.append(
                contentsOf: [
                    first.textureCoordinate,
                    b.textureCoordinate,
                    c.textureCoordinate
                ]
            )
        }

        guard let firstRing = rings.first,
              let lastRing = rings.last else {
            return SCNGeometry()
        }

        for longitude in 0..<longitudeSegments {
            let next = (longitude + 1) % longitudeSegments
            let top = MeshPoint(
                position: SCNVector3(
                    Float(profile.lean * 0.92),
                    Float(profile.yScale * (0.92 + unit(seed * 307) * 0.15)),
                    Float((unit(seed * 313) - 0.5) * 0.18)
                ),
                textureCoordinate: CGPoint(
                    x: (CGFloat(longitude) + 0.5) / CGFloat(longitudeSegments),
                    y: 0
                )
            )
            appendTriangle(top, firstRing[next], firstRing[longitude])
        }

        if rings.count > 1 {
            for latitude in 0..<(rings.count - 1) {
                for longitude in 0..<longitudeSegments {
                    let next = (longitude + 1) % longitudeSegments
                    let upperLeft = rings[latitude][longitude]
                    let upperRight = rings[latitude][next]
                    let lowerLeft = rings[latitude + 1][longitude]
                    let lowerRight = rings[latitude + 1][next]
                    appendTriangle(upperLeft, upperRight, lowerLeft)
                    appendTriangle(upperRight, lowerRight, lowerLeft)
                }
            }
        }

        for longitude in 0..<longitudeSegments {
            let next = (longitude + 1) % longitudeSegments
            let bottom = MeshPoint(
                position: SCNVector3(
                    Float(-profile.lean * 0.5),
                    Float(-profile.yScale * (0.88 + unit(seed * 317) * 0.12)),
                    Float((unit(seed * 331) - 0.5) * 0.14)
                ),
                textureCoordinate: CGPoint(
                    x: (CGFloat(longitude) + 0.5) / CGFloat(longitudeSegments),
                    y: 1
                )
            )
            appendTriangle(bottom, lastRing[longitude], lastRing[next])
        }

        let centeredVertices = centeredAndFitted(vertices)
        let renderedNormals = element.materialKind == .metal
            ? smoothMetalNormals(
                vertices: centeredVertices,
                faceNormals: normals
            )
            : normals
        let sources = [
            SCNGeometrySource(vertices: centeredVertices),
            SCNGeometrySource(normals: renderedNormals),
            SCNGeometrySource(textureCoordinates: textureCoordinates)
        ]
        let indices = centeredVertices.indices.map(Int32.init)
        let element = SCNGeometryElement(
            indices: indices,
            primitiveType: .triangles
        )
        return SCNGeometry(sources: sources, elements: [element])
    }

    private func naturalMetalProfile(_ profile: ShapeProfile) -> ShapeProfile {
        ShapeProfile(
            xScale: profile.xScale,
            yScale: profile.yScale,
            zScale: profile.zScale,
            ridgeStrength: min(profile.ridgeStrength * 0.36, 0.13),
            lobeCount: min(max(profile.lobeCount, 2), 4),
            lobeStrength: profile.lobeStrength * 0.52,
            taper: profile.taper * 0.42,
            lean: profile.lean * 0.55,
            twist: profile.twist * 0.32
        )
    }

    private func smoothMetalNormals(
        vertices: [SCNVector3],
        faceNormals: [SCNVector3]
    ) -> [SCNVector3] {
        zip(vertices, faceNormals).map { vertex, faceNormal in
            let roundedNormal = normalized(vertex)
            return normalized(
                SCNVector3(
                    roundedNormal.x * 0.84 + faceNormal.x * 0.16,
                    roundedNormal.y * 0.84 + faceNormal.y * 0.16,
                    roundedNormal.z * 0.84 + faceNormal.z * 0.16
                )
            )
        }
    }

    private func centeredAndFitted(_ vertices: [SCNVector3]) -> [SCNVector3] {
        guard let first = vertices.first else { return vertices }

        var minimum = first
        var maximum = first

        for vertex in vertices.dropFirst() {
            minimum.x = min(minimum.x, vertex.x)
            minimum.y = min(minimum.y, vertex.y)
            minimum.z = min(minimum.z, vertex.z)
            maximum.x = max(maximum.x, vertex.x)
            maximum.y = max(maximum.y, vertex.y)
            maximum.z = max(maximum.z, vertex.z)
        }

        let center = SCNVector3(
            (minimum.x + maximum.x) * 0.5,
            (minimum.y + maximum.y) * 0.5,
            (minimum.z + maximum.z) * 0.5
        )
        let width = maximum.x - minimum.x
        let height = maximum.y - minimum.y
        let depth = maximum.z - minimum.z
        let largestDimension = max(width, max(height, depth))
        let fitScale: Float = largestDimension > 0.001
            ? 2.15 / largestDimension
            : 1

        return vertices.map { vertex in
            SCNVector3(
                (vertex.x - center.x) * fitScale,
                (vertex.y - center.y) * fitScale,
                (vertex.z - center.z) * fitScale
            )
        }
    }

    private func shapeProfile(seed: Int) -> ShapeProfile {
        let variation = unit(seed * 401) - 0.5
        let depthVariation = unit(seed * 409) - 0.5

        switch seed % 7 {
        case 0:
            return ShapeProfile(
                xScale: 1.3 + variation * 0.16,
                yScale: 0.7,
                zScale: 0.7 + depthVariation * 0.14,
                ridgeStrength: 0.28,
                lobeCount: 3,
                lobeStrength: 0.1,
                taper: 0.08,
                lean: 0.08,
                twist: 0.08
            )
        case 1:
            return ShapeProfile(
                xScale: 0.72,
                yScale: 1.26 + variation * 0.18,
                zScale: 0.62 + depthVariation * 0.12,
                ridgeStrength: 0.34,
                lobeCount: 5,
                lobeStrength: 0.07,
                taper: 0.24,
                lean: 0.2,
                twist: 0.16
            )
        case 2:
            return ShapeProfile(
                xScale: 1.42 + variation * 0.16,
                yScale: 0.58,
                zScale: 0.48 + depthVariation * 0.12,
                ridgeStrength: 0.22,
                lobeCount: 2,
                lobeStrength: 0.13,
                taper: -0.1,
                lean: -0.1,
                twist: 0.05
            )
        case 3:
            return ShapeProfile(
                xScale: 0.78 + variation * 0.12,
                yScale: 1.12,
                zScale: 0.78 + depthVariation * 0.12,
                ridgeStrength: 0.18,
                lobeCount: 6,
                lobeStrength: 0.14,
                taper: 0.34,
                lean: 0.04,
                twist: 0.04
            )
        case 4:
            return ShapeProfile(
                xScale: 1.14,
                yScale: 0.8 + variation * 0.12,
                zScale: 0.72 + depthVariation * 0.15,
                ridgeStrength: 0.3,
                lobeCount: 4,
                lobeStrength: 0.16,
                taper: 0.18,
                lean: 0.3,
                twist: -0.12
            )
        case 5:
            return ShapeProfile(
                xScale: 1.03 + variation * 0.12,
                yScale: 0.88,
                zScale: 0.96 + depthVariation * 0.15,
                ridgeStrength: 0.38,
                lobeCount: 3,
                lobeStrength: 0.2,
                taper: 0,
                lean: -0.14,
                twist: 0.22
            )
        default:
            return ShapeProfile(
                xScale: 0.92 + variation * 0.14,
                yScale: 0.94,
                zScale: 0.74 + depthVariation * 0.13,
                ridgeStrength: 0.3,
                lobeCount: 7,
                lobeStrength: 0.08,
                taper: -0.2,
                lean: 0.16,
                twist: -0.2
            )
        }
    }

    private func specimenMaterial() -> SCNMaterial {
        let material = SCNMaterial()
        material.name = "\(element.symbol)-solid"
        material.lightingModel = .physicallyBased
        let texture = UIImage(
            named: element.materialKind == .crystal
                ? "ElementCrystalTexture"
                : "ElementMetalTexture"
        )
        material.diffuse.contents = texture
        material.diffuse.wrapS = .repeat
        material.diffuse.wrapT = .repeat
        material.diffuse.minificationFilter = .linear
        material.diffuse.magnificationFilter = .linear
        material.diffuse.mipFilter = .linear
        material.diffuse.contentsTransform = textureTransform
        material.multiply.contents = UIColor(element.materialTint)
        material.metalness.contents = element.materialKind == .metal ? 0.34 : 0.06
        material.roughness.contents = roughness
        material.isDoubleSided = true
        return material
    }

    private var textureTransform: SCNMatrix4 {
        let scale = Float(1.7 + unit(element.number * 419) * 1.8)
        let rotation = Float(unit(element.number * 421) * .pi * 2)
        let scaled = SCNMatrix4MakeScale(scale, scale, 1)
        return SCNMatrix4Mult(
            SCNMatrix4MakeRotation(rotation, 0, 0, 1),
            scaled
        )
    }

    private var roughness: CGFloat {
        if element.materialKind == .crystal {
            return 0.56
        }

        return switch element.surfaceStyle {
        case .polishedMetal: 0.58
        case .brushedMetal: 0.7
        case .hammeredMetal: 0.78
        case .softCutMetal: 0.72
        case .dullMetal: 0.88
        case .brittleMetal: 0.82
        case .radioactiveMetal: 0.8
        default: 0.74
        }
    }

    private func subtract(_ lhs: SCNVector3, _ rhs: SCNVector3) -> SCNVector3 {
        SCNVector3(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
    }

    private func cross(_ lhs: SCNVector3, _ rhs: SCNVector3) -> SCNVector3 {
        SCNVector3(
            lhs.y * rhs.z - lhs.z * rhs.y,
            lhs.z * rhs.x - lhs.x * rhs.z,
            lhs.x * rhs.y - lhs.y * rhs.x
        )
    }

    private func dot(_ lhs: SCNVector3, _ rhs: SCNVector3) -> Float {
        lhs.x * rhs.x + lhs.y * rhs.y + lhs.z * rhs.z
    }

    private func normalized(_ vector: SCNVector3) -> SCNVector3 {
        let length = sqrt(
            vector.x * vector.x
                + vector.y * vector.y
                + vector.z * vector.z
        )
        guard length > 0.0001 else {
            return SCNVector3(0, 1, 0)
        }
        return SCNVector3(
            vector.x / length,
            vector.y / length,
            vector.z / length
        )
    }

    private func unit(_ value: Int) -> CGFloat {
        let raw = sin(Double(value) * 12.9898) * 43_758.5453
        return CGFloat(raw - floor(raw))
    }
}

private struct CenteredSpecimenSceneView: UIViewRepresentable {
    let scene: SCNScene
    let cameraName: String

    func makeUIView(context: Context) -> SCNView {
        let view = SCNView(frame: .zero)
        configure(view)
        return view
    }

    func updateUIView(_ view: SCNView, context: Context) {
        guard view.scene?.rootNode.name != scene.rootNode.name else { return }
        configure(view)
    }

    private func configure(_ view: SCNView) {
        view.scene = scene
        view.backgroundColor = .clear
        view.autoenablesDefaultLighting = false
        view.antialiasingMode = .multisampling4X
        view.preferredFramesPerSecond = 30
        view.rendersContinuously = false
        view.allowsCameraControl = true
        view.pointOfView = scene.rootNode.childNode(
            withName: cameraName,
            recursively: true
        )

        let controller = view.defaultCameraController
        controller.interactionMode = .orbitTurntable
        controller.automaticTarget = false
        controller.target = SCNVector3Zero
        controller.inertiaEnabled = true
        controller.inertiaFriction = 0.12
    }
}

struct IrregularOctagonShape: Shape {
    let seed: Int

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        var path = Path()

        for index in 0..<8 {
            let baseAngle = Double(index) / 8 * .pi * 2 - .pi / 2
            let angleOffset = Double(unit(seed * 43 + index * 19) - 0.5) * 0.18
            let angle = baseAngle + angleOffset
            let radius = 0.74 + unit(seed * 31 + index * 23) * 0.24
            let point = CGPoint(
                x: center.x + CGFloat(cos(angle)) * rect.width * 0.48 * radius,
                y: center.y + CGFloat(sin(angle)) * rect.height * 0.48 * radius
            )

            if index == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }

        path.closeSubpath()
        return path
    }

    private func unit(_ value: Int) -> CGFloat {
        let raw = sin(Double(value) * 12.9898) * 43_758.5453
        return CGFloat(raw - floor(raw))
    }
}

struct IrregularPolygonShape: Shape {
    let seed: Int
    let sideCount: Int

    func path(in rect: CGRect) -> Path {
        let sides = max(5, min(10, sideCount))
        let center = CGPoint(x: rect.midX, y: rect.midY)
        var path = Path()

        for index in 0..<sides {
            let baseAngle = Double(index) / Double(sides) * .pi * 2 - .pi / 2
            let angleOffset = Double(
                unit(seed * 53 + index * 31) - 0.5
            ) * 0.16
            let radius = 0.78 + unit(seed * 37 + index * 17) * 0.2
            let point = CGPoint(
                x: center.x
                    + CGFloat(cos(baseAngle + angleOffset))
                    * rect.width * 0.48 * radius,
                y: center.y
                    + CGFloat(sin(baseAngle + angleOffset))
                    * rect.height * 0.48 * radius
            )

            if index == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }

        path.closeSubpath()
        return path
    }

    private func unit(_ value: Int) -> CGFloat {
        let raw = sin(Double(value) * 12.9898) * 43_758.5453
        return CGFloat(raw - floor(raw))
    }
}

struct ElementCategoryDetailView: View {
    let category: ElementCategory
    @Environment(\.dismiss) private var dismiss

    private var examples: [PeriodicElement] {
        PeriodicTableData.allElements
            .filter { $0.category == category }
            .prefix(8)
            .map { $0 }
    }

    var body: some View {
        ZStack {
            Color.skillSyncBackground.ignoresSafeArea()

            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    Button("Done") { dismiss() }
                        .font(.headline)
                        .foregroundStyle(.cyan)
                }

                Circle()
                    .fill(category.color.opacity(0.18))
                    .frame(width: 74, height: 74)
                    .overlay {
                        Circle()
                            .stroke(category.color, lineWidth: 2)
                    }
                    .overlay {
                        Image(systemName: "atom")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(category.color)
                    }
                    .shadow(color: category.color.opacity(0.4), radius: 18)

                Text(category.title)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                Text(category.description)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.72))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)

                VStack(spacing: 9) {
                    Text("Examples")
                        .font(.caption.bold())
                        .foregroundStyle(.white.opacity(0.48))
                        .textCase(.uppercase)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 9) {
                            ForEach(examples) { element in
                                VStack(spacing: 3) {
                                    Text(element.symbol)
                                        .font(.headline.bold())
                                    Text("\(element.number)")
                                        .font(.caption2)
                                }
                                .foregroundStyle(.white)
                                .frame(width: 54, height: 54)
                                .background(
                                    category.color.opacity(0.17),
                                    in: RoundedRectangle(cornerRadius: 12)
                                )
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(category.color.opacity(0.42))
                                }
                            }
                        }
                    }
                }

                Spacer()
            }
            .padding(24)
        }
        .preferredColorScheme(.dark)
    }
}

enum ElementCategory: String, CaseIterable, Identifiable {
    case alkaliMetal
    case alkalineEarthMetal
    case transitionMetal
    case postTransitionMetal
    case metalloid
    case reactiveNonmetal
    case halogen
    case nobleGas
    case lanthanide
    case actinide

    var id: Self { self }

    var title: String {
        switch self {
        case .alkaliMetal: "Alkali Metals"
        case .alkalineEarthMetal: "Alkaline Earth Metals"
        case .transitionMetal: "Transition Metals"
        case .postTransitionMetal: "Post-transition Metals"
        case .metalloid: "Metalloids"
        case .reactiveNonmetal: "Reactive Nonmetals"
        case .halogen: "Halogens"
        case .nobleGas: "Noble Gases"
        case .lanthanide: "Lanthanides"
        case .actinide: "Actinides"
        }
    }

    var color: Color {
        switch self {
        case .alkaliMetal: .red
        case .alkalineEarthMetal: .orange
        case .transitionMetal: .blue
        case .postTransitionMetal: .indigo
        case .metalloid: .teal
        case .reactiveNonmetal: .cyan
        case .halogen: .green
        case .nobleGas: .purple
        case .lanthanide: .pink
        case .actinide: Color(red: 0.63, green: 0.32, blue: 1)
        }
    }

    var description: String {
        switch self {
        case .alkaliMetal:
            "Alkali metals are soft, highly reactive metals in Group 1."
        case .alkalineEarthMetal:
            "Alkaline earth metals are reactive Group 2 metals that commonly form two positive charges."
        case .transitionMetal:
            "Transition metals often conduct heat and electricity well and can form colorful compounds."
        case .postTransitionMetal:
            "Post-transition metals are generally softer and have lower melting points than transition metals."
        case .metalloid:
            "Metalloids have a mixture of metallic and nonmetallic properties and are useful in electronics."
        case .reactiveNonmetal:
            "Reactive nonmetals tend to gain or share electrons when they form chemical bonds."
        case .halogen:
            "Halogens are highly reactive Group 17 nonmetals that readily form salts."
        case .nobleGas:
            "Noble gases have very stable outer electron shells, so they are usually unreactive."
        case .lanthanide:
            "Lanthanides are shiny inner-transition metals often used in magnets, screens, and electronics."
        case .actinide:
            "Actinides are heavy inner-transition metals; every actinide is radioactive."
        }
    }
}

enum PeriodicTableData {
    private static let symbols = [
        "H", "He", "Li", "Be", "B", "C", "N", "O", "F", "Ne",
        "Na", "Mg", "Al", "Si", "P", "S", "Cl", "Ar", "K", "Ca",
        "Sc", "Ti", "V", "Cr", "Mn", "Fe", "Co", "Ni", "Cu", "Zn",
        "Ga", "Ge", "As", "Se", "Br", "Kr", "Rb", "Sr", "Y", "Zr",
        "Nb", "Mo", "Tc", "Ru", "Rh", "Pd", "Ag", "Cd", "In", "Sn",
        "Sb", "Te", "I", "Xe", "Cs", "Ba", "La", "Ce", "Pr", "Nd",
        "Pm", "Sm", "Eu", "Gd", "Tb", "Dy", "Ho", "Er", "Tm", "Yb",
        "Lu", "Hf", "Ta", "W", "Re", "Os", "Ir", "Pt", "Au", "Hg",
        "Tl", "Pb", "Bi", "Po", "At", "Rn", "Fr", "Ra", "Ac", "Th",
        "Pa", "U", "Np", "Pu", "Am", "Cm", "Bk", "Cf", "Es", "Fm",
        "Md", "No", "Lr", "Rf", "Db", "Sg", "Bh", "Hs", "Mt", "Ds",
        "Rg", "Cn", "Nh", "Fl", "Mc", "Lv", "Ts", "Og"
    ]

    private static let names1 = [
        "Hydrogen", "Helium", "Lithium", "Beryllium", "Boron",
        "Carbon", "Nitrogen", "Oxygen", "Fluorine", "Neon",
        "Sodium", "Magnesium", "Aluminum", "Silicon", "Phosphorus",
        "Sulfur", "Chlorine", "Argon", "Potassium", "Calcium",
        "Scandium", "Titanium", "Vanadium", "Chromium", "Manganese",
        "Iron", "Cobalt", "Nickel", "Copper", "Zinc",
        "Gallium", "Germanium", "Arsenic", "Selenium", "Bromine",
        "Krypton", "Rubidium", "Strontium", "Yttrium", "Zirconium"
    ]

    private static let names2 = [
        "Niobium", "Molybdenum", "Technetium", "Ruthenium", "Rhodium",
        "Palladium", "Silver", "Cadmium", "Indium", "Tin",
        "Antimony", "Tellurium", "Iodine", "Xenon", "Cesium",
        "Barium", "Lanthanum", "Cerium", "Praseodymium", "Neodymium",
        "Promethium", "Samarium", "Europium", "Gadolinium", "Terbium",
        "Dysprosium", "Holmium", "Erbium", "Thulium", "Ytterbium",
        "Lutetium", "Hafnium", "Tantalum", "Tungsten", "Rhenium",
        "Osmium", "Iridium", "Platinum", "Gold", "Mercury"
    ]

    private static let names3 = [
        "Thallium", "Lead", "Bismuth", "Polonium", "Astatine",
        "Radon", "Francium", "Radium", "Actinium", "Thorium",
        "Protactinium", "Uranium", "Neptunium", "Plutonium", "Americium",
        "Curium", "Berkelium", "Californium", "Einsteinium", "Fermium",
        "Mendelevium", "Nobelium", "Lawrencium", "Rutherfordium",
        "Dubnium", "Seaborgium", "Bohrium", "Hassium", "Meitnerium",
        "Darmstadtium", "Roentgenium", "Copernicium", "Nihonium",
        "Flerovium", "Moscovium", "Livermorium", "Tennessine", "Oganesson"
    ]

    private static let names = names1 + names2 + names3

    static let mainGrid: [PeriodicElement?] = {
        var grid = Array<PeriodicElement?>(repeating: nil, count: 7 * 18)

        func place(_ number: Int, row: Int, column: Int) {
            grid[row * 18 + column] = element(number)
        }

        place(1, row: 0, column: 0)
        place(2, row: 0, column: 17)

        for number in 3...4 { place(number, row: 1, column: number - 3) }
        for number in 5...10 { place(number, row: 1, column: number + 7) }
        for number in 11...12 { place(number, row: 2, column: number - 11) }
        for number in 13...18 { place(number, row: 2, column: number - 1) }
        for number in 19...36 { place(number, row: 3, column: number - 19) }
        for number in 37...54 { place(number, row: 4, column: number - 37) }

        place(55, row: 5, column: 0)
        place(56, row: 5, column: 1)
        for number in 72...86 { place(number, row: 5, column: number - 69) }

        place(87, row: 6, column: 0)
        place(88, row: 6, column: 1)
        for number in 104...118 { place(number, row: 6, column: number - 101) }

        return grid
    }()

    static let lanthanides = (57...71).map(element)
    static let actinides = (89...103).map(element)
    static let allElements = (1...118).map(element)

    private static func element(_ number: Int) -> PeriodicElement {
        PeriodicElement(
            number: number,
            symbol: symbols[number - 1],
            name: number <= names.count
                ? names[number - 1]
                : "Element \(symbols[number - 1])",
            category: category(for: number)
        )
    }

    private static func category(for number: Int) -> ElementCategory {
        if [3, 11, 19, 37, 55, 87].contains(number) {
            return .alkaliMetal
        }
        if [4, 12, 20, 38, 56, 88].contains(number) {
            return .alkalineEarthMetal
        }
        if (57...71).contains(number) {
            return .lanthanide
        }
        if (89...103).contains(number) {
            return .actinide
        }
        if (21...30).contains(number)
            || (39...48).contains(number)
            || (72...80).contains(number)
            || (104...112).contains(number) {
            return .transitionMetal
        }
        if [13, 31, 49, 50, 81, 82, 83, 84, 113, 114, 115, 116].contains(number) {
            return .postTransitionMetal
        }
        if [5, 14, 32, 33, 51, 52].contains(number) {
            return .metalloid
        }
        if [9, 17, 35, 53, 85, 117].contains(number) {
            return .halogen
        }
        if [2, 10, 18, 36, 54, 86, 118].contains(number) {
            return .nobleGas
        }
        return .reactiveNonmetal
    }
}
