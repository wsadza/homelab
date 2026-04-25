
Steps:
1 - Install K3s disable treafik, flannel, sericelb
2 - Install cilium with L2 mode (load-balancing mode, masqarade)
3 - Make sure your node (host) is properly resolving DNS 
  - PATH: /etc/resolv.conf
  - PATH: /etc/network/interfaces - (dns-namespace)
  - CONF: 1.1.1.1 8.8.8.8
4 - Install envoy-gateway, it shoud expose trafic under LB range which you
    definied in cilium
  - CMD: ip neigh
 
Tips:
