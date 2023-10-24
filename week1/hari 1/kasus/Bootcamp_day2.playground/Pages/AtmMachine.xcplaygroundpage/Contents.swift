import UIKit

print("============================")
print("=========ATM KUBANK=========")
print("[1] Deposit")
print("[2] Tarik Tunai")
print("============================")

class Deposit{
    var depo = 0
    func add(depo: Int) {
        if(self.depo < depo){
            print("Deposit anda kurang")
        }
        else   {
            print("Deposit anda sebesar \(depo)")
        }
    }
}


var dpo = Deposit()
dpo.depo = 300000
dpo.add(depo: 300000)
