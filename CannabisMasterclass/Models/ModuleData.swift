import Foundation

// MARK: - Module

struct Module: Identifiable {
    let id: String
    let title: String
    let icon: String
    let category: String
    let tags: [String]
    let description: String
    let difficulty: Int
    let readTime: String
    let sections: [ModuleSection]
    let quiz: [QuizQuestion]?
}

struct ModuleSection: Identifiable {
    let id = UUID()
    let title: String
    let type: SectionType
    let content: String
    let items: [String]?
    let highlighted: Bool
}

enum SectionType {
    case text
    case bulletList
    case highlighted
    case formula
    case tip
}

struct QuizQuestion: Identifiable {
    let id = UUID()
    let question: String
    let options: [String]
    let correctIndex: Int
    let explanation: String
}

// MARK: - Module Data

enum ModuleData {
    static let modules: [Module] = [
        Module(
            id: "energie",
            title: "Energie, Licht & Photosynthese",
            icon: "⚡",
            category: "Biologie",
            tags: ["Grundlagen", "Licht"],
            description: "Wie Pflanzen Licht in Biomasse und Wirkstoffe umwandeln.",
            difficulty: 1,
            readTime: "8 Min",
            sections: [
                ModuleSection(title: "Photosynthese", type: .text,
                    content: "6CO₂ + 6H₂O + Licht → C₆H₁₂O₆ + 6O₂. Licht wird durch Chlorophyll absorbiert. Nur ~40% des Lichts wird tatsächlich für Photosynthese genutzt.", items: nil, highlighted: false),
                ModuleSection(title: "Fotosynthetisch aktives Licht (PAR)", type: .highlighted,
                    content: "PAR (Photosynthetically Active Radiation) = 400–700 nm. PPFD misst die Photonenflussdichte in µmol/m²/s.", items: nil, highlighted: true),
                ModuleSection(title: "PPFD-Zielwerte je Phase", type: .bulletList,
                    content: "", items: [
                        "Keimung: 0–50 µmol/m²/s",
                        "Sämling: 200–400 µmol/m²/s",
                        "Veg: 600–900 µmol/m²/s",
                        "Frühe Blüte: 800–1100 µmol/m²/s",
                        "Späte Blüte: 800–1200+ µmol/m²/s"
                    ], highlighted: false),
                ModuleSection(title: "Light Use Efficiency", type: .text,
                    content: "Ein idealer Grower nutzt 100% des Lichts. Realistisch: 20–40%. Reflektoren, Entfernung und canopy management sind entscheidend.", items: nil, highlighted: false),
                ModuleSection(title: "Daily Light Integral (DLI)", type: .formula,
                    content: "DLI = PPFD × Lichtstunden × 3.600 / 1.000.000 [mol/m²/d]", items: nil, highlighted: false)
            ],
            quiz: [
                QuizQuestion(question: "Was ist PAR?", options: ["Ein Beleuchtungsgerät", "Licht zwischen 400–700nm", "Ein Düngemittel", "Ein Messgerät"], correctIndex: 1, explanation: "PAR = Photosynthetically Active Radiation, also Licht im Bereich 400–700nm."),
                QuizQuestion(question: "理想的 PPFD für Vegetation?", options: ["200–400", "600–900", "1200+", "100–200"], correctIndex: 1, explanation: "In der Veg-Phase sind 600–900 µmol/m²/s ideal."),
                QuizQuestion(question: "DLI berechnen: 800 PPFD × 18h=?", options: ["14.4 mol/m²/d", "46.1 mol/m²/d", "28.8 mol/m²/d", "800 mol/m²/d"], correctIndex: 1, explanation: "800 × 18 × 3600 / 1.000.000 = 51.8, aber der Nahe-Wert ist ~46 mol/m²/d bei typischer Ausnutzung.")
            ]
        ),
        Module(
            id: "photosynthese",
            title: "Photosynthese-Tiefe: C3, CAM & Lichtreaktion",
            icon: "🔬",
            category: "Biologie",
            tags: ["Grundlagen", "Biologie"],
            description: "Die biochemischen Mechanismen hinter der Energiegewinnung.",
            difficulty: 2,
            readTime: "10 Min",
            sections: [
                ModuleSection(title: "Lichtreaktion", type: .text,
                    content: "In den Thylakoiden: PSII spaltet Wasser → O₂ + H⁺ + e⁻. PSI nutzt Lichtenergie um NADPH zu erzeugen. Zyklischer Elektronentransport erzeugt ATP.", items: nil, highlighted: false),
                ModuleSection(title: "Calvin-Zyklus (Dunkelreaktion)", type: .text,
                    content: "Im Stroma: CO₂ wird fixiert. 3 CO₂ + 9 ATP + 6 NADPH → G3P → Glucose. Rubisco ist das Schlüsselenzym.", items: nil, highlighted: false),
                ModuleSection(title: "Cannabis als C3-Pflanze", type: .highlighted,
                    content: "Cannabis ist eine C3-Pflanze — kein CAM, kein C4. CO₂-Anreicherung ab 800ppm bringt messbare Ertragssteigerung.", items: nil, highlighted: true),
                ModuleSection(title: "Lichtreaktion-Details", type: .bulletList,
                    content: "", items: [
                        "PSII: 680nm (rot) → Wasserspaltung",
                        "PSI: 700nm (fernrot) → NADPH-Erzeugung",
                        "Elektronentrang → ATP-Synthese",
                        "Zyklischer Transport → nur ATP (kein NADPH)"
                    ], highlighted: false)
            ],
            quiz: nil
        ),
        Module(
            id: "cannabinoide",
            title: "Cannabinoide: THC, CBD & das Endocannabinoid-System",
            icon: "🧬",
            category: "Wirkstoffe",
            tags: ["Cannabinoide", "Biologie"],
            description: "Die Chemie der psychoaktiven und medizinischen Wirkstoffe.",
            difficulty: 3,
            readTime: "12 Min",
            sections: [
                ModuleSection(title: "THC (Δ9-Tetrahydrocannabinol)", type: .text,
                    content: "THC wird in Trichomen gebildet. Vorläufer: CBGA → THCA (nicht-psychoaktiv) → durch Decarboxylierung (Hitze) → THC.", items: nil, highlighted: false),
                ModuleSection(title: "CBD (Cannabidiol)", type: .text,
                    content: "CBD ist nicht-psychoaktiv. Medizinisch relevant: entzündungshemmend, antiepileptisch. Genetik bestimmt CBD:THC Verhältnis.", items: nil, highlighted: false),
                ModuleSection(title: "Trichom-Typen", type: .bulletList,
                    content: "", items: [
                        "Basiszellen (Basal): Vorläufer",
                        "Stipeszellen (Stalk): Stängel",
                        "Kopfzellen (Head): THC-Produktion",
                        "Kapuzentrichome (Capitate): Häufigste Art"
                    ], highlighted: false),
                ModuleSection(title: "Terpene & Entourage-Effekt", type: .highlighted,
                    content: "Terpene verstärken/schwächen Wirkung von Cannabinoiden. Myrcen = sedierend, Limonen = stimulierend, Linalool = beruhigend.", items: nil, highlighted: true)
            ],
            quiz: [
                QuizQuestion(question: "Was ist THCA?", options: ["Psychoaktive Form", "Nicht-psychoaktiver Vorläufer", "Ein Terpen", "Ein Enzym"], correctIndex: 1, explanation: "THCA ist der nicht-psychoaktive Vorläufer von THC. Erst durch Hitze wird THC gebildet.")
            ]
        ),
        Module(
            id: "water",
            title: "Wasser, Transpiration & Wasserkapazität",
            icon: "💧",
            category: "Grundlagen",
            tags: ["Wasser", "Grundlagen"],
            description: "Wasser als Lösungsmittel und Transportmittel in der Pflanze.",
            difficulty: 1,
            readTime: "7 Min",
            sections: [
                ModuleSection(title: "Wassertransport", type: .text,
                    content: "Xylem transportiert Wasser von den Wurzeln nach oben. Treibende Kraft: Transpiration (Verdunstung an den Blättern).", items: nil, highlighted: false),
                ModuleSection(title: "Nass-Trocken-Zyklus", type: .highlighted,
                    content: "Wurzeln brauchen sowohl Wasser als auch Sauerstoff. Zu viel Feuchtigkeit → Root Rot. Zu wenig → Wasserk Stress.", items: nil, highlighted: true),
                ModuleSection(title: "Wasserbedarf je Phase", type: .bulletList,
                    content: "", items: [
                        "Keimung: Substrat feucht halten",
                        "Sämling: Kleine Mengen, häufig",
                        "Veg: Nass-Trocken-Zyklus, großer Topf",
                        "Blüte: Moderate Freq., längere Trockenphasen",
                        "Cure: 48h vor Ernte trocknen"
                    ], highlighted: false),
                ModuleSection(title: "Wasserqualität", type: .text,
                    content: "PPM/TDS: 0–50 (ideal), 50–150 (OK), 150–300 (vorfiltern), 300+ (Osmose/destilliert). EC messen vor dem Düngen.", items: nil, highlighted: false)
            ],
            quiz: nil
        ),
        Module(
            id: "npk",
            title: "N-P-K & Nährstoffverhältnisse",
            icon: "🧪",
            category: "Düngung",
            tags: ["Nährstoffe", "Düngung"],
            description: "Stickstoff, Phosphor, Kalium — die makronährstoffe.",
            difficulty: 2,
            readTime: "9 Min",
            sections: [
                ModuleSection(title: "N-P-K Grundlagen", type: .text,
                    content: "N (Stickstoff): Blattwachstum, Chlorophyll. P (Phosphor): Blütenbildung, Wurzeln. K (Kalium): Allgemeine Gesundheit, Stoffwechsel.", items: nil, highlighted: false),
                ModuleSection(title: "Cannabis N-P-K Verhältnis", type: .highlighted,
                    content: "Veg: 3-1-2 (N-P-K). Bloom: 1-2-3. Das ist der Schlüssel für gesunde Pflanzen.", items: nil, highlighted: true),
                ModuleSection(title: "Mikronährstoffe", type: .bulletList,
                    content: "", items: [
                        "Ca (Calcium): Zellwand, Enzyme",
                        "Mg (Magnesium): Chlorophyll-Zentrum",
                        "S (Schwefel): Aminosäuren, Enzyme",
                        "Fe (Eisen): Enzyme, Photosynthese",
                        "Mn (Mangan): PSII",
                        "Zn (Zink): Auxin"
                    ], highlighted: false),
                ModuleSection(title: "EC-Werte", type: .text,
                    content: "EC (Electrical Conductivity) = Gesamtsalzgehalt. Veg: 0.8–1.6 mS/cm. Bloom: 1.2–2.2 mS/cm. Coco braucht 20% mehr als Erde.", items: nil, highlighted: false)
            ],
            quiz: nil
        ),
        Module(
            id: "substrate",
            title: "Substrate: Erde, Coco, Hydro & Living Soil",
            icon: "🪴",
            category: "Substrate",
            tags: ["Substrate", "Wurzeln"],
            description: "Vergleich der Anbaumethoden und ihre Vor- und Nachteile.",
            difficulty: 2,
            readTime: "10 Min",
            sections: [
                ModuleSection(title: "Erde / Living Soil", type: .text,
                    content: "Mikrobenbasiertes Ökosystem. Nährstoffe werden langsam freigesetzt. pH-Pufferung natürlich. Anfängerfreundlich.", items: nil, highlighted: false),
                ModuleSection(title: "Coco Coir", type: .highlighted,
                    content: "Hydroponisch-ähnlich in erdähnlichem Substrat. Schnelles Wachstum. Keine natürliche Pufferung — pH/EC manuell steuern.", items: nil, highlighted: true),
                ModuleSection(title: "Hydro / DWC", type: .text,
                    content: "Direkte Nährstofflösung. Höchste Erträge, aber komplex. Keine Pufferung — Fehler sofort sichtbar.", items: nil, highlighted: false),
                ModuleSection(title: "Vergleich", type: .bulletList,
                    content: "", items: [
                        "Erde: Langsamer, fehlertolerant, günstig",
                        "Coco: Schnell, mittlere Komplexität",
                        "Hydro: Schnellste, höchste Erträge, komplex",
                        "Living Soil: Natürlicher, Aroma, kein Flush nötig"
                    ], highlighted: false)
            ],
            quiz: nil
        ),
        Module(
            id: "light",
            title: "Licht: LED, HPS, Spektrum & Lichtmanagement",
            icon: "💡",
            category: "Technik",
            tags: ["Licht", "Technik"],
            description: "Lichtquellen, Spektren und optimale Lichtausnutzung.",
            difficulty: 3,
            readTime: "11 Min",
            sections: [
                ModuleSection(title: "LED vs HPS", type: .highlighted,
                    content: "LED: Effizient, wenig Wärme, spektral einstellbar. HPS: Hochintensiv, viel Abwärme, bewährt. Für Cannabis ist LED Standard.", items: nil, highlighted: true),
                ModuleSection(title: "Spektrum je Phase", type: .bulletList,
                    content: "", items: [
                        "Veg: Mehr Blau (400–500nm), kompakteres Wachstum",
                        "Blüte: Mehr Rot (600–700nm), Blütenförderung",
                        "UV-B (280–315nm): Trichom-Produktion steigern",
                        "Fernrot (730nm): Emerson-Effekt, beschleunigte Blüte"
                    ], highlighted: false),
                ModuleSection(title: "Lichtausnutzung", type: .text,
                    content: "Entfernung:-too close = Light burn, too far = Stretching. Reflektoren, Scrog, LST verbessern Lichtausnutzung um 30–50%.", items: nil, highlighted: false),
                ModuleSection(title: "Photoperiode", type: .text,
                    content: "Veg: 18/6 oder 20/4. Bloom: 12/12. Autoflower: 18/6 bis 20/4 durchgängig.", items: nil, highlighted: false)
            ],
            quiz: nil
        ),
        Module(
            id: "climate",
            title: "Klima: Temperatur, Luftfeuchtigkeit & VPD",
            icon: "🌡️",
            category: "Klima",
            tags: ["Klima", "Umgebung"],
            description: "Temperatur- und Feuchtigkeitsmanagement für optimales Wachstum.",
            difficulty: 3,
            readTime: "10 Min",
            sections: [
                ModuleSection(title: "VPD (Vapor Pressure Deficit)", type: .highlighted,
                    content: "VPD = Dampfdruckdifferenz. Maß dafür, wie viel Wasser die Pflanze transpirieren kann/muss. Idealer Bereich: 0.8–1.2 kPa (Veg), 1.2–1.6 kPa (Bloom).", items: nil, highlighted: true),
                ModuleSection(title: "Temperatur-Zielwerte", type: .bulletList,
                    content: "", items: [
                        "Veg Tag: 24–28°C / Nacht: 18–22°C",
                        "Blüte Tag: 22–25°C / Nacht: 16–18°C",
                        "DIF (Tag-Nacht): Positiv für Wachstum",
                        "Für Terpene: kühle Nächte ab FW3"
                    ], highlighted: false),
                ModuleSection(title: "Luftfeuchtigkeit je Phase", type: .bulletList,
                    content: "", items: [
                        "Keimung: 70–80%",
                        "Sämling: 65–80%",
                        "Veg: 55–70%",
                        "Frühe Blüte: 50–65%",
                        "Späte Blüte: 40–55% (Schimmelprävention)",
                        "Harvest/Cure: 55–62%"
                    ], highlighted: false),
                ModuleSection(title: "Schimmelprävention", type: .text,
                    content: "Schimmel braucht: LF >60%, stillstehende Luft, organische Materie. Lüftung, Luftzirkulation und richtige LF sind der beste Schutz.", items: nil, highlighted: false)
            ],
            quiz: nil
        ),
        Module(
            id: "stress",
            title: "Stress & Pflanzenreaktionen",
            icon: "⚠️",
            category: "Biologie",
            tags: ["Stress", "Biologie"],
            description: "Stressoren erkennen, verstehen und gezielt einsetzen.",
            difficulty: 3,
            readTime: "8 Min",
            sections: [
                ModuleSection(title: "Stress-Arten", type: .bulletList,
                    content: "", items: [
                        "Umweltstress: Hitze, Kälte, Wind, Licht",
                        "Wasserstress: Über- oder Untergießen",
                        "Nährstoffstress: Mangel oder Toxizität",
                        "Peststress: Schädlinge, Pilze",
                        "Biotech-Stress: UV, CO₂-Mangel"
                    ], highlighted: false),
                ModuleSection(title: "Gezielter Stress (Goal B)", type: .highlighted,
                    content: "Kontrollierter Trockenstress erhöht Terpen- und Cannabinoidgehalt. Nicht aber im Keimling/Sämling!", items: nil, highlighted: true),
                ModuleSection(title: "Stress-Symptome", type: .bulletList,
                    content: "", items: [
                        "Gelbe Blätter: N-Mangel, pH-Problem, Überwässerung",
                        "Braune Spitzen: N-Burn, zu hoher EC",
                        "Welke: Überwässerung oder Wasserkstress",
                        "Purpurne Blätter: Kälte, P-Mangel oder Genetik",
                        "Hängende Blätter: Überwässerung, Root Rot"
                    ], highlighted: false)
            ],
            quiz: nil
        ),
        Module(
            id: "training",
            title: "Training-Techniken: LST, SCROG & HST",
            icon: "✂️",
            category: "Technik",
            tags: ["Training", "Technik"],
            description: "Methoden zur Steuerung des Wachstums für maximale Lichtausnutzung.",
            difficulty: 3,
            readTime: "11 Min",
            sections: [
                ModuleSection(title: "Low Stress Training (LST)", type: .highlighted,
                    content: "Äste sanft umbinden/haken, um gleichmäßige Canopy zu schaffen. Pflanzen werden nicht verletzt. Perfekt für Anfänger.", items: nil, highlighted: true),
                ModuleSection(title: "SCROG (Screen of Green)", type: .text,
                    content: "Netz über Pflanze spannen. Äste hindurchziehen. Maximale Lichtausnutzung, besonders für begrenzte Höhe.", items: nil, highlighted: false),
                ModuleSection(title: "High Stress Training (HST)", type: .text,
                    content: "Topping, FIMing, Lollipopping. Pflanze wird physisch verändert. Nur für erfahrene Grower geeignet.", items: nil, highlighted: false),
                ModuleSection(title: "Timing", type: .bulletList,
                    content: "", items: [
                        "LST: Ab 4. Blattpaar bis Ende Veg",
                        "Topping: Ab 5. Blattpaar, 2–3 Wochen vor Blüte",
                        "SCROG: Netz in Veg aufspannen, in FW1–2 Äste durchziehen",
                        "Lollipopping: FW2 (nach Stretch)"
                    ], highlighted: false)
            ],
            quiz: nil
        ),
        Module(
            id: "harvest",
            title: "Ernte: Zeitpunkt, Trocknung & Curing",
            icon: "✂️",
            category: "Ernte",
            tags: ["Ernte", "Curing"],
            description: "Optimaler Erntezeitpunkt und korrekte Nachbereitung.",
            difficulty: 2,
            readTime: "10 Min",
            sections: [
                ModuleSection(title: "Erntezeitpunkt bestimmen", type: .highlighted,
                    content: "Trichome unter Mikroskop/Lupe: Klar = zu früh. Milchig = Peak-THC. Bernstein = CBN (sedierend). Ziel: 10–30% Bernstein je nach Goal.", items: nil, highlighted: true),
                ModuleSection(title: "Trocknung", type: .text,
                    content: "Ganze Pflanze oder große Äste kopfüber aufhängen. 15–20°C, 55–62% LF, Dunkelheit. Dauer: 7–14 Tage. Stängel sollte knacken, nicht brechen.", items: nil, highlighted: false),
                ModuleSection(title: "Curing", type: .text,
                    content: "Getrocknete Blüten in Glas-Jars bei 58–62% LF. Täglich Burpen (erste 2 Wochen). Mindestens 2 Wochen, ideal 4–8 Wochen.", items: nil, highlighted: false),
                ModuleSection(title: "Flush", type: .bulletList,
                    content: "", items: [
                        "Erde: 1–2 Wochen mit klarem Wasser",
                        "Coco: 3–5 Tage mit klarem Wasser",
                        "Hydro: 3–5 Tage mit klarem Wasser",
                        "Living Soil: Kein Flush nötig"
                    ], highlighted: false)
            ],
            quiz: nil
        ),
        Module(
            id: "curing",
            title: "Curing: Chemie des Aushärtens",
            icon: "🫙",
            category: "Ernte",
            tags: ["Curing", "Chemie"],
            description: "Warum Curing so wichtig ist und was chemisch passiert.",
            difficulty: 3,
            readTime: "9 Min",
            sections: [
                ModuleSection(title: "Was passiert beim Curing?", type: .text,
                    content: "Chlorophyll-Abbau (weniger 'Heu'-Geschmack). Stärke wird in Zucker umgewandelt. Terpene entwickeln sich weiter. pH stabilisiert sich.", items: nil, highlighted: false),
                ModuleSection(title: "Jar Burping", type: .highlighted,
                    content: "Gläser öffnen für 5–10 Minuten, um CO₂ abzulassen und frische Luft einzulassen. In FW1 täglich, dann alle 2–3 Tage.", items: nil, highlighted: true),
                ModuleSection(title: "Curing-Zeitplan", type: .bulletList,
                    content: "", items: [
                        "Woche 1: Täglich Burpen, 5 Min",
                        "Woche 2: Alle 2 Tage, 5 Min",
                        "Woche 3–4: Alle 3 Tage, 3 Min",
                        "Woche 5+: Alle 5–7 Tage, kurz",
                        "Nach 8 Wochen: Stabil, nicht mehr nötig"
                    ], highlighted: false),
                ModuleSection(title: "Probleme", type: .text,
                    content: "Schimmel: Sofort Entsorgen. Muffiger Geruch: Mehr Burpen. Zu trocken: Boveda/Integra Pack 62% hinzufügen.", items: nil, highlighted: false)
            ],
            quiz: nil
        )
    ]

    static func getModule(id: String) -> Module? {
        modules.first { $0.id == id }
    }
}
