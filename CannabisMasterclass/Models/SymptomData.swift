import Foundation

// MARK: - Symptom Library Entry

struct SymptomEntry: Identifiable {
    let id: String
    let name: String
    let icon: String
    let category: String
    let causes: [String]
    let fixes: [String]
    let severity: String // "low", "medium", "high"
    let affectedAreas: [String]
    let relatedSymptoms: [String]
}

// MARK: - Symptom Data

enum SymptomData {
    static let symptoms: [SymptomEntry] = [
        SymptomEntry(
            id: "yellow_leaves",
            name: "Gelbe Blätter",
            icon: "🟡",
            category: "Nährstoff",
            causes: ["Stickstoffmangel", "Überwässerung", "pH-Ungleichgewicht", "Wurzelfäule"],
            fixes: ["N-Dünger erhöhen (Veg: 3-1-2)", "pH auf 6.0–7.0 prüfen", "Gießfrequenz reduzieren", "Wurzelzustand prüfen"],
            severity: "medium",
            affectedAreas: ["Untere Blätter", "Ältere Blätter"],
            relatedSymptoms: ["brown_spots", "wilting"]
        ),
        SymptomEntry(
            id: "brown_spots",
            name: "Braune Flecken",
            icon: "🟤",
            category: "Nährstoff",
            causes: ["Magnesiummangel", "Kalziummangel", "pH-Ungleichgewicht", "Lichtverbrennung"],
            fixes: ["Epsom-Salz (1g/L) für Mg", "CalMag-Dünger", "pH auf 6.2–6.5 prüfen", "Lichtabstand erhöhen"],
            severity: "medium",
            affectedAreas: ["Mittlere Blätter", "Blattmitte"],
            relatedSymptoms: ["yellow_leaves", "leaf_curl"]
        ),
        SymptomEntry(
            id: "wilting",
            name: "Welken / Hängende Blätter",
            icon: "🥀",
            category: "Wasser",
            causes: ["Überwässerung", "Wasserkstress", "Root Rot", "Hitzestress"],
            fixes: ["Gießfrequenz anpassen", "Topfgewicht prüfen", "Wurzeln inspizieren", "Temperatur senken"],
            severity: "high",
            affectedAreas: ["Ganze Pflanze", "Blattspitzen"],
            relatedSymptoms: ["yellow_leaves", "drooping"]
        ),
        SymptomEntry(
            id: "leaf_curl",
            name: "Blattwölbung / Kräuselung",
            icon: "🍃",
            category: "Umwelt",
            causes: ["Hitzestress", "Windstress", "VPD zu hoch", "Thripse/Spinnmilben"],
            fixes: ["Temperatur/Lüftung anpassen", "Luftfeuchtigkeit erhöhen", "Schädlinge prüfen", "Ventilator-Position"],
            severity: "medium",
            affectedAreas: ["Blattspitzen", "Neues Wachstum"],
            relatedSymptoms: ["brown_spots", "pest_damage"]
        ),
        SymptomEntry(
            id: "pest_damage",
            name: "Schädlingsbefall",
            icon: "🐛",
            category: "Schädling",
            causes: ["Spinnmilben", "Thripse", "Weiße Fliege", "Trauermücken"],
            fixes: ["Neemöl (nicht in Blüte!)", "Raubmilben aussetzen", "Sticky Traps", "Isolieren"],
            severity: "high",
            affectedAreas: ["Blattunterseite", "Neues Wachstum"],
            relatedSymptoms: ["leaf_curl", "yellow_leaves"]
        ),
        SymptomEntry(
            id: "white_mold",
            name: "Weißer Schimmel / Mehltau",
            icon: "⚪",
            category: "Pilz",
            causes: ["Zu hohe Luftfeuchtigkeit", "Schlechte Zirkulation", "Dichte Bepflanzung", "Stehendes Wasser"],
            fixes: ["LF auf 40–50% senken", "Besser lüften", "Befallene Stellen entfernen", "Schwefel-Vaporisator"],
            severity: "high",
            affectedAreas: ["Blattoberseite", "Blüten"],
            relatedSymptoms: ["bud_rot", "powdery_mold"]
        ),
        SymptomEntry(
            id: "bud_rot",
            name: "Bud Rot (Botrytis)",
            icon: "🌫️",
            category: "Pilz",
            causes: ["LF >60% in Blüte", "Schlechte Luftzirkulation", "Dichte Buds", "Kondenswasser"],
            fixes: ["Befallene Buds sofort entfernen", "LF auf 40–50% senken", "Ventilatoren auf Buds richten", "Vorbeugend: Buds ausdünnen"],
            severity: "high",
            affectedAreas: ["Innere der Blüten", "Große Buds"],
            relatedSymptoms: ["white_mold", "brown_spots"]
        ),
        SymptomEntry(
            id: "nutrient_burn",
            name: "N-Burn (Nährstoffverbrennung)",
            icon: "🔥",
            category: "Nährstoff",
            causes: ["EC zu hoch", "Dünger überdosiert", "Pufferung in Coco fehlt", "Zu häufig gießen"],
            fixes: ["EC reduzieren", "Mit klarem Wasser spülen (Flush)", "pH prüfen", "Neues Wachstum beobachten"],
            severity: "medium",
            affectedAreas: ["Blattspitzen", "Blattkanten"],
            relatedSymptoms: ["brown_spots", "yellow_leaves"]
        ),
        SymptomEntry(
            id: "light_burn",
            name: "Lichtverbrennung",
            icon: "☀️",
            category: "Umwelt",
            causes: ["Licht zu nah", "PPFD zu hoch", "Hitzestress durch Lampen", "Keine Anpassungsphase"],
            fixes: ["Lichtabstand erhöhen", "PPFD reduzieren", "Pflanze langsam an höheres Licht gewöhnen"],
            severity: "medium",
            affectedAreas: ["Oberste Blätter", "Direkt unter Licht"],
            relatedSymptoms: ["leaf_curl", "nutrient_burn"]
        ),
        SymptomEntry(
            id: "purple_leaves",
            name: "Purpurne/Lila Verfärbung",
            icon: "🟣",
            category: "Genetik",
            causes: ["Genetik (Anthocyane)", "Kälte (<18°C Nacht)", "P-Mangel", "pH-Ungleichgewicht"],
            fixes: ["Genetik: normal, kein Handeln nötig", "Nachttemperatur prüfen", "P-Dünger prüfen", "pH auf 6.0–6.5"],
            severity: "low",
            affectedAreas: ["Untere Blätter", "Blattkanten"],
            relatedSymptoms: ["yellow_leaves"]
        ),
        SymptomEntry(
            id: "stunted_growth",
            name: "Gehemmtes Wachstum",
            icon: "📏",
            category: "Wachstum",
            causes: ["Wurzelprobleme", "pH-Ungleichgewicht", "Zu wenig Licht", "Kälte"],
            fixes: ["Wurzeln prüfen", "pH auf 6.0–7.0 (Substrat-abhängig)", "PPFD erhöhen", "Temperatur prüfen"],
            severity: "medium",
            affectedAreas: ["Ganze Pflanze", "Neues Wachstum"],
            relatedSymptoms: ["wilting", "yellow_leaves"]
        ),
        SymptomEntry(
            id: "foxtailing",
            name: "Foxtailing",
            icon: "🦊",
            category: "Wachstum",
            causes: ["Genetik", "Hitzestress", "UV-Stress", "Zu spät in Blüte"],
            fixes: ["Genetik: normal", "Temperatur senken", "UV-Exposition reduzieren"],
            severity: "low",
            affectedAreas: ["Blütenoberseite"],
            relatedSymptoms: ["nutrient_burn"]
        ),
        SymptomEntry(
            id: "calyxes_opening",
            name: "Offene Calyxen (zu früh)",
            icon: "🌸",
            category: "Ernte",
            causes: ["Zu früher Erntezeitpunkt", "Genetik", "Stress"],
            fixes: ["Trichome mit Lupe/Mikroskop prüfen", "Nicht nach Calyxen richten"],
            severity: "low",
            affectedAreas: ["Blüten"],
            relatedSymptoms: ["foxtailing"]
        ),
        SymptomEntry(
            id: "herming",
            name: "Hermaphroditismus",
            icon: "⚧️",
            category: "Genetik",
            causes: ["Lichtleck (Photoperiode)", "Stress", "Hitze", "Genetik"],
            fixes: ["Männliche Blüten sofort entfernen", "Lichtleck prüfen", "Stress reduzieren", "Genetik wechseln"],
            severity: "high",
            affectedAreas: ["Blüten", "Noden"],
            relatedSymptoms: ["calyxes_opening"]
        ),
        SymptomEntry(
            id: "slow_germination",
            name: "Langsame Keimung",
            icon: "🐌",
            category: "Keimung",
            causes: ["Zu kalt", "Zu trocken", "Samen zu tief", "Alte Samen"],
            fixes: ["Temperatur 22–26°C", "Substrat feucht halten", "Paper-Towel-Methode testen", "Stratifizieren"],
            severity: "low",
            affectedAreas: ["Samen"],
            relatedSymptoms: ["stunted_growth"]
        ),
        SymptomEntry(
            id: "stretching",
            name: "Strecken (Etiolierung)",
            icon: "📏",
            category: "Licht",
            causes: ["Zu wenig Licht", "Zu weit entfernte Lampe", "Zu wenig Stunden (Auto)"],
            fixes: ["PPFD erhöhen", "Lichtabstand verringern", "Für Autos: 18–20h Licht"],
            severity: "medium",
            affectedAreas: ["Stängel", "Internodien"],
            relatedSymptoms: ["stunted_growth"]
        )
    ]

    static func getSymptom(id: String) -> SymptomEntry? {
        symptoms.first { $0.id == id }
    }

    static func search(query: String) -> [SymptomEntry] {
        let q = query.lowercased()
        return symptoms.filter {
            $0.name.lowercased().contains(q) ||
            $0.category.lowercased().contains(q) ||
            $0.causes.contains { $0.lowercased().contains(q) }
        }
    }
}
