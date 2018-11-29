//
//  CZWCellMoreImageVsController.swift
//  Codes
//
//  Created by chenzw on 2018/11/23.
//  Copyright © 2018 Gripay. All rights reserved.
//

import UIKit

extension CZWCellMoreImageVsController{
    func addRunloopObserver() {
        guard let runloop = CFRunLoopGetCurrent() else {return}
        let unmanaged = Unmanaged.passRetained(self)
        let uptr = unmanaged.toOpaque()
        let vptr = UnsafeMutableRawPointer(uptr)
        var content = CFRunLoopObserverContext(version: 0, info: vptr, retain: nil, release: nil, copyDescription: nil)
        guard let obserber = CFRunLoopObserverCreate(kCFAllocatorDefault, CFRunLoopActivity.beforeWaiting.rawValue, true, 0, observerCallbackFunc(), &content) else {return}
        CFRunLoopAddObserver(runloop, obserber, CFRunLoopMode.commonModes)
        
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector:#selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    func observerCallbackFunc() -> CFRunLoopObserverCallBack {
        
        return {(observer, activity, context) -> Void in
            guard let context = context else {
                return
            }
            let object = Unmanaged<CZWCellMoreImageVsController>.fromOpaque(context).takeUnretainedValue()

            guard let task = object.tasks.first as? runLoopCallback else {
                return
            }
            task();
            object.tasks.removeFirst()
        }
    }
    
    @objc func fireTimer() {

    }
}


class CZWCellMoreImageVsController: UITableViewController {
    
    typealias runLoopCallback = ()->()

    var tasks:Array = [AnyObject]()
    let maxtaskCount = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addRunloopObserver()
    }
    
    // 把要执行的图片渲染，下载事件加入Runoop
    func addTask (task:@escaping runLoopCallback) {
        self.tasks.append(task as AnyObject)

        if self.tasks.count > self.maxtaskCount {
            self.tasks.remove(at: 0)
        }
        print(self.tasks.count)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 99
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        
        if  cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "reuseIdentifier")
        }
        
        for i in 0..<3{
            cell?.contentView.viewWithTag(100+i)?.removeFromSuperview()
        }

        self.addTask {
            CZWTableViewController.addImageV(cell!, index: 0)
        }
        self.addTask {
            CZWTableViewController.addImageV(cell!, index: 1)
        }
        self.addTask {
            CZWTableViewController.addImageV(cell!, index: 2)
        }

        return cell!
    }

}


//    // Runloop观察者执行的回调函数
//    static func runloopObserverCallout() -> CFRunLoopObserverCallBack {
//        return { (observer, activity, context) -> Void in
//            guard let context = context else {
//                return
//            }
////            let a = context?.assumingMemoryBound(to: CZWTableViewController.self).pointee
//             let a = Unmanaged<CZWTableViewController>.fromOpaque(context).takeUnretainedValue()
//            print(a)
//            context?.deallocate()


//             UnsafeMutableRawPointer
//            context?.

//            guard let numberPointer = context?.assumingMemoryBound(to: CZWCellMoreImageVsController.self) else {
//                return
//            }
//            numberPointer
////            let Bself = numberPointer.pointee
//            print(numberPointer.pointee)

//            print("AAAAAAAAa")


//            print(Bself)


//            Bself?.title = "ss"
//
//            let task = (Bself?.tasks.first) as? runLoopCallback
//
//            print(task)
//
//           task?()
//        }
//    }




//            guard let task = numberPointer.tasks.first else { return  }
//            task()
//
//            switch(activity) {
//
//            case CFRunLoopActivity.entry:
//                print("Run Loop已经启动")
//                break
//            case CFRunLoopActivity.beforeTimers:
//                print("Run Loop分配定时任务前")
//                break
//            case CFRunLoopActivity.beforeSources:
//                print("Run Loop分配输入事件源前")
//                break
//            case CFRunLoopActivity.beforeWaiting:
//                print("Run Loop休眠前")
//                break
//            case CFRunLoopActivity.afterWaiting:
//                print("Run Loop休眠后")
//                break
//            case CFRunLoopActivity.exit:
//                print("Run Loop退出后")
//                break
//            default:
//                break
//
//            }
//        }
//    }

//    private func CPCCalendarViewMainRunLoopObserver (observer: CFRunLoopObserver!, activity: CFRunLoopActivity, calendarPtr: UnsafeMutableRawPointer?) {
//        guard let calendarWrapper = calendarPtr.map ({ Unmanaged <CZWCellMoreImageVsController>.fromOpaque ($0).takeUnretainedValue () }) else {
//            return;
//        }
////        calendarWrapper.mainRunLoopWillStartWaiting ();
//    }

//    func addRunloopObserver() {
//        /*
//         获取Run Loop对象
//
//         前文中提到过，在Cocoa和Core Foundation框架中都没有提供创建Run Loop的方法，只有从当前线程获取Run Loop的方法：
//
//         在Cocoa框架中，NSRunLoop类提供了类方法currentRunLoop()获取NSRunLoop对象。> 该方法是获取当前线程中已存在的Run Loop，如果不存在，那其实还是会创建一个Run Loop对象返回，只是Cocoa框架没有向我们暴露该接口。
//
//         在Core Foundation框架中提供了CFRunLoopGetCurrent()函数获取CFRunLoop对象。
//
//         虽然这两个Run Loop对象并不完全等价，它们之间还是可以转换的，我们可以通过NSRunLoop对象提供的getCFRunLoop()方法获取CFRunLoop对象。因为NSRunLoop和CFRunLoop指向的都是当前线程中同一个Run Loop，所以在使用时它们可以混用，比如说要给Run Loop添加观察者时就必须得用CFRunLoop了。
//        */
//        let runloop = CFRunLoopGetCurrent()
//
//        /*
//         配置Run Loop观察者
//
//         前文中提到过，可以向Run Loop中添加各种事件源和观察者，这里事件源是必填项，也就是说Run Loop中至少要有一种事件源，不论是Input source还是timer，如果Run Loop中没有事件源的话，那么在启动Run Loop后就会立即退出。而观察者是可选项，如果没有监控Run Loop各运行状态的需求，可以不配置观察者，这一节先看看如何向Run Loop中添加观察者。
//
//         在Cocoa框架中，并没有提供创建配置Run Loop观察者的相关接口，所以我们只能通过Core Foundation框架中提供的对象和方法创建并配置Run Loop观察者，下面我们看看示例代码：
//
//         version：结构体版本号，必须设置为0。
//         info：上下文中retain、release、copyDescription三个回调函数以及Run Loop观察者的回调函数所有者对象的指针。在Swift中，UnsafePointer结构体代表C系语言中申明为常量的指针，UnsafeMutablePoinger结构体代表C系语言中申明为非常量的指针，比如说：
//         allocator：该参数为对象内存分配器，一般使用默认的分配器kCFAllocatorDefault。
//         activities：该参数配置观察者监听Run Loop的哪种运行状态。在示例中，我们让观察者监听Run Loop的所有运行状态。
//         repeats：该参数标识观察者只监听一次还是每次Run Loop运行时都监听。
//         order：观察者优先级，当Run Loop中有多个观察者监听同一个运行状态时，那么就根据该优先级判断，0为最高优先级别。
//         callout：观察者的回调函数，在Core Foundation框架中用CFRunLoopObserverCallBack重定义了回调函数的闭包。
//         context：观察者的上下文。
//         */

//        autoreleasepool {
//        var _self = self
//        var context = CFRunLoopObserverContext(version: 0,
//                                               info: &_self,
//                                               retain: nil,
//                                               release: nil,
//                                               copyDescription: nil)
//
//        // 观察者上下文
//        let runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault,
//                                                      CFRunLoopActivity.allActivities.rawValue,
//                                                      true,
//                                                      0,
//                                                      CZWCellMoreImageVsController.runloopObserverCallout(),
//                                                      &context)
//
//        CFRunLoopAddObserver(runloop, runLoopObserver, CFRunLoopMode.defaultMode)
//        }
//
//        autoreleasepool {
//            guard let runloop = CFRunLoopGetCurrent() else {return}
//            let unmanaged = Unmanaged.passRetained(self)
//            let uptr = unmanaged.toOpaque()
//            let vptr = UnsafeMutableRawPointer(uptr)
//            var content = CFRunLoopObserverContext(version: 0, info: vptr, retain: nil, release: nil, copyDescription: nil)
//            guard let obserber = CFRunLoopObserverCreate(kCFAllocatorDefault, CFRunLoopActivity.beforeWaiting.rawValue, true, 0, observerCallbackFunc(), &content) else {return}
//            CFRunLoopAddObserver(runloop, obserber, CFRunLoopMode.defaultMode)
//        }
//
//        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector:#selector(fireTimer), userInfo: nil, repeats: true)
//
//        var loopCount = 10
//        repeat {
//            RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
//            loopCount = loopCount - 1
//        } while(loopCount > 0)
//    }
//
//    func observerCallbackFunc() -> CFRunLoopObserverCallBack {
//
//        return {(observer, activity, context) -> Void in
//            guard let context = context else {
//                return
//            }
//            let work = Unmanaged<CZWCellMoreImageVsController>.fromOpaque(context).takeUnretainedValue()
//
//            print(work)
//            guard let t = (work.tasks.first) as? runLoopCallback else {
//                return
//            }
//            print(t)
//            t()
//        }
//    }
//
//
//    @objc func fireTimer() {
//
//    }

