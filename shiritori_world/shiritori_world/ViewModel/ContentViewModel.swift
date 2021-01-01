import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var accepted: Bool = false
    
    func accept_policy(){
        self.accepted = true
        UserDefaults.standard.set(true, forKey: "visit")
    }
}

