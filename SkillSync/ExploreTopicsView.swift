import SwiftUI

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
            RoundedRectangle(cornerRadius: 20)
                .stroke(.cyan.opacity(isExpanded ? 0.4 : 0.2), lineWidth: 1)
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
            RoundedRectangle(cornerRadius: 16)
                .stroke(accent.opacity(isPlaceholder ? 0.08 : 0.2), lineWidth: 1)
        }
    }
}

struct PeriodicTableLessonView: View {
    private let columns = Array(
        repeating: GridItem(.fixed(54), spacing: 5),
        count: 18
    )

    var body: some View {
        ZStack {
            AmbientBackgroundView(isAnimated: true)

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

                    ScrollView(.horizontal, showsIndicators: true) {
                        VStack(alignment: .leading, spacing: 16) {
                            LazyVGrid(columns: columns, spacing: 5) {
                                ForEach(PeriodicTableData.mainGrid.indices, id: \.self) { index in
                                    if let element = PeriodicTableData.mainGrid[index] {
                                        ElementTile(element: element)
                                    } else {
                                        Color.clear.frame(width: 54, height: 62)
                                    }
                                }
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                ElementSeriesRow(
                                    label: "Lanthanides",
                                    elements: PeriodicTableData.lanthanides
                                )
                                ElementSeriesRow(
                                    label: "Actinides",
                                    elements: PeriodicTableData.actinides
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
    }
}

struct ElementTile: View {
    let element: PeriodicElement

    var body: some View {
        VStack(spacing: 2) {
            Text("\(element.number)")
                .font(.system(size: 9, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(element.symbol)
                .font(.system(size: 20, weight: .black, design: .rounded))
        }
        .foregroundStyle(.white)
        .padding(5)
        .frame(width: 54, height: 62)
        .background(
            LinearGradient(
                colors: [
                    element.accent.opacity(0.5),
                    element.accent.opacity(0.16)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 8)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(element.accent.opacity(0.62), lineWidth: 1)
        }
        .shadow(color: element.accent.opacity(0.15), radius: 5)
    }
}

struct ElementSeriesRow: View {
    let label: String
    let elements: [PeriodicElement]

    var body: some View {
        HStack(spacing: 5) {
            Text(label)
                .font(.system(size: 9, weight: .bold, design: .rounded))
                .foregroundStyle(.purple)
                .frame(width: 100, alignment: .trailing)
                .padding(.trailing, 6)

            ForEach(elements) { element in
                ElementTile(element: element)
            }
        }
    }
}

struct PeriodicElement: Identifiable {
    let number: Int
    let symbol: String
    let accent: Color

    var id: Int { number }
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

    private static func element(_ number: Int) -> PeriodicElement {
        PeriodicElement(
            number: number,
            symbol: symbols[number - 1],
            accent: accent(for: number)
        )
    }

    private static func accent(for number: Int) -> Color {
        if (57...71).contains(number) || (89...103).contains(number) {
            return .purple
        }
        if [1, 6, 7, 8, 15, 16, 34].contains(number) {
            return .cyan
        }
        if [2, 10, 18, 36, 54, 86, 118].contains(number) {
            return .blue
        }
        return number.isMultiple(of: 3) ? .purple : .blue
    }
}
