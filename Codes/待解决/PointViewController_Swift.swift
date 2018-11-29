//
//  PointViewController_Swift.swift
//  Codes
//
//  Created by chenzw on 2018/11/26.
//  Copyright © 2018 Gripay. All rights reserved.
//

import UIKit

class PointViewController_Swift: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        

//        let a = 100
//        print(a)
//        let a_rawptr = UnsafeMutableRawPointer.allocate(bytes: MemoryLayout<PointViewController_Swift>.size, alignedTo: MemoryLayout<PointViewController_Swift>.alignment)
//        print(a_rawptr)
//        let bind_rawptr = a_rawptr.bindMemory(to: PointViewController_Swift.self, capacity: MemoryLayout<PointViewController_Swift>.stride)
//        print(bind_rawptr)
//        bind_rawptr.initialize(to: self)
//        print(bind_rawptr)
//
        
//        self.test()
    }
    func test() {
        // 1
        let count = 2
        let stride = MemoryLayout<Int>.stride
        let alignment = MemoryLayout<Int>.alignment
        let byteCount = stride * count
        
        // 2
        do {
            print("Raw pointers")
            
            // 3
            let pointer = UnsafeMutableRawPointer.allocate(bytes: byteCount, alignedTo: alignment)
            // 4
            defer {
                pointer.deallocate(bytes: byteCount, alignedTo: alignment)
            }
            
            // 5
            pointer.storeBytes(of: 42, as: Int.self)
            pointer.advanced(by: stride).storeBytes(of: 6, as: Int.self)
            pointer.load(as: Int.self)
            pointer.advanced(by: stride).load(as: Int.self)
            
            // 6
            let bufferPointer = UnsafeRawBufferPointer(start: pointer, count: byteCount)
            for (index, byte) in bufferPointer.enumerated() {
                print("byte \(index): \(byte)")
            }
        }
        
//        do {
//            print("Typed pointers")
//
//            let pointer = UnsafeMutablePointer<Int>.allocate(capacity: count)
//            pointer.initialize(to: 0, count: count)
//            defer {
//                pointer.deinitialize(count: count)
//                pointer.deallocate(capacity: count)
//            }
//
//            pointer.pointee = 42
//            pointer.advanced(by: 1).pointee = 6
//            pointer.pointee
//            pointer.advanced(by: 1).pointee
//
//            let bufferPointer = UnsafeBufferPointer(start: pointer, count: count)
//            for (index, value) in bufferPointer.enumerated() {
//                print("value \(index): \(value)")
//            }
//        }
        
        do {
            print("Converting raw pointers to typed pointers")
            
            let rawPointer = UnsafeMutableRawPointer.allocate(bytes: byteCount, alignedTo: alignment)
            defer {
                rawPointer.deallocate(bytes: byteCount, alignedTo: alignment)
            }
            
            let typedPointer = rawPointer.bindMemory(to: PointViewController_Swift.self, capacity: count)
            typedPointer.initialize(to: self, count: count)
            defer {
                typedPointer.deinitialize(count: count)
            }
            
            typedPointer.pointee = self
//            typedPointer.advanced(by: 1).pointee = 6
//            typedPointer.pointee
//            typedPointer.advanced(by: 1).pointee
            
            let bufferPointer = UnsafeBufferPointer(start: typedPointer, count: count)
            for (index, value) in bufferPointer.enumerated() {
                print("value \(index): \(value)")
            }
        }
    }
    
    
    //
    func testUnsafeMutablePointer() {
        let a_unsafe_mutable_pointer = UnsafeMutablePointer<Int>.allocate(capacity: 0)
        a_unsafe_mutable_pointer.initialize(to: 5)
        
        var a : Int = a_unsafe_mutable_pointer.pointee
        
        print(a)
        printPointer(ptr:&a)
    }
    
    
    func printPointer(ptr:UnsafeMutablePointer<Int>) {
        print("UnsafeMutablePointer:\(ptr)")
        print("pointee:\(ptr.pointee)")
    }

    // UnsafeMutableRawPointer
    // UnsafeMutableRawPointer按我的理解就是无类型的原始指针
    func testUnsafeMutableRawPointer() {
        // 1.分配内存
        var size = MemoryLayout<Int>.size
        // 其中alignTo是开辟内存中的对齐，不是很了解，貌似会影响效率，太底层了，不太懂
        var a_unsafe_mutable_raw_pointer = UnsafeMutableRawPointer.allocate(bytes: size, alignedTo: size)
        // 这时，这个a_unsafe_mutable_raw_pointer感觉没啥用，还是需要转换为UnsafeMutablePointer来对内存进行操作。
        

        // 2.初始化
        // 初始化内存为Int类型，并赋值为1
        a_unsafe_mutable_raw_pointer.bindMemory(to: PointViewController_Swift.self, capacity: 1)
        
        
        
        
        /*
         3.绑定UnsafeMutablePointer
         
         绑定了UnsafeMutablePointer,使用UnsafeMutablePointer才能对内存进行赋值,有两种方法绑定：
         
         (1) bindMemory()
         
         该方法绑定内存为指定类型并返回一个UnsafeMutablePointer<指定类型>的指针
         */
//        var a_unsafe_mutable_pointer = a_unsafe_mutable_raw_pointer.bindMemory(to: Int.self, capacity: 1)
        
        /*
         (2) assumingMemoryBound()
         
         该方法意思是直接转换这个原始指针为一个UnsafeMutablePointer<指定类型>的指针
         
         var a_unsafe_mutable_pointer = a_unsafe_mutable_raw_pointer.assumingMemoryBound(to: Int.self)
         -
         */
        
        // 这样，就可以使用这个a_unsafe_mutable_pointer进行其他操作了。
        
        /*
         5.转换
         
         (1) Swift -> UnsafeMutableRawPointer
         
         var a = 10
         var ptr = UnsafeMutableRawPointer(&a)
         (2) UnsafeMutableRawPointer -> Swift
         其过程应当为UnsafeMutableRawPointer转换为UnsafeMutablePointer，再由UnsafeMutablePointer转换为Swift指针
         */
        
//        let t = a_unsafe_mutable_raw_pointer.
        
    }
}
