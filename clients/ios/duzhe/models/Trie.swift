//
//  Trie.swift
//  duzhe
//
//  Created by Bill Glover on 21/01/2021.
//

import Foundation

class TrieNode<T: Hashable> {
    var value: T?
    var children: [T: TrieNode] = [:]
    var isWordEnd = false
    
    init(value: T? = nil){
        self.value = value
    }
    
    func add(child: T){
        // make sure the child doesn't already exit
        guard children[child] == nil else {return}
        
        children[child] = TrieNode(value: child)
    }
}

class Trie {
    typealias Node = TrieNode<Character>
    private let root: Node
    
    init() {
        root = Node()
    }
}

extension Trie {
    func reset() {
        root.children = [:]
    }
    
    func insert(word: String) {
        guard !word.isEmpty else { return }
        var currentNode = root
        
        for char in word {
            if let child = currentNode.children[char] {
                currentNode = child
            } else {
                currentNode.add(child: char)
                currentNode = currentNode.children[char]!
            }
        }
        
        currentNode.isWordEnd = true
    }
    
    func contains(word: String) -> Bool {
        guard !word.isEmpty else { return false }
        var currentNode = root
        
        for char in word {
            if let child = currentNode.children[char] {
                currentNode = child
            } else {
                return false
            }
        }
        
        return currentNode.isWordEnd
    }
    
    func knownPhrases(text: String) -> ([Range<String.Index>], Int, Double) {
        var currentNode = root
        let cs = Array(text)
        var i = 0
        let len = cs.count
        
        var start = 0
        
        var matches: [Range<String.Index>] = Array()
        var known = 0
                
        while(i<len){
        
            // if the current character isn't in the trie
            if currentNode.children[cs[i]] == nil {
                
                // check to see if we matched at the previous node
                if currentNode.isWordEnd {
                    // add it to the list of known phrases
                    i -= 1
                    let startIndex = text.index(text.startIndex, offsetBy: start)
                    let endIndex = text.index(text.startIndex, offsetBy: i+1)
                    let range = startIndex..<endIndex
                    matches.append(range)
                    known += text[range].count
                    start = i
                    
                }
                    
                // continue searching at the root
                currentNode = root
                i += 1
                start = i
                continue
            }
            
            // otherwise the character was found in trie so go deeper
            currentNode = currentNode.children[cs[i]]!
            
            // if this is the last character then check to see if we matched
            if i == len-1 && currentNode.isWordEnd {
                let startIndex = text.index(text.startIndex, offsetBy: start)
                let endIndex = text.index(text.startIndex, offsetBy: i+1)
                let range = startIndex..<endIndex
                matches.append(range)
                known += text[range].count
            }
            
            i+=1
        }
        
        let count = text.split{!$0.isLetter}.joined().count
        
        return (matches, count, Double(known)/Double(count))
    }
}
