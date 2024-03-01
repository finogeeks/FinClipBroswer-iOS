platform :ios, "9.0"

source 'https://git.finogeeks.com/cocoapods/FinPods'
#source 'https://cdn.cocoapods.org'
source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'
source 'ssh://gitlab.finogeeks.club/finclip-ios/DevPods'
source 'ssh://gitlab.finogeeks.club/finclip-ios/FinPods'

inhibit_all_warnings!

def commonPods
  pod 'SVProgressHUD', '2.2.5'
  pod 'TPKeyboardAvoiding'
  pod 'Masonry', '1.1.0'
  pod 'AFNetworking', '4.0.1'
  pod 'YYModel'
  pod 'SDWebImage', '5.15.4'
end

def finclipPods
    pod 'FinApplet', '2.43.7'
    pod 'FinAppletExt', '2.43.7'
    pod 'FinAppletGDMap', '2.43.7'
    pod 'FinAppletBLE', '2.43.7'
    pod 'FinAppletContact', '2.43.7'
    pod 'FinAppletClipBoard', '2.43.7'
end

target "FinClipBrowser" do
    commonPods
    finclipPods
end





