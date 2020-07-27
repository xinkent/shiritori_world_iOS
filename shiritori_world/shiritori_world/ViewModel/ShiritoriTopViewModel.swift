import SwiftUI
import Firebase

class ShiritoriTopViewModel: ObservableObject {
    @Published var isValid: Bool = true
    @Published var isHidden: Bool = false
    @Published var word: String = ""
    @Published var shiritori: Shiritori?
//    @EnvironmentObject var sf: ShiritoriFetcher
    
    
    let db = Firestore.firestore()
    func send_answer(sf: ShiritoriFetcher){
        
        var shiritoriList:[ShiritoriWord] = sf.shiritori.shiritoriWords ?? []
        shiritoriList.append(
            ShiritoriWord(id:shiritoriList.count + 1, userID:sf.user.userID!, word:self.word, lat:100, long:100)
        )
        db.collection("shiritori_test").document(sf.user.currentShiritoriID!).setData(
            ["month":"202006",
             "shiritori_id":sf.user.currentShiritoriID!,
            "shiritori_word": shiritoriList.map{$0.toFirestoreMap()}]
            ,merge:false
        )
    }
}
