import Foundation

// MARK: - Phase Target

struct PhaseTarget {
    let lightPPFD: ClosedRange<Double>?
    let lightHours: Double?
    let tempDay: ClosedRange<Double>?
    let tempNight: ClosedRange<Double>?
    let vpd: ClosedRange<Double>?
    let humidity: ClosedRange<Double>?
    let ec: ClosedRange<Double>?
    let ph: ClosedRange<Double>?
    let water: String?
}

// MARK: - Phase Task

struct PhaseTask: Identifiable {
    let id = UUID()
    let text: String
    let critical: Bool
}

// MARK: - Phase Question

struct PhaseQuestion: Identifiable {
    let id: String
    let text: String
    let options: [String]
}

// MARK: - Phase Definition

struct PhaseDefinition {
    let key: PhaseKey
    let duration: String
    let description: String
    let targets: PhaseTarget
    let goalTips: [GrowGoal: String]
    let tasks: [PhaseTask]
    let questions: [PhaseQuestion]
}

// MARK: - Phase Data

enum PhaseData {
    static let phases: [PhaseKey: PhaseDefinition] = [
        .germination: PhaseDefinition(
            key: .germination,
            duration: "1–2 Wochen",
            description: "Samen keimen bei 22–26°C und hoher Luftfeuchtigkeit.",
            targets: PhaseTarget(
                lightPPFD: 0...50,
                lightHours: 24,
                tempDay: 22...26,
                tempNight: 20...22,
                vpd: 0.2...0.4,
                humidity: 70...80,
                ec: 0...0.4,
                ph: 6.0...7.0,
                water: "Substrat feucht halten, nicht nass"
            ),
            goalTips: [
                .A: "Kein Unterschied — Keimung ist immer gleich.",
                .B: "Kein Unterschied — Keimung ist immer gleich.",
                .C: "Kein Unterschied — Keimung ist immer gleich."
            ],
            tasks: [
                PhaseTask(text: "Rockwool/Coco anfeuchten (pH 5.5–6.0)", critical: true),
                PhaseTask(text: "Samen in 1cm Tiefe platzieren", critical: true),
                PhaseTask(text: "Becher/Minigewächshaus abdecken (80%+ LF)", critical: false),
                PhaseTask(text: "Temperatur 22–26°C sicherstellen", critical: true),
                PhaseTask(text: "Kein Gießen bis Keimling sichtbar", critical: false)
            ],
            questions: [
                PhaseQuestion(id: "germ_method", text: "Methode?", options: ["Rockwool", "Coco", "Erde", "Direkt im Topf"]),
                PhaseQuestion(id: "germ_root", text: "Wurzel sichtbar?", options: ["Ja", "Nein", "Kein Samen sichtbar"])
            ]
        ),
        .seedling: PhaseDefinition(
            key: .seedling,
            duration: "2–3 Wochen",
            description: "Kleine Pflanze mit Kotyledonen und ersten echten Blättern.",
            targets: PhaseTarget(
                lightPPFD: 200...400,
                lightHours: 18,
                tempDay: 22...26,
                tempNight: 18...22,
                vpd: 0.4...0.8,
                humidity: 65...80,
                ec: 0.2...0.4,
                ph: 6.0...7.0,
                water: "Sanft gießen (nass-trocken-Zyklus)"
            ),
            goalTips: [
                .A: "Gleichbleibende Bedingungen, kein Stress.",
                .B: "Gleichbleibende Bedingungen. Stress kommt später.",
                .C: "Gleichbleibende Bedingungen. Solide Basis."
            ],
            tasks: [
                PhaseTask(text: "Sanft gießen (nass-trocken-Zyklus)", critical: true),
                PhaseTask(text: "Licht: 200–400 PPFD", critical: true),
                PhaseTask(text: "Keine Nährstoffe oder sehr schwach (EC <0.4)", critical: false),
                PhaseTask(text: "Erste Blattpaare beobachten", critical: false)
            ],
            questions: [
                PhaseQuestion(id: "seedling_health", text: "Zustand?", options: ["Gesund", "Streckt sich", "Blätter hängen"])
            ]
        ),
        .veg: PhaseDefinition(
            key: .veg,
            duration: "4–8 Wochen",
            description: "Kraftvolles Wachstum — Blätter, Stängel und Wurzeln.",
            targets: PhaseTarget(
                lightPPFD: 600...900,
                lightHours: 18,
                tempDay: 24...28,
                tempNight: 18...22,
                vpd: 0.8...1.2,
                humidity: 55...70,
                ec: 0.8...1.6,
                ph: 6.0...7.0,
                water: "Nass-Trocken-Zyklus, Wurzeln oxidieren lassen"
            ),
            goalTips: [
                .A: "Maximale Wuchsgeschwindigkeit. Hoher N, großer Topf.",
                .B: "Etwas kürzere Veg-Phase, moderate Größe.",
                .C: "Ausgewogenes Wachstum, 4–6 Wochen Veg."
            ],
            tasks: [
                PhaseTask(text: "PPFD 600–900 µmol/m²/s", critical: true),
                PhaseTask(text: "N-P-K im Verhältnis 3-1-2", critical: true),
                PhaseTask(text: "Topping/LST für gleichmäßige Canopy", critical: false),
                PhaseTask(text: "Stängel verdicken (Ventilator)", critical: false),
                PhaseTask(text: "Wurzelwachstum prüfen (Drainage)", critical: false),
                PhaseTask(text: "pH 5.8–6.3 (Coco/Hydro) oder 6.2–7.0 (Erde)", critical: true)
            ],
            questions: [
                PhaseQuestion(id: "veg_week", text: "Woche Veg?", options: ["Woche 1–2", "Woche 3–4", "Woche 5+"]),
                PhaseQuestion(id: "veg_training", text: "Training?", options: ["Keins", "Topping", "LST", "SCROG"])
            ]
        ),
        .early_bloom: PhaseDefinition(
            key: .early_bloom,
            duration: "1–2 Wochen",
            description: "Stretch-Phase — Pflanze verdoppelt sich fast.",
            targets: PhaseTarget(
                lightPPFD: 800...1100,
                lightHours: 12,
                tempDay: 24...26,
                tempNight: 18...20,
                vpd: 1.0...1.4,
                humidity: 50...65,
                ec: 1.2...1.8,
                ph: 6.0...7.0,
                water: "Nass-Trocken-Zyklus, moderate Freq."
            ),
            goalTips: [
                .A: "13h Photoperiode testen für +Stretch. N weiter hoch.",
                .B: "12h Photoperiode. N schneller reduzieren.",
                .C: "12–13h (Testen). Balanced N-Reduktion."
            ],
            tasks: [
                PhaseTask(text: "Photoperiode auf 12/12 umstellen (Photo)", critical: true),
                PhaseTask(text: "N langsam reduzieren", critical: true),
                PhaseTask(text: "PPFD auf 800+ erhöhen", critical: false),
                PhaseTask(text: "Stretch-Risiko: Stützen bereithalten", critical: false)
            ],
            questions: [
                PhaseQuestion(id: "stretch_amount", text: "Stretch?", options: ["Stark (2x+)", "Moderat", "Kaum"])
            ]
        ),
        .late_bloom: PhaseDefinition(
            key: .late_bloom,
            duration: "6–9 Wochen",
            description: "Bildung und Reifung der Blüten.",
            targets: PhaseTarget(
                lightPPFD: 800...1200,
                lightHours: 12,
                tempDay: 22...25,
                tempNight: 14...18,
                vpd: 1.4...2.0,
                humidity: 40...55,
                ec: 0.8...1.4,
                ph: 6.0...7.0,
                water: "Länger austrocknen lassen"
            ),
            goalTips: [
                .A: "Keine Stressoren, gut ernährt lassen. Ertrag steht über alles.",
                .B: "VPD hoch (1.5–2.0), Trockenstress, kühle Nächte.",
                .C: "Leichter Trockenstress ab Woche 6. Kühle Nächte ab Woche 7."
            ],
            tasks: [
                PhaseTask(text: "VPD 1.2–1.6 kPa", critical: true),
                PhaseTask(text: "P/K Boost in FW1–FW3", critical: true),
                PhaseTask(text: "Defoliation R2 (Woche 3 Blüte)", critical: false),
                PhaseTask(text: "Trichome mit Lupe/Mikroskop beobachten", critical: false),
                PhaseTask(text: "Nachttemperatur 16–18°C für Terpene", critical: false),
                PhaseTask(text: "Schimmel-Checks alle 2 Tage", critical: true)
            ],
            questions: [
                PhaseQuestion(id: "bloom_week", text: "Woche Blüte?", options: ["FW 1–2", "FW 3–4", "FW 5–6", "FW 7–8", "FW 9+"]),
                PhaseQuestion(id: "trichome_state", text: "Trichome?", options: ["Klar", "Milchig", "Bernsteinfarben", "Gemischt"])
            ]
        ),
        .harvest: PhaseDefinition(
            key: .harvest,
            duration: "1 Tag",
            description: "Pflanze schneiden und zum Trocknen aufhängen.",
            targets: PhaseTarget(
                lightPPFD: nil,
                lightHours: nil,
                tempDay: 15...20,
                tempNight: 15...18,
                vpd: nil,
                humidity: 55...62,
                ec: nil,
                ph: nil,
                water: "48h vor Ernte nicht gießen"
            ),
            goalTips: [
                .A: "Früherer Erntezeitpunkt (weniger Amber, mehr Biomasse).",
                .B: "Späterer Erntezeitpunkt (20%+ Amber = vollste Potenz).",
                .C: "Milchig-trüb, <10% Amber für ausgewogene Wirkung."
            ],
            tasks: [
                PhaseTask(text: "Trichome: 10–30% bernsteinfarben", critical: true),
                PhaseTask(text: "Pflanze 48h dunkel stellen (optional)", critical: false),
                PhaseTask(text: "Große Äste einzeln schneiden", critical: false),
                PhaseTask(text: "Aufhängen kopfüber bei 20°C, 55% LF", critical: true)
            ],
            questions: [
                PhaseQuestion(id: "harvest_weight", text: "Gewicht (optional)", options: ["<50g", "50–100g", "100–200g", "200g+"])
            ]
        ),
        .cure: PhaseDefinition(
            key: .cure,
            duration: "4–12 Wochen",
            description: "Aushärten in Gläsern — Geschmack und Potenz entwickeln sich.",
            targets: PhaseTarget(
                lightPPFD: nil,
                lightHours: nil,
                tempDay: 18...22,
                tempNight: 18...22,
                vpd: nil,
                humidity: 58...62,
                ec: nil,
                ph: nil,
                water: "In Gläsern bei 58–62% RF"
            ),
            goalTips: [
                .A: "Mindestens 2 Wochen, ideal 4.",
                .B: "Längeres Curing (8–12 Wochen). Terpene brauchen Zeit.",
                .C: "6–8 Wochen Curing für optimale Balance."
            ],
            tasks: [
                PhaseTask(text: "Jars bei 58–62% LF befüllen", critical: true),
                PhaseTask(text: "Täglich Burpen (erste 2 Wochen)", critical: true),
                PhaseTask(text: "Temperatur unter 20°C", critical: false),
                PhaseTask(text: "Glas für 5 Min öffnen alle 2–3 Tage", critical: false),
                PhaseTask(text: "Feuchtigkeitsmeter in Gläsern", critical: false)
            ],
            questions: [
                PhaseQuestion(id: "cure_jar_count", text: "Gläser?", options: ["1–2", "3–5", "6+"])
            ]
        )
    ]
}
