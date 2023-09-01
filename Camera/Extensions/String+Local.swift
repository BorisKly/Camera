//
//  String+Local.swift
//  Camera
//
//  Created by Borys Klykavka on 31.08.2023.
//

import Foundation

extension String {
   
    func formatTo(style: DateFormatterStyle) -> Date? {
        let dateFormatter = DateFormatter()
       
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = style.rawValue
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return dateFormatter.date(from: self)
    }
}
