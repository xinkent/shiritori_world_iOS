import Firebase
import SwiftUI
import MapKit

class ShiritoriFetcher: ObservableObject{
    @Published var shiritori = Shiritori()
    @Published var user = User()
    let db = Firestore.firestore()
    
    func fetchUserShiritori(){
    // User情報を取得した後、そのUserに紐づくshiritoriデータを取得する
    // TODO：取得DocumentIDの指定方法検討
        do{
            try self.fetchUser(){
                self.fetchShiritori()
            }
        }catch{
                print("User Error occured")
                Thread.sleep(forTimeInterval: 1)
                self.fetchUserShiritori()
        }
    }
    
    
    func fetchUser(completionClosure:@escaping (() -> Void)) throws{
        // UserオブジェクトをFetchする
        if Auth.auth().currentUser == nil {
            throw NSError(domain:"User is not authentificated", code:-1, userInfo:nil)
        }
        
        // userドキュメントにリスナーを設置し、完了後にcompletionClosureを実行する
        let uid = Auth.auth().currentUser!.uid
        
        self.db.collection("user").document(uid)
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
            print("Firestore User data: \(data)") // debug
                
            let userID = data["userID"] as? String
            let currentShiritoriID = data["currentShiritoriID"] as? String
            
            self.user = User(userID: userID, currentShiritoriID: currentShiritoriID)
            completionClosure()
        }
    }
    
    func fetchShiritori(){
        // shiritoriオブジェクトをFetchする
        self.db.collection("shiritori_test").document(self.user.currentShiritoriID!)
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
            print("Firestore Shiritori data: \(data)") // debug
             
            // fetchしたドキュメントからフィールドを抽出し、shiritoriWordsを作成
            let shiritoriWordList = data["shiritori_word"] as! [[String:Any]]
            var shiritoriWords = shiritoriWordList.map{self.getShiriotoriWordData(shiritoriWord:$0)}
            
            // それぞれのshirotoriWordに対し、非同期で住所情報を取得
            for i in 0..<shiritoriWords.count{
                let wordLocation = shiritoriWords[i].location
                self.getAddress(location:wordLocation){ (result: String) in
                    shiritoriWords[i].address = result
                }
            }
            
            let month = data["month"] as! String
            let shiritori_id = data["shiritori_id"] as! String
            self.shiritori = Shiritori(shiritoriID: shiritori_id, month: month, shiritoriWords: shiritoriWords)
            
        }
    }
    
    typealias CompletionClosure = ((_ result:String) -> Void)
    func getAddress(location:CLLocation, completionClosure:@escaping CompletionClosure){
        // MapKitの逆ジオコーディングにより緯度経度から住所を取得すし、完了後にCompletionクロージャを実行する。
    
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
    
    func getShiriotoriWordData(shiritoriWord: [String: Any]) -> ShiritoriWord{
        // FirestoreのshiritoriドキュメントからshiritoriWordインスタンスを作成する
    
        let id = shiritoriWord["order"] as? Int
        let lat = shiritoriWord["lat"]! as? Double
        let long = shiritoriWord["long"]! as? Double
        let userID = shiritoriWord["user_id"] as? String
        let word = shiritoriWord["word"] as? String
        let answerDate = (shiritoriWord["answer_date"] as! Timestamp).dateValue()
        return ShiritoriWord(id:id!, userID:userID!, word:word!, lat:lat!, long:long!, answerDate: answerDate)
    }
    
}

struct ShiritoriFetcher_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ShiritoriFetcher())
    }
}
