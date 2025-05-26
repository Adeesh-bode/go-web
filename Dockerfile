## Implementing Multistage DockerFile
# stage1 - base image , download dependecies, build binary file  
# stage2 - use distroless for the same image inplace of normal image -- security , reduced image size 
    # use the binary build in stage 1 and expose port and run the application
# all docker keywords are capitalcase
FROM golang:1.22.5 AS base 
# base is alias for golang base image

WORKDIR /app 
# using a app directory for complete setup - in the docker container

COPY go.mod .  
# go mod is go's dependency management file - will copy it in app directory #package.json, requirements.txt , pom.xml for java

RUN go mod download
# like npm install

COPY . .
# copy all from this directory to app directory # all source code

RUN go build -o main .
# build go project with build binary file main and place it in app same directory i.e currently we have set current directory as app directory


# Final Stage( optimizing ) :  use distroless images contain only the essential application and its runtime dependencies—nothing more

# WORKDIR / by default

FROM gcr.io/distroless/base

## now copy our build binary to this distroless image
COPY --from=base /app/main .
# from the base to the default directory of the distroless image

## now copy the static ( folder with all source code put into this directory)
COPY --from=base /app/static ./static

EXPOSE 8080

CMD ["./main"] 
# start command for go prject is ./<buildbinaryfoldername>



################### Test the docker file and success of containerrzatn locally
# docker build  -t adeshbode/go-web-app .
# docker run -p 8080:8080 -it adeshbode/go-web-app 
# mapping contaier port 8080 to host port 8080 in this case our our laptop can be ec2 or ecs on cloud

### upload  image to docker hub
# docker push adeshbode/go-web-app:v1