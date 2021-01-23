# use existing image as base image
FROM alpine

# Download and install dependency
RUN apk add --update redis

# Tell image whta is start up cmd when it starts as container
CMD ["redis-server"]