import SwiftUI

class ShiritoriListViewModel: ObservableObject {
    @Published var beforeSent: Bool = false
    @Published var isSent: Bool = false
    @Published var isError: Bool = false
    @Published var order: Int = 0
    @Published var flag_name:String = "is_location_masked"
    @Published var flag_value:Bool = true
    
    func beforeSend(order:Int, flag_name:String, flag_value:Bool){
        self.order = order
        self.flag_name = flag_name
        self.flag_value = flag_value
        self.beforeSent = true
    }
    
    func updateShiritoriFlag(sf:ShiritoriFetcher){
        print("call updateShiritoriUpdate")
        let data = ["doc_id":sf.user.currentShiritoriID!, "shiritori_order":String(self.order), "flag_name":self.flag_name,
            // "flag_value":String(self.flag_value)
            "flag_value": 10
        ] as [String : Any]
        print(data)
        sf.functions.httpsCallable("updateFlag").call(data){(result, error) in
            if error != nil{
                print("udpate shiritori failed:\(String(describing: error))")
            } else {
                print("update shiritori succeeded")
            }
        }
    }
}
