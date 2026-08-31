# Stage 1: Base image
FROM nginx:alpine

# Remove default nginx static assets
RUN rm -rf /usr/share/nginx/html/*

# Copy your custom static HTML file
COPY index.html /usr/share/nginx/html/index.html

# Set default port (Render will override this dynamically via $PORT)
ENV PORT=80

# Replace the default Nginx configuration with a dynamic PORT-binding config
RUN echo $'server {\n\
    listen ${PORT};\n\
    server_name _;\n\
    root /usr/share/nginx/html;\n\
    index index.html;\n\
\n\
    location / {\n\
        try_files $uri $uri/ /index.html;\n\
    }\n\
\n\
    # Cache static assets\n\
    location ~* \.(?:css|js|jpg|jpeg|gif|png|ico|svg)$ {\n\
        expires 7d;\n\
        add_header Cache-Control "public, no-transform";\n\
    }\n\
}' > /etc/nginx/templates/default.conf.template

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
