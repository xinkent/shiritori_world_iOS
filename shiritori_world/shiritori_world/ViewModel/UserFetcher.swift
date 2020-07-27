
import Firebase
import SwiftUI
import MapKit

class UserFetcher: ObservableObject{
    @Published var user = User()
    let db = Firestore.firestore()
    
    func fetchUser(){
        // userドキュメントにリスナーを設置し、userを更新する
        let uid = Auth.auth().currentUser!.uid
        
        db.collection("user").document(uid)
            .addSnapshotListener{ documentSnapshot, error in
            // 読み込みエラーもしくは、ドキュメントが存在しない場合処理を中断
            guard let document = documentSnapshot else {
              print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            print("Current data: \(data)") // debug
                
            let userID = data["userID"] as? String
            let currentShiritoriID = data["currentShiritoriID"] as? String
            let currentShiritoriName = data["currentShiritoriName"] as? String
            
            self.user = User(userID: userID, currentShiritoriID: currentShiritoriID, currentShiritoriName: currentShiritoriName )
        }
    }
}

//struct ShiritoriFetcher_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environmentObject(ShiritoriFetcher())
//    }
//}
