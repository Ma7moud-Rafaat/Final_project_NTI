FROM nginx:1.27-alpine

COPY OurWebSite/ /usr/share/nginx/html/

RUN if [ ! -f /usr/share/nginx/html/index.html ] && [ -f /usr/share/nginx/html/Home.html ]; then \
      cp /usr/share/nginx/html/Home.html /usr/share/nginx/html/index.html ; \
    fi

EXPOSE 80