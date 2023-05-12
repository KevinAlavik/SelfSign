FROM php:7.4-cli

WORKDIR /app

COPY install.sh .
COPY start.sh .

RUN chmod +x install.sh
RUN ./install.sh && rm install.sh  # Execute the script and remove it afterwards

COPY SelfSign /app/SelfSign

RUN chmod +x start.sh

ENV PORT=1300
EXPOSE 1300

CMD ["./start.sh"]
