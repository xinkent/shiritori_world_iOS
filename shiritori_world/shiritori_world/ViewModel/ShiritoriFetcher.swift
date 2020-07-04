import Firebase
import SwiftUI
import MapKit

class ShiritoriFetcher: ObservableObject{
  @Published var shiritoriWords:[ShiritoriWord] = []
  let db = Firestore.firestore()
    
  func fetchShiritori(documentID:String){
    // 指定したしりとりIDのドキュメントにリスナーを設置し、shiritoriWordsを更新する。
    // TODO：取得DocumentIDの指定方法検討
    
    db.collection("shiritori_test").document(documentID)
      .addSnapshotListener { documentSnapshot, error in
      
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
      
      // fetchしたドキュメントからフィールドを抽出し、shiritoriWordsを作成
      let shiritoriWordList = data["shiritori_word"] as! [[String:Any]]
      self.shiritoriWords = shiritoriWordList.map{self.getShiriotoriWordData(shiritoriWord:$0)}
      
      // それぞれのshirotoriWordに対し、非同期で住所情報を取得
      for i in 0..<self.shiritoriWords.count{
        let wordLocation = self.shiritoriWords[i].location
        self.getAddress(location:wordLocation){ (result: String) in
          self.shiritoriWords[i].address = result
        }
      }
    }
  }
  
  
  func getShiriotoriWordData(shiritoriWord: [String: Any]) -> ShiritoriWord{
    // FirestoreのshiritoriドキュメントからshiritoriWordインスタンスを作成する
    
    let id = shiritoriWord["order"] as? Int
    let lat = shiritoriWord["lat"]! as? Double
    let long = shiritoriWord["long"]! as? Double
    let userID = shiritoriWord["user_id"] as? String
    let word = shiritoriWord["word"] as? String
    return ShiritoriWord(id:id!, userID:userID!, word:word!, lat:lat!, long:long!)
  }
  
	typealias CompletionClosure = ((_ result:String) -> Void)
  func getAddress(location:CLLocation, completionClosure:@escaping CompletionClosure){
    // MapKitの逆ジオコーディングにより緯度経度から住所を取得する
    
    CLGeocoder().reverseGeocodeLocation(location){ placemarks, error in
      guard
        let placemark = placemarks?.first, error == nil,
        let administrativeArea = placemark.administrativeArea, // 都道府県
        let locality = placemark.locality // 市区町村
      else{
          print("住所が取得できませんでした")
          return
      }
      print("getAddress: \(administrativeArea)  \(locality)")
      completionClosure("\(administrativeArea)  \(locality)")
    }
  }
}

struct ShiritoriFetcher_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ShiritoriFetcher())
    }
}
