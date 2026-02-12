FROM nginx:1.27-alpine
RUN rm -f /usr/share/nginx/html/index.html
COPY OurWebSite/ /usr/share/nginx/html/
RUN [ -f /usr/share/nginx/html/Home.html ] && cp -f /usr/share/nginx/html/Home.html /usr/share/nginx/html/index.html || true
EXPOSE 80
