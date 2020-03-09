Pod::Spec.new do |s|

s.name = 'MI_SDK_EMVCO_UL'

s.version = '0.0.1'

s.license = { :type => 'BSD' }

s.homepage = 'https://www.modirum.com'

s.authors = { 'Juha Aaltonen' => 'juhapekka.aaltonen@modirum.com' }

s.summary = 'Modirum 3DS 2.0 SDK iOS framework for EMVCo (UL)'

s.platform = :ios

s.source = { :path => 'MI_SDK_EMVCO_UL.framework.zip' }

s.ios.deployment_target = '8.0'

s.ios.vendored_frameworks = 'MI_SDK_EMVCO_UL.framework'

end
