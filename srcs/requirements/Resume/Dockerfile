FROM debian:11

# Minimal static site image to serve the resume
# Copies the `Resume/` directory into nginx document root
RUN apt-get update \
 && apt-get install -y nginx \
 && rm -rf /var/lib/apt/lists/*

RUN rm -rf /var/www/html/*

COPY . /var/www/html/

EXPOSE 3307

CMD ["nginx", "-g", "daemon off;"]