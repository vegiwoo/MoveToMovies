//
//  LinkedList.swift
//  MoveToMovies
//
//  Created by Dmitry Samartcev on 10.03.2021.
//

#if canImport(Foundation)
import Foundation

/// Нода для связанного списка
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

/// Связанный список
public struct LinkedList<T>: CustomStringConvertible where T: Equatable{

     var head: LinkedListNode<T>?
     var tail: LinkedListNode<T>?
    
    public var count: Int = 0
    
    /// Проверка связанного списка на пустоту.
    public var isEmpty: Bool {
        return head == nil
    }
    
    /// Возврашает первую ноду (голову) связанного списка.
    public var first: LinkedListNode<T>? {
        return head
    }
    
    /// Возврашает значение первой ноды (головы) связанного списка.
    public var firstValue: T? {
        return head?.value
    }
    
    /// Возврашает последнюю ноду (хвост) связанного списка.
    public var last: LinkedListNode<T>? {
        return tail
    }
    
    /// Возврашает значение последней ноды (хвоста) связанного списка.
    public var lastValue: T? {
        return tail?.value
    }
    
    /// Возврашает описание значений все нод связанного списка.
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
    
    // MARK: - Добавление
    /// Добавляет новую ноду в конец связанного списка.
    /// - Parameter value: Значение для LinkedListNode.
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
    
    // MARK: - Поиск
    /// Возвращает ноду, поиск которой производится по указанному id.
    /// - Parameter id: Идентификатор для поиска ноды.
    /// - Returns: Найденная нода или nil если нода не найдена.
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
    
    /// Возвращает ноду, поиск которой производится по указанному значению внутри нее.
    /// - Parameter id: Значение для поиска ноды.
    /// - Returns: Найденная нода или nil если нода не найдена.
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
    
    /// Возвращает значение для ноды, поиск которой производится по указанному id.
    /// - Parameter id: Идентификатор для поиска ноды.
    /// - Returns: Значение найденной ноды или nil если нода не найдена.
    public func getValueForNode(_ id: UUID) -> T? {
        guard let node = getNode(id) else { return nil }
        return node.value
    }
    
    /// Возвращает значение следующей ноды относительно ноды, указанной к поиску по id.
    /// - Parameter id: Идентификатор для поиска ноды.
    /// - Returns: Значение следующей ноды относительно указанной ноды или ноль если нода по указанному id не найдена или у нее отсутствует следующая нода.
    public func getNextNodeValueForNode(_ id: UUID) -> T? {
        guard let node = getNode(id), let nextNode = node.next else { return nil }
        return nextNode.value
    }
    
    // MARK: - Удаление

    /// Удаляет определенную ноду связанного списка
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

    /// Удаляет последнюю ноду (хвост) связанного списка.
    /// - Returns: Значение удаленной ноды или nil если удаление не удалось.
    @discardableResult
    public mutating func pop() -> T? {
        guard !isEmpty, tail != nil else { return nil }
        return remove(node: tail!)
    }
    
    /// Удаляет все ноды связанного списка кроме первой (головы).
    /// - Returns: Значение первой ноды списка.
    @discardableResult
    public mutating func popToHead() -> T? {
        guard let head = head else { return nil }
        tail?.next = nil; tail?.previous = nil
        head.next = nil; head.previous = nil
        count = 1
        return head.value
    }

//    /// Удаляет все ноды связанного списка до указанной (не включая ее).
//    ///
//    /// Нода, указанная по id становится хвостом связнанного списка.
//    /// - Parameter byId: Идентификатор для поиска целевой ноды.
//    /// - Returns: Значение указанной ноды или nil если она не найдена.
//    public mutating func popToNode(byId id: UUID) -> T? {
//        guard let destinationNode = getNode(id) else {
//            return nil
//        }
//
//        if destinationNode.id == head?.id {
//            return popToHead()
//        } else {
//            tail?.next = nil; tail?.previous = nil
//            destinationNode.next = nil
//            tail = destinationNode
//            return tail?.value
//        }
//    }
    
    /// Удаляеет все ноды связанного списка, обнуляя его
    public mutating func removeAll() {
        head = nil; tail = nil
    }
}
#endif
