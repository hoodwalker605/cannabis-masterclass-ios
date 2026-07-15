import Foundation

// MARK: - Calculator

struct Calculator: Identifiable {
    let id: String
    let title: String
    let icon: String
    let description: String
    let inputs: [CalcInput]
    let questions: [CalcQuestion]?
    let unit: String
    let formula: String
}

struct CalcInput: Identifiable {
    let id: String
    let label: String
    let type: InputType
    let min: Double?
    let max: Double?
    let step: Double?
    let defaultValue: Double?
    let options: [String]?
    let unit: String?
}

enum InputType {
    case slider
    case number
    case toggle
    case option
}

struct CalcQuestion: Identifiable {
    let id = UUID()
    let text: String
    let options: [String]
}

// MARK: - Calculator Data

enum CalculatorData {
    static let calculators: [Calculator] = [
        Calculator(
            id: "dli",
            title: "DLI-Rechner",
            icon: "☀️",
            description: "Daily Light Integral berechnen",
            inputs: [
                CalcInput(id: "ppfd", label: "PPFD (µmol/m²/s)", type: .slider, min: 100, max: 1500, step: 50, defaultValue: 600, options: nil, unit: "µmol/m²/s"),
                CalcInput(id: "hours", label: "Lichtstunden", type: .slider, min: 12, max: 24, step: 1, defaultValue: 18, options: nil, unit: "h"),
                CalcInput(id: "efficiency", label: "Ausnutzung (%)", type: .slider, min: 30, max: 100, step: 5, defaultValue: 60, options: nil, unit: "%")
            ],
            questions: nil,
            unit: "mol/m²/d",
            formula: "DLI = PPFD × h × 3600 / 1.000.000"
        ),
        Calculator(
            id: "vpd",
            title: "VPD-Rechner",
            icon: "🌡️",
            description: "Vapor Pressure Deficit berechnen",
            inputs: [
                CalcInput(id: "temp", label: "Temperatur", type: .slider, min: 10, max: 40, step: 0.5, defaultValue: 25, options: nil, unit: "°C"),
                CalcInput(id: "rh", label: "Relative Luftfeuchtigkeit", type: .slider, min: 20, max: 95, step: 1, defaultValue: 60, options: nil, unit: "%")
            ],
            questions: nil,
            unit: "kPa",
            formula: "VPD = es × (1 - RH/100)"
        ),
        Calculator(
            id: "yield",
            title: "Ernteertrag",
            icon: "⚖️",
            description: "Geschätzter Trockenertrag",
            inputs: [
                CalcInput(id: "plants", label: "Anzahl Pflanzen", type: .slider, min: 1, max: 12, step: 1, defaultValue: 1, options: nil, unit: "Stk"),
                CalcInput(id: "type", label: "Typ", type: .option, min: nil, max: nil, step: nil, defaultValue: nil, options: ["Indoor", "Outdoor", "Greenhouse"], unit: nil),
                CalcInput(id: "experience", label: "Erfahrung", type: .option, min: nil, max: nil, step: nil, defaultValue: nil, options: ["Anfänger", "Fortgeschritten", "Experte"], unit: nil),
                CalcInput(id: "goal", label: "Goal", type: .option, min: nil, max: nil, step: nil, defaultValue: nil, options: ["A: Ertrag", "B: Harz", "C: Balance"], unit: nil)
            ],
            questions: nil,
            unit: "g (trocken)",
            formula: "Indoor: 0.5–1.5g/W, Outdoor: 100–500g/Pflanze"
        ),
        Calculator(
            id: "nutrients",
            title: "Nährstoff-Rechner",
            icon: "🧪",
            description: "EC & NPK Bedarf berechnen",
            inputs: [
                CalcInput(id: "phase", label: "Phase", type: .option, min: nil, max: nil, step: nil, defaultValue: nil, options: ["Sämling", "Veg", "Frühe Blüte", "Späte Blüte"], unit: nil),
                CalcInput(id: "substrate", label: "Substrat", type: .option, min: nil, max: nil, step: nil, defaultValue: nil, options: ["Erde", "Coco", "Hydro"], unit: nil),
                CalcInput(id: "liters", label: "Topf-Volumen", type: .slider, min: 1, max: 50, step: 1, defaultValue: 11, options: nil, unit: "L")
            ],
            questions: nil,
            unit: "EC mS/cm",
            formula: "EC_ideal = Phase × Substrat-Korrektur"
        ),
        Calculator(
            id: "potsize",
            title: "Topfgrößen-Rechner",
            icon: "🪴",
            description: "Optimale Topfgröße berechnen",
            inputs: [
                CalcInput(id: "goal", label: "Goal", type: .option, min: nil, max: nil, step: nil, defaultValue: nil, options: ["A: Ertrag", "B: Harz", "C: Balance"], unit: nil),
                CalcInput(id: "experience", label: "Erfahrung", type: .option, min: nil, max: nil, step: nil, defaultValue: nil, options: ["Anfänger", "Fortgeschritten", "Experte"], unit: nil),
                CalcInput(id: "type", label: "Typ", type: .option, min: nil, max: nil, step: nil, defaultValue: nil, options: ["Indoor", "Outdoor"], unit: nil)
            ],
            questions: nil,
            unit: "Liter",
            formula: "Indoor: 1.5–5L/10cm Pflanzenhöhe"
        ),
        Calculator(
            id: "co2",
            title: "CO₂ / PPFD-Rechner",
            icon: "🌬️",
            description: "CO₂-Anreicherung & PPFD",
            inputs: [
                CalcInput(id: "co2_ppm", label: "CO₂ (ppm)", type: .slider, min: 400, max: 2000, step: 50, defaultValue: 400, options: nil, unit: "ppm"),
                CalcInput(id: "ppfd", label: "PPFD (µmol/m²/s)", type: .slider, min: 200, max: 1500, step: 50, defaultValue: 600, options: nil, unit: "µmol/m²/s")
            ],
            questions: nil,
            unit: "mol/m²/d",
            formula: "CO₂-Erhöhung: +30% PPFD für +1% Ertrag"
        ),
        Calculator(
            id: "cost",
            title: "Kosten-Rechner",
            icon: "💰",
            description: "Grow-Kosten schätzen",
            inputs: [
                CalcInput(id: "months", label: "Dauer (Monate)", type: .slider, min: 2, max: 8, step: 1, defaultValue: 4, options: nil, unit: "Mo"),
                CalcInput(id: "watts", label: "Leistung (W)", type: .slider, min: 50, max: 1000, step: 25, defaultValue: 200, options: nil, unit: "W"),
                CalcInput(id: "price_kwh", label: "Strompreis (€/kWh)", type: .slider, min: 0.15, max: 0.50, step: 0.01, defaultValue: 0.30, options: nil, unit: "€"),
                CalcInput(id: "yield_g", label: "Ertrag (g)", type: .slider, min: 10, max: 500, step: 10, defaultValue: 100, options: nil, unit: "g")
            ],
            questions: nil,
            unit: "€",
            formula: "Kosten = Watt × Stunden × Preis + Dünger + Substrat"
        )
    ]

    static func getCalculator(id: String) -> Calculator? {
        calculators.first { $0.id == id }
    }
}
