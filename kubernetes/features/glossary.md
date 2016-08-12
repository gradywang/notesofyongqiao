## Kubernetes Glossary

### [Images](http://kubernetes.io/docs/user-guide/images/)
- Only support docker image now;
- Default pull policy is `IfNotPresent`, then kublet does not pull an image if it already exists. If you want to enable force pull, please set the pull policy to `Always` or set `:latest` tag (equate to does not specify the tag) for your image. **Notes: the best practice is always specify a specific tag for image to track which image is using and easy to roll back**
- Can use the private registry
 - Google registry
 - AWS EC2 registry

### Volumes
- Purpose: Keep data when POD containers re-created, and share data between POD containers.
- Enclose POD, and has the same lifecyle with POD.
- Support many type of volumes, and a POD can use any number of volumes simultaneously.
- In POD specification, define what volumes will be provided to POD, and in each container specification, define where to mount these volumes.
 - emptyDir: Firstly created when POD is scheduled to a node, and existing as long as the POD is running on this host. By default, the data are stored on the physical medium, and you can set `emptyDir.medium` to `Memory`to store the data in Memory, but this will count against your container’s memory limit Supported cases:
   - Disk-based merge or sort, etc.
   - Ensure a long computation recover from crashes.
   - Data provider and consumer between multiple containers in a POD.
 - hostPath: Mounts a file or directory from the host node’s filesystem into your pod. Supported cases:
   - Mount `/var/run/docker.sock` to start host container from a container.
