# 上科大 Why-Fi Surfer 登录器

## 简介

算是心血来潮了吧。很早以前就看到 LWT 女神写的 python 版本的登录器，我就在想这东西能不能移植到手机上。正好赶上学校 Wi-Fi 登录认证换版本之际，现学现做用 Swift 3.0 语言搞出了这么个东西。拼凑起来也能用了。而且我还是尽力把这东西打造的贴心一些。希望大家喜欢。

## 2018.8.31 更新
- 由于用于获取 SSID 信息的 CNCopyCurrentNetworkInfo 函数在 iOS 12 中需要在 App Capability 中打开 Access Wi-Fi Information，目前该 Capability 无法在未付费开发者中启用，所以为了方便，加入了 Check SSID 选项，默认为关，Check SSID 为关时，不会检查当前所连接的 SSID 名称。
- 使用 iOS 12 SDK 编译。

## 2018.1.25 更新
- 更新了 POST 请求（send/sync）的地址。修复了无法登录的错误。
- 部分 UI 界面修改保证在主线程进行。

## 2017.11.4 更新
- 使用了 CocoaPods 管理那些第三方库，和那些乱七八糟的库管理说再见。
- 换成了 Swift 4。其实没什么大变化。
- 适配了 iPhone X 界面。
- 修改了已经失效的链接。

## 主要功能
- 支持所有 iOS 8.0 以上版本的 iPhone，iPad 和 iPod Touch。 【兼容 iPhone 4S 或更新机型、iiPad Air 或更新机型、iPad mini （第一代）或更新机型、iPad 2 或更新机型、iPad Pro、iPod Touch（第五代）或更新机型】
- 支持标准 iPad 和 12.9寸 iPad Pro 界面。支持 iPad 多任务分屏 Slide Over 和 Split View。 iPad 版支持横屏旋转。
- 支持从锁屏界面、通知中心、3D Touch 菜单进行快速查看与访问。
- 与学校登录认证相同的结果反馈。
- 支持记住密码（钥匙串访问）与自动登录。
- 支持访问原始登录网页与查看状态。
- 支持通知中心通知是否需要连接网络，离开学校回来会特别有用。（实验性功能）
- 支持通过 Ping 来检查互联网连接情况。
- App 内置了需要安装的描述文件。
- 支持 简体中文、繁體中文、English、日本語、한국어。

## 其他
- 欢迎反馈任何 BUG，虽然因为证书签名的关系，我可能无法及时修补。但是还是会努力的。
- 感谢我的好朋友 Simon 把一开始丑到爆炸的界面改成了符合 iOS 规范的界面设计。
- 源代码位于 https://github.com/TomJinW/WhyFi_Surfer ，写的有点乱还没什么注释，如果想参考的话就拿去吧。

## 使用的第三方库
- SwiftyJSON https://github.com/SwiftyJSON/SwiftyJSON
- KeyChainAccess https://github.com/kishikawakatsumi/KeychainAccess
- PlainPing https://github.com/naptics/PlainPing
- SVWebViewController https://github.com/TransitApp/SVWebViewController