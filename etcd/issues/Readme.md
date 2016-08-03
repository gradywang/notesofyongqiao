## Found issues
- Due to some known issues: [#3223](https://github.com/coreos/etcd/issues/3223) and [#4005](https://github.com/coreos/etcd/issues/4005), etcd has a bad performance (high cpu usage in etcd leader caused the high request latency) after enabling authentication, those issues are planned to be fixed in etcd 3.1 release. **-- Found this issue has be addressed in [#5991](https://github.com/coreos/etcd/pull/5991), need to do some verification then close this issue.**

- The Latest official ETCD image does not support to specify any parametes to run a etcd cluster. Refer issue [#6088](https://github.com/coreos/etcd/issues/6088) for the details.

## Supportor
Wang Yong Qiao (Weichat: gradyYQwang \ Mail: grady.wang@foxmail.com)
