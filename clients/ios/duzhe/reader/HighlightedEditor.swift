//
//  HighlightedEditor.swift
//  duzhe
//
//  Created by Bill Glover on 24/01/2021.
//

import SwiftUI
import UIKit

struct HighlightedEditor<ViewModelType: VocabViewModelProtocol>: UIViewRepresentable, HighlightingEditor {
    
    @Binding var text: String
    @ObservedObject var viewModel: ViewModelType
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        
        textView.delegate = context.coordinator
        textView.addDoneButton(title: "Done", target: textView, selector: #selector(textView.doneButtonTapped(button:)))
        
        textView.delegate = context.coordinator
        textView.isEditable = true
        textView.isScrollEnabled = true
                
        return textView
    }
    
    public func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.isScrollEnabled = false
        
        let highlightedText = getHighlightedText( text: text )
        
        if let range = uiView.markedTextNSRange {
            uiView.setAttributedMarkedText(highlightedText, selectedRange: range)
        } else {
            uiView.attributedText = highlightedText
        }
        uiView.isScrollEnabled = true
        uiView.selectedTextRange = context.coordinator.selectedTextRange
    }
    
    private func getHighlightedText(text: String) -> NSMutableAttributedString {
        let highlightedString = NSMutableAttributedString(string: text)
        let all = NSRange(location: 0, length: text.count)
        
        let font = UIFont.systemFont(ofSize: 28)
        let textColor = UIColor.label
        
        highlightedString.addAttribute(.font, value: font, range: all)
        highlightedString.addAttribute(.foregroundColor, value: textColor, range: all)
        
        //---//
        
        let (matches, length, readability) = viewModel.trie.knownPhrases(text: text)
        
        // Apply Base Styles
        //highlightedString.addAttribute(.foregroundColor, value: UIColor.label, range: NSRange(location: 0, length: highlightedString.length))
        //highlightedString.addAttribute(.font, value: font, range: NSRange(location: 0, length: highlightedString.length))

        // Highlight Matched Words
        for r in matches {
            let nsRange = NSRange(r, in: text)
            //highlightedString.addAttribute(.underlineStyle, value: 3, range: nsRange)
            highlightedString.addAttribute(.foregroundColor, value: UIColor(Color.accentColor), range: nsRange)
        }
        
        return highlightedString
    }
        
    public class Coordinator: NSObject, UITextViewDelegate {
        var parent: HighlightedEditor
        var selectedTextRange: UITextRange? = nil
        
        init(_ markdownEditorView: HighlightedEditor) {
            self.parent = markdownEditorView
        }
        
        public func textViewDidChange(_ textView: UITextView) {
            
            // For Multistage Text Input
            guard textView.markedTextRange == nil else { return }
            
            self.parent.text = textView.text
            selectedTextRange = textView.selectedTextRange
        }
        
    }
}

extension UITextView {
    var markedTextNSRange: NSRange? {
        guard let markedTextRange = markedTextRange else { return nil }
        let location = offset(from: beginningOfDocument, to: markedTextRange.start)
        let length = offset(from: markedTextRange.start, to: markedTextRange.end)
        return NSRange(location: location, length: length)
    }
    
    func addDoneButton(title: String, target: Any, selector: Selector) {

        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
        toolBar.setItems([flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }

    @objc func doneButtonTapped(button: UIBarButtonItem) {
        self.resignFirstResponder()
    }
}
