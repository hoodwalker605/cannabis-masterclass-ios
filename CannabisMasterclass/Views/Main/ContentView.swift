import SwiftUI

struct ContentView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        Group {
            if !state.wizardComplete {
                WizardView()
            } else {
                MainTabView()
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            if !state.wizardComplete {
                state.showWizard = true
            }
        }
    }
}
