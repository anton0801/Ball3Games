import Foundation

class RecordsViewModel: ObservableObject {
    
    @Published var game1Record: Int = UserDefaults.standard.integer(forKey: "game_1_record") {
        didSet {
            UserDefaults.standard.set(game1Record, forKey: "game_1_record")
        }
    }
    
    @Published var game2Record: Int = UserDefaults.standard.integer(forKey: "game_2_record") {
        didSet {
            UserDefaults.standard.set(game2Record, forKey: "game_2_record")
        }
    }
    
}
