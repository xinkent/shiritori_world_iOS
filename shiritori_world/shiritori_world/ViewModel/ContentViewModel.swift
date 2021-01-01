import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var accepted: Bool = false
    
    func acceptPolicy(){
        self.accepted = true
        UserDefaults.standard.set(true, forKey: "visit")
    }
}

