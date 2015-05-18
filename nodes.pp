#
# nodes.pp - defines all puppet nodes
#

# self-manage the puppet master server
node 'puppet' { }

node 'client1' {
  class { 'helloworld': }
}

node 'client2' { }
