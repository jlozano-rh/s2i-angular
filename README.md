# Builder Image: s2i-angular

Custom OpenShift s2i builder image for Angular apps using Angular CLI and Apache httpd 2.4.

## Generate docker image

You can generate a new docker image based on the Dockerfile in this repository. Simply run the next command:
```bash
$ docker build -t s2i-angular-httpd .
```

## How to use it?

You can test this s2i builder image with an `Angular Hello World app`, running the next command:
```bash
$ s2i build https://github.com/your/angular-app.git --context-dir=. s2i-angular-httpd angular-test-app
$ docker run -p 8080:8080 angular-test-app
```

> **Note:** you can import the builder imagen into your OpenShift cluster with `oc import-image --confirm [docker|quay|any].registry.com/your-user/s2i-angular-httpd --reference-policy local -n openshift`.

# Tekton Task

Inside `./tekton/` folder, exist a YAML file with a generic task (based on buildah and nginx) to build an Angular application. This task only use official Red Hat images (like Nodejs and Nginx) to package all the application into a single lightweight docker image.
