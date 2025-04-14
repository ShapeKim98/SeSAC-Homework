//
//  WordWizard.swift
//  ImplementDay
//
//  Created by 김도형 on 4/14/25.
//

import Foundation

func 단어_마법사() -> Int {
    let str = "dufjqnswoaldlTdmtlwygpgpanswpduftlaglaksemfrhdlTtmqslekgggdlanswpakwcnrhdjffmsekdmaanswpfhsjadjrktlwyekdmaanswprkdufjqnsemfdmfrlekflrhdlTtmqslekdlrjfthsdmfhvntlsmsqnsdmsdjqtdmtlrpTwy".lowercased()
    var result = 0
    for (index, char) in str.enumerated() {
        let value = Int(char.asciiValue ?? 0) - 96
        result += (index + value)
    }
    let count = str.filter { char in
        char == "a" || char == "e" || char == "i" || char == "o" || char == "u"
    }.count
    
    result *= str.count
    result += count
    return result
}
