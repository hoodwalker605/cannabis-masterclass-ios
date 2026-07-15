import Foundation

enum Persistence {
    static let stateKey = "cannamc_state_v1"
    static let wizardProgressKey = "cannamc_wizard_progress"
    static let moduleProgressKey = "cannamc_module_progress"
    static let widgetValuesKey = "cannamc_widget_values"
    static let communityKey = "cannamc_community_v1"

    static func save<T: Codable>(_ value: T, forKey key: String) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    static func load<T: Codable>(forKey key: String, as type: T.Type) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key),
              let value = try? JSONDecoder().decode(type, from: data) else { return nil }
        return value
    }

    static func remove(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
