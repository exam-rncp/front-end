FROM node:10-alpine

# Install bash, make, Python, and other necessary tools
RUN apk update && apk add --no-cache make bash python3

# Install PhantomJS and CasperJS globally
RUN npm install -g phantomjs-prebuilt --unsafe-perm=true
RUN npm install -g casperjs --unsafe-perm=true

# Set up the app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Ensure CasperJS and Python are in the PATH
ENV PATH="$PATH:/usr/local/bin"

# Optionally, set Python 3 as the default 'python' command if needed
RUN ln -sf /usr/bin/python3 /usr/bin/python
