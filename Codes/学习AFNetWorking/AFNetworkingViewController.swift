//
//  AFNetworkingViewController.swift
//  Codes
//
//  Created by chenzw on 2018/11/29.
//  Copyright © 2018 Gripay. All rights reserved.
//

import UIKit

class AFNetworkingViewController: BaseTextViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let a:Set = [1,2,3,4,5]
        
//        let b = a.map { $0 * 2 }

//        let b = a.map ({ (element) -> Int in return element * 2} )
//        let b = a.map ({ element in return element * 2} )
//        let b = a.map ({ element in element * 2} )
//        let b = a.map ({$0 * 2} )
        let b = a.map {$0 * 2}

        print(b)
        
//        Dictionary(<#T##keysAndValues: Sequence##Sequence#>, uniquingKeysWith: <#T##(_, _) throws -> _#>)
        
//        let b = [4,5,6,7,8]
//
//        let c = a.intersection(b)
//        let d = a.subtracting(b)
//        let e = a.union(b)
//
//        print(c)
//        print(d)
//        print(e)
//
//        let s = "Hello World"
        
        
        
        print ( Dictionary("hello".map{($0,1)} ,uniquingKeysWith: +) )

        // https://www.jianshu.com/p/856f0e26279d
        var str = ""
        str.append("1.网络通信模块\r2.网络状态监听模块\r3.网络通信安全策略模块\r4.网络通信信息序列化&反序列化模块\r5.UIKit库的扩展\r")
        str.append("核心模块AFURLSessionManager,基于NSURLSession封装\r")
        str.append("self.operationQueue.maxConcurrentOperationCount = 1;这个operationQueue就是我们代理回调的queue。这里把代理回调的线程并发数设置为1\r")
        str.append("设置存储NSURL task与AFURLSessionManagerTaskDelegate的词典（重点，在AFNet中，每一个task都会被匹配一个AFURLSessionManagerTaskDelegate 来做task的delegate事件处理） self.mutableTaskDelegatesKeyedByTaskIdentifier = [[NSMutableDictionary alloc] init]; \r")
        str.append("设置AFURLSessionManagerTaskDelegate 词典的锁，确保词典在多线程访问时的线程安全 self.lock = [[NSLock alloc] init]; self.lock.name = AFURLSessionManagerLockName;\r")
        str.append("self.mutableTaskDelegatesKeyedByTaskIdentifier，这个是用来让每一个请求task和我们自定义的AF代理来建立映射用的，其实AF对task的代理进行了一个封装，并且转发代理到AF自定义的代理，这是AF比较重要的一部分\r")
        str.append("[self.session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) { }];这个方法用来异步的获取当前session的所有未完成的task。其实讲道理来说在初始化中调用这个方法应该里面一个task都不会有。我们打断点去看，也确实如此，里面的数组都是空的。 但是想想也知道，AF大神不会把一段没用的代码放在这吧。辗转多处，终于从AF的issue中找到了结论：github 。 原来这是为了防止后台回来，重新初始化这个session，一些之前的后台请求任务，导致程序的crash。 \r")
        str.append("初始化方法到这就全部完成了。\r\r")
        str.append("生成了一个系统的NSURLSessionDataTask实例，并且开始网络请求。 1.用self.requestSerializer和各种参数去获取了一个我们最终请求网络需要的NSMutableURLRequest实例。 2.调用另外一个方法dataTaskWithRequest去拿到我们最终需要的NSURLSessionDataTask实例，并且在完成的回调里，调用我们传过来的成功和失败的回调。 \r")
        
        str.append("说到底这个方法还是没有做实事，我们继续到requestSerializer方法里去看，看看AF到底如何拼接成我们需要的request的：\r")
        str.append("将request的各种属性循环遍历 如果自己观察到的发生变化的属性，在这些方法里 把给自己设置的属性给request设置\r。")
        str.append("AFHTTPRequestSerializerObservedKeyPaths()是一个c函数，返回一个数组，我们来看看这个函数:其实这个函数就是封装了一些属性的名字，这些都是NSUrlRequest的属性\r")
        str.append("从自己的head里去遍历，如果有值则设置给request的head [self.HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {  if (![request valueForHTTPHeaderField:field]) { [mutableRequest setValue:value forHTTPHeaderField:field]; } }];\r")
        str.append("来把各种类型的参数，array dic set转化成字符串，给request\r")
        str.append("//自定义的解析方式 if (self.queryStringSerialization) { else { //默认解析方式 。")
        str.append("最后判断该request中是否包含了GET、HEAD、DELETE（都包含在HTTPMethodsEncodingParametersInURI）。因为这几个method的quey是拼接到url后面的。而POST、PUT是把query拼接到http body中的。\r")
        str.append("//设置请求体 [mutableRequest setHTTPBody:[query dataUsingEncoding:self.stringEncoding]];\r")
        str.append("这个方法做了3件事： 1.从self.HTTPRequestHeaders中拿到设置的参数，赋值要请求的request里去, 2.把请求网络的参数，从array dic set这些容器类型转换为字符串，具体转码方式，我们可以使用自定义的方式，也可以用AF默认的转码方式。自定义的方式没什么好说的，想怎么去解析由你自己来决定。我们可以来看看默认的方式：转码主要是以上三个函数，配合着注释应该也很好理解：主要是在递归调用AFQueryStringPairsFromKeyAndValue。判断vaLue是什么类型的，然后去递归调用自己，直到解析的是除了array dic set以外的元素，然后把得到的参数数组返回。  其中有个AFQueryStringPair对象，其只有两个属性和两个方法： 至此，我们原来的容器类型的参数，就这样变成字符串类型了。  紧接着这个方法还根据该request中请求类型，来判断参数字符串应该如何设置到request中去。如果是GET、HEAD、DELETE，则把参数quey是拼接到url后面的。而POST、PUT是把query拼接到http body中的: \r")
        str.append("至此，我们生成了一个request\r")
        
        str.append("绕了一圈我们又回来了。。 我们继续往下看：当解析错误，我们直接调用传进来的fauler的Block失败返回了，这里有一个self.completionQueue,这个是我们自定义的，这个是一个GCD的Queue如果设置了那么从这个Queue中回调结果，否则从主队列回调。 实际上这个Queue还是挺有用的，之前还用到过。我们公司有自己的一套数据加解密的解析模式，所以我们回调回来的数据并不想是主线程，我们可以设置这个Queue,在分线程进行解析数据，然后自己再调回到主线程去刷新UI。 言归正传，我们接着调用了父类的生成task的方法，并且执行了一个成功和失败的回调，我们接着去父类AFURLSessionManger里看（总算到我们的核心类了..）：\r")
        str.append("理解下，第一为什么用sync，因为是想要主线程等在这，等执行完，在返回，因为必须执行完dataTask才有数据，传值才有意义。 //第二，为什么要用串行队列，因为这块是为了防止ios8以下内部的dataTaskWithRequest是并发创建的， //这样会导致taskIdentifiers这个属性值不唯一，因为后续要用taskIdentifiers来作为Key对应delegate。 dispatch_syn 方法非常简单，关键是理解这么做的目的：为什么我们不直接去调用 dataTask = [self.session dataTaskWithRequest:request]; 非要绕这么一圈，我们点进去bug日志里看看，原来这是为了适配iOS8的以下，创建session的时候，偶发的情况会出现session的属性taskIdentifier这个值不唯一，而这个taskIdentifier是我们后面来映射delegate的key,所以它必须是唯一的。 具体原因应该是NSURLSession内部去生成task的时候是用多线程并发去执行的。想通了这一点，我们就很好解决了，我们只需要在iOS8以下同步串行的去生成task就可以防止这一问题发生（如果还是不理解同步串行的原因，可以看看注释）。 题外话：很多同学都会抱怨为什么sync我从来用不到，看，有用到的地方了吧，很多东西不是没用，而只是你想不到怎么用。\r")
        str.append("// AFURLSessionManagerTaskDelegate与AFURLSessionManager建立相互关系 delegate.manager = self; delegate.completionHandler = completionHandler; //这个taskDescriptionForSessionTasks用来发送开始和挂起通知的时候会用到,就是用这个值来Post通知，来两者对应 ataTask.taskDescription = self.taskDescriptionForSessionTasks;  // ***** 将AF delegate对象与 dataTask建立关系  [self setDelegate:delegate forTask:dataTask]; // 设置AF delegate的上传进度，下载进度块。\r")
        str.append("总结一下: 1）这个方法，生成了一个AFURLSessionManagerTaskDelegate,这个其实就是AF的自定义代理。我们请求传来的参数，都赋值给这个AF的代理了。 2）delegate.manager = self;代理把AFURLSessionManager这个类作为属性了,我们可以看到： @property (nonatomic, weak) AFURLSessionManager *manager;  这个属性是弱引用的，所以不会存在循环引用的问题。 3）我们调用了[self setDelegate:delegate forTask:dataTask]; \r")
        str.append("//加锁保证字典线程安全 [self.lock lock]; // 将AF delegate放入以taskIdentifier标记的词典中（同一个NSURLSession中的taskIdentifier是唯一的） self.mutableTaskDelegatesKeyedByTaskIdentifier[@(task.taskIdentifier)] = delegate; // 为AF delegate 设置task 的progress监听 [delegate setupProgressForTask:task]; //添加task开始和暂停的通知 self addNotificationObserverForTask:task]; [self.lock unlock];\r")
        str.append("这个方法主要就是把AF代理和task建立映射，存在了一个我们事先声明好的字典里。 而要加锁的原因是因为本身我们这个字典属性是mutable的，是线程不安全的。而我们对这些方法的调用，确实是会在复杂的多线程环境中，后面会仔细提到线程问题。 还有个[delegate setupProgressForTask:task];我们到方法里去看看：\r")
        str.append("方法非常简单直观，主要就是如果task触发KVO,则给progress进度赋值，应为赋值了，所以会触发progress的KVO，也会调用到这里，然后去执行我们传进来的downloadProgressBlock和uploadProgressBlock。主要的作用就是为了让进度实时的传递。 主要是观摩一下大神的写代码的结构，这个解耦的编程思想，不愧是大神... 还有一点需要注意：我们之前的setProgress和这个KVO监听，都是在我们AF自定义的delegate内的，是有一个task就会有一个delegate的。所以说我们是每个task都会去监听这些属性，分别在各自的AF代理内。看到这，可能有些小伙伴会有点乱，没关系。等整个讲完之后我们还会详细的去讲捋一捋manager、task、还有AF自定义代理三者之前的对应关系。\r")
        str.append("到这里我们整个对task的处理就完成了。\r")
        str.append("接着task就开始请求网络了，还记得我们初始化方法中：\r")
        str.append("self.session = [NSURLSession sessionWithConfiguration:self.sessionConfiguration delegate:self delegateQueue:self.operationQueue]; 我们把AFUrlSessionManager作为了所有的task的delegate。当我们请求网络的时候，这些代理开始调用了：\r")
        str.append("AFUrlSessionManager一共实现了如上图所示这么一大堆NSUrlSession相关的代理。（小伙伴们的顺序可能不一样，楼主根据代理隶属重新排序了一下） 而只转发了其中3条到AF自定义的delegate中：\r")
        str.append("这就是我们一开始说的，AFUrlSessionManager对这一大堆代理做了一些公共的处理，而转发到AF自定义代理的3条，则负责把每个task对应的数据回调出去。 又有小伙伴问了，我们设置的这个代理不是NSURLSessionDelegate吗？怎么能响应NSUrlSession这么多代理呢？我们点到类的声明文件中去看看： @protocol NSURLSessionDelegate <NSObject> @protocol NSURLSessionTaskDelegate <NSURLSessionDelegate> @protocol NSURLSessionDataDelegate <NSURLSessionTaskDelegate> @protocol NSURLSessionDownloadDelegate <NSURLSessionTaskDelegate> @protocol NSURLSessionStreamDelegate <NSURLSessionTaskDelegate> 我们可以看到这些代理都是继承关系，而在NSURLSession实现中，只要设置了这个代理，它会去判断这些所有的代理，是否respondsToSelector这些代理中的方法，如果响应了就会去调用。 而AF还重写了respondsToSelector方法: \r")
        str.append("而AF还重写了respondsToSelector方法: - (BOOL)respondsToSelector:(SEL)selector { //复写了selector的方法，这几个方法是在本类有实现的，但是如果外面的Block没赋值的话，则返回NO，相当于没有实现！  if (selector == @selector(URLSession:task:willPerformHTTPRedirection:newRequest:completionHandler:)) { return self.taskWillPerformHTTPRedirection != nil; } else if (selector == @selector(URLSession:dataTask:didReceiveResponse:completionHandler:)) { return self.dataTaskDidReceiveResponse != nil; } else if (selector == @selector(URLSession:dataTask:willCacheResponse:completionHandler:)) { } else if (selector == @selector(URLSessionDidFinishEventsForBackgroundURLSession:)) { return self.didFinishEventsForBackgroundURLSession != nil; } return [[self class] instancesRespondToSelector:selector]; }\r")
        str.append("讲到这，我们顺便看看AFUrlSessionManager的一些自定义Block： 各自对应的还有一堆这样的set方法：作者用@property把这个些Block属性在.m文件中声明,然后复写了set方法  然后在.h中去声明这些set方法： - (void)setSessionDidBecomeInvalidBlock:(nullable void (^)(NSURLSession *session, NSError *error))block; 为什么要绕这么一大圈呢？原来这是为了我们这些用户使用起来方便，调用set方法去设置这些Block，能很清晰的看到Block的各个参数与返回值。大神的精髓的编程思想无处不体现... \r")
        str.append("\r")
        str.append("接下来我们就讲讲这些代理方法做了什么（按照顺序来）：\r")
        str.append("NSURLSessionDelegate\r")
        str.append("代理1： //当前这个session已经失效时，该代理方法被调用。 /* 如果你使用finishTasksAndInvalidate函数使该session失效， 那么session首先会先完成最后一个task，然后再调用URLSession:didBecomeInvalidWithError:代理方法， 如果你调用invalidateAndCancel方法来使session失效，那么该session会立即调用上面的代理方法。 */  - (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error  { if (self.sessionDidBecomeInvalid) { elf.sessionDidBecomeInvalid(session, error); } [[NSNotificationCenter defaultCenter] postNotificationName:AFURLSessionDidInvalidateNotification object:session]; } 方法调用时机注释写的很清楚，就调用了一下我们自定义的Block,还发了一个失效的通知，至于这个通知有什么用。很抱歉，AF没用它做任何事，只是发了...目的是用户自己可以利用这个通知做什么事吧。 其实AF大部分通知都是如此。当然，还有一部分通知AF还是有自己用到的，包括配合对UIKit的一些扩展来使用，后面我们会有单独篇幅展开讲讲这些UIKit的扩展类的实现。 \r")
        str.append("//2、https认证 - (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler \r")
        str.append("web服务器接收到客户端请求时，有时候需要先验证客户端是否为正常用户，再决定是够返回真实数据。这种情况称之为服务端要求客户端接收挑战（NSURLAuthenticationChallenge *challenge）。接收到挑战后，客户端要根据服务端传来的challenge来生成completionHandler所需的NSURLSessionAuthChallengeDisposition disposition和NSURLCredential *credential（disposition指定应对这个挑战的方法，而credential是客户端生成的挑战证书，注意只有challenge中认证方法为NSURLAuthenticationMethodServerTrust的时候，才需要生成挑战证书）。最后调用completionHandler回应服务器端的挑战。 \r")
        str.append("当服务器端要求客户端提供证书时或者进行NTLM认证（Windows NT LAN Manager，微软提出的WindowsNT挑战/响应验证机制）时，此方法允许你的app提供正确的挑战证书。 当某个session使用SSL/TLS协议，第一次和服务器端建立连接的时候，服务器会发送给iOS客户端一个证书，此方法允许你的app验证服务期端的证书链（certificate keychain） 注：如果你没有实现该方法，该session会调用其NSURLSessionTaskDelegate的代理方法URLSession:task:didReceiveChallenge:completionHandler: 。 这里，我把官方文档对这个方法的描述翻译了一下。 总结一下，这个方法其实就是做https认证的。看看上面的注释，大概能看明白这个方法做认证的步骤，我们还是如果有自定义的做认证的Block，则调用我们自定义的，否则去执行默认的认证步骤，最后调用完成认证： \r")
        str.append("代理3： 当session中所有已经入队的消息被发送出去后，会调用该代理方法。 - (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session\r")
        str.append("在iOS中，当一个后台传输任务完成或者后台传输时需要证书，而此时你的app正在后台挂起，那么你的app在后台会自动重新启动运行，并且这个app的UIApplicationDelegate会发送一个application:handleEventsForBackgroundURLSession:completionHandler:消息。该消息包含了对应后台的session的identifier，而且这个消息会导致你的app启动。你的app随后应该先存储completion handler，然后再使用相同的identifier创建一个background configuration，并根据这个background configuration创建一个新的session。这个新创建的session会自动与后台任务重新关联在一起。 当你的app获取了一个URLSessionDidFinishEventsForBackgroundURLSession:消息，这就意味着之前这个session中已经入队的所有消息都转发出去了，这时候再调用先前存取的completion handler是安全的，或者因为内部更新而导致调用completion handler也是安全的。 r")
        str.append("NSURLSessionTaskDelegate\r")
        str.append("代理4： //被服务器重定向的时候调用 - (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response  newRequest:(NSURLRequest *)request ompletionHandler:(void (^)(NSURLRequest *))completionHandler \r")
        str.append("一开始我以为这个方法是类似NSURLProtocol，可以在请求时自己主动的去重定向request，后来发现不是，这个方法是在服务器去重定向的时候，才会被调用。当我们服务器重定向的时候，代理就被调用了，我们可以去重新定义这个重定向的request。 关于这个代理还有一些需要注意的地方： 此方法只会在default session或者ephemeral session中调用，而在background session中，session task会自动重定向。 \r")
        str.append("这个模式总共分为3种： 对于NSURLSession对象的初始化需要使用NSURLSessionConfiguration，而NSURLSessionConfiguration有三个类工厂方法： +defaultSessionConfiguration 返回一个标准的 +ephemeralSessionConfiguration 返回一个预设配置，这个配置中不会对缓存，Cookie 和证书进行持久性的存储。这对于实现像秘密浏览这种功能来说是很理想的。 +backgroundSessionConfiguration:(NSString *)identifier 的独特之处在于，它会创建一个后台 session。后台 session 不同于常规的，普通的 session，它甚至可以在应用程序挂起，退出或者崩溃的情况下运行上传和下载任务。初始化时指定的标识符，被用于向任何可能在进程外恢复后台传输的守护进程（daemon）提供上下文。\r")
        str.append("代理5： //https认证 - (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler \r")
        str.append("之前我们也有一个https认证，功能一样，执行的内容也完全一样。 区别在于这个是non-session-level级别的认证，而之前的是session-level级别的。 相对于它，多了一个参数task,然后调用我们自定义的Block会多回传这个task作为参数，这样我们就可以根据每个task去自定义我们需要的https认证方式。 \r")
        str.append("代理6： //当一个session task需要发送一个新的request body stream到服务器端的时候，调用该代理方法。 - (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task needNewBodyStream:(void (^)(NSInputStream *bodyStream))completionHandler \r")
        str.append("如果task是由uploadTaskWithStreamedRequest:创建的，那么提供初始的request body stream时候会调用该代理方法。 因为认证挑战或者其他可恢复的服务器错误，而导致需要客户端重新发送一个含有body stream的request，这时候会调用该代理。 \r")
        str.append("代理7： //周期性地通知代理发送到服务器端数据的进度。 - (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend \r")
        str.append("代理8： task完成之后的回调，成功和失败都会回调这里 函数讨论：  注意这里的error不会报告服务期端的error，他表示的是客户端这边的eroor，比如无法解析hostname或者连不上host主机。 - (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error \r")
        str.append("//根据task去取我们一开始创建绑定的delegate AFURLSessionManagerTaskDelegate *delegate = [self delegateForTask:task];\r")
        str.append("//把代理转发给我们绑定的delegate [delegate URLSession:session task:task didCompleteWithError:error]; //转发完移除delegate [self removeDelegateForTask:task]; \r")
        str.append("代理9： //收到服务器响应后调用 - (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response  completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler \r")
        str.append("函数作用： 告诉代理，该data task获取到了服务器端传回的最初始回复（response）。注意其中的completionHandler这个block，通过传入一个类型为NSURLSessionResponseDisposition的变量来决定该传输任务接下来该做什么： NSURLSessionResponseAllow 该task正常进行 NSURLSessionResponseCancel 该task会被取消 NSURLSessionResponseBecomeDownload 会调用URLSession:dataTask:didBecomeDownloadTask:方法来新建一个download task以代替当前的data task NSURLSessionResponseBecomeStream  转成一个StreamTask \r")
        str.append("代理10：//上面的代理如果设置为NSURLSessionResponseBecomeDownload，则会调用这个方法 - (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask 这个代理方法是被上面的代理方法触发的，作用就是新建一个downloadTask，替换掉当前的dataTask。所以我们在这里做了AF自定义代理的重新绑定操作。  调用自定义Block。\r")
        str.append("按照顺序来，其实还有个AF没有去实现的代理： //AF没实现的代理  - (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeStreamTask:(NSURLSessionStreamTask *)streamTask; 这个也是之前的那个代理，设置为NSURLSessionResponseBecomeStream则会调用到这个代理里来。会新生成一个NSURLSessionStreamTask来替换掉之前的dataTask。 \r")
        str.append("代理11： //当我们获取到数据就会调用，会被反复调用，请求到的数据就在这被拼装完整 - (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data 这个方法和上面didCompleteWithError算是NSUrlSession的代理中最重要的两个方法了。  我们转发了这个方法到AF的代理中去，所以数据的拼接都是在AF的代理中进行的。这也是情理中的，毕竟每个响应数据都是对应各个task，各个AF代理的。在AFURLSessionManager都只是做一些公共的处理。 \r")
        str.append("代理12： 当task接收到所有期望的数据后，session会调用此代理方法。  - (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse  completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler \r")
        str.append("当task接收到所有期望的数据后，session会调用此代理方法。如果你没有实现该方法，那么就会使用创建session时使用的configuration对象决定缓存策略。这个代理方法最初的目的是为了阻止缓存特定的URLs或者修改NSCacheURLResponse对象相关的userInfo字典。 该方法只会当request决定缓存response时候调用。作为准则，responses只会当以下条件都成立的时候返回缓存： 该request是HTTP或HTTPS URL的请求（或者你自定义的网络协议，并且确保该协议支持缓存） 确保request请求是成功的（返回的status code为200-299） 返回的response是来自服务器端的，而非缓存中本身就有的 提供的NSURLRequest对象的缓存策略要允许进行缓存 服务器返回的response中与缓存相关的header要允许缓存 该response的大小不能比提供的缓存空间大太多（比如你提供了一个磁盘缓存，那么response大小一定不能比磁盘缓存空间还要大5%） \r")
        str.append("总结一下就是一个用来缓存response的方法，方法中调用了我们自定义的Block，自定义一个response用来缓存。\r")
        str.append("NSURLSessionDownloadDelegate\r")
        str.append("下载完成的时候调用  - (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location \r")
        str.append("代理14： //周期性地通知下载进度调用 - (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite \r")
        str.append("简单说一下这几个参数: bytesWritten 表示自上次调用该方法后，接收到的数据字节数 totalBytesWritten表示目前已经接收到的数据字节数 totalBytesExpectedToWrite 表示期望收到的文件总字节数，是由Content-Length header提供。如果没有提供，默认是NSURLSessionTransferSizeUnknown。 \r")
        str.append("代理15： //当下载被取消或者失败后重新恢复下载时调用 - (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes \r")
        str.append("如果一个正在下载任务被取消或者失败了，你可以请求一个resumeData对象（比如在userInfo字典中通过NSURLSessionDownloadTaskResumeData这个键来获取到resumeData）并使用它来提供足够的信息以重新开始下载任务。 随后，你可以使用resumeData作为downloadTaskWithResumeData:或downloadTaskWithResumeData:completionHandler:的参数。当你调用这些方法时，你将开始一个新的下载任务。一旦你继续下载任务，session会调用它的代理方法URLSession:downloadTask:didResumeAtOffset:expectedTotalBytes:其中的downloadTask参数表示的就是新的下载任务，这也意味着下载重新开始了。 \r")
        str.append("其实这个就是用来做断点续传的代理方法。可以在下载失败的时候，拿到我们失败的拼接的部分resumeData，然后用去调用downloadTaskWithResumeData：就会调用到这个代理方法来了。 其中注意：fileOffset这个参数，如果文件缓存策略或者最后文件更新日期阻止重用已经存在的文件内容，那么该值为0。否则，该值表示当前已经下载data的偏移量。 方法中仅仅调用了downloadTaskDidResume自定义Block \r")
        str.append("至此NSUrlSesssion的delegate讲完了。大概总结下：  每个代理方法对应一个我们自定义的Block,如果Block被赋值了，那么就调用它。 在这些代理方法里，我们做的处理都是相对于这个sessionManager所有的request的。是公用的处理。 转发了3个代理方法到AF的deleagate中去了，AF中的deleagate是需要对应每个task去私有化处理的。 \r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        str.append("\r")
        textView.text = str
    }
}
