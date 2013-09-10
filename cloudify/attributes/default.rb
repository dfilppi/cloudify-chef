default[:cloudify][:workdir] = "/tmp"
default[:cloudify][:tmpdir] = "/tmp"
default[:cloudify][:user] = "cloudify"
default[:cloudify][:link] = "http://repository.cloudifysource.org/org/cloudifysource/2.6.0-5000-RELEASE/gigaspaces-cloudify-2.6.0-ga-b5000"
default[:cloudify][:cloudfile]="hp-cloud.groovy"

default[:cloudify][:cloudmachineid]="az-2.region-a.geo-1/2711661"
default[:cloudify][:cloudhardwareid]="az-2.region-a.geo-1/102"
default[:cloudify][:cloudimageid]="az-2.region-a.geo-1/221"

#cloud driver settings
default[:cloudify][:clouduser]="YOUR KEY"
default[:cloudify][:cloudtenant]="YOUR TENANT"
default[:cloudify][:apikey]="YOUR SECRET KEY"
default[:cloudify][:keyfile]="KEY FILE (E.G. KEY.PEM)"
default[:cloudify][:keypair]="YOU KEYPAIR NAME: USUALLY THE FILE - .PEM"
default[:cloudify][:securitygroup]="YOUR SECURITY GROUP"
default[:cloudify][:smalllinuxhardwareid]="az-2.region-a.geo-1/102"
default[:cloudify][:smalllinuximageid]="az-2.region-a.geo-1/221"
default[:cloudify][:ubuntuimageid]="az-2.region-a.geo-1/67070"
default[:cloudify][:persistencepath]="/tmp"

default[:giga][:cloudimageid]="az-2.region-a.geo-1/221"
default[:giga][:cloudhardwareid]="az-2.region-a.geo-1/102"
default[:giga][:cloudmachineid]="az-2.region-a.geo-1/2711661"
default[:giga][:cloudtemplate]="SMALL_LINUX"

