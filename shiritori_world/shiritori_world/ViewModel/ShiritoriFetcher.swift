import Firebase
import SwiftUI

class ShiritoriFetcher: ObservableObject{
  @Published var shiritoriWords:[ShiritoriWord] = [] // UserIDに対応するshiritoriを取得する
  let db = Firestore.firestore()
  // TODO：取得DocumentIDの指定方法検討
  func fetchShiritori(documentID:String){
    db.collection("shiritori_test").document(documentID)
    .addSnapshotListener { documentSnapshot, error in
        self.shiritoriWords = []
         guard let document = documentSnapshot else {
          print("Error fetching document: \(error!)")
          return
         }
         guard let data = document.data() else {
          print("Document data was empty.")
          return
         }
        print("Current data: \(data)")
        let shiritoriWordList = data["shiritori_word"] as! [[String:Any]]
        for shiritoriWord in shiritoriWordList {
            let id = shiritoriWord["order"] as? Int
            let lat = shiritoriWord["lat"]! as? Double
            let long = shiritoriWord["long"]! as? Double
            let userID = shiritoriWord["user_id"] as? String
            let word = shiritoriWord["word"] as? String
            self.shiritoriWords.append(ShiritoriWord(id:id!, userID:userID!, lat:lat!, long:long!, word:word!))
      }
    }
  } 
}

struct ShiritoriFetcher_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ShiritoriFetcher())
    }
}
