import Foundation

struct ElementScienceRecord {
    let atomicMass: String
    let electronConfiguration: String
    let oxidationStates: String
    let standardState: String
    let meltingPointKelvin: Double?
    let boilingPointKelvin: Double?
    let density: String
    let groupBlock: String
    let yearDiscovered: String
}

enum ElementPhysicalForm: String, CaseIterable, Identifiable {
    case solid
    case liquid
    case gas

    var id: Self { self }

    var title: String {
        rawValue.capitalized
    }
}

enum ElementScienceData {
    // Generated from the NIH PubChem Periodic Table JSON dataset.
    // https://pubchem.ncbi.nlm.nih.gov/rest/pug/periodictable/JSON
    static let records: [ElementScienceRecord] = [
        ElementScienceRecord(atomicMass: "1.0080", electronConfiguration: "1s1", oxidationStates: "+1, -1", standardState: "Gas", meltingPointKelvin: 13.81, boilingPointKelvin: 20.28, density: "0.00008988", groupBlock: "Nonmetal", yearDiscovered: "1766"),
        ElementScienceRecord(atomicMass: "4.00260", electronConfiguration: "1s2", oxidationStates: "0", standardState: "Gas", meltingPointKelvin: 0.95, boilingPointKelvin: 4.22, density: "0.0001785", groupBlock: "Noble gas", yearDiscovered: "1868"),
        ElementScienceRecord(atomicMass: "7.0", electronConfiguration: "[He]2s1", oxidationStates: "+1", standardState: "Solid", meltingPointKelvin: 453.65, boilingPointKelvin: 1615, density: "0.534", groupBlock: "Alkali metal", yearDiscovered: "1817"),
        ElementScienceRecord(atomicMass: "9.012183", electronConfiguration: "[He]2s2", oxidationStates: "+2", standardState: "Solid", meltingPointKelvin: 1560, boilingPointKelvin: 2744, density: "1.85", groupBlock: "Alkaline earth metal", yearDiscovered: "1798"),
        ElementScienceRecord(atomicMass: "10.81", electronConfiguration: "[He]2s2 2p1", oxidationStates: "+3", standardState: "Solid", meltingPointKelvin: 2348, boilingPointKelvin: 4273, density: "2.37", groupBlock: "Metalloid", yearDiscovered: "1808"),
        ElementScienceRecord(atomicMass: "12.011", electronConfiguration: "[He]2s2 2p2", oxidationStates: "+4, +2, -4", standardState: "Solid", meltingPointKelvin: 3823, boilingPointKelvin: 4098, density: "2.2670", groupBlock: "Nonmetal", yearDiscovered: "Ancient"),
        ElementScienceRecord(atomicMass: "14.007", electronConfiguration: "[He] 2s2 2p3", oxidationStates: "+5, +4, +3, +2, +1, -1, -2, -3", standardState: "Gas", meltingPointKelvin: 63.15, boilingPointKelvin: 77.36, density: "0.0012506", groupBlock: "Nonmetal", yearDiscovered: "1772"),
        ElementScienceRecord(atomicMass: "15.999", electronConfiguration: "[He]2s2 2p4", oxidationStates: "-2", standardState: "Gas", meltingPointKelvin: 54.36, boilingPointKelvin: 90.2, density: "0.001429", groupBlock: "Nonmetal", yearDiscovered: "1774"),
        ElementScienceRecord(atomicMass: "18.99840316", electronConfiguration: "[He]2s2 2p5", oxidationStates: "-1", standardState: "Gas", meltingPointKelvin: 53.53, boilingPointKelvin: 85.03, density: "0.001696", groupBlock: "Halogen", yearDiscovered: "1670"),
        ElementScienceRecord(atomicMass: "20.180", electronConfiguration: "[He]2s2 2p6", oxidationStates: "0", standardState: "Gas", meltingPointKelvin: 24.56, boilingPointKelvin: 27.07, density: "0.0008999", groupBlock: "Noble gas", yearDiscovered: "1898"),
        ElementScienceRecord(atomicMass: "22.9897693", electronConfiguration: "[Ne]3s1", oxidationStates: "+1", standardState: "Solid", meltingPointKelvin: 370.95, boilingPointKelvin: 1156, density: "0.97", groupBlock: "Alkali metal", yearDiscovered: "1807"),
        ElementScienceRecord(atomicMass: "24.305", electronConfiguration: "[Ne]3s2", oxidationStates: "+2", standardState: "Solid", meltingPointKelvin: 923, boilingPointKelvin: 1363, density: "1.74", groupBlock: "Alkaline earth metal", yearDiscovered: "1808"),
        ElementScienceRecord(atomicMass: "26.981538", electronConfiguration: "[Ne]3s2 3p1", oxidationStates: "+3", standardState: "Solid", meltingPointKelvin: 933.437, boilingPointKelvin: 2792, density: "2.70", groupBlock: "Post-transition metal", yearDiscovered: "Ancient"),
        ElementScienceRecord(atomicMass: "28.085", electronConfiguration: "[Ne]3s2 3p2", oxidationStates: "+4, +2, -4", standardState: "Solid", meltingPointKelvin: 1687, boilingPointKelvin: 3538, density: "2.3296", groupBlock: "Metalloid", yearDiscovered: "1854"),
        ElementScienceRecord(atomicMass: "30.97376200", electronConfiguration: "[Ne]3s2 3p3", oxidationStates: "+5, +3, -3", standardState: "Solid", meltingPointKelvin: 317.3, boilingPointKelvin: 553.65, density: "1.82", groupBlock: "Nonmetal", yearDiscovered: "1669"),
        ElementScienceRecord(atomicMass: "32.07", electronConfiguration: "[Ne]3s2 3p4", oxidationStates: "+6, +4, -2", standardState: "Solid", meltingPointKelvin: 388.36, boilingPointKelvin: 717.75, density: "2.067", groupBlock: "Nonmetal", yearDiscovered: "Ancient"),
        ElementScienceRecord(atomicMass: "35.45", electronConfiguration: "[Ne]3s2 3p5", oxidationStates: "+7, +5, +1, -1", standardState: "Gas", meltingPointKelvin: 171.65, boilingPointKelvin: 239.11, density: "0.003214", groupBlock: "Halogen", yearDiscovered: "1774"),
        ElementScienceRecord(atomicMass: "39.9", electronConfiguration: "[Ne]3s2 3p6", oxidationStates: "0", standardState: "Gas", meltingPointKelvin: 83.8, boilingPointKelvin: 87.3, density: "0.0017837", groupBlock: "Noble gas", yearDiscovered: "1894"),
        ElementScienceRecord(atomicMass: "39.0983", electronConfiguration: "[Ar]4s1", oxidationStates: "+1", standardState: "Solid", meltingPointKelvin: 336.53, boilingPointKelvin: 1032, density: "0.89", groupBlock: "Alkali metal", yearDiscovered: "1807"),
        ElementScienceRecord(atomicMass: "40.08", electronConfiguration: "[Ar]4s2", oxidationStates: "+2", standardState: "Solid", meltingPointKelvin: 1115, boilingPointKelvin: 1757, density: "1.54", groupBlock: "Alkaline earth metal", yearDiscovered: "Ancient"),
        ElementScienceRecord(atomicMass: "44.95591", electronConfiguration: "[Ar]4s2 3d1", oxidationStates: "+3", standardState: "Solid", meltingPointKelvin: 1814, boilingPointKelvin: 3109, density: "2.99", groupBlock: "Transition metal", yearDiscovered: "1879"),
        ElementScienceRecord(atomicMass: "47.867", electronConfiguration: "[Ar]4s2 3d2", oxidationStates: "+4, +3, +2", standardState: "Solid", meltingPointKelvin: 1941, boilingPointKelvin: 3560, density: "4.5", groupBlock: "Transition metal", yearDiscovered: "1791"),
        ElementScienceRecord(atomicMass: "50.9415", electronConfiguration: "[Ar]4s2 3d3", oxidationStates: "+5, +4, +3, +2", standardState: "Solid", meltingPointKelvin: 2183, boilingPointKelvin: 3680, density: "6.0", groupBlock: "Transition metal", yearDiscovered: "1801"),
        ElementScienceRecord(atomicMass: "51.996", electronConfiguration: "[Ar]3d5 4s1", oxidationStates: "+6, +3, +2", standardState: "Solid", meltingPointKelvin: 2180, boilingPointKelvin: 2944, density: "7.15", groupBlock: "Transition metal", yearDiscovered: "1797"),
        ElementScienceRecord(atomicMass: "54.93804", electronConfiguration: "[Ar]4s2 3d5", oxidationStates: "+7, +4, +3, +2", standardState: "Solid", meltingPointKelvin: 1519, boilingPointKelvin: 2334, density: "7.3", groupBlock: "Transition metal", yearDiscovered: "1774"),
        ElementScienceRecord(atomicMass: "55.84", electronConfiguration: "[Ar]4s2 3d6", oxidationStates: "+3, +2", standardState: "Solid", meltingPointKelvin: 1811, boilingPointKelvin: 3134, density: "7.874", groupBlock: "Transition metal", yearDiscovered: "Ancient"),
        ElementScienceRecord(atomicMass: "58.93319", electronConfiguration: "[Ar]4s2 3d7", oxidationStates: "+3, +2", standardState: "Solid", meltingPointKelvin: 1768, boilingPointKelvin: 3200, density: "8.86", groupBlock: "Transition metal", yearDiscovered: "1735"),
        ElementScienceRecord(atomicMass: "58.693", electronConfiguration: "[Ar]4s2 3d8", oxidationStates: "+3, +2", standardState: "Solid", meltingPointKelvin: 1728, boilingPointKelvin: 3186, density: "8.912", groupBlock: "Transition metal", yearDiscovered: "1751"),
        ElementScienceRecord(atomicMass: "63.55", electronConfiguration: "[Ar]4s1 3d10", oxidationStates: "+2, +1", standardState: "Solid", meltingPointKelvin: 1357.77, boilingPointKelvin: 2835, density: "8.933", groupBlock: "Transition metal", yearDiscovered: "Ancient"),
        ElementScienceRecord(atomicMass: "65.4", electronConfiguration: "[Ar]4s2 3d10", oxidationStates: "+2", standardState: "Solid", meltingPointKelvin: 692.68, boilingPointKelvin: 1180, density: "7.134", groupBlock: "Transition metal", yearDiscovered: "1746"),
        ElementScienceRecord(atomicMass: "69.723", electronConfiguration: "[Ar]4s2 3d10 4p1", oxidationStates: "+3", standardState: "Solid", meltingPointKelvin: 302.91, boilingPointKelvin: 2477, density: "5.91", groupBlock: "Post-transition metal", yearDiscovered: "1875"),
        ElementScienceRecord(atomicMass: "72.63", electronConfiguration: "[Ar]4s2 3d10 4p2", oxidationStates: "+4, +2", standardState: "Solid", meltingPointKelvin: 1211.4, boilingPointKelvin: 3106, density: "5.323", groupBlock: "Metalloid", yearDiscovered: "1886"),
        ElementScienceRecord(atomicMass: "74.92159", electronConfiguration: "[Ar]4s2 3d10 4p3", oxidationStates: "+5, +3, -3", standardState: "Solid", meltingPointKelvin: 1090, boilingPointKelvin: 887, density: "5.776", groupBlock: "Metalloid", yearDiscovered: "Ancient"),
        ElementScienceRecord(atomicMass: "78.97", electronConfiguration: "[Ar]4s2 3d10 4p4", oxidationStates: "+6, +4, -2", standardState: "Solid", meltingPointKelvin: 493.65, boilingPointKelvin: 958, density: "4.809", groupBlock: "Nonmetal", yearDiscovered: "1817"),
        ElementScienceRecord(atomicMass: "79.90", electronConfiguration: "[Ar]4s2 3d10 4p5", oxidationStates: "+5, +1, -1", standardState: "Liquid", meltingPointKelvin: 265.95, boilingPointKelvin: 331.95, density: "3.11", groupBlock: "Halogen", yearDiscovered: "1826"),
        ElementScienceRecord(atomicMass: "83.80", electronConfiguration: "[Ar]4s2 3d10 4p6", oxidationStates: "0", standardState: "Gas", meltingPointKelvin: 115.79, boilingPointKelvin: 119.93, density: "0.003733", groupBlock: "Noble gas", yearDiscovered: "1898"),
        ElementScienceRecord(atomicMass: "85.468", electronConfiguration: "[Kr]5s1", oxidationStates: "+1", standardState: "Solid", meltingPointKelvin: 312.46, boilingPointKelvin: 961, density: "1.53", groupBlock: "Alkali metal", yearDiscovered: "1861"),
        ElementScienceRecord(atomicMass: "87.62", electronConfiguration: "[Kr]5s2", oxidationStates: "+2", standardState: "Solid", meltingPointKelvin: 1050, boilingPointKelvin: 1655, density: "2.64", groupBlock: "Alkaline earth metal", yearDiscovered: "1790"),
        ElementScienceRecord(atomicMass: "88.90584", electronConfiguration: "[Kr]5s2 4d1", oxidationStates: "+3", standardState: "Solid", meltingPointKelvin: 1795, boilingPointKelvin: 3618, density: "4.47", groupBlock: "Transition metal", yearDiscovered: "1794"),
        ElementScienceRecord(atomicMass: "91.22", electronConfiguration: "[Kr]5s2 4d2", oxidationStates: "+4", standardState: "Solid", meltingPointKelvin: 2128, boilingPointKelvin: 4682, density: "6.52", groupBlock: "Transition metal", yearDiscovered: "1789"),
        ElementScienceRecord(atomicMass: "92.90637", electronConfiguration: "[Kr]5s1 4d4", oxidationStates: "+5, +3", standardState: "Solid", meltingPointKelvin: 2750, boilingPointKelvin: 5017, density: "8.57", groupBlock: "Transition metal", yearDiscovered: "1801"),
        ElementScienceRecord(atomicMass: "95.95", electronConfiguration: "[Kr]5s1 4d5", oxidationStates: "+6", standardState: "Solid", meltingPointKelvin: 2896, boilingPointKelvin: 4912, density: "10.2", groupBlock: "Transition metal", yearDiscovered: "1778"),
        ElementScienceRecord(atomicMass: "96.90636", electronConfiguration: "[Kr]5s2 4d5", oxidationStates: "+7, +6, +4", standardState: "Solid", meltingPointKelvin: 2430, boilingPointKelvin: 4538, density: "11", groupBlock: "Transition metal", yearDiscovered: "1937"),
        ElementScienceRecord(atomicMass: "101.1", electronConfiguration: "[Kr]5s1 4d7", oxidationStates: "+3", standardState: "Solid", meltingPointKelvin: 2607, boilingPointKelvin: 4423, density: "12.1", groupBlock: "Transition metal", yearDiscovered: "1827"),
        ElementScienceRecord(atomicMass: "102.9055", electronConfiguration: "[Kr]5s1 4d8", oxidationStates: "+3", standardState: "Solid", meltingPointKelvin: 2237, boilingPointKelvin: 3968, density: "12.4", groupBlock: "Transition metal", yearDiscovered: "1803"),
        ElementScienceRecord(atomicMass: "106.42", electronConfiguration: "[Kr]4d10", oxidationStates: "+3, +2", standardState: "Solid", meltingPointKelvin: 1828.05, boilingPointKelvin: 3236, density: "12.0", groupBlock: "Transition metal", yearDiscovered: "1803"),
        ElementScienceRecord(atomicMass: "107.868", electronConfiguration: "[Kr]5s1 4d10", oxidationStates: "+1", standardState: "Solid", meltingPointKelvin: 1234.93, boilingPointKelvin: 2435, density: "10.501", groupBlock: "Transition metal", yearDiscovered: "Ancient"),
        ElementScienceRecord(atomicMass: "112.41", electronConfiguration: "[Kr]5s2 4d10", oxidationStates: "+2", standardState: "Solid", meltingPointKelvin: 594.22, boilingPointKelvin: 1040, density: "8.69", groupBlock: "Transition metal", yearDiscovered: "1817"),
        ElementScienceRecord(atomicMass: "114.818", electronConfiguration: "[Kr]5s2 4d10 5p1", oxidationStates: "+3", standardState: "Solid", meltingPointKelvin: 429.75, boilingPointKelvin: 2345, density: "7.31", groupBlock: "Post-transition metal", yearDiscovered: "1863"),
        ElementScienceRecord(atomicMass: "118.71", electronConfiguration: "[Kr]5s2 4d10 5p2", oxidationStates: "+4, +2", standardState: "Solid", meltingPointKelvin: 505.08, boilingPointKelvin: 2875, density: "7.287", groupBlock: "Post-transition metal", yearDiscovered: "Ancient"),
        ElementScienceRecord(atomicMass: "121.760", electronConfiguration: "[Kr]5s2 4d10 5p3", oxidationStates: "+5, +3, -3", standardState: "Solid", meltingPointKelvin: 903.78, boilingPointKelvin: 1860, density: "6.685", groupBlock: "Metalloid", yearDiscovered: "Ancient"),
        ElementScienceRecord(atomicMass: "127.6", electronConfiguration: "[Kr]5s2 4d10 5p4", oxidationStates: "+6, +4, -2", standardState: "Solid", meltingPointKelvin: 722.66, boilingPointKelvin: 1261, density: "6.232", groupBlock: "Metalloid", yearDiscovered: "1782"),
        ElementScienceRecord(atomicMass: "126.9045", electronConfiguration: "[Kr]5s2 4d10 5p5", oxidationStates: "+7, +5, +1, -1", standardState: "Solid", meltingPointKelvin: 386.85, boilingPointKelvin: 457.55, density: "4.93", groupBlock: "Halogen", yearDiscovered: "1811"),
        ElementScienceRecord(atomicMass: "131.29", electronConfiguration: "[Kr]5s2 4d10 5p6", oxidationStates: "0", standardState: "Gas", meltingPointKelvin: 161.36, boilingPointKelvin: 165.03, density: "0.005887", groupBlock: "Noble gas", yearDiscovered: "1898"),
        ElementScienceRecord(atomicMass: "132.9054520", electronConfiguration: "[Xe]6s1", oxidationStates: "+1", standardState: "Solid", meltingPointKelvin: 301.59, boilingPointKelvin: 944, density: "1.93", groupBlock: "Alkali metal", yearDiscovered: "1860"),
        ElementScienceRecord(atomicMass: "137.33", electronConfiguration: "[Xe]6s2", oxidationStates: "+2", standardState: "Solid", meltingPointKelvin: 1000, boilingPointKelvin: 2170, density: "3.62", groupBlock: "Alkaline earth metal", yearDiscovered: "1808"),
        ElementScienceRecord(atomicMass: "138.9055", electronConfiguration: "[Xe]6s2 5d1", oxidationStates: "+3", standardState: "Solid", meltingPointKelvin: 1191, boilingPointKelvin: 3737, density: "6.15", groupBlock: "Lanthanide", yearDiscovered: "1839"),
        ElementScienceRecord(atomicMass: "140.116", electronConfiguration: "[Xe]6s2 4f1 5d1", oxidationStates: "+4, +3", standardState: "Solid", meltingPointKelvin: 1071, boilingPointKelvin: 3697, density: "6.770", groupBlock: "Lanthanide", yearDiscovered: "1803"),
        ElementScienceRecord(atomicMass: "140.90766", electronConfiguration: "[Xe]6s2 4f3", oxidationStates: "+3", standardState: "Solid", meltingPointKelvin: 1204, boilingPointKelvin: 3793, density: "6.77", groupBlock: "Lanthanide", yearDiscovered: "1885"),
        ElementScienceRecord(atomicMass: "144.24", electronConfiguration: "[Xe]6s2 4f4", oxidationStates: "+3", standardState: "Solid", meltingPointKelvin: 1294, boilingPointKelvin: 3347, density: "7.01", groupBlock: "Lanthanide", yearDiscovered: "1885"),
        ElementScienceRecord(atomicMass: "144.91276", electronConfiguration: "[Xe]6s2 4f5", oxidationStates: "+3", standardState: "Solid", meltingPointKelvin: 1315, boilingPointKelvin: 3273, density: "7.26", groupBlock: "Lanthanide", yearDiscovered: "1945"),
        ElementScienceRecord(atomicMass: "150.4", electronConfiguration: "[Xe]6s2 4f6", oxidationStates: "+3, +2", standardState: "Solid", meltingPointKelvin: 1347, boilingPointKelvin: 2067, density: "7.52", groupBlock: "Lanthanide", yearDiscovered: "1879"),
        ElementScienceRecord(atomicMass: "151.964", electronConfiguration: "[Xe]6s2 4f7", oxidationStates: "+3, +2", standardState: "Solid", meltingPointKelvin: 1095, boilingPointKelvin: 1802, density: "5.24", groupBlock: "Lanthanide", yearDiscovered: "1901"),
        ElementScienceRecord(atomicMass: "157.25", electronConfiguration: "[Xe]6s2 4f7 5d1", oxidationStates: "+3", standardState: "Solid", meltingPointKelvin: 1586, boilingPointKelvin: 3546, density: "7.90", groupBlock: "Lanthanide", yearDiscovered: "1880"),
        ElementScienceRecord(atomicMass: "158.92535", electronConfiguration: "[Xe]6s2 4f9", oxidationStates: "+3", standardState: "Solid", meltingPointKelvin: 1629, boilingPointKelvin: 3503, density: "8.23", groupBlock: "Lanthanide", yearDiscovered: "1843"),
        ElementScienceRecord(atomicMass: "162.500", electronConfiguration: "[Xe]6s2 4f10", oxidationStates: "+3", standardState: "Solid", meltingPointKelvin: 1685, boilingPointKelvin: 2840, density: "8.55", groupBlock: "Lanthanide", yearDiscovered: "1886"),
        ElementScienceRecord(atomicMass: "164.93033", electronConfiguration: "[Xe]6s2 4f11", oxidationStates: "+3", standardState: "Solid", meltingPointKelvin: 1747, boilingPointKelvin: 2973, density: "8.80", groupBlock: "Lanthanide", yearDiscovered: "1878"),
        ElementScienceRecord(atomicMass: "167.26", electronConfiguration: "[Xe]6s2 4f12", oxidationStates: "+3", standardState: "Solid", meltingPointKelvin: 1802, boilingPointKelvin: 3141, density: "9.07", groupBlock: "Lanthanide", yearDiscovered: "1843"),
        ElementScienceRecord(atomicMass: "168.93422", electronConfiguration: "[Xe]6s2 4f13", oxidationStates: "+3", standardState: "Solid", meltingPointKelvin: 1818, boilingPointKelvin: 2223, density: "9.32", groupBlock: "Lanthanide", yearDiscovered: "1879"),
        ElementScienceRecord(atomicMass: "173.05", electronConfiguration: "[Xe]6s2 4f14", oxidationStates: "+3, +2", standardState: "Solid", meltingPointKelvin: 1092, boilingPointKelvin: 1469, density: "6.90", groupBlock: "Lanthanide", yearDiscovered: "1878"),
        ElementScienceRecord(atomicMass: "174.9667", electronConfiguration: "[Xe]6s2 4f14 5d1", oxidationStates: "+3", standardState: "Solid", meltingPointKelvin: 1936, boilingPointKelvin: 3675, density: "9.84", groupBlock: "Lanthanide", yearDiscovered: "1907"),
        ElementScienceRecord(atomicMass: "178.49", electronConfiguration: "[Xe]6s2 4f14 5d2", oxidationStates: "+4", standardState: "Solid", meltingPointKelvin: 2506, boilingPointKelvin: 4876, density: "13.3", groupBlock: "Transition metal", yearDiscovered: "1923"),
        ElementScienceRecord(atomicMass: "180.9479", electronConfiguration: "[Xe]6s2 4f14 5d3", oxidationStates: "+5", standardState: "Solid", meltingPointKelvin: 3290, boilingPointKelvin: 5731, density: "16.4", groupBlock: "Transition metal", yearDiscovered: "1802"),
        ElementScienceRecord(atomicMass: "183.84", electronConfiguration: "[Xe]6s2 4f14 5d4", oxidationStates: "+6", standardState: "Solid", meltingPointKelvin: 3695, boilingPointKelvin: 5828, density: "19.3", groupBlock: "Transition metal", yearDiscovered: "1783"),
        ElementScienceRecord(atomicMass: "186.207", electronConfiguration: "[Xe]6s2 4f14 5d5", oxidationStates: "+7, +6, +4", standardState: "Solid", meltingPointKelvin: 3459, boilingPointKelvin: 5869, density: "20.8", groupBlock: "Transition metal", yearDiscovered: "1925"),
        ElementScienceRecord(atomicMass: "190.2", electronConfiguration: "[Xe]6s2 4f14 5d6", oxidationStates: "+4, +3", standardState: "Solid", meltingPointKelvin: 3306, boilingPointKelvin: 5285, density: "22.57", groupBlock: "Transition metal", yearDiscovered: "1803"),
        ElementScienceRecord(atomicMass: "192.22", electronConfiguration: "[Xe]6s2 4f14 5d7", oxidationStates: "+4, +3", standardState: "Solid", meltingPointKelvin: 2719, boilingPointKelvin: 4701, density: "22.42", groupBlock: "Transition metal", yearDiscovered: "1803"),
        ElementScienceRecord(atomicMass: "195.08", electronConfiguration: "[Xe]6s1 4f14 5d9", oxidationStates: "+4, +2", standardState: "Solid", meltingPointKelvin: 2041.55, boilingPointKelvin: 4098, density: "21.46", groupBlock: "Transition metal", yearDiscovered: "1735"),
        ElementScienceRecord(atomicMass: "196.96657", electronConfiguration: "[Xe]6s1 4f14 5d10", oxidationStates: "+3, +1", standardState: "Solid", meltingPointKelvin: 1337.33, boilingPointKelvin: 3129, density: "19.282", groupBlock: "Transition metal", yearDiscovered: "Ancient"),
        ElementScienceRecord(atomicMass: "200.59", electronConfiguration: "[Xe]6s2 4f14 5d10", oxidationStates: "+2, +1", standardState: "Liquid", meltingPointKelvin: 234.32, boilingPointKelvin: 629.88, density: "13.5336", groupBlock: "Transition metal", yearDiscovered: "Ancient"),
        ElementScienceRecord(atomicMass: "204.383", electronConfiguration: "[Xe]6s2 4f14 5d10 6p1", oxidationStates: "+3, +1", standardState: "Solid", meltingPointKelvin: 577, boilingPointKelvin: 1746, density: "11.8", groupBlock: "Post-transition metal", yearDiscovered: "1861"),
        ElementScienceRecord(atomicMass: "207", electronConfiguration: "[Xe]6s2 4f14 5d10 6p2", oxidationStates: "+4, +2", standardState: "Solid", meltingPointKelvin: 600.61, boilingPointKelvin: 2022, density: "11.342", groupBlock: "Post-transition metal", yearDiscovered: "Ancient"),
        ElementScienceRecord(atomicMass: "208.98040", electronConfiguration: "[Xe]6s2 4f14 5d10 6p3", oxidationStates: "+5, +3", standardState: "Solid", meltingPointKelvin: 544.55, boilingPointKelvin: 1837, density: "9.807", groupBlock: "Post-transition metal", yearDiscovered: "1753"),
        ElementScienceRecord(atomicMass: "208.98243", electronConfiguration: "[Xe]6s2 4f14 5d10 6p4", oxidationStates: "+4, +2", standardState: "Solid", meltingPointKelvin: 527, boilingPointKelvin: 1235, density: "9.32", groupBlock: "Metalloid", yearDiscovered: "1898"),
        ElementScienceRecord(atomicMass: "209.98715", electronConfiguration: "[Xe]6s2 4f14 5d10 6p5", oxidationStates: "7, 5, 3, 1, -1", standardState: "Solid", meltingPointKelvin: 575, boilingPointKelvin: nil, density: "7", groupBlock: "Halogen", yearDiscovered: "1940"),
        ElementScienceRecord(atomicMass: "222.01758", electronConfiguration: "[Xe]6s2 4f14 5d10 6p6", oxidationStates: "0", standardState: "Gas", meltingPointKelvin: 202, boilingPointKelvin: 211.45, density: "0.00973", groupBlock: "Noble gas", yearDiscovered: "1900"),
        ElementScienceRecord(atomicMass: "223.01973", electronConfiguration: "[Rn]7s1", oxidationStates: "+1", standardState: "Solid", meltingPointKelvin: 300, boilingPointKelvin: nil, density: "", groupBlock: "Alkali metal", yearDiscovered: "1939"),
        ElementScienceRecord(atomicMass: "226.02541", electronConfiguration: "[Rn]7s2", oxidationStates: "+2", standardState: "Solid", meltingPointKelvin: 973, boilingPointKelvin: 1413, density: "5", groupBlock: "Alkaline earth metal", yearDiscovered: "1898"),
        ElementScienceRecord(atomicMass: "227.02775", electronConfiguration: "[Rn]7s2 6d1", oxidationStates: "+3", standardState: "Solid", meltingPointKelvin: 1324, boilingPointKelvin: 3471, density: "10.07", groupBlock: "Actinide", yearDiscovered: "1899"),
        ElementScienceRecord(atomicMass: "232.038", electronConfiguration: "[Rn]7s2 6d2", oxidationStates: "+4", standardState: "Solid", meltingPointKelvin: 2023, boilingPointKelvin: 5061, density: "11.72", groupBlock: "Actinide", yearDiscovered: "1828"),
        ElementScienceRecord(atomicMass: "231.03588", electronConfiguration: "[Rn]7s2 5f2 6d1", oxidationStates: "+5, +4", standardState: "Solid", meltingPointKelvin: 1845, boilingPointKelvin: nil, density: "15.37", groupBlock: "Actinide", yearDiscovered: "1913"),
        ElementScienceRecord(atomicMass: "238.0289", electronConfiguration: "[Rn]7s2 5f3 6d1", oxidationStates: "+6, +5, +4, +3", standardState: "Solid", meltingPointKelvin: 1408, boilingPointKelvin: 4404, density: "18.95", groupBlock: "Actinide", yearDiscovered: "1789"),
        ElementScienceRecord(atomicMass: "237.048172", electronConfiguration: "[Rn]7s2 5f4 6d1", oxidationStates: "+6, +5, +4, +3", standardState: "Solid", meltingPointKelvin: 917, boilingPointKelvin: 4175, density: "20.25", groupBlock: "Actinide", yearDiscovered: "1940"),
        ElementScienceRecord(atomicMass: "244.06420", electronConfiguration: "[Rn]7s2 5f6", oxidationStates: "+6, +5, +4, +3", standardState: "Solid", meltingPointKelvin: 913, boilingPointKelvin: 3501, density: "19.84", groupBlock: "Actinide", yearDiscovered: "1940"),
        ElementScienceRecord(atomicMass: "243.061380", electronConfiguration: "[Rn]7s2 5f7", oxidationStates: "+6, +5, +4, +3", standardState: "Solid", meltingPointKelvin: 1449, boilingPointKelvin: 2284, density: "13.69", groupBlock: "Actinide", yearDiscovered: "1944"),
        ElementScienceRecord(atomicMass: "247.07035", electronConfiguration: "[Rn]7s2 5f7 6d1", oxidationStates: "+3", standardState: "Solid", meltingPointKelvin: 1618, boilingPointKelvin: 3400, density: "13.51", groupBlock: "Actinide", yearDiscovered: "1944"),
        ElementScienceRecord(atomicMass: "247.07031", electronConfiguration: "[Rn]7s2 5f9", oxidationStates: "+4, +3", standardState: "Solid", meltingPointKelvin: 1323, boilingPointKelvin: nil, density: "14", groupBlock: "Actinide", yearDiscovered: "1949"),
        ElementScienceRecord(atomicMass: "251.07959", electronConfiguration: "[Rn]7s2 5f10", oxidationStates: "+3", standardState: "Solid", meltingPointKelvin: 1173, boilingPointKelvin: nil, density: "", groupBlock: "Actinide", yearDiscovered: "1950"),
        ElementScienceRecord(atomicMass: "252.0830", electronConfiguration: "[Rn]7s2 5f11", oxidationStates: "+3", standardState: "Solid", meltingPointKelvin: 1133, boilingPointKelvin: nil, density: "", groupBlock: "Actinide", yearDiscovered: "1952"),
        ElementScienceRecord(atomicMass: "257.09511", electronConfiguration: "[Rn] 5f12 7s2", oxidationStates: "+3", standardState: "Solid", meltingPointKelvin: 1800, boilingPointKelvin: nil, density: "", groupBlock: "Actinide", yearDiscovered: "1952"),
        ElementScienceRecord(atomicMass: "258.09843", electronConfiguration: "[Rn]7s2 5f13", oxidationStates: "+3, +2", standardState: "Solid", meltingPointKelvin: 1100, boilingPointKelvin: nil, density: "", groupBlock: "Actinide", yearDiscovered: "1955"),
        ElementScienceRecord(atomicMass: "259.10100", electronConfiguration: "[Rn]7s2 5f14", oxidationStates: "+3, +2", standardState: "Solid", meltingPointKelvin: 1100, boilingPointKelvin: nil, density: "", groupBlock: "Actinide", yearDiscovered: "1957"),
        ElementScienceRecord(atomicMass: "266.120", electronConfiguration: "[Rn]7s2 5f14 6d1", oxidationStates: "+3", standardState: "Solid", meltingPointKelvin: 1900, boilingPointKelvin: nil, density: "", groupBlock: "Actinide", yearDiscovered: "1961"),
        ElementScienceRecord(atomicMass: "267.122", electronConfiguration: "[Rn]7s2 5f14 6d2", oxidationStates: "+4", standardState: "Solid", meltingPointKelvin: nil, boilingPointKelvin: nil, density: "", groupBlock: "Transition metal", yearDiscovered: "1964"),
        ElementScienceRecord(atomicMass: "268.126", electronConfiguration: "[Rn]7s2 5f14 6d3", oxidationStates: "5, 4, 3", standardState: "Solid", meltingPointKelvin: nil, boilingPointKelvin: nil, density: "", groupBlock: "Transition metal", yearDiscovered: "1967"),
        ElementScienceRecord(atomicMass: "269.128", electronConfiguration: "[Rn]7s2 5f14 6d4", oxidationStates: "6, 5, 4, 3, 0", standardState: "Solid", meltingPointKelvin: nil, boilingPointKelvin: nil, density: "", groupBlock: "Transition metal", yearDiscovered: "1974"),
        ElementScienceRecord(atomicMass: "270.133", electronConfiguration: "[Rn]7s2 5f14 6d5", oxidationStates: "7, 5, 4, 3", standardState: "Solid", meltingPointKelvin: nil, boilingPointKelvin: nil, density: "", groupBlock: "Transition metal", yearDiscovered: "1976"),
        ElementScienceRecord(atomicMass: "269.1336", electronConfiguration: "[Rn]7s2 5f14 6d6", oxidationStates: "8, 6, 5, 4, 3, 2", standardState: "Solid", meltingPointKelvin: nil, boilingPointKelvin: nil, density: "", groupBlock: "Transition metal", yearDiscovered: "1984"),
        ElementScienceRecord(atomicMass: "277.154", electronConfiguration: "[Rn]7s2 5f14 6d7 (calculated)", oxidationStates: "9, 8, 6, 4, 3, 1", standardState: "Solid", meltingPointKelvin: nil, boilingPointKelvin: nil, density: "", groupBlock: "Transition metal", yearDiscovered: "1982"),
        ElementScienceRecord(atomicMass: "282.166", electronConfiguration: "[Rn]7s2 5f14 6d8 (predicted)", oxidationStates: "8, 6, 4, 2, 0", standardState: "Expected to be a Solid", meltingPointKelvin: nil, boilingPointKelvin: nil, density: "", groupBlock: "Transition metal", yearDiscovered: "1994"),
        ElementScienceRecord(atomicMass: "282.169", electronConfiguration: "[Rn]7s2 5f14 6d9 (predicted)", oxidationStates: "5, 3, 1, -1", standardState: "Expected to be a Solid", meltingPointKelvin: nil, boilingPointKelvin: nil, density: "", groupBlock: "Transition metal", yearDiscovered: "1994"),
        ElementScienceRecord(atomicMass: "286.179", electronConfiguration: "[Rn]7s2 5f14 6d10 (predicted)", oxidationStates: "2, 1, 0", standardState: "Expected to be a Solid", meltingPointKelvin: nil, boilingPointKelvin: nil, density: "", groupBlock: "Transition metal", yearDiscovered: "1996"),
        ElementScienceRecord(atomicMass: "286.182", electronConfiguration: "[Rn]5f14 6d10 7s2 7p1 (predicted)", oxidationStates: "", standardState: "Expected to be a Solid", meltingPointKelvin: nil, boilingPointKelvin: nil, density: "", groupBlock: "Post-transition metal", yearDiscovered: "2004"),
        ElementScienceRecord(atomicMass: "290.192", electronConfiguration: "[Rn]7s2 7p2 5f14 6d10 (predicted)", oxidationStates: "6, 4,2, 1, 0", standardState: "Expected to be a Solid", meltingPointKelvin: nil, boilingPointKelvin: nil, density: "", groupBlock: "Post-transition metal", yearDiscovered: "1998"),
        ElementScienceRecord(atomicMass: "290.196", electronConfiguration: "[Rn]7s2 7p3 5f14 6d10 (predicted)", oxidationStates: "3, 1", standardState: "Expected to be a Solid", meltingPointKelvin: nil, boilingPointKelvin: nil, density: "", groupBlock: "Post-transition metal", yearDiscovered: "2003"),
        ElementScienceRecord(atomicMass: "293.205", electronConfiguration: "[Rn]7s2 7p4 5f14 6d10 (predicted)", oxidationStates: "+4, +2, -2", standardState: "Expected to be a Solid", meltingPointKelvin: nil, boilingPointKelvin: nil, density: "", groupBlock: "Post-transition metal", yearDiscovered: "2000"),
        ElementScienceRecord(atomicMass: "294.211", electronConfiguration: "[Rn]7s2 7p5 5f14 6d10 (predicted)", oxidationStates: "+5, +3, +1, -1", standardState: "Expected to be a Solid", meltingPointKelvin: nil, boilingPointKelvin: nil, density: "", groupBlock: "Halogen", yearDiscovered: "2010"),
        ElementScienceRecord(atomicMass: "295.216", electronConfiguration: "[Rn]7s2 7p6 5f14 6d10 (predicted)", oxidationStates: "+6, +4, +2, +1, 0, -1", standardState: "Expected to be a Gas", meltingPointKelvin: nil, boilingPointKelvin: nil, density: "", groupBlock: "Noble gas", yearDiscovered: "2006"),
    ]

    static func record(for atomicNumber: Int) -> ElementScienceRecord {
        precondition((1...records.count).contains(atomicNumber))
        return records[atomicNumber - 1]
    }
}

extension PeriodicElement {
    var scienceRecord: ElementScienceRecord {
        ElementScienceData.record(for: number)
    }

    var atomicCompositionDescription: String {
        let record = scienceRecord
        let configuration = record.electronConfiguration.isEmpty
            ? "not yet measured"
            : record.electronConfiguration
        let oxidation = record.oxidationStates.isEmpty
            ? "not yet established"
            : record.oxidationStates

        var neutronNote = ""
        if let mass = Double(record.atomicMass) {
            let estimatedNeutrons = max(0, Int(mass.rounded()) - number)
            neutronNote = " A representative isotope near the rounded mass would have about \(estimatedNeutrons) neutrons, but isotopes of \(name) can contain different neutron counts."
        }

        return """
        A neutral \(name) atom contains \(number) protons and \(number) electrons. Its listed atomic mass is \(record.atomicMass) u and its electron configuration is \(configuration).\(neutronNote) Common oxidation states are \(oxidation).
        """
    }

    var materialCompositionDescription: String {
        if number >= 104 {
            return """
            A pure \(name) sample would contain only \(symbol) atoms, but only a few short-lived atoms have been produced. Scientists infer its bulk material and compounds from nuclear decay, periodic trends, and the small number of reactions that can be observed.
            """
        }

        return """
        Pure elemental \(name) is made only of \(symbol) atoms. Ores, salts, oxides, alloys, and molecules that contain \(name) are different materials because other atoms are bonded or mixed with it. \(formsDescription)
        """
    }

    var phaseConditionsDescription: String {
        let record = scienceRecord

        if number == 2 {
            return """
            Helium becomes liquid below \(temperatureText(record.boilingPointKelvin)) at about 1 atmosphere. It does not freeze at ordinary pressure—even near absolute zero—so producing solid helium also requires high pressure.
            """
        }

        if number == 6 {
            return """
            Carbon stays solid across an enormous temperature range. At ordinary pressure it usually sublimes instead of forming a normal open liquid pool; liquid carbon requires extreme temperature and pressure. The listed high-temperature values depend strongly on pressure and allotrope.
            """
        }

        if number == 33 {
            return """
            Arsenic normally sublimes from solid to vapor near 615 °C at atmospheric pressure. A stable liquid range requires increased pressure, so its phase behavior is not described by a simple room-pressure melt-then-boil sequence.
            """
        }

        guard let meltingPoint = record.meltingPointKelvin,
              let boilingPoint = record.boilingPointKelvin else {
            return """
            Reliable melting and boiling points are not available because a macroscopic \(name) sample has not been produced or measured. Its listed standard state—\(record.standardState.lowercased())—is \(number >= 104 ? "a scientific prediction" : "the best available description").
            """
        }

        return """
        Near 1 atmosphere, \(name) is expected to be solid below \(temperatureText(meltingPoint)), liquid from about \(temperatureText(meltingPoint)) to \(temperatureText(boilingPoint)), and gas above \(temperatureText(boilingPoint)). Exact values can shift with pressure, purity, isotope, and crystal form.
        """
    }

    var formAppearanceDescription: String {
        switch number {
        case 1:
            return "Hydrogen gas is colorless. Liquid hydrogen is also colorless and transparent, while solid hydrogen forms clear-to-white molecular crystals at still lower temperatures."
        case 2:
            return "Helium gas and liquid helium are colorless. Solid helium, made only under pressure, is also expected to look clear; peach or pink light comes from an electrical discharge, not the ordinary gas."
        case 5:
            return "Boron can form a brown amorphous powder or very hard, dark, glossy crystals. Different boron structures change its color, hardness, and electrical behavior."
        case 6:
            return "Graphite is soft, opaque, and dark gray with layered sheets; diamond is transparent and extremely hard; graphene is a one-atom-thick sheet; amorphous carbon is a black powder or porous solid."
        case 7:
            return "Nitrogen is a colorless gas. Liquid nitrogen is clear and colorless, and solid nitrogen forms colorless molecular crystals at cryogenic temperatures."
        case 8:
            return "Oxygen gas is colorless, but liquid and solid oxygen are pale sky blue. Ozone is a different molecular form, O₃, and is blue with a sharp odor."
        case 9:
            return "Fluorine is a very pale yellow gas, becomes a brighter yellow liquid when cooled, and forms pale yellow-to-white molecular crystals when frozen."
        case 15:
            return "White phosphorus is a pale, waxy, translucent solid; red phosphorus is a dark red powder; violet phosphorus forms purple-red crystals; black phosphorus has dark layered, graphite-like flakes."
        case 16:
            return "Common sulfur forms bright yellow crystals or powder. Molten sulfur begins yellow and runny, becomes dark red-brown and unusually thick as chains form, then thins again at higher temperature."
        case 17:
            return "Chlorine is a yellow-green gas. Cooling makes an amber-yellow liquid and then a pale yellow crystalline solid."
        case 34:
            return "Gray selenium is dense with a metallic sheen, red selenium can be a powder or translucent crystals, and black selenium is glassy and brittle."
        case 35:
            return "Bromine is a dark red-brown liquid at room temperature. Its vapor is orange-brown, and frozen bromine forms dark red molecular crystals."
        case 50:
            return "White beta-tin is bright, metallic, and bendable. Below about 13.2 °C, gray alpha-tin can form a dull, brittle, nonmetallic powder-like structure—a slow change called tin pest."
        case 53:
            return "Iodine is a shiny blue-black crystalline solid. It melts into a deep violet-black liquid and produces a strongly violet vapor when heated."
        case 80:
            return "Mercury is a mirror-bright silver liquid near room temperature. When frozen below about −38.8 °C it becomes a soft silver solid; its vapor is normally invisible."
        case 104...118:
            return "No visible bulk sample exists. The app’s solid, liquid, and vapor previews are clearly marked educational predictions rather than observed photographs."
        default:
            switch category {
            case .alkaliMetal, .alkalineEarthMetal, .transitionMetal,
                 .postTransitionMetal, .lanthanide, .actinide:
                return "The solid is a naturally irregular metallic piece with \(metalAppearanceProfile.label) coloring. When molten it becomes a mobile, reflective liquid; at far higher temperature its dilute atomic vapor is usually hard to see unless excited in a lamp or flame."
            case .metalloid:
                return "Its common solid is brittle, crystalline, and dark or metallic-looking. A molten sample becomes a dense reflective liquid, while the high-temperature vapor is much less visible than the solid."
            case .reactiveNonmetal:
                return "Its solid form is molecular, layered, or network-like rather than metallic. Cooling or heating changes molecular spacing and motion, so the liquid flows and the gas spreads to fill its container."
            case .halogen:
                return "The pure element forms small molecules. The solid is crystalline, the liquid is strongly colored and mobile, and the gas spreads through a container; color generally becomes more intense for the heavier halogens."
            case .nobleGas:
                return "The ordinary gas is colorless. Cryogenic liquid and solid forms are generally clear or colorless; the familiar bright colors appear only when an electrical discharge excites the atoms."
            }
        }
    }

    var scienceSummaryLine: String {
        let record = scienceRecord
        let density = record.density.isEmpty
            ? "not measured"
            : "\(record.density) g/cm³"
        return """
        \(record.groupBlock) · \(record.standardState) · atomic mass \(record.atomicMass) u · density \(density) · discovered \(record.yearDiscovered)
        """
    }

    var tutorStudyContext: String {
        let record = scienceRecord
        let meltingPoint = record.meltingPointKelvin.map(temperatureText)
            ?? "not reliably measured"
        let boilingPoint = record.boilingPointKelvin.map(temperatureText)
            ?? "not reliably measured"
        let density = record.density.isEmpty
            ? "not reliably measured"
            : "\(record.density) g/cm³"
        let oxidationStates = record.oxidationStates.isEmpty
            ? "not yet established"
            : record.oxidationStates

        return """
        Selected periodic-table element: \(name) (\(symbol))
        Atomic number: \(number)
        Classification: \(record.groupBlock)
        Standard state: \(record.standardState)
        Atomic mass: \(record.atomicMass) u
        Electron configuration: \(record.electronConfiguration)
        Common oxidation states: \(oxidationStates)
        Density: \(density)
        Melting point: \(meltingPoint)
        Boiling point: \(boilingPoint)

        Atomic composition:
        \(atomicCompositionDescription)

        Pure element and material composition:
        \(materialCompositionDescription)

        Phase conditions:
        \(phaseConditionsDescription)

        Appearance in different forms:
        \(formAppearanceDescription)

        Natural occurrence:
        \(occurrenceDescription)

        Common uses:
        \(usesDescription)

        Safety:
        \(safetyDescription)
        """
    }

    var focusedTutorQuestions: [String] {
        [
            "Quiz me on the solid, liquid, and gas forms of \(name). Ask one question at a time and wait for my answer.",
            "Explain why \(name) is \(standardStateDescription) near room temperature. Use its phase-change temperatures and give me a memory trick.",
            "Help me compare pure \(name) with compounds or materials that contain \(name). Include what the different forms look like.",
            "Give me a short review of \(name), then ask me three recall questions about its atoms, forms, appearance, and where it is found."
        ]
    }

    func conditionDescription(for form: ElementPhysicalForm) -> String {
        let record = scienceRecord

        if number == 2 {
            return switch form {
            case .solid:
                "Solid helium needs very low temperature plus high pressure; it does not freeze at ordinary pressure."
            case .liquid:
                "Helium becomes liquid below about \(temperatureText(record.boilingPointKelvin)) at ordinary pressure."
            case .gas:
                "Above about \(temperatureText(record.boilingPointKelvin)), helium spreads as a gas."
            }
        }

        if number == 6 {
            return switch form {
            case .solid:
                "Carbon’s graphite, diamond, and other allotropes remain solid across a huge temperature range."
            case .liquid:
                "Liquid carbon requires extreme temperature and pressure; it is not an ordinary open-container liquid."
            case .gas:
                "At ordinary pressure, intensely heated carbon tends to sublime from solid toward vapor."
            }
        }

        if number == 33 {
            return switch form {
            case .solid:
                "Arsenic is normally a brittle solid at room conditions."
            case .liquid:
                "A stable arsenic liquid requires pressure because ordinary-pressure arsenic tends to sublime."
            case .gas:
                "At ordinary pressure, arsenic sublimes into vapor near 615 °C."
            }
        }

        switch form {
        case .solid:
            if let meltingPoint = record.meltingPointKelvin {
                return "Expected below about \(temperatureText(meltingPoint)) near 1 atmosphere."
            }
        case .liquid:
            if let meltingPoint = record.meltingPointKelvin,
               let boilingPoint = record.boilingPointKelvin {
                return "Expected between about \(temperatureText(meltingPoint)) and \(temperatureText(boilingPoint)) near 1 atmosphere."
            }
        case .gas:
            if let boilingPoint = record.boilingPointKelvin {
                return "Expected above about \(temperatureText(boilingPoint)) near 1 atmosphere."
            }
        }

        return "This bulk form has not been measured reliably; the preview is an educational prediction."
    }

    private func temperatureText(_ kelvin: Double?) -> String {
        guard let kelvin else { return "an unknown temperature" }
        let celsius = kelvin - 273.15
        let precision = abs(celsius) < 100 ? 1 : 0
        return "\(String(format: "%.\(precision)f", celsius)) °C (\(String(format: "%.2f", kelvin)) K)"
    }
}
