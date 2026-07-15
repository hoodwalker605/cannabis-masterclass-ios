import Foundation

// MARK: - Calculator Logic

enum CalculatorLogic {
    // DLI = PPFD * hours * 3600 / 1_000_000
    static func calculateDLI(ppfd: Double, hours: Double, efficiency: Double = 60) -> Double {
        let raw = ppfd * hours * 3600.0 / 1_000_000.0
        return raw * (efficiency / 100.0)
    }

    static func dliRecommendation(_ dli: Double) -> String {
        switch dli {
        case ..<15: return "Zu wenig — Pflanze streckt sich, schwaches Wachstum"
        case 15..<25: return "Optimal für Sämling/Veg"
        case 25..<40: return "Optimal für Veg/Frühe Blüte"
        case 40..<60: return "Optimal für Späte Blüte"
        default: return "Sehr hoch — prüfe ob PPFD zu hoch ist"
        }
    }

    // VPD = saturation vapor pressure * (1 - RH/100)
    // Tetens formula: es = 0.6108 * exp(17.27 * T / (T + 237.3))
    static func calculateVPD(temp: Double, rh: Double) -> Double {
        let es = 0.6108 * exp(17.27 * temp / (temp + 237.3))
        return es * (1.0 - rh / 100.0)
    }

    static func vpdRecommendation(_ vpd: Double, phase: String) -> String {
        switch vpd {
        case ..<0.4: return "Zu niedrig — Risiko für Mehltau"
        case 0.4..<0.8: return "Gut für Keimling/Sämling"
        case 0.8..<1.2: return "Optimal für Vegetation"
        case 1.2..<1.6: return "Optimal für Blüte"
        case 1.6..<2.0: return "Leicht hoch — kann Ertrag steigern"
        default: return "Zu hoch — Wasserkstress möglich"
        }
    }

    static func estimateYield(plants: Int, type: String, experience: String, goal: String) -> String {
        var base: Double
        switch type {
        case "Indoor": base = 150
        case "Outdoor": base = 300
        case "Greenhouse": base = 250
        default: base = 150
        }

        switch experience {
        case "Anfänger": base *= 0.5
        case "Fortgeschritten": base *= 0.8
        case "Experte": base *= 1.0
        default: base *= 0.7
        }

        switch goal {
        case "A: Ertrag": base *= 1.2
        case "B: Harz": base *= 0.7
        case "C: Balance": base *= 1.0
        default: base *= 1.0
        }

        let total = Int(base) * plants
        let dry = Int(Double(total) * 0.25)
        return "\(total)g (feucht) → ~\(dry)g (trocken)"
    }

    static func calculateNutrientsEC(phase: String, substrate: String) -> String {
        var baseEC: Double
        switch phase {
        case "Sämling": baseEC = 0.3
        case "Veg": baseEC = 1.2
        case "Frühe Blüte": baseEC = 1.5
        case "Späte Blüte": baseEC = 1.8
        default: baseEC = 1.0
        }

        switch substrate {
        case "Coco": baseEC *= 1.2
        case "Hydro": baseEC *= 1.3
        default: break
        }

        return String(format: "%.1f mS/cm", baseEC)
    }

    static func recommendPotSize(goal: String, experience: String, type: String) -> String {
        var base: Double
        switch type {
        case "Indoor": base = 11
        case "Outdoor": base = 25
        default: base = 15
        }

        switch goal {
        case "A: Ertrag": base = max(base, 15)
        case "B: Harz": base = min(base, 7)
        default: break
        }

        switch experience {
        case "Anfänger": base = max(base, 11)
        default: break
        }

        return "\(Int(base)) Liter"
    }

    static func calculateCO2Yield(co2ppm: Double, ppfd: Double) -> String {
        let baselineYield = calculateDLI(ppfd: ppfd, hours: 18, efficiency: 60)
        let co2Boost: Double
        if co2ppm <= 400 {
            co2Boost = 0
        } else if co2ppm <= 800 {
            co2Boost = (co2ppm - 400) / 400 * 15
        } else if co2ppm <= 1200 {
            co2Boost = 15 + (co2ppm - 800) / 400 * 10
        } else {
            co2Boost = 25 + (co2ppm - 1200) / 800 * 5
        }

        let effectiveDLI = baselineYield * (1 + co2Boost / 100)
        return String(format: "Effektiver DLI: %.1f mol/m²/d (+%.0f%% durch CO₂)", effectiveDLI, co2Boost)
    }

    static func calculateCost(months: Double, watts: Double, priceKwh: Double, yieldGrams: Double) -> String {
        let kwh = watts / 1000 * 18 * 30 * months // 18h light
        let electricityCost = kwh * priceKwh
        let nutrientCost = Double(months) * 20
        let substrateCost = 15.0
        let total = electricityCost + nutrientCost + substrateCost

        let costPerGram = yieldGrams > 0 ? total / yieldGrams : 0
        return String(format: "Strom: %.2f€ + Dünger: %.0f€ + Substrat: %.0f€\nGesamt: %.2f€\nPro Gramm: %.2f€/g", electricityCost, nutrientCost, substrateCost, total, costPerGram)
    }
}
