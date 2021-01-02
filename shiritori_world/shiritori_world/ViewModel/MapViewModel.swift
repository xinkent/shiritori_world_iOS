import SwiftUI
import Firebase

class MapViewModel: ObservableObject {
    @Published var reportBeforeSent: Bool = false
    @Published var isSent: Bool = false
    @Published var isError:Bool = false
    @Published var selection: Int = 0 {
        willSet { // selectionが変更された時、選択肢そのものが更新されるようにする
            id = UUID()
        }
    }
    @Published var id: UUID = UUID()
    var selected_order: Int = 0
    let collection_name = "shiritori"
    
    func reportBeforeSend(){
        self.reportBeforeSent = true
    }
    
    func reportShiritori(sf: ShiritoriFetcher, order: Int){
        print("call reportShiritori")
        let flag_list = ["is_reported":true]
        let data  = ["doc_id":sf.user.currentShiritoriID!, "shiritori_order":String(order), "flag_list":flag_list,
        ] as [String : Any]
        print(data)
        sf.functions.httpsCallable("updateFlag").call(data){(result, error) in
            if error != nil{
                self.isError = true
                print("report shiritori failed:\(String(describing: error))")
            } else {
                self.isSent = true
                print("report shiritori succeeded")
            }
        }
    }
}
