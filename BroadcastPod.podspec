#
# Be sure to run `pod lib lint BroadcastPod.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BroadcastPod'
  s.version          = '1.0.2'
  s.summary          = 'This repo consist of the code for screensharing on ios.'
  s.swift_version    = '5.0'
# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  'This repo consist of the code for screensharing on ios.'
                       DESC

  s.homepage         = 'https://github.com/signalwire/broadcast-pod'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Signalwire' => 'zeeshan.saiyed@eocsmob.com'}
  s.source           = { :git => 'https://zeeshanecosmob@github.com/signalwire/broadcast-pod.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.1'

  s.source_files = 'BroadcastPod/Classes/**/*'
  
  # s.resource_bundles = {
  #   'BroadcastPod' => ['BroadcastPod/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
