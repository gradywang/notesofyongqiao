## Notes
- If you will start lots of watch operation on the etcd cluster, please remember to adjust the `open file size` before bootstraping your etcd cluster. For example:
```
# ulimit -n 65535
```
