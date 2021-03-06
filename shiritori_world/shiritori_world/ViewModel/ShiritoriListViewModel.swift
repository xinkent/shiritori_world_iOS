import SwiftUI

class ShiritoriListViewModel: ObservableObject {
    @Published var updateBeforeSent: Bool = false
    @Published var reportBeforeSent: Bool = false
    @Published var isSent: Bool = false
    @Published var isError: Bool = false
    @Published var order: Int = 0
    @Published var is_masked: Bool = false
    // @Published var flag_name:String = "is_location_masked"
    // @Published var flag_value:Bool = true
    
    func updateBeforeSend(order:Int, is_masked:Bool){
        self.order = order
        self.is_masked = is_masked
        self.updateBeforeSent = true
    }
    
    func reportBeforeSend(order:Int){
        self.order = order
        self.reportBeforeSent = true
    }
    
    func updateShiritoriFlag(sf:ShiritoriFetcher){
        print("call updateShiritoriUpdate maskLocation")
        let flag = !self.is_masked
        let flag_list = ["is_location_masked":flag, "is_word_masked":flag, "is_name_masked":flag]
        let data = ["doc_id":sf.user.currentShiritoriID!, "shiritori_order":String(self.order), "flag_list":flag_list,
        ] as [String : Any]
        print(data)
        sf.functions.httpsCallable("updateFlag").call(data){(result, error) in
            if error != nil{
                self.isError = true
                print("udpate shiritori failed:\(String(describing: error))")
            } else {
                self.isSent = true
                print("update shiritori succeeded")
            }
        }
    }
    
    func reportShiritori(sf: ShiritoriFetcher){
        print("call reportShiritori")
        let flag_list = ["is_reported":true]
        let data  = ["doc_id":sf.user.currentShiritoriID!, "shiritori_order":String(self.order), "flag_list":flag_list,
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
