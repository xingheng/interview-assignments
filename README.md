## SearchDemo



#### View

* **ContentView**，主页面view，嵌入了一个`NavigationView`用来在导航栏显示主标题，通过输入状态来确定导航栏、搜索框以及搜索结果的显隐性。当发起网络请求时，会先显示正在加载的网络提示，请求完成后，如果收到服务器返回的错误提示，会直接显示在屏幕中间。如果存在搜索结果的下一页数据，会在List最底部显示一个Loading提示。
* **SearchView**，自定义的`UISearchBar`实现，包含编辑状态和实时的输入文本内容。
* **CellView**，自定义的Cell样式，根据Model层数据完成绑定。
* **ActivityIndicator**，自定义Indicator，在网络请求过程中会显示出提示。（只在Xcode 11/iOS 13下有效，Xcode 12/iOS 14下会自动切换到`ProgressView`代替。）



#### Model

* **ProductViewModel**，直接绑定到ContentView中的观察者，监听整个页面的状态和数据，包括输入状态的键盘实时高度。收到网络请求响应之后根据返回结果判断是否存在下一页数据，最终根据View中的触发条件开始请求下一页。
* **ProductModel**，包含完整的模拟数据模型，方便数据反序列化和数据绑定。



#### Network

* **ProductRequest**， （模拟的)搜索网络请求，通过指定关键词来过滤目标结果。搜索类别名称、商标、产品名称等字段，支持分页搜索。
* **HTTPServer**，启用一个本地的http服务，当app启动的时候开始初始化，用来接收客户端发起的搜索请求。

