import Firebase
import SwiftUI
import MapKit

class ShiritoriFetcher: ObservableObject{
  @Published var shiritoriWords:[ShiritoriWord] = [] // UserIDに対応するshiritoriを取得する
  let db = Firestore.firestore()
//  var address = ""
    
  // TODO：取得DocumentIDの指定方法検討
  func fetchShiritori(documentID:String){
    db.collection("shiritori_test").document(documentID)
    .addSnapshotListener { documentSnapshot, error in
        self.shiritoriWords = [] // 表示しりとりの初期化
         guard let document = documentSnapshot else {
          print("Error fetching document: \(error!)")
          return
         }
         guard let data = document.data() else {
          print("Document data was empty.")
          return
         }
        // print("Current data: \(data)") // debug
        let shiritoriWordList = data["shiritori_word"] as! [[String:Any]] // fetchしたドキュメントからフィールドを抽出
        
        for shiritoriWord in shiritoriWordList {
            let id = shiritoriWord["order"] as? Int
            let lat = shiritoriWord["lat"]! as? Double
            let long = shiritoriWord["long"]! as? Double
//            print("lat: \(lat)")
//            print("long: \(long)")
            
            let location = CLLocation(latitude: 35.711271, longitude: 139.797323)// default asakusa
            // MapKitを用いた逆ジオコーディング
//            var address = ""
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
//                guard
                    let placemark = placemarks?.first// error == nil,
                let administrativeArea = placemark?.administrativeArea // 都道府県
                let locality = placemark?.locality // 市区町村
//                  let thoroughfare = placemark.thoroughfare, // 地名(丁目)
//                  let subThoroughfare = placemark.subThoroughfare, // 番地
//                  let postalCode = placemark.postalCode, // 郵便番号
//                  let location = placemark.location // 緯度経度情報
//                else {
//                    return
//                a}
//                print("placemark: \(placemark)")
//                print("prefecture: \(administrativeArea)")
//                print("locality: \(locality)")

//                self.address = administrativeArea! + locality!
             }
//            Thread.sleep(forTimeInterval: 3)
//            print("address: \(self.address)")
            let userID = shiritoriWord["user_id"] as? String
            let word = shiritoriWord["word"] as? String
            
            self.shiritoriWords.append(ShiritoriWord(id:id!, userID:userID!, lat:lat!, long:long!,  word:word!))
      }
    }
  } 
}

struct ShiritoriFetcher_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ShiritoriFetcher())
    }
}
