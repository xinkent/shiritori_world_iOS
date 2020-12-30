import SwiftUI

class ShiritoriListViewModel: ObservableObject {
    @Published var beforeSent: Bool = false
    @Published var isSent: Bool = false
    @Published var isError: Bool = false
    @Published var order: Int = 0
    // @Published var flag_name:String = "is_location_masked"
    // @Published var flag_value:Bool = true
    
    func beforeSend(order:Int){
        self.order = order
        //  self.flag_name = flag_name
        // self.flag_value = flag_value
        self.beforeSent = true
    }
    
    func updateShiritoriFlag(sf:ShiritoriFetcher){
        print("call updateShiritoriUpdate maskLocation")
        let flag_list = ["is_location_masked":true, "is_word_masked":true, "is_name_masked":true]
        let data = ["doc_id":sf.user.currentShiritoriID!, "shiritori_order":String(self.order), "flag_list":flag_list,
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
