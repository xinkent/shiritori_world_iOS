import SwiftUI

class ShiritoriTopViewModel: ObservableObject {
    @Published var isTurn: Bool = false
    @Published var isValid: Bool = true
    @Published var isHidden: Bool = false
    @Published var word: String = ""
    @Published var shiritori: Shiritori?
    
}
