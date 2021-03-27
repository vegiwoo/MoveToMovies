//  LinkedList.swift
//  Created by Dmitry Samartcev on 25.03.2021.

import Foundation

/// Node for linked list
public class LinkedListNode<T> where T: Equatable {
    public var id: UUID
    public var value: T
    public var next: LinkedListNode?
    public var previous: LinkedListNode?

    public init(id: UUID = UUID(), value: T) {
        self.id = id
        self.value = value
    }
    
    static public func == (lhs: LinkedListNode<T>, rhs: LinkedListNode<T>) -> Bool {
        lhs.id == rhs.id
    }
    
    static public func != (lhs: LinkedListNode<T>, rhs: LinkedListNode<T>) -> Bool {
        lhs.id != rhs.id
    }
}

/// Linked list
public struct LinkedList<T>: CustomStringConvertible where T: Equatable{

     var head: LinkedListNode<T>?
     var tail: LinkedListNode<T>?
    
    public var count: Int = 0
    
    /// Checking a linked list for emptiness.
    public var isEmpty: Bool {
        return head == nil
    }
    
    /// Returns the first node (head) of the linked list.
    public var first: LinkedListNode<T>? {
        return head
    }
    
    /// Returns the value of the first node (head) of the linked list.
    public var firstValue: T? {
        return head?.value
    }
    
    /// Returns the last node (tail) of the linked list.
    public var last: LinkedListNode<T>? {
        return tail
    }
    
    /// Returns the value of the last node (tail) of the linked list.
    public var lastValue: T? {
        return tail?.value
    }
    
    /// Returns a description of the values of all nodes in the linked list.
    public var description: String {
        var text = "["
        var node = head
        while node != nil {
            text += "\(node!.value)"
            node = node?.next
            if node != nil { text += ", "}
        }
        return text + "]"
    }
    
    // MARK: - Adding
    /// Adds a new node to the end of the linked list.
    /// - Parameter value: Value for LinkedListNode.
    public mutating func push(value: T) {
        let newNode = LinkedListNode(value: value)
        if tail != nil {
            newNode.previous = tail
            tail?.next = newNode
        } else {
            head = newNode
        }
        tail = newNode
        count += 1
    }
    
    // MARK: - Search
    /// Returns the node that is searched for by the specified id.
    /// - Parameter id: Identifier for finding a node.
    /// - Returns: Found node or nil if no node is found.
    public func getNode(_ id: UUID) -> LinkedListNode<T>? {
        guard let head = head else { return nil }
        
        var node: LinkedListNode<T>?  = head
        
        repeat {
            guard let existingNode = node else {
                return nil
            }
            
            if existingNode.id == id {
                return existingNode
            } else {
                if let nextNode = existingNode.next {
                    node = nextNode
                }
            }
        } while node != nil
        
        return nil
    }
    
    /// Returns the node, which is searched for by the specified value inside it.
    /// - Parameter id: Value for finding a node.
    /// - Returns: Found node or nil if no node is found.
    public func getNode(_ value: T) -> LinkedListNode<T>? {
        guard let head = head else { return nil }
        
        var node: LinkedListNode<T>?  = head
        
        repeat {
            guard let existingNode = node else {
                return nil
            }
            
            if existingNode.value == value {
                return existingNode
            } else {
                if let nextNode = existingNode.next {
                    node = nextNode
                }
            }
        } while node != nil
        
        return nil
    }
    
    /// Returns the value for the node searched for by the specified id.
    /// - Parameter id: Identifier for finding a node.
    /// - Returns: The value of the found node, or nil if the node is not found.
    public func getValueForNode(_ id: UUID) -> T? {
        guard let node = getNode(id) else { return nil }
        return node.value
    }
    
    /// Returns the value of the next node relative to the node specified for search by id.
    /// - Parameter id: Identifier for finding a node.
    /// - Returns: The value of the next node relative to the specified node, or zero if the node at the specified id is not found or it does not have the next node.
    public func getNextNodeValueForNode(_ id: UUID) -> T? {
        guard let node = getNode(id), let nextNode = node.next else { return nil }
        return nextNode.value
    }
    
    // MARK: - Deleting
    /// Removes a specific node in the linked list
    /// - Parameter node: Node to remove from linked list.
    /// - Returns: Value of removed node.
    private mutating func remove(node: LinkedListNode<T>) -> T {
        let previous = node.previous
        let next = node.next
        if let previous = previous {
            previous.next = next
        } else {
            head = next
        }
        next?.previous = previous
        
        if next == nil { tail = previous }

        node.previous = nil
        node.next = nil
        
        count -= 1
        
        return node.value
    }

    /// Removes the last node (tail) of the linked list.
    /// - Returns: The value of the remote node, or nil if the delete failed.
    @discardableResult
    public mutating func pop() -> T? {
        guard !isEmpty, tail != nil else { return nil }
        return remove(node: tail!)
    }
    
    /// Deletes all nodes of the linked list except the first (head).
    /// - Returns: The value of the first node in the list.
    @discardableResult
    public mutating func popToHead() -> T? {
        guard let head = head else { return nil }
        tail?.next = nil; tail?.previous = nil
        head.next = nil; head.previous = nil
        count = 1
        return head.value
    }

    /// Deletes all nodes of the linked list, resetting it to zero.
    public mutating func removeAll() {
        head = nil; tail = nil
    }
}
