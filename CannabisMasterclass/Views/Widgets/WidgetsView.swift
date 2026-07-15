import SwiftUI

struct WidgetsView: View {
    @EnvironmentObject var state: AppState
    @State private var selectedCalculator: String? = nil

    var body: some View {
        NavigationView {
            ZStack {
                Color.nuiBg.ignoresSafeArea()

                if let calcId = selectedCalculator, let calc = CalculatorData.getCalculator(id: calcId) {
                    CalculatorDetailView(calculator: calc, selectedCalculator: $selectedCalculator)
                } else {
                    calculatorList
                }
            }
            .navigationTitle("Rechner")
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(.dark)
        }
    }

    private var calculatorList: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(CalculatorData.calculators) { calc in
                    Button(action: {
                        Haptics.light()
                        selectedCalculator = calc.id
                    }) {
                        NuiCard {
                            HStack(spacing: 14) {
                                Text(calc.icon)
                                    .font(.system(size: 32))
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(calc.title)
                                        .font(.system(size: DesignSystem.textLg, weight: .semibold))
                                        .foregroundColor(.white)
                                    Text(calc.description)
                                        .font(.system(size: DesignSystem.textSm))
                                        .foregroundColor(.nuiSecondaryText)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.nuiSecondaryText)
                            }
                            .padding(14)
                        }
                    }
                }
            }
            .padding(16)
        }
    }
}

// MARK: - Calculator Detail

struct CalculatorDetailView: View {
    let calculator: Calculator
    @Binding var selectedCalculator: String?
    @EnvironmentObject var state: AppState
    @State private var values: [String: Double] = [:]
    @State private var result: String = ""

    var body: some View {
        ZStack {
            Color.nuiBg.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    // Back button
                    HStack {
                        Button(action: { selectedCalculator = nil }) {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                Text("Zurück")
                            }
                            .foregroundColor(Color.brandGreen)
                        }
                        Spacer()
                    }

                    // Header
                    VStack(spacing: 8) {
                        Text(calculator.icon)
                            .font(.system(size: 48))
                        Text(calculator.title)
                            .font(.system(size: DesignSystem.textXl, weight: .bold))
                            .foregroundColor(.white)
                        Text(calculator.description)
                            .font(.system(size: DesignSystem.textMd))
                            .foregroundColor(.nuiSecondaryText)
                    }

                    // Formula
                    NuiCard {
                        VStack(spacing: 6) {
                            Text("Formel")
                                .font(.system(size: DesignSystem.textSm, weight: .medium))
                                .foregroundColor(.nuiSecondaryText)
                            Text(calculator.formula)
                                .font(.system(size: DesignSystem.textSm, design: .monospaced))
                                .foregroundColor(Color.brandGreen)
                        }
                        .padding(12)
                    }

                    // Inputs
                    ForEach(calculator.inputs) { input in
                        inputView(input)
                    }

                    // Result
                    if !result.isEmpty {
                        NuiCard {
                            VStack(spacing: 8) {
                                Text("Ergebnis")
                                    .font(.system(size: DesignSystem.textSm, weight: .medium))
                                    .foregroundColor(.nuiSecondaryText)
                                Text(result)
                                    .font(.system(size: DesignSystem.textLg, weight: .bold))
                                    .foregroundColor(Color.brandGreen)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(16)
                        }
                    }

                    // Calculate button
                    NuiButton(title: "Berechnen", icon: "🔢") {
                        Haptics.success()
                        calculate()
                    }
                }
                .padding(16)
            }
        }
        .onAppear {
            // Load saved values
            for input in calculator.inputs {
                if let saved = state.getWidgetValue(widgetId: calculator.id, key: input.id) {
                    values[input.id] = saved
                } else if let def = input.defaultValue {
                    values[input.id] = def
                }
            }
        }
    }

    @ViewBuilder
    private func inputView(_ input: CalcInput) -> some View {
        switch input.type {
        case .slider:
            NuiCard {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(input.label)
                            .font(.system(size: DesignSystem.textSm, weight: .medium))
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(values[input.id, default: input.defaultValue ?? 0], specifier: "%.1f") \(input.unit ?? "")")
                            .font(.system(size: DesignSystem.textSm, weight: .bold))
                            .foregroundColor(Color.brandGreen)
                    }
                    Slider(
                        value: Binding(
                            get: { values[input.id] ?? input.defaultValue ?? 0 },
                            set: { values[input.id] = $0; state.saveWidgetValue(widgetId: calculator.id, key: input.id, value: $0) }
                        ),
                        in: (input.min ?? 0)...(input.max ?? 100),
                        step: input.step ?? 1
                    )
                    .accentColor(Color.brandGreen)

                    HStack {
                        Text("\(input.min ?? 0, specifier: "%.0f")")
                            .font(.system(size: 10))
                            .foregroundColor(.nuiSecondaryText)
                        Spacer()
                        Text("\(input.max ?? 100, specifier: "%.0f")")
                            .font(.system(size: 10))
                            .foregroundColor(.nuiSecondaryText)
                    }
                }
                .padding(14)
            }

        case .option:
            NuiCard {
                VStack(alignment: .leading, spacing: 8) {
                    Text(input.label)
                        .font(.system(size: DesignSystem.textSm, weight: .medium))
                        .foregroundColor(.white)
                    HStack(spacing: 6) {
                        ForEach(input.options ?? [], id: \.self) { option in
                            Button(action: {
                                Haptics.selection()
                                let index = Double((input.options ?? []).firstIndex(of: option) ?? 0)
                                values[input.id] = index
                                state.saveWidgetValue(widgetId: calculator.id, key: input.id, value: index)
                            }) {
                                Text(option)
                                    .font(.system(size: DesignSystem.textXs, weight: .medium))
                                    .foregroundColor(values[input.id] == Double((input.options ?? []).firstIndex(of: option) ?? 0) ? .white : .nuiSecondaryText)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(values[input.id] == Double((input.options ?? []).firstIndex(of: option) ?? 0) ? Color.brandGreen : Color.nuiCardElevated)
                                    .cornerRadius(DesignSystem.radiusSm)
                            }
                        }
                    }
                }
                .padding(14)
            }

        default:
            EmptyView()
        }
    }

    private func calculate() {
        switch calculator.id {
        case "dli":
            let ppfd = values["ppfd"] ?? 600
            let hours = values["hours"] ?? 18
            let eff = values["efficiency"] ?? 60
            let dli = CalculatorLogic.calculateDLI(ppfd: ppfd, hours: hours, efficiency: eff)
            result = String(format: "%.1f mol/m²/d\n%s", dli, CalculatorLogic.dliRecommendation(dli))

        case "vpd":
            let temp = values["temp"] ?? 25
            let rh = values["rh"] ?? 60
            let vpd = CalculatorLogic.calculateVPD(temp: temp, rh: rh)
            result = String(format: "%.2f kPa\n%s", vpd, CalculatorLogic.vpdRecommendation(vpd, phase: ""))

        case "yield":
            let plants = Int(values["plants"] ?? 1)
            let type = calculator.inputs[1].options?[Int(values["type"] ?? 0)] ?? "Indoor"
            let exp = calculator.inputs[2].options?[Int(values["experience"] ?? 1)] ?? "Fortgeschritten"
            let goal = calculator.inputs[3].options?[Int(values["goal"] ?? 2)] ?? "C: Balance"
            result = CalculatorLogic.estimateYield(plants: plants, type: type, experience: exp, goal: goal)

        case "nutrients":
            let phase = calculator.inputs[0].options?[Int(values["phase"] ?? 1)] ?? "Veg"
            let substrate = calculator.inputs[1].options?[Int(values["substrate"] ?? 0)] ?? "Erde"
            result = CalculatorLogic.calculateNutrientsEC(phase: phase, substrate: substrate)

        case "potsize":
            let goal = calculator.inputs[0].options?[Int(values["goal"] ?? 2)] ?? "C: Balance"
            let exp = calculator.inputs[1].options?[Int(values["experience"] ?? 1)] ?? "Fortgeschritten"
            let type = calculator.inputs[2].options?[Int(values["type"] ?? 0)] ?? "Indoor"
            result = CalculatorLogic.recommendPotSize(goal: goal, experience: exp, type: type)

        case "co2":
            let co2 = values["co2_ppm"] ?? 400
            let ppfd = values["ppfd"] ?? 600
            result = CalculatorLogic.calculateCO2Yield(co2ppm: co2, ppfd: ppfd)

        case "cost":
            let months = values["months"] ?? 4
            let watts = values["watts"] ?? 200
            let price = values["price_kwh"] ?? 0.30
            let yld = values["yield_g"] ?? 100
            result = CalculatorLogic.calculateCost(months: months, watts: watts, priceKwh: price, yieldGrams: yld)

        default:
            result = "Berechnung nicht verfügbar"
        }
    }
}
