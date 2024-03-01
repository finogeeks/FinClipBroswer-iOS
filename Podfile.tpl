platform :ios, "11.0"

source 'https://git.finogeeks.com/cocoapods/FinPods'
source 'ssh://gitlab.finogeeks.club/finclip-ios/DevPods'
source 'ssh://gitlab.finogeeks.club/finclip-ios/FinPods'
source 'https://cdn.cocoapods.org'

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
    pod 'FinApplet', '__finapplet_version__'
    pod 'FinAppletExt', '__finapplet_version__'
    pod 'FinAppletGDMap', '__finapplet_version__'
    pod 'FinAppletBLE', '__finapplet_version__'
    pod 'FinAppletContact', '__finapplet_version__'
    pod 'FinAppletClipBoard', '__finapplet_version__'
    pod 'FinAppletLive', '__finapplet_version__'
    pod 'FinAppletAgoraRTC', '__finapplet_version__'
    #pod 'FinAppletShare', '__finapplet_version__'
end

target "FinClipBrowser" do
    commonPods
    finclipPods
end





