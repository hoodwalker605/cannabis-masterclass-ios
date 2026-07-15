import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        TabView(selection: $state.selectedTab) {
            GuideView()
                .tabItem {
                    Image(systemName: "leaf.fill")
                    Text("Guide")
                }
                .tag(0)

            ModulesView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Lernen")
                }
                .tag(1)

            WidgetsView()
                .tabItem {
                    Image(systemName: "calculator.fill")
                    Text("Rechner")
                }
                .tag(2)

            DiagnosisView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Diagnose")
                }
                .tag(3)

            CommunityView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Community")
                }
                .tag(4)

            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profil")
                }
                .tag(5)
        }
        .accentColor(Color.brandGreen)
    }
}
