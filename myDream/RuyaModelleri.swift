//
//  File.swift
//  myDream
//
//  Created by Bahadır Sengun on 3.04.2023.
//

import Foundation


class RuyaSembol{
    
    var sembolResim:String?
    var sembolisim:String?
    var sembolAnlami:String?
    var favoriSembol:Bool = false
    init(){
        
    }
    
    
    init(sembolResim: String?, sembolisim: String?, sembolAnlami: String?, favoriSembol: Bool = false) {
        self.sembolResim = sembolResim
        self.sembolisim = sembolisim
        self.sembolAnlami = sembolAnlami
        self.favoriSembol = favoriSembol
    }
    
    
}


class SoruCevap{
    var soruID:Int?
    var soruIsim:String?
    var soruCevap:String?
    
    init(){
        
    }
    
    init(soruID: Int?, soruIsim: String?, soruCevap: String?) {
        self.soruID = soruID
        self.soruIsim = soruIsim
        self.soruCevap = soruCevap
    }
    
}

class RuyaSembolAnlam{
    
    var sembolID: Int?
    var sembolisim:String?
    var sembolAnlami:String?
    
    init(){
        
    }
    
    
    init(sembolisim: String?, sembolAnlami: String?,sembolID: Int?) {
        self.sembolID = sembolID
        self.sembolisim = sembolisim
        self.sembolAnlami = sembolAnlami
    }
    
}
