//
//  TreeNode.swift
//  
//
//  Created by Jesse Spencer on 2/21/23.
//

/// An object which provides tree behaviors.
public
final
class TreeNode<T> {
    public
    var parent: TreeNode<T>?
    public
    var value: T
    public
    var children: [TreeNode<T>]
    
    public
    init(parent: TreeNode<T>? = nil, value: T, children: [TreeNode<T>] = []) {
        self.parent = parent
        self.value = value
        self.children = children
    }
}

