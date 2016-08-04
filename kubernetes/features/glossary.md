## Kubernetes Glossary

### [Images](http://kubernetes.io/docs/user-guide/images/)
- Only support docker image now;
- Default pull policy is `IfNotPresent`, then kublet does not pull an image if it already exists. If you want to enable force pull, please set the pull policy to `Always` or set `:latest` tag (equate to does not specify the tag) for your image. **Notes: the best practice is always specify a specific tag for image to track which image is using and easy to roll back**
- Can use the private registry
 - Google registry
 - AWS EC2 registry
 
