//
//  HighlightingEditor.swift
//  duzhe
//
//  Created by Bill Glover on 24/01/2021.
//

import SwiftUI

internal protocol HighlightingEditor {
    var text: String { get set }
}

extension HighlightingEditor {
    
//    static func getHighlightedText(text: String) -> NSMutableAttributedString {
//        let highlightedString = NSMutableAttributedString(string: text)
//        let all = NSRange(location: 0, length: text.count)
//        
//        let font = UIFont.systemFont(ofSize: 28)
//        let textColor = UIColor.label
//        
//        highlightedString.addAttribute(.font, value: font, range: all)
//        highlightedString.addAttribute(.foregroundColor, value: textColor, range: all)
//        
//        //---//
//        
//        let tr = Trie()
//        tr.insert(word: "你")
//        tr.insert(word: "好")
//        tr.insert(word: "你好")
//        tr.insert(word: "我")
//        tr.insert(word: "中")
//        tr.insert(word: "国")
//        tr.insert(word: "中国")
//        
//        let matches = tr.knownPhrases(text: text)
//        
//        // Apply Base Styles
//        //highlightedString.addAttribute(.foregroundColor, value: UIColor.label, range: NSRange(location: 0, length: highlightedString.length))
//        //highlightedString.addAttribute(.font, value: font, range: NSRange(location: 0, length: highlightedString.length))
//
//        // Highlight Matched Words
//        for r in matches {
//            let nsRange = NSRange(r, in: text)
//            //highlightedString.addAttribute(.underlineStyle, value: 3, range: nsRange)
//            highlightedString.addAttribute(.foregroundColor, value: UIColor.systemTeal, range: nsRange)
//        }
//        
//        
//        
//        
//        
//        
//        
//        return highlightedString
//    }
}
